# external-dns-crds

This Chart contains CRDs needed by [external-dns](https://github.com/kubernetes-sigs/external-dns).

The Chart has the same version as the `external-dns`s, try to keep them equal even when no changes on the CRDs are made.

The CRDs are retrieved/adjusted from the [external-dns CRDs directory](https://github.com/kubernetes-sigs/external-dns/tree/master/charts/external-dns/crds), Checkout the right tag and see if there are any changes.

If the version of the CRDs changes, aka breaking changes (this doesn't happen every day) more actions will be required!
