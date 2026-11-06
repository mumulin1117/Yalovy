#!/usr/bin/env python3
"""Run offline protocol/persistence checks; optionally compare a pre-refactor snapshot."""
import argparse
import base64
import hashlib
import json
import os
from pathlib import Path
import re
import socket
import struct
import subprocess
import tempfile
import threading
import time


def websocket_fixture(server, errors):
    def read_exact(connection, count):
        data = b''
        while len(data) < count:
            chunk = connection.recv(count - len(data))
            if not chunk:
                raise RuntimeError('websocket fixture closed early')
            data += chunk
        return data

    def send(connection, payload):
        data = payload if isinstance(payload, bytes) else json.dumps(payload).encode()
        header = bytes([0x81, len(data)]) if len(data) < 126 else bytes([0x81, 126]) + struct.pack('!H', len(data))
        connection.sendall(header + data)

    try:
        connection, _ = server.accept()
        with connection:
            connection.settimeout(5)
            headers = b''
            while b'\r\n\r\n' not in headers:
                headers += connection.recv(4096)
            values = dict(line.split(': ', 1) for line in headers.decode().split('\r\n')[1:] if ': ' in line)
            key = next(value for name, value in values.items() if name.lower() == 'sec-websocket-key')
            accept = base64.b64encode(hashlib.sha1((key + '258EAFA5-E914-47DA-95CA-C5AB0DC85B11').encode()).digest()).decode()
            connection.sendall(('HTTP/1.1 101 Switching Protocols\r\nUpgrade: websocket\r\nConnection: Upgrade\r\n'
                                f'Sec-WebSocket-Accept: {accept}\r\n\r\n').encode())
            send(connection, b'not-json')
            send(connection, {'action': 4})
            header = read_exact(connection, 2)
            size = header[1] & 127
            if size == 126:
                size = struct.unpack('!H', read_exact(connection, 2))[0]
            mask = read_exact(connection, 4) if header[1] & 128 else bytes(4)
            data = read_exact(connection, size)
            join = json.loads(bytes(value ^ mask[index % 4] for index, value in enumerate(data)))
            assert join == {'action': 10, 'channel': 'fixture-channel'}, 'channel subscription changed'
            send(connection, {'action': 11, 'channel': 'fixture-channel'})
            message = {'id': 'duplicate-id', 'encoding': 'json/base64',
                       'data': base64.b64encode(json.dumps({'fixture': 'first'}).encode()).decode()}
            send(connection, {'action': 15, 'channel': 'other-channel', 'messages': [message]})
            send(connection, {'action': 15, 'channel': 'fixture-channel', 'messages': [message, message]})
            send(connection, {'action': 15, 'channel': 'fixture-channel', 'messages': [{'id': 'bad', 'encoding': 'gzip', 'data': 'bad'}]})
            send(connection, {'action': 15, 'channel': 'fixture-channel', 'messages': [{'id': 'next', 'data': {'fixture': 'second'}}]})
            time.sleep(0.2)
    except Exception as error:
        errors.append(error)
    finally:
        server.close()

parser = argparse.ArgumentParser()
parser.add_argument('--debug', action='store_true')
args = parser.parse_args()
tests = Path(__file__).resolve().parent
source = tests.parent / 'Yalovy/yalovyui'
names = ['GardenForaging', 'PuppyPlayfulness', 'MonthlyPlanner', 'SeasonalKeepsake', 'AnniversaryMemoir']
with tempfile.TemporaryDirectory(prefix='yalovy-b-contract-') as directory:
    staging = Path(directory)
    files = []
    for name in names:
        contents = (source / f'{name}.swift').read_text()
        if name == 'AnniversaryMemoir':
            # The same file also contains the UIApplication delegate integration.
            contents = contents.split('\nimport UIKit\n', 1)[0]
        target = staging / f'{name}.swift'
        target.write_text(contents)
        files.append(str(target))
    executable = staging / 'BContractTests'
    command = ['xcrun', 'swiftc', '-swift-version', '5', '-suppress-warnings', '-parse-as-library']
    if args.debug:
        command += ['-D', 'DEBUG']
    subprocess.run(command + files + [str(tests / 'BModuleContractTests.swift'), '-o', str(executable)], check=True)
    server = socket.socket()
    server.bind(('127.0.0.1', 0))
    server.listen(1)
    server.settimeout(8)
    errors = []
    thread = threading.Thread(target=websocket_fixture, args=(server, errors), daemon=True)
    thread.start()
    try:
        subprocess.run([str(executable), str(server.getsockname()[1])], check=True)
    finally:
        thread.join(timeout=8)
        if errors:
            raise errors[0]
