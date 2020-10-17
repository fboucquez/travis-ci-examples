#!/usr/bin/env bash
set -e

. ./travis/pipeline-functions.sh

#validate_env_variable PATH

VERSION=$(head -n 1 version.txt)
echo "${VERSION}"

NEW_VERSION=$(increment_version "$VERSION")

echo "${NEW_VERSION}"


