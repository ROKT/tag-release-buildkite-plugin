#!/bin/bash
set -euo pipefail

CURRENT_TAG_NAME=$1
REMOVE_TAG_NAME=${2:-}
REPLACE_TAGNAME=${3:-}
TAG_IDENTIFIER=${4:-}

IFS=':' read -ra step_key_array <<< "${BUILDKITE_STEP_KEY}"

if [ ${#step_key_array[@]} -lt 4 ]
then
    echo -e "\e[33mStep Key not in correct format to determine tag name. Expected format is deployment:{env}:{region}:{name}\e[0m"
    exit 0
fi

env=${step_key_array[1]}
region=${step_key_array[2]}
if [ ! -z "$TAG_IDENTIFIER" ]; then separator="-"; else separator=""; fi
identifier="$separator${4:-}"
tag_postfix="$env-$region$identifier"

echo "--- :git: tagging release."

git config user.email "buildkite@rokt.com"
git config user.name "Buildkite"

# Delete any tags with name 'REMOVE_TAG_NAME' (might not exist)
if [ "$REMOVE_TAG_NAME" != "" ]; then git push origin :refs/tags/"$REMOVE_TAG_NAME-$tag_postfix" || true; fi

if [ "$REPLACE_TAGNAME" != "" ];
then
    # Replace any tags with name 'CURRENT_TAG_NAME' with 'REPLACE_TAGNAME' (might not exist)
    git push origin refs/tags/"$CURRENT_TAG_NAME-$tag_postfix":refs/tags/"$REPLACE_TAGNAME-$tag_postfix" :refs/tags/"$CURRENT_TAG_NAME-$tag_postfix" || true
else
    # Otherwise, delete any existing tags with name 'CURRENT_TAG_NAME' (might not exist)
    git push origin :refs/tags/"$CURRENT_TAG_NAME-$tag_postfix" || true
fi

# Create new local tag with name 'CURRENT_TAG_NAME'
TAG_MESSAGE="{\"BUILDKITE_JOB_ID\"=${BUILDKITE_JOB_ID},\"BUILDKITE_BUILD_NUMBER\"=\"${BUILDKITE_BUILD_NUMBER}\",\"BUILDKITE_BUILD_URL\"=\"${BUILDKITE_BUILD_URL}\", }"
git tag -fa "$CURRENT_TAG_NAME-$tag_postfix" -m "${TAG_MESSAGE}"

# Push the new tag
git push origin refs/tags/"$CURRENT_TAG_NAME-$tag_postfix"
