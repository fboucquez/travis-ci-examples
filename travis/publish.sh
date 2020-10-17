#!/usr/bin/env bash
set -e

echo "Publishing version $VERSION"
bash ./publish-me.sh one "$OPERATION"
