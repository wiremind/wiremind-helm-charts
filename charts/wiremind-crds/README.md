# wiremind-crds

This Chart contains CRDs needed by NO operator.

## ExpectedDeploymentScale
Used to persist Deployments original scale (used when scaling to 0 + no HPA is used) + scaling priority. (would be replaced by annotations on Deployments in the future)

## ReleaseInfo
Its just a disguised ConfigMap, used to store info/metadata about Helm release, using a CRD to be able to `--suppress` their Helm diff.
