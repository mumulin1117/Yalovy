#!/bin/sh
set -eu
mkdir -p "${DERIVED_FILE_DIR}/portraitArchive"
/usr/bin/xcrun --sdk macosx swiftc -O \
  -sdk "$(/usr/bin/xcrun --sdk macosx --show-sdk-path)" \
  -module-cache-path "${DERIVED_FILE_DIR}/portraitArchive" \
  "${SRCROOT}/Yalovy/YearlyGrowthMosaic.swift" \
  "${SRCROOT}/portraitArchive/AnnualPortrait.swift" \
  -o "${DERIVED_FILE_DIR}/portraitArchive/annualPortrait"
"${DERIVED_FILE_DIR}/portraitArchive/annualPortrait" \
  "${SRCROOT}/yalovy-content" \
  "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/annualPortrait.png"
