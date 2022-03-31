#!/bin/bash

function generate_crd_helm_patch_file()
{
    patch_file_path="$1"
    release_name="$2"
    release_namespace="$3"
    echo -n "Generating ${patch_file_path} "
    echo '''metadata:
  labels:
    app.kubernetes.io/managed-by: Helm
  annotations:
    meta.helm.sh/release-name: '$release_name'
    meta.helm.sh/release-namespace: '$release_namespace'
''' > $patch_file_path
    echo "OK"
}

function patch_crds_chart()
{
    if [ -z "$1" ]; then
        echo "${1} is not a valid crds helm chart"
        exit 84
    fi

    if [ -z "$NAMESPACE" ]; then
        echo "Please provide the env variable NAMESPACE"
        exit 84
    fi

    if [ -z "$KUBE_CONTEXT" ]; then
        echo "Please provide the env variable KUBE_CONTEXT"
        exit 84
    fi

    directory_path_absolute=`realpath $1`
    directory_path_relative=`realpath $1 --relative-to=.`
    extension='yaml'

    chart_path="${directory_path_relative}/Chart.yaml"
    chart_name=`docker run --rm -v "${PWD}":/workdir mikefarah/yq '.name' "${chart_path}"`

    patch_file_path="${directory_path_relative}/crd-helm-patch-tmp.yaml"
    generate_crd_helm_patch_file "$patch_file_path" "$chart_name" "$NAMESPACE"

    templates_directory_path_absolute="${directory_path_absolute}/templates"
    templates=`ls $templates_directory_path_absolute/*.yaml`
    echo "Entering ${templates_directory_path_absolute}"
    for template in $templates; do
        template_filepath_relative=`realpath $template --relative-to=.`
        crd_name=`docker run --rm -v "${PWD}":/workdir mikefarah/yq 'select(di == 0) | .metadata.name' "${template_filepath_relative}"`
        echo -n "Processing ${template_filepath_relative} with crd name ${crd_name}: "
        if [[ "$crd_name" != "" ]]; then
            # Patch with kubectl
            kubectl --context "$KUBE_CONTEXT" patch crd "$crd_name" --patch-file "$patch_file_path"
            retVal=`echo $?`
            if [[ "$retVal" == "0" ]]; then
                echo "OK"
                continue
            fi
        fi
        echo "KO"
    done
    rm "$patch_file_path"
}

function main()
{
    for var in "$@"
    do
        patch_crds_chart $var
    done
}

main $@
