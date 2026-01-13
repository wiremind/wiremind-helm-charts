#!/bin/bash

set -e

BRANCH="main"
CUSTOM_PATH="charts"

usage() {
	echo "Usage: $0 -r <repo> -b <branch> -a <app>"
	echo ""
	echo "Options:"
	echo "  -r, --repo        GitHub repository in 'owner/repo' format (e.g., bitnami/charts)"
	echo "  -b, --branch      Branch or tag to fetch files from (default: main)"
	echo "  -a, --app         List of comma separated applications name to update charts for (e.g., rabbitmq,keycloak)"
	echo "  --path            Path inside the repo to fetch chart files from"
	echo "  --wiremind-image  Image version to use from wiremind github container registry"
	echo "  -h, --help        Show this help message"
	exit 1
}

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -r|--repo) REPO="$2"; shift ;;
        -b|--branch) BRANCH="$2"; shift ;;
		-a|--app) APPS="$2"; shift ;;
        --path) CUSTOM_PATH="$2"; shift ;;
		--wiremind-image) IMAGE_TAG="$2"; shift ;;
        -h|--help) usage ;;
        *) echo "Unknown parameter: $1"; usage ;;
    esac
    shift
done

if [[ -z "$REPO" || -z "$APPS" ]]; then
	echo "❌ Error: Both --repo and --app parameters are required."
	usage
fi

ZIP_URL="https://github.com/$REPO/archive/refs/heads/$BRANCH.zip"
TMP_DIR=$(mktemp -d)
ZIP_FILE="$TMP_DIR/repo.zip"

curl -sL "$ZIP_URL" -o "$ZIP_FILE"
unzip -q "$ZIP_FILE" -d "$TMP_DIR"

REPO_DIR="$TMP_DIR/${REPO##*/}-$BRANCH"

IFS=',' read -r -a APP_ARRAY <<< "$APPS"
for APP in "${APP_ARRAY[@]}"; do
	echo "🔄 Retrieving chart for application: $APP"

	if [[ ! -d "$REPO_DIR/$CUSTOM_PATH/$APP" ]]; then
		echo "❌ Error: Chart directory '$CUSTOM_PATH/$APP' not found in the repository."
		rm -rf "$TMP_DIR"
		exit 1
	fi
	README_INFO="# $APP Helm chart\n\nHelm chart for $APP sourced from $REPO repository.\n\n## Update the chart\n\nTo update this chart, run the following command from root dir:\n\n\`\`\`bash\n./update_chart.sh -r $REPO -b $BRANCH -a $APP --path $CUSTOM_PATH --wiremind-image <image-tag>\n\`\`\`\n\nReplace \`<image-tag>\` with the desired image version from Wiremind GitHub Container Registry.\n\n."
	echo -e "$README_INFO" > "$REPO_DIR/$CUSTOM_PATH/$APP/README_tmp.md"
	cat "$REPO_DIR/$CUSTOM_PATH/$APP/README.md" >> "$REPO_DIR/$CUSTOM_PATH/$APP/README_tmp.md"
	mv "$REPO_DIR/$CUSTOM_PATH/$APP/README_tmp.md" "$REPO_DIR/$CUSTOM_PATH/$APP/README.md"
	if [[ -d "./charts/$APP" ]]; then
		rsync -a "$REPO_DIR/$CUSTOM_PATH/$APP/" "./charts/$APP/"
		echo "✅ Chart for '$APP' successfully updated in './charts/$APP'."
	else
		cp -r "$REPO_DIR/$CUSTOM_PATH/$APP" "./charts/"
		echo "✅ Chart for '$APP' successfully added in './charts/$APP'."
	fi
	if [[ -n "$IMAGE_TAG" ]]; then
		owner="${REPO%%/*}"
		sed -i -E "s/^  registry: .*$/  registry: ghcr.io/g" "./charts/$APP/values.yaml"
		sed -i -E "s/^  repository: .*$/  repository: wiremind\/$owner\/$APP/g" "./charts/$APP/values.yaml"
		sed -i -E "s/^  tag: .*$/  tag: $IMAGE_TAG/g" "./charts/$APP/values.yaml"
		echo "✅ Image information updated for '$APP'"
	fi
done

rm -rf "$TMP_DIR"
