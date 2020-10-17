#!/usr/bin/env bash
set -e

TRAVIS_EVENT_TYPE="push"
TRAVIS_BRANCH="main"
RELEASE_BRANCH="main"
DEV_BRANCH="main"
POST_RELEASE_BRANCH="main"
TRAVIS_COMMIT_MESSAGE="release"
TRAVIS_REPO_SLUG=fboucquez/travis-ci-examples
SCRIPT="./build-me.sh language4"

. ./travis/travis-functions.sh
echo "Script operation $SCRIPT $(resolve_operation) $(load_version_from_file)"
bash -c "$SCRIPT $(resolve_operation) $(load_version_from_file)"
