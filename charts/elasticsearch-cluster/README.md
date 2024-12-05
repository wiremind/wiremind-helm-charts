# Elasticsearch Cluster

A all-in-one hat chart.

## Introduction

A all-in-one hat chart containing:

- elasticsearch master nodes
- elasticsearch hot nodes
- elasticsearch warm nodes
- elasticsearch cold nodes
- elasticsearch ingest nodes
- kibana
- cerebro
- prometheus-elasticsearch-exporter
- build-in default ILM settings

Every component can be disabled.

## Configuration

Please refer to values.yaml for definition of possible values.

## Upgrade

### v3.8.6 to v4.3.2+

1. Scale down all statefulsets (elasticsearch and kibana)
2. kubectl delete deploy -l app=prometheus-elasticsearch-exporter --namespace $NAMESPACE
3. kubectl delete secret $RELEASE_NAME-es-token --namespace $NAMESPACE
4. Upgrade
