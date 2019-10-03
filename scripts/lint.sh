#!/usr/bin/env bash

set -eo pipefail 

if [ -f /.dockerenv ]; then
  hadolint alpine.Dockerfile
  hadolint debian.Dockerfile
else
  docker run -v $(pwd):/host:ro hadolint/hadolint:v1.17.2-debian hadolint /host/alpine.Dockerfile
  docker run -v $(pwd):/host:ro hadolint/hadolint:v1.17.2-debian hadolint /host/debian.Dockerfile
fi
