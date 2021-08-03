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
if [ -n "$TAG_IDENTIFIER" ]; then separator="/"; else separator=""; fi
identifier="$separator${4:-}"
tag_prefix="deployment$identifier/$env/$region"

echo "--- :git: tagging release."

# git config user.email "buildkite@rokt.com"
# git config user.name "Buildkite"

git config user.email "${BUILDKITE_BUILD_AUTHOR_EMAIL:-$BUILDKITE_BUILD_CREATOR_EMAIL}"
git config user.name "${BUILDKITE_BUILD_AUTHOR:-$BUILDKITE_BUILD_CREATOR}"

# Delete any tags with name 'REMOVE_TAG_NAME' (might not exist)
if [ "$REMOVE_TAG_NAME" != "" ]; then git push origin :refs/tags/"$tag_prefix/$REMOVE_TAG_NAME" || true; fi

if [ "$REPLACE_TAGNAME" != "" ];
then
  # Delete any existing tags with name 'REPLACE_TAGNAME' (might not exist)
  git push origin :refs/tags/"$tag_prefix/$REPLACE_TAGNAME" || true
  # Then replace any tags with name 'CURRENT_TAG_NAME' with 'REPLACE_TAGNAME' (might not exist)
  git push origin refs/tags/"$tag_prefix/$CURRENT_TAG_NAME":refs/tags/"$tag_prefix/$REPLACE_TAGNAME" :refs/tags/"$tag_prefix/$CURRENT_TAG_NAME" || true
else
  # Otherwise, just delete any existing tags with name 'CURRENT_TAG_NAME' (might not exist)
  git push origin :refs/tags/"$tag_prefix/$CURRENT_TAG_NAME" || true
fi

# Create new local tag with name 'CURRENT_TAG_NAME'
TAG_MESSAGE="{\"BUILDKITE_JOB_ID\"=${BUILDKITE_JOB_ID},\"BUILDKITE_BUILD_NUMBER\"=\"${BUILDKITE_BUILD_NUMBER}\",\"BUILDKITE_BUILD_URL\"=\"${BUILDKITE_BUILD_URL}\" }"
git tag -fa "$tag_prefix/$CURRENT_TAG_NAME" -m "${TAG_MESSAGE}"

# Push the new tag
git push origin refs/tags/"$tag_prefix/$CURRENT_TAG_NAME"
