# chaos-mesh-crds

Helm chart for deploying Chaos Mesh CRDs.

### How to update the Chart

The Chart has the same version as the `chaos-mesh`s, try to keep them equal.

CRDs are located [here](https://github.com/chaos-mesh/chaos-mesh/tree/master/helm/chaos-mesh/crds)

```
../../scripts/update_crds.sh -r chaos-mesh/chaos-mesh -b v2.8.7 --folder helm/chaos-mesh/crds
```

Then remove the schema descriptions:

```
for f in templates/*.yaml; do
  yq -i 'del(.. | select(tag == "!!map" and has("description") and (.description | tag) == "!!str") | .description)' "$f"
done
```

Helm stores each release in a Secret, and a Secret holds at most 1 MiB.
With the descriptions, the 2.8.7 release takes about 1087 KiB, so the install fails.
Without them, it takes about 228 KiB.
The filter removes only string values: a schema field named `description` is a map and stays.
`kubectl explain` shows no help text for these CRDs.
