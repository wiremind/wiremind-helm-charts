#!/bin/bash

set -e

BRANCH="main"
CUSTOM_PATH="charts"

usage() {
	echo "Usage: $0 -r <repo> -b <branch> -a <app>"
	echo ""
	echo "Options:"
	echo "  -r, --repo      GitHub repository in 'owner/repo' format (e.g., bitnami/charts)"
	echo "  -b, --branch    Branch or tag to fetch files from (default: main)"
	echo "  -a, --app       List of comma separated applications name to update charts for (e.g., rabbitmq,keycloak)"
	echo "  --path          Path inside the repo to fetch chart files from"
	echo "  -h, --help      Show this help message"
	exit 1
}

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -r|--repo) REPO="$2"; shift ;;
        -b|--branch) BRANCH="$2"; shift ;;
		-a|--app) APPS="$2"; shift ;;
        --path) CUSTOM_PATH="$2"; shift ;;
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
	echo "🔄 Updating chart for application: $APP"

	if [[ ! -d "$REPO_DIR/$CUSTOM_PATH/$APP" ]]; then
		echo "❌ Error: Chart directory '$CUSTOM_PATH/$APP' not found in the repository."
		rm -rf "$TMP_DIR"
		exit 1
	fi
	cp -r "$REPO_DIR/$CUSTOM_PATH/$APP" "./charts/"
	echo "✅ Chart for '$APP' updated successfully in './charts/$APP'."
done

rm -rf "$TMP_DIR"
