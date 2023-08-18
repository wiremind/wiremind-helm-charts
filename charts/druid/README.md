# Druid Helm Chart

[Druid](https://druid.apache.org/), a real-time analytics database designed for fast slice-and-dice analytics ("OLAP" queries) on large data sets.

This Chart is to deploy a Druid cluster on Kubernetes.

It provides the following features:

- You don't have to deal with a Kubernetes `Operator` burden.
- The creation of different [tiers](https://druid.apache.org/docs/latest/operations/mixed-workloads.html#service-tiering) (hot and cold for example) of Historical nodes.
- The creation of several worker [categories](https://druid.apache.org/docs/latest/configuration/index.html#workercategoryspec).
- Configuration as code: Specify the concerned component and the configuration you want it to have in the values and the Chart will take care of applying it.
- [HPA](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) for the workers with the possibility to scale to zero using [kube-hpa-scale-to-zero](https://github.com/machine424/kube-hpa-scale-to-zero).
- Global and per component environment variables can be passed to the [official druid docker image](https://github.com/apache/druid/tree/master/distribution/docker).

Notes:
- The Chart focuses on (or is optimized for) druid [native batch ingestion](https://druid.apache.org/docs/latest/ingestion/native-batch.html), but it should work for all other types of ingestion, contributions are welcome.
- Despite calling them `Indexers`, the workers are `MiddleManagers` actually, you can still enable the real experimental `Indexers` workers, see [here](https://druid.apache.org/docs/latest/design/indexer.html).
- You need to provide some configuration in the values file before deploying, look for `SET_ME` placeholders. Contributions to make this optional are welcome.
- The Chart is tested 