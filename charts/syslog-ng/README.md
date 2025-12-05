# syslog-ng

syslog-ng is an enhanced log daemon that supports a wide range of input and output methods, including syslog, message queues, and databases, for flexible log management and forwarding.

## Introduction

This chart deploys syslog-ng to your Kubernetes cluster via a Deployment and Service using the [linuxserver/syslog-ng](https://hub.docker.com/r/linuxserver/syslog-ng) Docker image.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+

## Installing the Chart

To install the chart with the release name `my-release`, run:

```bash
$ helm repo add wiremind https://wiremind.github.io/wiremind-helm-charts
$ helm install my-release wiremind/syslog-ng
```

After a few seconds, syslog-ng should be running and ready to receive logs.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the syslog-ng chart and their default values.

### Image Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Image repository | `lscr.io/linuxserver/syslog-ng` |
| `image.tag` | Image tag | `""` (uses Chart appVersion: 4.8.3) |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |

### Environment Variables

| Parameter | Description | Default |
|-----------|-------------|---------|
| `env` | Environment variables map | See values.yaml |
| `env.TZ` | Timezone | `Etc/UTC` |
| `env.LOG_TO_STDOUT` | Log to stdout instead of /config/log/ | `"true"` (enabled) |
| `extraEnv` | Additional environment variables | `{}` |
| `extraSecretEnv` | Additional environment variables from secrets | `{}` |

### Service Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.ports` | List of service ports | See values.yaml |
| `service.ports[].name` | Port name | `syslog-udp`, `syslog-tcp` |
| `service.ports[].port` | External port | `514` (both UDP and TCP) |
| `service.ports[].targetPort` | Internal container port | `5514` |
| `service.ports[].protocol` | Protocol | `UDP`, `TCP` |

### Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `config.enabled` | Create ConfigMap with syslog-ng.conf | `true` |
| `config.syslogNgConf` | syslog-ng.conf content | See values.yaml |
| `config.existingConfigMap` | Use existing ConfigMap | `""` |

### Container Command and Args

| Parameter | Description | Default |
|-----------|-------------|---------|
| `command` | Container command override | `[]` (uses image default) |
| `args` | Container args override | `[]` (uses image default) |

### Resources

| Parameter | Description | Default |
|-----------|-------------|---------|
| `resources` | CPU/Memory resource requests and limits | See values.yaml |
| `resources.limits.cpu` | CPU limit | `500m` |
| `resources.limits.memory` | Memory limit | `512Mi` |
| `resources.requests.cpu` | CPU request | `100m` |
| `resources.requests.memory` | Memory request | `128Mi` |

### Probes

| Parameter | Description | Default |
|-----------|-------------|---------|
| `livenessProbe.enabled` | Enable liveness probe | `false` |
| `readinessProbe.enabled` | Enable readiness probe | `false` |

### Pod Scheduling

| Parameter | Description | Default |
|-----------|-------------|---------|
| `priorityClassName` | Priority class name for pod scheduling | `""` |
| `runtimeClassName` | Runtime class name for pod execution | `""` |
| `nodeSelector` | Node selector for pod assignment | `{}` |
| `tolerations` | Tolerations for pod assignment | `[]` |
| `affinity` | Affinity rules for pod assignment | `{}` |
| `topologySpreadConstraints` | Topology spread constraints | `[]` |

### Pod Disruption Budget

| Parameter | Description | Default |
|-----------|-------------|---------|
| `podDisruptionBudget.enabled` | Enable PodDisruptionBudget | `false` |
| `podDisruptionBudget.minAvailable` | Minimum available pods during disruption | `""` |
| `podDisruptionBudget.maxUnavailable` | Maximum unavailable pods during disruption | `""` |

## Usage Examples

### Basic Installation

```bash
helm install syslog-ng wiremind/syslog-ng
```

### Custom Configuration

Create a custom `values.yaml`:

```yaml
config:
  syslogNgConf: |
    @version: 4.8
    @include "scl.conf"

    # Sources
    source s_net {
        network(
            ip(0.0.0.0)
            port(5514)
            transport("udp")
        );
        network(
            ip(0.0.0.0)
            port(5514)
            transport("tcp")
        );
    };

    # Destinations
    destination d_messages {
        stdout();
    };

    # Log paths - connect sources to destinations
    log {
        source(s_net);
        destination(d_messages);
    };
```

Then install:

```bash
helm install syslog-ng wiremind/syslog-ng -f values.yaml
```

### Using NodePort Service

```yaml
service:
  type: NodePort
```

### Custom Service Ports

Add or modify service ports:

```yaml
service:
  ports:
    - name: syslog-udp
      port: 514
      targetPort: 5514
      protocol: UDP
    - name: syslog-tcp
      port: 514
      targetPort: 5514
      protocol: TCP
    - name: custom-port
      port: 9000
      targetPort: 9000
      protocol: TCP
```

### Using Topology Spread Constraints

```yaml
topologySpreadConstraints:
  - maxSkew: 1
    topologyKey: topology.kubernetes.io/zone
    whenUnsatisfiable: ScheduleAnyway
    labelSelector:
      matchLabels:
        app.kubernetes.io/name: syslog-ng
        app.kubernetes.io/instance: RELEASE-NAME
```

### Using Affinity Rules

```yaml
affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchExpressions:
              - key: app.kubernetes.io/name
                operator: In
                values:
                  - syslog-ng
          topologyKey: kubernetes.io/hostname
```

### Using Existing ConfigMap

If you have an existing ConfigMap with syslog-ng.conf:

```yaml
config:
  enabled: false
  existingConfigMap: "my-syslog-ng-config"
```

### Custom Container Command and Args

Override the container command or arguments:

```yaml
command:
  - /custom/command

args:
  - --custom-arg
  - value
```

### Using PodDisruptionBudget

Enable PodDisruptionBudget to ensure availability during disruptions:

```yaml
podDisruptionBudget:
  enabled: true
  minAvailable: 1  # Or use maxUnavailable instead
```

Or:

```yaml
podDisruptionBudget:
  enabled: true
  maxUnavailable: 1
```

## Ports and Protocols

The chart exposes ports configured in `service.ports`. By default:

- **UDP 514**: Standard syslog protocol (mapped to container port 5514)
- **TCP 514**: Reliable syslog over TCP (mapped to container port 5514)

You can add or modify ports by updating the `service.ports` list in `values.yaml`.

## Configuration File

The syslog-ng configuration file is mounted at `/config/syslog-ng.conf` inside the container. You can customize it by:

1. Providing custom configuration in `values.yaml` under `config.syslogNgConf`
2. Using an existing ConfigMap via `config.existingConfigMap`

The default configuration:
- Uses syslog-ng 4.8 format (`@version: 4.8`)
- Listens on UDP and TCP protocols on port 5514
- Outputs logs to stdout using `stdout()` driver
- Includes a `log` statement connecting sources to destinations

The `/config` directory uses ephemeral storage (emptyDir) by default. The `/run` directory is mounted as tmpfs (1Gi limit) for s6-overlay compatibility.

## Security Context

The chart includes security context settings for running securely:
- `readOnlyRootFilesystem: true` by default
- Capabilities: `SETGID`, `SETUID`, `CHOWN` are added, all others dropped
- `allowPrivilegeEscalation: false`
- Seccomp profile: `RuntimeDefault`

You can customize security context settings via `podSecurityContext` and `securityContext` in values.yaml.

## Health Checks

The chart includes configurable liveness and readiness probes that use `syslog-ng-ctl stats` to verify the service is running and ready. Probes are disabled by default (`enabled: false`) but can be enabled via `livenessProbe.enabled` and `readinessProbe.enabled` in values.yaml.

## Troubleshooting

### Check Pod Status

```bash
kubectl get pods -l app.kubernetes.io/name=syslog-ng
```

### View Logs

```bash
kubectl logs -l app.kubernetes.io/name=syslog-ng
```

### Test syslog-ng Configuration

```bash
kubectl exec -it <pod-name> -- syslog-ng-ctl config-test
```

### Reload Configuration

```bash
kubectl exec -it <pod-name> -- syslog-ng-ctl reload
```

### Check PodDisruptionBudget Status

```bash
kubectl get pdb -n <namespace> -l app.kubernetes.io/name=syslog-ng
```

## References

- [syslog-ng Documentation](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition)
- [linuxserver/syslog-ng Docker Image](https://hub.docker.com/r/linuxserver/syslog-ng)
- [linuxserver/syslog-ng GitHub](https://github.com/linuxserver/docker-syslog-ng)
