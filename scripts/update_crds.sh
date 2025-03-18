#!/bin/bash

set -e

# Default values
branch="main"
output_dir="templates"

# Function to display usage
usage() {
    echo "Usage: $0 -r <repo> -b <branch> --folder <folder> [-o <output_dir>]"
    echo ""
    echo "Options:"
    echo "  -r, --repo      GitHub repository in 'owner/repo' format (e.g., traefik/traefik-helm-chart)"
    echo "  -b, --branch    Branch or tag to fetch files from (default: main)"
    echo "  --folder        Path inside the repo to fetch CRD files from"
    echo "  -o, --output    Directory to save CRD files (default: templates)"
    echo "  -h, --help      Show this help message"
    exit 1
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -r|--repo) repo="$2"; shift ;;
        -b|--branch) branch="$2"; shift ;;
        --folder) folder="$2"; shift ;;
        -o|--output) output_dir="$2"; shift ;;
        -h|--help) usage ;;
        *) echo "Unknown parameter: $1"; usage ;;
    esac
    shift
done

# Validate required parameters
if [[ -z "$repo" || -z "$folder" ]]; then
    echo "❌ Error: --repo and --folder are required."
    usage
fi

# Set up API URL
api_url="https://api.github.com/repos/$repo/contents/$folder?ref=$branch"

echo "🔍 Fetching CRD files from $repo ($branch) in folder '$folder'..."

# Fetch file list from GitHub API
files=$(curl -s "$api_url" | jq -r '.[] | select(.name | endswith(".yaml")) | .download_url')

# Ensure we got valid results
if [[ -z "$files" ]]; then
    echo "❌ No YAML files found at $api_url"
    exit 1
fi

# Create output directory
mkdir -p "$output_dir"

# Download each file
for file in $files; do
    filename=$(basename "$file")
    echo "⬇️ Downloading $filename..."
    curl -sSL -o "$output_dir/$filename" -L "$file"

    if [[ $? -ne 0 ]]; then
        echo "❌ Failed to download $filename"
    else
        echo "✅ Saved to $output_dir/$filename"
    fi
done

echo "🎉 All CRDs downloaded successfully!"
