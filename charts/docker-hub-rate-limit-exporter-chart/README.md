# docker-hub-rate-limit-exporter Helm Chart

## How to install the chart

The helm chart can be installed through a helm chart repository hosted on a github page in this repository. To install follow the next steps:

1. run `helm repo add viadee https://viadee.github.io/docker-hub-rate-limit-exporter`
2. run `helm install <release-name> viadee/docker-hub-rate-limit-exporter`

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

| Parameter                         | Description                                                                                                       | Default |
| --------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ------- |
| `config.exporterPort`             | Port the deployment exposes                                                                                       | `80`    |
| `config.exporterVerbosity`        | Loglevel of the deployment                                                                                        | `1`     |
| `config.dockerhubUsername`        | To authenticate with dockerhub                                                                                    | `nil`   |
| `config.dockerhubPassword`        | To authenticate with dockerhub (use access token)                                                                 | `nil`   |
| `serviceMonitor.enabled`          | If true, creates a ServiceMonitor instance                                                                        | `false` |
| `serviceMonitor.additionalLabels` | Configure additional labels for the servicemonitor                                                                | `{}`    |
| `serviceMonitor.namespace`        | The namespace into which the servicemonitor is deployed. If not set, will the same as the namespace of this chart | `nil`   |
| `serviceMonitor.interval`         | The interval with which prometheus will scrape                                                                    | `30s`   |
| `serviceMonitor.scrapeTimeout`    | The timeout for the scrape request                                                                                | `10s`   |

## Attribution

<div>Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
