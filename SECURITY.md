# Security policy

## Supported versions

Only the latest released version of each chart receives fixes. Upgrade to it before reporting.

## Reporting a vulnerability

Do not open a public issue or pull request for a security problem.

Report it privately through [GitHub private vulnerability reporting](https://github.com/wiremind/wiremind-helm-charts/security/advisories/new) and include:

- the chart and its version,
- the values needed to reproduce,
- the impact you observed or expect.

We acknowledge reports within 5 working days and keep you updated until a fix is released.

## Scope

In scope: what the charts render, such as RBAC, security contexts, exposed ports, secret handling and default values.

Out of scope: vulnerabilities in the applications or container images the charts deploy. Report those to the upstream project; we bump the image once a fixed release exists.
