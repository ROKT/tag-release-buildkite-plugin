#!/bin/bash
set -euo pipefail

CURRENT_TAG_NAME=$1
REMOVE_TAG_NAME={$2:-}
REPLACE_TAGNAME={$3:-}

echo "--- :git: tagging release"

git config user.email "buildkite@rokt.com"
git config user.name "Buildkite"

# Delete any tags with name 'REMOVE_TAG_NAME' (might not exist)
if [ REMOVE_TAG_NAME != '']; then git push origin :refs/tags/"$REMOVE_TAG_NAME" || true; fi

if [ REPLACE_TAGNAME != ''];
then
    # Replace any tags with name 'CURRENT_TAG_NAME' with 'REPLACE_TAGNAME' (might not exist)
    git push origin refs/tags/"$CURRENT_TAG_NAME":refs/tags/"$REPLACE_TAGNAME" :refs/tags/"$CURRENT_TAG_NAME" || true
else
    # Otherwise, delete any existing tags with name 'CURRENT_TAG_NAME' (might not exist)
    git push origin :refs/tags/"$CURRENT_TAG_NAME" || true
fi

# Create new local tag
TAG_MESSAGE="{\"BUILDKITE_JOB_ID\"=${BUILDKITE_JOB_ID},\"BUILDKITE_BUILD_NUMBER\"=\"${BUILDKITE_BUILD_NUMBER}\",\"BUILDKITE_BUILD_URL\"=\"${BUILDKITE_BUILD_URL}\", }"
git tag -fa "$CURRENT_TAG_NAME" -m "${TAG_MESSAGE}"

# Show the tags
git --no-pager tag

# Push the new tag
git push origin refs/tags/"$CURRENT_TAG_NAME"
