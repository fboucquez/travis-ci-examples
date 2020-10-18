#!/usr/bin/env bash
set -e
. ./travis/travis-functions.sh
echo "Releasing $(resolve_operation) on version $(load_version_from_file)"

push_github_pages $(load_version_from_file) 'my-docs/'
