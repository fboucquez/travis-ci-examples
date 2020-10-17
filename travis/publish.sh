#!/usr/bin/env bash
set -e

. ./travis/travis-functions.sh

./publish-me.sh one "$OPERATION"
