#!/usr/bin/env bash
set -e

. ./travis/travis-functions.sh

./release-me.sh one "$OPERATION"
