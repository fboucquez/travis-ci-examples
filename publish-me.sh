#!/usr/bin/env bash
set -e

. ./travis/travis-functions.sh
load_version_from_file
echo "Publish $OPERATION on version $VERSION"
