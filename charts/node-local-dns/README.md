# node-local-dns

NodeLocal DNS Cache helm chart

![Version: 2.4.0](https://img.shields.io/badge/Version-2.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.23.1](https://img.shields.io/badge/AppVersion-1.23.1-informational?style=flat-square)

[<img src="https://lablabs.io/static/ll-logo.png" width=350px>](https://lablabs.io/)

## Installing the Chart

This chart deploys NodeLocal DNSCache Daemon set according to <https://kubernetes.io/docs/tasks/administer-cluster/nodelocaldns/>.

It is designed to work both with iptables and IPVS setup.

Latest available `node-local-dns` image can be found at [node-local-dns google container repository](https://console.cloud.google.com/gcr/images/google-containers/GLOBAL/k8s-dns-node-cache)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| commonLabels | object | `{}` |  |
| config.localDnsIp | string | `"169.254.20.11"` |  |
| config.zones.".:53".plugins.cache.denial | object | `{}` |  |
| config.zones.".:53".plugins.cache.parameters | int | `30` |  |
| config.zones.".:53".plugins.cache.prefetch | object | `{}` |  |
| config.zones.".:53".plugins.cache.serve_stale | object | `{}` | Set to `{duration: 10m, refresh_mode: immediate}` to serve expired answers when the upstream is unreachable. Defaults to CoreDNS' `1h immediate` when set to a non-empty map without keys. |
| config.zones.".:53".plugins.cache.success | object | `{}` |  |
| config.zones.".:53".plugins.debug | bool | `false` |  |
| config.zones.".:53".plugins.errors | bool | `true` |  |
| config.zones.".:53".plugins.forward.except | string | `""` |  |
| config.zones.".:53".plugins.forward.expire | string | `""` |  |
| config.zones.".:53".plugins.forward.force_tcp | bool | `false` |  |
| config.zones.".:53".plugins.forward.health_check | string | `""` |  |
| config.zones.".:53".plugins.forward.max_fails | string | `""` |  |
| config.zones.".:53".plugins.forward.parameters | string | `"__PILLAR__UPSTREAM__SERVERS__"` |  |
| config.zones.".:53".plugins.forward.policy | string | `""` |  |
| config.zones.".:53".plugins.forward.prefer_udp | bool | `false` |  |
| config.zones.".:53".plugins.health.port | int | `8080` |  |
| config.zones.".:53".plugins.log.classes | string | `"all"` |  |
| config.zones.".:53".plugins.log.format | string | `"combined"` |  |
| config.zones.".:53".plugins.prometheus | bool | `true` |  |
| config.zones.".:53".plugins.reload | bool | `true` |  |
| config.zones.".:53".plugins.template | object | `{}` |  |
| config.zones."in-addr.arpa:53".plugins.cache.parameters | int | `30` |  |
| config.zones."in-addr.arpa:53".plugins.debug | bool | `false` |  |
| config.zones."in-addr.arpa:53".plugins.errors | bool | `true` |  |
| config.zones."in-addr.arpa:53".plugins.forward.force_tcp | bool | `false` |  |
| config.zones."in-addr.arpa:53".plugins.forward.parameters | string | `"__PILLAR__UPSTREAM__SERVERS__"` |  |
| config.zones."in-addr.arpa:53".plugins.health.port | int | `8080` |  |
| config.zones."in-addr.arpa:53".plugins.log.classes | string | `"all"` |  |
| config.zones."in-addr.arpa:53".plugins.log.format | string | `"combined"` |  |
| config.zones."in-addr.arpa:53".plugins.prometheus | bool | `true` |  |
| config.zones."in-addr.arpa:53".plugins.reload | bool | `true` |  |
| config.zones."ip6.arpa:53".plugins.cache.parameters | int | `30` |  |
| config.zones."ip6.arpa:53".plugins.debug | bool | `false` |  |
| config.zones."ip6.arpa:53".plugins.errors | bool | `true` |  |
| config.zones."ip6.arpa:53".plugins.forward.force_tcp | bool | `false` |  |
| config.zones."ip6.arpa:53".plugins.forward.parameters | string | `"__PILLAR__UPSTREAM__SERVERS__"` |  |
| config.zones."ip6.arpa:53".plugins.health.port | int | `8080` |  |
| config.zones."ip6.arpa:53".plugins.log.classes | string | `"all"` |  |
| config.zones."ip6.arpa:53".plugins.log.format | string | `"combined"` |  |
| config.zones."ip6.arpa:53".plugins.prometheus | bool | `true` |  |
| config.zones."ip6.arpa:53".plugins.reload | bool | `true` |  |
| image.args.healthPort | int | `8080` |  |
| image.args.interfaceName | string | `"nodelocaldns"` |  |
| image.args.quiet | bool | `false` |  |
| image.args.setupInterface | bool | `true` |  |
| image.args.setupIptables | bool | `false` |  |
| image.args.skipTeardown | bool | `true` |  |
| image.args.syncInterval | string | `"1ns"` |  |
| image.args.upstreamSvc | string | `"kube-dns"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"registry.k8s.io/dns/k8s-dns-node-cache"` |  |
| image.tag | string | `"1.23.0"` |  |
| imagePullSecrets | list | `[]` |  |
| metrics.port | int | `9253` |  |
| metrics.prometheusScrape | string | `"true"` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| podmonitor.enabled | bool | `false` |  |
| podmonitor.metricRelabelings | list | `[]` |  |
| priorityClassName | string | `"system-node-critical"` |  |
| readinessProbe | string | `nil` |  |
| resources.requests.cpu | string | `"30m"` |  |
| resources.requests.memory | string | `"50Mi"` |  |
| securityContext.privileged | bool | `true` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tolerations[0].key | string | `"CriticalAddonsOnly"` |  |
| tolerations[0].operator | string | `"Exists"` |  |
| tolerations[1].effect | string | `"NoExecute"` |  |
| tolerations[1].operator | string | `"Exists"` |  |
| tolerations[2].effect | string | `"NoSchedule"` |  |
| tolerations[2].operator | string | `"Exists"` |  |
| updateStrategy.rollingUpdate.maxUnavailable | string | `"10%"` |  |
| useHostNetwork | bool | `true` |  |

## Additional Information

### Cilium

For clusters running [cilium](https://cilium.io/), there is a CRD,
[local-redirect-policy](https://docs.cilium.io/en/stable/network/kubernetes/local-redirect-policy/),
which needs be extra enabled via `--set localRedirectPolicy=true`.
It enables pod traffic destined to an IP address and port/protocol tuple or Kubernetes service to be redirected
locally to backend pod(s) within a node, using eBPF.
The namespace of backend pod(s) need to match with that of the policy.

For using this feature, values should provides the following extra configuration,

For getting the `CLUSTER_DNS_IP`,

```console
kubectl get svc kube-dns -n kube-system -o jsonpath={.spec.clusterIP}
```

```yaml
config:
  localDnsIp: CLUSTER_DNS_IP
  cilium:
    clusterDNSService: kube-dns
    clusterDNSNamespace: kube-system
    udp:
      enabled: true
      portName: dns
    tcp:
      enabled: true
      portName: dns-tcp
```

#### RKE2

As this feature heavily depends on the Cluster DNS implementation, for a [Rancher Kubernetes Engine 2](https://docs.rke2.io/) cluster,
`clusterDNSService` should be `rke2-coredns-rke2-coredns`, and port names,
`udp-53` and `tcp-53` respectively.

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)