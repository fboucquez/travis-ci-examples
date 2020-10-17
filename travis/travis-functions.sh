#!/usr/bin/env bash
set -e

REMOTE_NAME="origin"

test_travis_functions ()
{
  echo "Travis Functions Loaded"
}

increment_version ()
{
  declare -a part=( ${1//\./ } )
  declare    new
  declare -i carry=1

  for (( CNTR=${#part[@]}-1; CNTR>=0; CNTR-=1 )); do
    len=${#part[CNTR]}
    new=$((part[CNTR]+carry))
    [ ${#new} -gt $len ] && carry=1 || carry=0
    [ $CNTR -gt 0 ] && part[CNTR]=${new: -len} || part[CNTR]=${new}
  done
  new="${part[*]}"
  echo -e "${new// /.}"
}

resolve_operation ()
{
  validate_env_variable "TRAVIS_EVENT_TYPE"
  validate_env_variable "TRAVIS_COMMIT_MESSAGE"
  validate_env_variable "RELEASE_BRANCH"
  validate_env_variable "DEV_BRANCH"
  OPERATION=""
  if [ "$TRAVIS_EVENT_TYPE" != "pull_request" ] && [ "$TRAVIS_COMMIT_MESSAGE" == "release" ]  && [ "$TRAVIS_BRANCH" == "$RELEASE_BRANCH" ];
   then
     OPERATION="release"
   else
       if [ "$TRAVIS_EVENT_TYPE" != "pull_request" ] && [ "$TRAVIS_BRANCH" == "$DEV_BRANCH" ];
     then
       OPERATION="publish"
     else
       OPERATION="build"
    fi
  fi
  echo "Resolved OPERATION $OPERATION"
}

validate_env_variable ()
{
  var="$1"
  if [ "${!var}" = "" ]
    then
      echo "Env $var has not been provided"
      exit 128
  fi
}


checkout_branch ()
{
  CHECKOUT_BRANCH="$1"
  validate_env_variable "TRAVIS_REPO_SLUG"
  validate_env_variable "CHECKOUT_BRANCH"
  validate_env_variable "GITHUB_TOKEN"
  validate_env_variable "REMOTE_NAME"
  git remote rm $REMOTE_NAME
  echo "Setting remote url https://github.com/${TRAVIS_REPO_SLUG}.git"
  git remote add $REMOTE_NAME "https://${GITHUB_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git" >/dev/null 2>&1
  echo "Checking out $CHECKOUT_BRANCH as travis leaves the head detached."
  git checkout $CHECKOUT_BRANCH
}


post_release(){

  validate_env_variable "RELEASE_BRANCH"
  validate_env_variable "REMOTE_NAME"
  validate_env_variable "POST_RELEASE_BRANCH"
  checkout_branch "${RELEASE_BRANCH}"

  VERSION=$(head -n 1 version.txt)
  NEW_VERSION=$(increment_version "$VERSION")

  echo "Version: $VERSION"
  echo "New Version: $NEW_VERSION"

  echo "Current Version"
  cat version.txt
  echo ""

  echo "Releasing version $VERSION"
  echo "$VERSION" > 'version.txt'
  git add version.txt
  git commit -m "Releasing version $VERSION"

  echo "Creating tag version v$VERSION"
  git tag -fa "v$VERSION" -m "Releasing version $VERSION"

  echo "Creating new version $NEW_VERSION"
  echo "$NEW_VERSION" > 'version.txt'
  git add version.txt
  git commit -m "Creating new version $NEW_VERSION"

  echo "Pushing code to $REMOTE_NAME $POST_RELEASE_BRANCH"
  git push $REMOTE_NAME $RELEASE_BRANCH:$POST_RELEASE_BRANCH
  echo "Pushing tags to $REMOTE_NAME"
  git push --tags $REMOTE_NAME

}

resolve_operation

if [ "$1" == "post_release" ];then
    post_release
fi

