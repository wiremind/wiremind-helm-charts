# kubemod

## About this Helm chart

KubeMod is a universal Kubernetes mutating operator.

https://github.com/kubemod/kubemod

## QuickStart

```bash
$ helm repo add wiremind https://wiremind.github.com/wiremind-helm-charts
$ helm install my-release wiremind/kubemod
```

## Introduction

This chart bootstraps a kubemod deployment and service on a Kubernetes cluster using the Helm Package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add wiremind https://wiremind.github.com/wiremind-helm-charts
$ helm install my-release wiremind/kubemod
```

The command deploys kubemod on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The configurable parameters of the kubemod chart and their descriptions can be seen in `values.yaml`.

> **Tip**: You can use the default [values.yaml](values.yaml)
