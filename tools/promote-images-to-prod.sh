#!/usr/bin/env bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <staging-file> <prod-file> <property-path>"
    exit 1
fi

staging_file=$1
prod_file=$2
property_path=$3

staging_value=$(yq eval "${property_path}" "$staging_file")
if [ -z "$staging_value" ]; then
    echo "Error: Property '${property_path}' not found in '${staging_file}'"
    exit 1
fi

yq eval --inplace "${property_path} = \"${staging_value}\"" "$prod_file"
