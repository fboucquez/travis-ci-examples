#!/usr/bin/env bash
set -e

. ./travis/travis-functions.sh
load_version_from_file
echo "Releasing $OPERATION on version $VERSION"
