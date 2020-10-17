#!/usr/bin/env bash
set -e

. ./travis/travis-functions.sh

VERSION=$(head -n 1 version.txt)
echo "${VERSION}"

echo "${NEW_VERSION}"

TRAVIS_EVENT_TYPE="push"
TRAVIS_BRANCH="main"
RELEASE_BRANCH="main"
DEV_BRANCH="main"
POST_RELEASE_BRANCH="main"
TRAVIS_COMMIT_MESSAGE="release"

test_travis_functions
post_release

#SCRIPT="./build-me.sh language1"
#FULL_SCRIPT="${SCRIPT} ${OPERATION}"
#bash $FULL_SCRIPT
#
#NEW_VERSION=$(increment_version "$VERSION")
#echo "NEW_VERSION $NEW_VERSION"
