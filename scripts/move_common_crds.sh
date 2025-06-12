#!/bin/bash

set -euo pipefail

if [[ "$#" -lt 3 ]]; then
    echo "Usage: $0 <src1> <src2> ... <dest>"
    exit 1
fi

# All arguments except last are sources
DEST="${@: -1}"
SOURCES=("${@:1:$#-1}")

# Ensure DEST exists
mkdir -p "$DEST"

echo "Moving CRDs to $DEST (skipping already existing ones)..."
echo "------------------------------------------------------"

# Build map of CRDs already present in DEST
declare -A DEST_CRDS

for FILE in "$DEST"/*.yaml; do
    if [[ -f "$FILE" ]]; then
        NAME=$(yq eval '.metadata.name' "$FILE" 2>/dev/null || true)
        if [[ -n "$NAME" && "$NAME" != "null" ]]; then
            DEST_CRDS["$NAME"]=1
        fi
    fi
done

# Now process sources
for SRC in "${SOURCES[@]}"; do
    echo
    echo "Processing source: $SRC"
    echo "------------------------"

    for FILE in "$SRC"/*.yaml; do
        NAME=$(yq eval '.metadata.name' "$FILE" 2>/dev/null || true)
        if [[ -z "$NAME" || "$NAME" == "null" ]]; then
            echo "Skipping $FILE (no metadata.name)"
            continue
        fi

        if [[ -n "${DEST_CRDS[$NAME]:-}" ]]; then
            echo "Skipping $FILE ($NAME already exists in $DEST)"
        else
            echo "Moving $FILE → $DEST/"
            cp "$FILE" "$DEST/"
            DEST_CRDS["$NAME"]=1
        fi
    done
done

echo
echo "Done! 🎉"
