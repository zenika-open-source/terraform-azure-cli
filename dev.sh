#!/usr/bin/env bash

set -eo pipefail

# FIXME: use getopts function to parse aguments
# FIXME: if provided, both TF and AZ CLI semvers should be regex-validated

# Set AZ and TF CLI to latest supported versions if not specified
[[ -n $1 ]] && AZ_VERSION=$1 || AZ_VERSION=$(jq -r '.azcli_version | sort | .[-1]' supported_versions.json)
[[ -n $2 ]] && TF_VERSION=$2 || TF_VERSION=$(jq -r '.tf_version | sort | .[-1]' supported_versions.json)

# Set image name and tag (dev if not specified)
IMAGE_NAME="zenika/terraform-azure-cli"
[[ -n $3 ]] && IMAGE_TAG=$3 || IMAGE_TAG="dev"

# Set platform for Hadolint image (only linux/arm64 or linux/arm64 supported)
PLATEFORM="linux/$(uname -m)"

# Lint Dockerfile
echo "Linting Dockerfile..."
docker container run --rm --interactive \
  --volume "${PWD}":/data \
  --workdir /data \
  --platform "${PLATEFORM}" \
  hadolint/hadolint:2.12.0-alpine /bin/hadolint \
  --config hadolint.yaml Dockerfile
echo "Lint Successful!"

# Build image
echo "Building images with AZURE_CLI_VERSION=${AZ_VERSION} and TERRAFORM_VERSION=${TF_VERSION}..."
docker buildx build \
  --progress plain \
  --platform "${PLATEFORM}" \
  --build-arg AZURE_CLI_VERSION="${AZ_VERSION}" \
  --build-arg TERRAFORM_VERSION="${TF_VERSION}" \
  --tag ${IMAGE_NAME}:${IMAGE_TAG} .
echo "Image successfully builded!"

# Test image
echo "Generating test config with AZURE_CLI_VERSION=${AZ_VERSION} and TERRAFORM_VERSION=${TF_VERSION}..."
export AZ_VERSION=${AZ_VERSION} && export TF_VERSION=${TF_VERSION}
envsubst '${AZ_VERSION},${TF_VERSION}' < tests/container-structure-tests.yml.template > tests/container-structure-tests.yml
echo "Test config successfully generated!"
echo "Executing container structure test..."
docker container run --rm --interactive \
  --volume "${PWD}"/tests/container-structure-tests.yml:/tests.yml:ro \
  --volume /var/run/docker.sock:/var/run/docker.sock:ro \
  gcr.io/gcp-runtimes/container-structure-test:v1.15.0 test \
  --image ${IMAGE_NAME}:${IMAGE_TAG} \
  --config /tests.yml

# cleanup
unset AZ_VERSION
unset TF_VERSION
