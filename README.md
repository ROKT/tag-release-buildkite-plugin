# Tag Release Buildkite Plugin

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) for tagging the release commit.

## Pre-requisites

This plugin records the environment and region as part of the tag name. These are extracted from the Step Key which must be in the format deployment:{env}:{region}:{name}

## Example

Recommended Usage:

```yml
steps:
  - label: ":cloud: Tag commit as pending"
    key: "deployment:${ENVIRONMENT}:${REGION}:tag-commit-pending"
    plugins:
    - ssh://git@bitbucket.org/ROKT/buildkite-tag-release.git#v1.0.0:
      release_complete: false

  ...

  - label: ":cloud: Tag commit as completed"
    key: "deployment:${ENVIRONMENT}:${REGION}:tag-commit-completed"
    - ssh://git@bitbucket.org/ROKT/buildkite-tag-release.git#v1.0.0:
      release_complete: true
```
