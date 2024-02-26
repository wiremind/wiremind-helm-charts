#!/bin/bash
set -e
set -x

# YQBIN="docker run --rm -v "${PWD}":/workdir mikefarah/yq"
YQBIN="yq"

if [ -z "$1" ]; then
  echo "Provide a valid crds file as first argument"
  exit 84
fi

filename=$(basename "$1")

# Format output name
output_names=$($YQBIN '.spec.names.plural | ({"match":.})' "${filename}" | cut -d ' ' -f 2)
output_dir=$(dirname "$(realpath $1)")/templates
echo "Output directory set to ${output_dir}"
mkdir -p "$output_dir"
document_index=0
for output_name in $output_names
do
    if [ $output_name == "---" ]; then continue; fi
    output_filename="crd-$output_name.yaml"
    echo "Processing ${output_filename} at index ${document_index}"
    $YQBIN eval "select(di == ${document_index})" "${filename}" > "$output_dir/$output_filename"
    document_index=$((document_index+1))
done
