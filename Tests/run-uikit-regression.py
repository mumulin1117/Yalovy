#!/usr/bin/env python3
"""Build a separate offline B-module QA app without replacing Yalovy or purchasing products."""
import argparse
from pathlib import Path
import plistlib
import shutil
import subprocess
import tempfile
import time

parser = argparse.ArgumentParser()
parser.add_argument('--device', required=True)
parser.add_argument('--debug', action='store_true', help='Compile the QA harness with DEBUG')
parser.add_argument('--assets', type=Path, required=True)
parser.add_argument('--output', type=Path, required=True)
args = parser.parse_args()
tests = Path(__file__).resolve().parent
source = tests.parent / 'Yalovy/yalovyui'
variant = 'migrated'
identifier = f'com.yalovy.qa.bmodule.{variant}'
args.output = args.output.resolve()
args.output.mkdir(parents=True, exist_ok=True)
with tempfile.TemporaryDirectory(prefix='yalovy-b-uikit-') as directory:
    bundle = Path(directory) / 'BModuleQA.app'
    bundle.mkdir()
    info = {'CFBundleExecutable': 'BModuleQA', 'CFBundleIdentifier': identifier,
            'CFBundleName': 'BModuleQA', 'CFBundlePackageType': 'APPL', 'CFBundleVersion': '1',
            'CFBundleShortVersionString': '1.0', 'MinimumOSVersion': '17.0', 'LSRequiresIPhoneOS': True,
            'UIDeviceFamily': [1], 'UILaunchScreen': {}, 'NSAppTransportSecurity': {'NSAllowsArbitraryLoads': True}}
    (bundle / 'Info.plist').write_bytes(plistlib.dumps(info))
    shutil.copy2(args.assets, bundle / 'Assets.car')
    sdk = subprocess.check_output(['xcrun', '--sdk', 'iphonesimulator', '--show-sdk-path'], text=True).strip()
    command = ['xcrun', 'swiftc', '-swift-version', '5', '-suppress-warnings', '-parse-as-library',
               '-sdk', sdk, '-target', 'arm64-apple-ios17.0-simulator']
    if args.debug:
        command += ['-D', 'DEBUG']
    sources = [str(path) for path in sorted(source.glob('*.swift'))]
    subprocess.run(command + sources + [str(tests / 'UIKitRegressionHarness.swift'), '-o', str(bundle / 'BModuleQA')], check=True)
    subprocess.run(['codesign', '--force', '--sign', '-', str(bundle)], check=True, capture_output=True)
    subprocess.run(['xcrun', 'simctl', 'install', args.device, str(bundle)], check=True)
    subprocess.run(['xcrun', 'simctl', 'launch', '--terminate-running-process', args.device, identifier], check=True)
    container = Path(subprocess.check_output(['xcrun', 'simctl', 'get_app_container', args.device, identifier, 'data'], text=True).strip())
    result = container / 'Documents/layout-results.json'
    deadline = time.monotonic() + 45
    while not result.exists() and time.monotonic() < deadline:
        time.sleep(0.25)
    if not result.exists():
        raise RuntimeError('QA app did not produce layout results; inspect simulator logs')
    for path in result.parent.glob('*'):
        shutil.copy2(path, args.output / path.name)
    subprocess.run(['xcrun', 'simctl', 'terminate', args.device, identifier], check=True)
    subprocess.run(['xcrun', 'simctl', 'uninstall', args.device, identifier], check=True)
    logs = (args.output / 'startup-stdout.log').read_text()
    metrics = ['entry_wait_started', 'entry_wait_ms=', 'webview_prepare_ms=', 'webview_reused=']
    assert all(metric in logs for metric in metrics), 'Test-environment startup diagnostics missing'
    print(f'UIKit fixture results: {args.output}')
