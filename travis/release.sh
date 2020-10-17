#!/usr/bin/env bash
set -e

. ./travis/travis-functions.sh
load_version_from_file()
echo "Releasing version $VERSION"
bash ./release-me.sh one "$OPERATION"
