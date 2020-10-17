#!/usr/bin/env bash
set -e

if [ "${RELEASE_BRANCH}" = "" ]
then
  echo "Env RELEASE_BRANCH has not been provided"
  exit 128
fi

if [ "${POST_RELEASE_BRANCH}" = "" ]
then
  echo "Post release error. Env POST_RELEASE_BRANCH has not been provided"
  exit 128
fi

if [ "${GITHUB_TOKEN}" = "" ]
then
  echo "Post release error. Env GITHUB_TOKEN has not been provided"
  exit 128
fi

if [ "${TRAVIS_REPO_SLUG}" = "" ]
then
  echo "Post release error. Env TRAVIS_REPO_SLUG has not been provided"
  exit 128
fi



VERSION=$(head -n 1 version.txt)
NEW_VERSION=$(increment_version "$VERSION")

echo "Version: $VERSION"
echo "New Version: $NEW_VERSION"

echo "Running post release git push"
REMOTE_NAME="origin"

if [[ "${TRAVIS_REPO_SLUG}" ]]; then
  git remote rm $REMOTE_NAME
  echo "Setting remote url https://github.com/${TRAVIS_REPO_SLUG}.git"
  git remote add $REMOTE_NAME "https://${GITHUB_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git" >/dev/null 2>&1
  echo "Checking out $RELEASE_BRANCH as travis leaves the head detached."
  git checkout $RELEASE_BRANCH
fi

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
