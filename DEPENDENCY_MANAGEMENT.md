# Dependency Management

This repository uses both **Dependabot** and **Renovate** for automated dependency updates.

## Dependabot

Dependabot is configured via `.github/dependabot.yml` and currently monitors:

- **GitHub Actions**: Checks for updates to GitHub Actions used in workflows

### Activating Dependabot

Dependabot is automatically enabled for repositories on GitHub. To verify it's active:

1. Go to the repository on GitHub
2. Click on **Settings** → **Security** → **Code security and analysis**
3. Ensure **Dependabot alerts** and **Dependabot security updates** are enabled
4. Check the **Insights** → **Dependency graph** → **Dependabot** tab to see pending updates

### Limitations

Dependabot has limited support for Helm charts:
- It **does not** track Helm chart dependencies (in `Chart.yaml`)
- It **does not** update Docker image tags in `values.yaml` files
- For comprehensive Helm chart dependency management, use Renovate instead

## Renovate (Recommended for Helm Charts)

Renovate is configured via `renovate.json` and provides comprehensive dependency management for:

- **Helm chart dependencies** (in `Chart.yaml`)
- **Docker images** (in `values.yaml` and templates)
- **GitHub Actions** (in `.github/workflows/`)
- **Kubernetes manifests**

### Activating Renovate

To activate Renovate for this repository:

#### Option 1: GitHub App (Recommended)

1. Install the [Renovate GitHub App](https://github.com/apps/renovate) to your GitHub organization or repository
2. Grant it access to this repository
3. Renovate will automatically detect the `renovate.json` configuration and start creating pull requests

#### Option 2: Self-hosted

If you prefer to run Renovate yourself:

1. Follow the [Renovate self-hosting documentation](https://docs.renovatebot.com/getting-started/running/)
2. Configure it to run on your infrastructure
3. Point it to this repository

### Configuration

The Renovate configuration includes:

- **Dependency Dashboard**: Creates an issue to track all pending updates
- **Semantic Commits**: Uses conventional commit format
- **Scheduled Updates**: Runs before 4am on Mondays to minimize disruption
- **Rate Limiting**: Maximum 5 concurrent PRs, 2 per hour
- **Grouping**: Groups related updates together (e.g., all Helm dependencies)

### Customizing Renovate

Edit `renovate.json` to customize behavior:

- Change the `schedule` to run more or less frequently
- Adjust `prConcurrentLimit` to control the number of simultaneous PRs
- Enable `automerge` for specific package types if desired
- Add more package rules for specific dependencies

## Comparison

| Feature | Dependabot | Renovate |
|---------|-----------|----------|
| GitHub Actions updates | ✅ | ✅ |
| Helm chart dependencies | ❌ | ✅ |
| Docker image tags in values.yaml | ❌ | ✅ |
| Kubernetes manifests | ❌ | ✅ |
| Free for public repos | ✅ | ✅ |
| Built into GitHub | ✅ | ❌ |
| Advanced configuration | ⚠️ Limited | ✅ Extensive |

## Recommendations

1. **Keep both enabled**: Use Dependabot for GitHub Actions (already built into GitHub) and Renovate for Helm-specific updates
2. **Use Renovate**: If you must choose one, Renovate provides the most comprehensive coverage for this Helm charts repository
3. **Review PRs carefully**: Both tools create automated PRs, but always review changes before merging
4. **Test updates**: Ensure CI/CD pipelines test chart changes before merging dependency updates

## Troubleshooting

### Dependabot not creating PRs

- Check **Settings** → **Security** → **Dependabot** is enabled
- Verify `.github/dependabot.yml` is valid YAML
- Check the **Insights** → **Dependency graph** → **Dependabot** tab for errors

### Renovate not creating PRs

- Verify the Renovate GitHub App is installed and has repository access
- Check the Renovate logs in the app's dashboard
- Validate `renovate.json` using the [Renovate config validator](https://docs.renovatebot.com/config-validation/)
- Look for an issue titled "Dependency Dashboard" that Renovate creates

## Further Reading

- [Dependabot documentation](https://docs.github.com/en/code-security/dependabot)
- [Renovate documentation](https://docs.renovatebot.com/)
- [Renovate Helm support](https://docs.renovatebot.com/modules/manager/helm-values/)
