# Tag Release Buildkite Plugin

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) for tagging the release commit.

## Example

Recommended Usage:

```yml
steps:
  - label: ":cloud: Tag commit as pending"
    plugins:
    - ssh://git@bitbucket.org/ROKT/buildkite-tag-release.git#v1.0.0:
      pending_tag_name: "Pending ${ENVIRONMENT}-${REGION}"
      release_complete: false

  ...

  - label: ":cloud: Tag commit as completed"
    - ssh://git@bitbucket.org/ROKT/buildkite-tag-release.git#v1.0.0:
      pending_tag_name: "Pending ${ENVIRONMENT}-${REGION}"
      current_tag_name: "Current ${ENVIRONMENT}-${REGION}"
      previous_tag_name: "Previous ${ENVIRONMENT}-${REGION}"
      release_complete: true
```
