# Marge-bot Helm Chart
Marge-bot is a merge-bot for GitLab

This is a fork of [zhilyaev/marge-bot-helm](https://github.com/zhilyaev/marge-bot-helm/)
using [hiboxsystems/marge-bot](https://github.com/hiboxsystems/marge-bot) instead of
non maintained [smarkets/marge-bot](https://github.com/smarkets/marge-bot)


See [hiboxsystems/marge-bot](https://github.com/hiboxsystems/marge-bot) for more project details.

## Chart Details

This chart uses env vars from [values.yaml](values.yaml) of helm chart.

Marge-bot version listed in the [Chart.yaml](Chart.yaml)

## Installing the Marge-bot Helm Chart

### Inline
```bash
$ helm repo add wiremind https://wiremind.github.io/wiremind-helm-charts
$ helm install <RELEASE_NAME> wiremind/marge-bot \
 --set "env[0].name=MARGE_GITLAB_URL" --set "env[0].value=<GITLAB_URL>" \
 --set "env[0].name=MARGE_AUTH_TOKEN" --set "env[0].value=<GITLAB_AUTH_TOKEN>" \
 --set "env[0].name=MARGE_SSH_KEY"    --set "env[0].value=$(cat ssh-key)"
```

### With values file

```bash
$ cat my.values
env:
  - name: MARGE_GITLAB_URL
    value: https://gitlab.com
  - name: MARGE_AUTH_TOKEN
    value: asdfsdkafjkdaf
  - name: MARGE_SSH_KEY
    value: |-
      -----BEGIN RSA PRIVATE KEY-----
$ helm install <RELEASE_NAME> stable/marge-bot -f my.values
```
