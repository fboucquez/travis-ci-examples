#!/usr/bin/env bash
set -e

VERSION=$(head -n 1 version.txt)
echo "Releasing $1 $2 on version $VERSION"