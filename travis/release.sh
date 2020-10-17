#!/usr/bin/env bash
set -e

echo "Releasing version $VERSION"
bash ./release-me.sh one "$OPERATION"
