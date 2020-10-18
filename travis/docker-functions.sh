#!/usr/bin/env bash
set -e

. ./travis/travis-functions.sh

docker_push(){
  VERSION="$1"
  OPERATION=$(resolve_operation)

  validate_env_variable "VERSION" "$FUNCNAME"
  validate_env_variable "OPERATION" "$FUNCNAME"
  validate_env_variable "DOCKER_IMAGE_NAME" "$FUNCNAME"
  validate_env_variable "DOCKER_USERNAME" "$FUNCNAME"
  validate_env_variable "DOCKER_PASSWORD" "$FUNCNAME"

  echo "Login into docker..."
  echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin

  echo "Creating image ${DOCKER_IMAGE_NAME}:${VERSION}"
  docker build -t "${DOCKER_IMAGE_NAME}:${VERSION}" .

  if [ "$OPERATION" = "publish" ]
  then
      echo "Building for operation ${OPERATION}..."
      echo "Docker tagging alpha version"
      docker tag "${DOCKER_IMAGE_NAME}:${VERSION}" "${DOCKER_IMAGE_NAME}:${VERSION}-alpha"
      docker tag "${DOCKER_IMAGE_NAME}:${VERSION}" "${DOCKER_IMAGE_NAME}:${VERSION}-alpha-$(date +%Y%m%d%H%M)"
      echo "Docker pushing alpha"
      docker push "${DOCKER_IMAGE_NAME}:${VERSION}-alpha"
      docker push "${DOCKER_IMAGE_NAME}:${VERSION}-alpha-$(date +%Y%m%d%H%M)"
  fi

  if [ "$OPERATION" = "release" ]
  then
      echo "Building for operation ${OPERATION}"
      echo "Docker tagging release version"
      docker tag "${DOCKER_IMAGE_NAME}:${VERSION}" "${DOCKER_IMAGE_NAME}:release"
      echo "Docker pushing release"
      docker push "${DOCKER_IMAGE_NAME}:release"
      docker push "${DOCKER_IMAGE_NAME}:${VERSION}"
  fi
}

if [ "$1" == "docker_push" ];then
    docker_push $2
fi

if [ "$1" == "docker_push_version_file" ];then
    docker_push $(load_version_from_file)
fi

