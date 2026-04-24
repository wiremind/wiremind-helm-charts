# prometheus-openstack-exporter

A Helm chart for [prometheus-openstack-exporter](https://github.com/openstack-exporter/openstack-exporter) - exports OpenStack metrics for Prometheus.

This chart is forked from the [upstream helm-charts repository](https://github.com/openstack-exporter/helm-charts) with the following enhancements:

- `existingSecret` support for managing credentials externally
- ServiceAccount with optional creation and annotations
- PodDisruptionBudget support
- NetworkPolicy support
- HorizontalPodAutoscaler support
- Enhanced security contexts (pod and container level)
- Additional pod labels and annotations configurability
- Topology spread constraints
- Liveness and readiness probes
- Image pull secrets support

## Installation

```bash
helm repo add wiremind https://wiremind.github.io/wiremind-helm-charts
helm install prometheus-openstack-exporter wiremind/prometheus-openstack-exporter
```

## Configuration

### Using an existing Secret

Instead of providing credentials in values, you can reference an existing Kubernetes Secret:

```yaml
secret:
  existingSecret: "my-openstack-credentials"
  existingSecretKey: "clouds.yaml"

clouds_yaml_config: ""  # Leave empty when using existingSecret
```

The secret should contain your `clouds.yaml` content:

```bash
kubectl create secret generic my-openstack-credentials \
  --from-file=clouds.yaml=/path/to/your/clouds.yaml
```

### Multi-cloud setup

```yaml
multicloud:
  enabled: true
  selfmonitor: true
  clouds:
    - name: production
      services:
        - compute
        - network
        - volume
    - name: staging
      services:
        - compute
        - network

clouds_yaml_config: |
  clouds:
    production:
      region_name: region1
      auth:
        auth_url: https://openstack-prod.example.com:5000/v3
        username: exporter
        password: secret
        project_name: monitoring
        project_domain_name: Default
        user_domain_name: Default
    staging:
      region_name: region1
      auth:
        auth_url: https://openstack-staging.example.com:5000/v3
        username: exporter
        password: secret
        project_name: monitoring
        project_domain_name: Default
        user_domain_name: Default
```

### Disabling specific services

```yaml
extraArgs:
  - --disable-service.baremetal
  - --disable-service.container-infra
  - --disable-service.object-store
```

## Values

See [values.yaml](values.yaml) for the full list of configurable values with descriptions.

## Upgrading

### From upstream chart

If migrating from the upstream chart, note the following changes:

1. The secret name now includes the release name: `<release>-prometheus-openstack-exporter-config`
2. You can use `secret.existingSecret` to reference your existing `openstack-config` secret
3. ServiceAccount is now created by default (disable with `serviceAccount.create: false`)
4. Security contexts are applied by default for better security posture
