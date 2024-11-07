# external-secrets-crds

This Chart contains CRDs needed by [external-secrets](https://github.com/external-secrets/external-secrets).

The Chart has the same version as the `external-secrets`s, try to keep them equal even when no changes on the CRDs are made.

The CRDs are retrieved/adjusted from [here](https://github.com/external-secrets/external-secrets/tree/main/deploy/crds), Checkout the right tag and see if there are any changes.

If the version of the CRDs changes, aka breaking changes (this doesn't happen every day) more actions will be required!

The release must be named `external-secrets` in the namespace `external-secrets` to have the CRDs working. This is because of the conversion webhook which is hardcoded in the CRDs.
