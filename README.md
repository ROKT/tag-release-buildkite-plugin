# Tag Release Buildkite Plugin

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) for tagging the release commit.

## Pre-requisites

This plugin records the environment and region as part of the tag name. These are extracted from the Step Key which must be in the format `deployment:{env}:{region}:{name}`

## Example

Set `mark_pending` to true to set the "pending" tag in a pre-command hook before the deployment starts. Set `mark_completed` to true to set the "current" & "previous" tags as a post-command hook after the deployment has succeeded (and remove the "pending" tag). At least one of these parameters should be true, and it's valid for them both to be true if your deployment only includes one step.

If you want to have release tags for different services deployed from the same repo, in the same or different build plans, you can provide a `tag_identifier`, that will be included in the tag name, to differentiate these.

Note the full tag name will be in the format `deployment[/{tag_identifier}]/{env}/{region}/<current|pending|previous>`.

#### Single Step Deployment:

```yml
env:
  ENVIRONMENT: prod
  REGION: us-west-2

steps:
  - label: "Single Deployment Step"
    key: "deployment:${ENVIRONMENT}:${REGION}:single-deployment-step"
    plugins:
    - rokt/tag-releas#v1.0.0:
        mark_pending: true
        mark_completed: true
```

#### Multi Step Deployment:

```yml
env:
  ENVIRONMENT: prod
  REGION: us-west-2

steps:
  - label: "First Deployment Step"
    key: "deployment:${ENVIRONMENT}:${REGION}:first-deployment-step"
    plugins:
    - rokt/tag-release#v1.0.0:
        mark_pending: true

  - label: "Final Deployment Step"
    key: "deployment:${ENVIRONMENT}:${REGION}:last-deployment-step"
    - rokt/tag-releas#v1.0.0:
        mark_completed: true
```

#### Deployment of Multiple Services:

```yml
env:
  ENVIRONMENT: prod
  REGION: us-west-2

steps:
  - label: "Deploy Service One"
    key: "deployment:${ENVIRONMENT}:${REGION}:deploy-service-one"
    plugins:
    - rokt/tag-releas#v1.0.0:
        mark_pending: true
        mark_completed: true
        tag_identifier: service-one

  - label: "Begin Deployment of Service Two"
    key: "deployment:${ENVIRONMENT}:${REGION}:begin-deploy-service-two"
    plugins:
    - rokt/tag-releas#v1.0.0:
        mark_pending: true
        tag_identifier: service-two

  - label: "Complete Deployment of Service Two"
    key: "deployment:${ENVIRONMENT}:${REGION}:complete-deployment-service-two"
    - rokt/tag-releas#v1.0.0:
        mark_completed: true
        tag_identifier: service-two
```
