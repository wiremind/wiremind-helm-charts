#!/bin/bash

function generate_helpers()
{
    helpers_path="$1"
    chart_name="$2"
    echo -n "Generating ${helpers_path} "
    echo '''{{/*
Expand the name of the chart.
*/}}
{{- define "'$chart_name'.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "'$chart_name'.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "'$chart_name'.labels" -}}
helm.sh/chart: {{ include "'$chart_name'.chart" . }}
{{ include "'$chart_name'.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "'$chart_name'.selectorLabels" -}}
app.kubernetes.io/name: {{ include "'$chart_name'.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
''' > $helpers_path
        echo "OK"
}

# Manually find and remove .metadata.labels since yq has "formatting problems with the gotemplate" :/
function manage_yaml_object()
{
    yaml_action="$1"
    template_filepath_relative_tmp="$2"
    key_to_find="$3"
    data_to_replace="$4"

    if [[ "$DEBUG" == "1" ]]; then
        echo $data_to_replace
    fi

    IFS='.' read -r -a keys_found <<< "$key_to_find"
    is_inside_keys=()
    keys_to_find=()
    keys_to_find_start_pos=()
    keys_to_find_end_pos=()
    keys_to_find_indentations=()
    keys_to_find_removed=()
    keys_to_find_founds=()
    for key in "${keys_found[@]}"
    do
        if [[ "$key" != "" ]]; then
            keys_to_find+=("$key")
            keys_to_find_founds+=("0")
            is_inside_keys+=("0")
            keys_to_find_founds+=("0")
            keys_to_find_start_pos+=("-1")
            keys_to_find_end_pos+=("-1")
            keys_to_find_removed+=("0")
        fi
    done
    key_to_find_count="${#is_inside_keys[@]}"

    line_count=0
    IFS=$'\n'
    while read -r line
    do
        indentation_count=`echo $line | awk -F '[^ ].*' '{print length($1)}'`
        trimed_line=`echo $line | awk '{$1=$1;print}' | grep -o '^[^#]*'`
        yaml_key=`echo $trimed_line | cut -d ':' -f 1`

        key_index=0
        for is_inside_key in "${is_inside_keys[@]}"
        do
            if [[ "$is_inside_key" == "0" ]]; then
                break
            fi
            key_index=$((key_index+1))
        done

        for keys_to_find_indentation_index in "${!keys_to_find_indentations[@]}"
        do
            if [[ "${is_inside_keys[$keys_to_find_indentation_index]}" == "1" ]]; then
                if [[ "$DEBUG" == "1" ]]; then
                    echo "Inside ${keys_to_find[$keys_to_find_indentation_index]}"
                    echo $line
                fi
                if [[ "$indentation_count" -gt "${keys_to_find_indentations[$keys_to_find_indentation_index]}" ]]; then
                    keys_to_find_end_pos[$keys_to_find_indentation_index]="$line_count"
                else
                    if [[ "$DEBUG" == "1" ]]; then
                        echo "Leaving ${keys_to_find[$keys_to_find_indentation_index]}"
                        echo $line
                    fi
                    is_inside_keys[$keys_to_find_indentation_index]="0"
                    tmp_index=$((keys_to_find_indentation_index+1))
                    multiple_create=0
                    while [[ "$tmp_index" -lt $key_to_find_count ]]
                    do
                        # Create missing key
                        if [[ "${keys_to_find_founds[$tmp_index]}" == "0" ]]; then
                            keys_to_find_founds[$tmp_index]="1"
                            is_inside_keys[$tmp_index]="0"
                            keys_to_find_indentations[$tmp_index]="$((keys_to_find_indentations[$((tmp_index-1))]+2))"

                            if [[ "$multiple_create" == "1" ]]; then
                                keys_to_find_start_pos[$tmp_index]="$((keys_to_find_start_pos[$((tmp_index-1))]+1))"
                                keys_to_find_end_pos[$tmp_index]="$((keys_to_find_end_pos[$((tmp_index-1))]+1))"
                            else
                                keys_to_find_start_pos[$tmp_index]="$((line_count))"
                                keys_to_find_end_pos[$tmp_index]="$((line_count))"
                            fi
                            multiple_create="1"

                            append_pos=${keys_to_find_start_pos[$tmp_index]}
                            yaml_key_formatted=`printf "%*s%s" ${keys_to_find_indentations[$tmp_index]} "" ${keys_to_find[$tmp_index]}:`
                            if [[ "$DEBUG" == "1" ]]; then
                                echo "Missing key, creating: $yaml_key_formatted"
                            fi
                            sed -i ''${append_pos}' a \'$yaml_key_formatted'' $template_filepath_relative_tmp
                        fi
                        tmp_index=$((tmp_index+1))
                    done
                    if [[ "$tmp_index" == "$key_to_find_count" ]]; then
                        index_to_remove=$(($tmp_index-1))
                        if [[ "${keys_to_find_removed[$index_to_remove]}" == "0" ]]; then
                            # Remove everything inside the last key
                            keys_to_find_removed[$index_to_remove]="1"
                            remove_start_pos=${keys_to_find_start_pos[$index_to_remove]}
                            remove_start_pos=$((remove_start_pos+1))
                            remove_end_pos=${keys_to_find_end_pos[$index_to_remove]}
                            remove_end_pos=$((remove_end_pos+1))
                            if [[ "$DEBUG" == "1" ]]; then
                                echo "Removing from line $remove_start_pos to $remove_end_pos"
                            fi
                            sed -i ''${remove_start_pos}','${remove_end_pos}'d' $template_filepath_relative_tmp

                            if [[ "$yaml_action" == "add" ]]; then
                                append_pos=${keys_to_find_start_pos[$index_to_remove]}
                                if [[ "$DEBUG" == "1" ]]; then
                                    echo ${keys_to_find_indentations[$index_to_remove]}
                                    echo ${keys_to_find[$index_to_remove]}
                                    set -x
                                fi
                                yaml_key_formatted=`printf "%*s%s" ${keys_to_find_indentations[$index_to_remove]} "" ${keys_to_find[$index_to_remove]}:`
                                if [[ "$DEBUG" == "1" ]]; then
                                    echo "Apending $yaml_key_formatted to line $append_pos"
                                fi
                                sed -i ''${append_pos}' a \'$yaml_key_formatted'' $template_filepath_relative_tmp
                                append_pos=$((append_pos+1))
                                sed -i ''${append_pos}' a {{ include "'$chart_name'.labels" . | indent 4 }}' $template_filepath_relative_tmp
                                if [[ "$DEBUG" == "1" ]]; then
                                    set +x
                                fi
                            fi
                        fi
                    fi
                fi
            fi
        done

        if [[ $((key_index*2)) == "$indentation_count" && "${keys_to_find[$key_index]}" != "" && "${keys_to_find[$key_index]}" == "$yaml_key" ]]; then
            if [[ "$DEBUG" == "1" ]]; then
                echo "Found label ${keys_to_find[$key_index]}"
            fi
            keys_to_find_founds[$key_index]="1"
            is_inside_keys[$key_index]="1"
            keys_to_find_indentations[$key_index]="$indentation_count"
            keys_to_find_start_pos[$key_index]="$line_count"
            keys_to_find_end_pos[$key_index]="$line_count"
        fi

        line_count=$((line_count+1))
    done < "$template_filepath_relative_tmp"
}

function print_helper()
{
    echo "Usage:"
    echo "DEBUG=\"1\" REGENERATE_HELPERS=\"1\" YAML_ACTION=\"add\" ./${0} path/to/chart-crds"
    echo "DEBUG=\"1\" YAML_ACTION=\"delete\" ./${0} path/to/chart-crds"
    echo "YAML_ACTION:"
    echo "add: Add a _helpers.tpl and the label inclusion directly into each CRD"
    echo "delete: Delete the labels of each CRD"
}

function process_crds_chart()
{
    if [ -z "$1" ]; then
        echo "${1} is not a valid crds helm chart"
        print_helper
        exit 84
    fi

    if [ -z "$YAML_ACTION" ]; then
        echo "Please provide the env variable YAML_ACTION"
        print_helper
        exit 84
    fi

    directory_path_absolute=`realpath $1`
    directory_path_relative=`realpath $1 --relative-to=.`
    extension='yaml'

    chart_path="${directory_path_relative}/Chart.yaml"
    chart_name=`docker run --rm -v "${PWD}":/workdir mikefarah/yq '.name' "${chart_path}"`

    helpers_path="${directory_path_relative}/templates/_helpers.tpl"
    if test -f $directory_path_relative"/templates/_helpers.tpl"; then
        if [[ "$REGENERATE_HELPERS" == "1" ]]; then
            generate_helpers $helpers_path $chart_name
        else
            echo "${helpers_path} already present, nothing done"
        fi
    else
        generate_helpers $helpers_path $chart_name
    fi

    templates_directory_path_absolute="${directory_path_absolute}/templates"
    templates=`ls $templates_directory_path_absolute/*.yaml`
    echo "Entering ${templates_directory_path_absolute}"
    for template in $templates; do
        template_filepath_relative=`realpath $template --relative-to=.`
        echo -n "Processing ${template_filepath_relative} "
        # Work with temp file
        template_filepath_relative_tmp="${template_filepath_relative}.tmp"
        cat $template_filepath_relative > $template_filepath_relative_tmp
        # Check if its a valid yaml file
        docker run --rm -v "${PWD}":/workdir mikefarah/yq "${template_filepath_relative}" > /dev/null 2>&1
        retVal=`echo $?`
        if [[ "$retVal" == "0" && ("$YAML_ACTION" == "add" || "$YAML_ACTION" == "delete") ]]; then
            # Manage metadata labels
            manage_yaml_object "$YAML_ACTION" "${template_filepath_relative_tmp}" ".metadata.labels" '{{ include "'$chart_name'.labels" . | indent 4 }}'
            cat $template_filepath_relative_tmp > $template_filepath_relative
            echo "OK"
        else
            echo "KO"
        fi
        rm $template_filepath_relative_tmp
    done
}

function main()
{
    for var in "$@"
    do
        process_crds_chart $var
    done
}

main $@
