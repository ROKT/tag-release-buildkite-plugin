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
        mark_pending: true

  ...

  - label: ":cloud: Tag commit as completed"
    key: "deployment:${ENVIRONMENT}:${REGION}:tag-commit-completed"
    - ssh://git@bitbucket.org/ROKT/buildkite-tag-release.git#v1.0.0:
        mark_completed: true
```

If you want to have release tags for different services deployed from the same repo, you can provide a tag_identifier to differentiate these. You can use multiple of these in the same build plan if desired.

```yml
steps:
  - label: ":cloud: Tag commit as pending"
    key: "deployment:${ENVIRONMENT}:${REGION}:tag-commit-pending"
    plugins:
    - ssh://git@bitbucket.org/ROKT/buildkite-tag-release.git#v1.0.0:
        mark_pending: true
        tag_identifier: service-name

  ...

  - label: ":cloud: Tag commit as completed"
    key: "deployment:${ENVIRONMENT}:${REGION}:tag-commit-completed"
    - ssh://git@bitbucket.org/ROKT/buildkite-tag-release.git#v1.0.0:
        mark_completed: true
        tag_identifier: service-name
```
