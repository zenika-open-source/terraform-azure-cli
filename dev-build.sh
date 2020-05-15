#!/usr/bin/env bash

set -eo pipefail

# Lint Dockerfile
echo "Linting Dockerfile..."
docker run --rm -i hadolint/hadolint < Dockerfile
echo "Lint Successful!"

# Build dev image
if [ -n "$1" ] && [ -n "$2" ] ; then
  echo "Building images with parameters AZURE_CLI_VERSION=${1} and TERRAFORM_VERSION=${2}..."
  docker image build --build-arg AZURE_CLI_VERSION="$1" --build-arg TERRAFORM_VERSION="$2" -t zenika/terraform-azure-cli:dev .
else
  echo "Building images with default parameters..."
  docker image build -f Dockerfile -t zenika/terraform-azure-cli:dev .
fi

# Test dev image
echo "Executing container structure test..."
if ! [ -x "$(command -v container-structure-test)" ] ; then
  echo "WARNING - SKIPPING: container-structure-test not found, please install the binary !"
  exit 1
else
  container-structure-test test --image zenika/terraform-azure-cli:dev --config tests/container-structure-test.yml
fi
