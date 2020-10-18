#!/bin/bash
set -e

. ./travis/docker-functions.sh

DOCKER_IMAGE_NAME=fboucqez/travis-ci-examples
DOCKER_USERNAME="dummy_name"
DOCKER_PASSWORD="dummy_password"

docker_push $(load_version_from_file)
