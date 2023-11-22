---
stage: Verify
group: Pipeline Security
info: "To determine the technical writer assigned to the Stage/Group associated with this page, see https://about.gitlab.com/handbook/product/ux/technical-writing/#assignments"
---

# Project CI/CD job token scope API **(FREE ALL)**

You can read more about the [CI/CD job token](../ci/jobs/ci_job_token.md)

NOTE:
All requests to the CI/CD job token scope API endpoint must be [authenticated](rest/index.md#authentication).
The authenticated user must have at least the Maintainer role for the project.

## Get a project's CI/CD job token access settings

Fetch the [CI/CD job token access settings](../ci/jobs/ci_job_token.md#configure-cicd-job-token-access) (job token scope) of a project.

```plaintext
GET /projects/:id/job_token_scope
```

Supported attributes:

| Attribute | Type           | Required | Description |
|-----------|----------------|----------|-------------|
| `id`      | integer/string | Yes      | ID or [URL-encoded path of the project](rest/index.md#namespaced-path-encoding). |

If successful, returns [`200`](rest/index.md#status-codes) and the following response attributes:

| Attribute          | Type    | Description |
|--------------------|---------|-------------|
| `inbound_enabled`  | boolean | Indicates if the CI/CD job token generated in other projects has access to this project. |
| `outbound_enabled` | boolean | Indicates if the CI/CD job token generated in this project has access to other projects. [Deprecated and planned for removal in GitLab 17.0](../update/deprecations.md#default-cicd-job-token-ci_job_token-scope-changed). |

Example request:

```shell
curl --header "PRIVATE-TOKEN: <your_access_token>" "https://gitlab.example.com/api/v4/projects/1/job_token_scope"
```

Example response:

```json
{
  "inbound_enabled": true,
  "outbound_enabled": false
}
```

## Patch a project's CI/CD job token access settings

> **Allow access to this project with a CI_JOB_TOKEN** setting [renamed to **Limit access _to_ this project**](https://gitlab.com/gitlab-org/gitlab/-/issues/411406) in GitLab 16.3.

Patch the [**Limit access _to_ this project** setting](../ci/jobs/ci_job_token.md#disable-the-job-token-scope-allowlist) (job token scope) of a project.

```plaintext
PATCH /projects/:id/job_token_scope
```

Supported attributes:

| Attribute | Type           | Required | Description |
|-----------|----------------|----------|-------------|
| `id`      | integer/string | Yes      | ID or [URL-encoded path of the project](rest/index.md#namespaced-path-encoding). |
| `enabled` | boolean        | Yes      | Indicates CI/CD job tokens generated in other projects have restricted access to this project. |

If successful, returns [`204`](rest/index.md#status-codes) and no response body.

Example request:

```shell
curl --request PATCH \
  --url "https://gitlab.example.com/api/v4/projects/1/job_token_scope" \
  --header 'PRIVATE-TOKEN: <your_access_token>' \
  --header 'Content-Type: application/json' \
  --data '{ "enabled": false }'
```

## Get a project's CI/CD job token inbound allowlist

Fetch the [CI/CD job token inbound allowlist](../ci/jobs/ci_job_token.md#allow-access-to-your-project-with-a-job-token) (job token scope) of a project.

```plaintext
GET /projects/:id/job_token_scope/allowlist
```

Supported attributes:

| Attribute | Type           | Required | Description |
|-----------|----------------|----------|-------------|
| `id`      | integer/string | Yes      | ID or [URL-encoded path of the project](rest/index.md#namespaced-path-encoding). |

This endpoint supports [offset-based pagination](rest/index.md#offset-based-pagination).

If successful, returns [`200`](rest/index.md#status-codes) and a list of project with limited fields for each project.

Example request:

```shell
curl --header "PRIVATE-TOKEN: <your_access_token>" "https://gitlab.example.com/api/v4/projects/1/job_token_scope/allowlist"
```

Example response:

```json
[
  {
    "id": 4,
    "description": null,
    "name": "Diaspora Client",
    "name_with_namespace": "Diaspora / Diaspora Client",
    "path": "diaspora-client",
    "path_with_namespace": "diaspora/diaspora-client",
    "created_at": "2013-09-30T13:46:02Z",
    "default_branch": "main",
    "tag_list": [
      "example",
      "disapora client"
    ],
    "topics": [
      "example",
      "disapora client"
    ],
    "ssh_url_to_repo": "git@gitlab.example.com:diaspora/diaspora-client.git",
    "http_url_to_repo": "https://gitlab.example.com/diaspora/diaspora-client.git",
    "web_url": "https://gitlab.example.com/diaspora/diaspora-client",
    "avatar_url": "https://gitlab.example.com/uploads/project/avatar/4/uploads/avatar.png",
    "star_count": 0,
    "last_activity_at": "2013-09-30T13:46:02Z",
    "namespace": {
      "id": 2,
      "name": "Diaspora",
      "path": "diaspora",
      "kind": "group",
      "full_path": "diaspora",
      "parent_id": null,
      "avatar_url": null,
      "web_url": "https://gitlab.example.com/diaspora"
    }
  },
  {
    ...
  }
```

## Add a project to a CI/CD job token inbound allowlist

Add a project to the [CI/CD job token inbound allowlist](../ci/jobs/ci_job_token.md#allow-access-to-your-project-with-a-job-token) of a project.

```plaintext
POST /projects/:id/job_token_scope/allowlist
```

Supported attributes:

| Attribute           | Type           | Required | Description |
|---------------------|----------------|----------|-------------|
| `id`                | integer/string | Yes      | ID or [URL-encoded path of the project](rest/index.md#namespaced-path-encoding). |
| `target_project_id` | integer        | Yes      | The ID of the project added to the CI/CD job token inbound allowlist. |

If successful, returns [`201`](rest/index.md#status-codes) and the following response attributes:

| Attribute           | Type    | Description |
|---------------------|---------|-------------|
| `source_project_id` | integer | ID of the project containing the CI/CD job token inbound allowlist to update. |
| `target_project_id` | integer | ID of the project that is added to the source project's inbound allowlist. |

Example request:

```shell
curl --request POST \
  --url "https://gitlab.example.com/api/v4/projects/1/job_token_scope/allowlist" \
  --header 'PRIVATE-TOKEN: <your_access_token>' \
  --header 'Content-Type: application/json' \
  --data '{ "target_project_id": 2 }'
```

Example response:

```json
{
  "source_project_id": 1,
  "target_project_id": 2
}
```

## Remove a project from a CI/CD job token inbound allowlist

Remove a project from the [CI/CD job token inbound allowlist](../ci/jobs/ci_job_token.md#allow-access-to-your-project-with-a-job-token) of a project.

```plaintext
DELETE /projects/:id/job_token_scope/allowlist/:target_project_id
```

Supported attributes:

| Attribute           | Type           | Required | Description |
|---------------------|----------------|----------|-------------|
| `id`                | integer/string | Yes      | ID or [URL-encoded path of the project](rest/index.md#namespaced-path-encoding). |
| `target_project_id` | integer        | Yes      | The ID of the project that is removed from the CI/CD job token inbound allowlist. |

If successful, returns [`204`](rest/index.md#status-codes) and no response body.

Example request:

```shell
curl --request DELETE \
  --url "https://gitlab.example.com/api/v4/projects/1/job_token_scope/allowlist/2" \
  --header 'PRIVATE-TOKEN: <your_access_token>' \
  --header 'Content-Type: application/json'
```
