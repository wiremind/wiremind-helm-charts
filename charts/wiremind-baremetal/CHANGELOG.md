# Changelog

# v1.4.0 (2022-06-13)
## Feat
- Support resources, containerSecurityContext, readinessProbe, livenessProbe, image, hostPID
- Convenient names for resources
- Use with instead of if and hardcoded values

# v1.3.1 (2022-03-02)
## Fix
- livenessprobe: less strict, run less often

# v1.3.0 (2022-06-20)
## Feat
- Support topolvm nodes (through the `TOPOLVM_ENABLED` env var), only decrypt in this case

# v1.2.0 (2022-06-20)
## Feat
- Add the possibility to set an `affinity` to the DaemonSet Pods

# v1.1.1 (2021-10-30)
## Fix
- Rename `scripts/` to `baremetal-scripts/*`
- Command exec `"-c"` instead of `-c`

# v1.1.0 (2021-10-30)
## Feat
- Add priorityclass

# v1.0.2 (2021-09-09)
## Fix
- Do not define default values, this is the job of the final values.yaml

# v1.0.1 (2021-08-03)
## Fix
- Add support for baremetal without volumes

# v1.0.0 (2021-05-20)
## Breaking change
- support several partitions

# v0.1.0 (2020-05-19)
## Feat
- scripts: more checks before running decryption

# v0.0.1 (2020-05-19)
## Feat
- Initial version
