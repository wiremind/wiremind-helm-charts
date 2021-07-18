# Grafana PDF Exporter

Grafana PDF Exporter can help you export your Grafana dashboard as PDF

## Introduction

This chart deploys Grafana PDF Exporter to your cluster via a Deployment and Service or CronJobs.

## WIP

TODO: Enable PDF creation from the Grafana dashboard window directly

# Prerequisites

- A running Grafana instance

## Installing the Chart

To install the chart with the release name `my-release`, run:

```bash
$ helm repo add wiremind https://wiremind.github.io/wiremind-helm-charts
$ helm install --name my-release wiremind/grafana-pdf-export
```

After a few seconds, you should see service statuses being written to the configured output.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The values.yaml lists the configurable parameters of the Grafana PDF Exporter chart and their default values.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    wiremind/grafana-pdf-export
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml wiremind/grafana-pdf-export
```


### Usage

## Stand Alone mode

You may export a grafana dashboard doing this.
Connect to your Grafana PDF Export pod

```bash
$ ./grafana_pdf_exporter.sh "https://grafana.xx/d/xx/xx&refresh=5s" output.pdf
```

Not that it is recommended to add ```&kiosk``` in your grafana dashboard URL so it will not display the Grafana menu bars

This will export your PDF to /output.pdf of your pod and upload it to the configured AWS Bucket (if enabled)
In case there is no configured AWS upload, it is possible to copy the file to your host station.

```bash
$ kubectl cp -n monitoring grafana-pdf-test-grafana-pdf-exporter-65475db8ff-wpgjj -c grafana-pdf-exporter   -- tar cf - /output.pdf | tar xf - -C /tmp/
```

Note that for very tall dashboards this will not export the whole dashboard but only what can be displayed in a normal Chrome window.
TODO: enable support for taller dashboards export

## CronJob Mode

The better way is to set a Cron Job so you can get your dashboard exported at regular intervals and sent by email.

For now it only supports sending reports using SendGrid. There is a Free plan supporting 100email/day which may be enough for your needs.