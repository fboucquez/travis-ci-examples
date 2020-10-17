#!/usr/bin/env bash
set -e

. ./travis/travis-functions.sh
load_version_from_file()
echo "Publishing version $VERSION"
bash ./publish-me.sh one "$OPERATION"
