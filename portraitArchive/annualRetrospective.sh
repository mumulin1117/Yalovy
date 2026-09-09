#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
/usr/bin/find yalovy-content -not -name '.DS_Store' -print | LC_ALL=C /usr/bin/sort | /usr/bin/sed 's|^|$(SRCROOT)/|' > portraitArchive/annualPlanner.xcfilelist
