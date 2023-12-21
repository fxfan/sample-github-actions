#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <image-name>"
    exit 1
fi

base=$1

# gcloud container images describe "$base":latest --format json 2>/dev/null |
#     jq -M ".image_summary.fully_qualified_digest" |
#     sed -e 's/\"//g' |
#     cut -d '@' -f 2

dummy_sha=$(openssl rand -hex 32 | openssl dgst -sha256 | cut -d " " -f 2)
echo "sha256:$dummy_sha"
