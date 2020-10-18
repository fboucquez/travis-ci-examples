#!/bin/bash
set -e

. ./travis/travis-functions.sh

POST_RELEASE_BRANCH=main


TRAVIS_EVENT_TYPE=push
RELEASE_BRANCH=main
DEV_BRANCH=dev
TRAVIS_BRANCH=dev
TRAVIS_COMMIT_MESSAGE=normal

assert_value "publish" $(resolve_operation)


TRAVIS_EVENT_TYPE=pull_request
RELEASE_BRANCH=main
DEV_BRANCH=dev
TRAVIS_BRANCH=dev
TRAVIS_COMMIT_MESSAGE=normal

assert_value "build" $(resolve_operation)

TRAVIS_EVENT_TYPE=push
RELEASE_BRANCH=main
DEV_BRANCH=main
TRAVIS_BRANCH=main
TRAVIS_COMMIT_MESSAGE=release

assert_value "release" $(resolve_operation)


TRAVIS_EVENT_TYPE=push
RELEASE_BRANCH=main
DEV_BRANCH=main
TRAVIS_BRANCH=main
TRAVIS_COMMIT_MESSAGE=normal

assert_value "publish" $(resolve_operation)


TRAVIS_EVENT_TYPE=push
RELEASE_BRANCH=main
DEV_BRANCH=dev
TRAVIS_BRANCH=main
TRAVIS_COMMIT_MESSAGE=normal

assert_value "release" $(resolve_operation)
