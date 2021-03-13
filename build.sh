#!/usr/bin/env bash

set -eo pipefail

# Set image name and tag (dev if not specified)
IMAGE_NAME="zenika/terraform-azure-cli"
[[ -n $3 ]] && IMAGE_TAG=$3 || IMAGE_TAG="dev"

# Set AZ and TF CLI to latest supported versions if not specified
# FIXME: if provided, both TF and AZ CLI semvers should be regex-validated
[[ -n $1 ]] && AZ_VERSION=$1 || AZ_VERSION=$(jq -r '.azcli_version | sort | .[-1]' supported_versions.json)
[[ -n $2 ]] && TF_VERSION=$2 || TF_VERSION=$(jq -r '.tf_version | sort | .[-1]' supported_versions.json)

# Lint Dockerfile
echo "Linting Dockerfile..."
docker run --rm -i hadolint/hadolint:latest-alpine < Dockerfile
echo "Dockerfile successfully linted!"

# Build image
echo "Building images with AZURE_CLI_VERSION=${AZ_VERSION} and TERRAFORM_VERSION=${TF_VERSION}..."
docker image build --build-arg AZURE_CLI_VERSION="$AZ_VERSION" --build-arg TERRAFORM_VERSION="$TF_VERSION" -t $IMAGE_NAME:$IMAGE_TAG .
echo "Image successfully builded!"

# Test image
echo "Generating test config..."
envsubst '${AZ_VERSION},${TF_VERSION}' < tests/container-structure-tests.yml.template > tests/container-structure-tests.yml
echo "Test config successfully generated!"
echo "Executing container structure test..."
docker container run --rm -it -v "${PWD}"/tests/container-structure-tests.yml:/tests.yml:ro -v /var/run/docker.sock:/var/run/docker.sock:ro gcr.io/gcp-runtimes/container-structure-test:v1.8.0 test --image $IMAGE_NAME:$IMAGE_TAG --config /tests.yml
