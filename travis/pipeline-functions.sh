#!/usr/bin/env bash
set -e

REMOTE_NAME="origin"

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
  CHECKOUT_BRANCH = $1
  git remote rm $REMOTE_NAME
  echo "Setting remote url https://github.com/${TRAVIS_REPO_SLUG}.git"
  git remote add $REMOTE_NAME "https://${GITHUB_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git" >/dev/null 2>&1
  echo "Checking out $CHECKOUT_BRANCH as travis leaves the head detached."
  git checkout $CHECKOUT_BRANCH
}
