#!/usr/bin/env bash
#
# If the value of a specified property in a YAML file is a container image name,
# this script will update its digest to the latest version using yq.
# After this replacement, the original file is overwritten.
#
# NOTE:
# yq messes up the YAML's whitespace.
# Please proceed with using this script, understanding this issue.

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <file-name> <property-path>"
    exit 1
fi

file_name=$1
property_path=$2
script_dir=$(dirname "$0")

current_image=$(yq eval "${property_path}" "$file_name")
echo "Current image: $current_image"
image_name=$(echo $current_image | cut -d '@' -f 1)

# Digests contain the prefix 'sha256:'
current_digest=$(echo $current_image | cut -d '@' -f 2)
latest_digest=$("$script_dir/latest-image-digest.sh" "$image_name")
echo "Latest digest: $latest_digest"

if [ -z "$latest_digest" ]; then
    echo "Error: Failed to get the latest image digest."
    exit 1
fi

if [[ "$current_digest" == "$latest_digest" ]]; then
    echo "The current image is the latest image, skipping."
    exit 0
fi

yq eval --inplace "${property_path} = \"${image_name}@${latest_digest}\"" "$file_name"
