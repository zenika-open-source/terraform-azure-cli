[![Docker Build Status](https://img.shields.io/docker/cloud/build/zenika/terraform-azure-cli.svg)](https://hub.docker.com/r/zenika/terraform-azure-cli/)
[![](https://images.microbadger.com/badges/image/zenika/terraform-azure-cli.svg)](https://microbadger.com/images/zenika/terraform-azure-cli)
[![Docker Pulls](https://img.shields.io/docker/pulls/zenika/terraform-azure-cli.svg)](https://hub.docker.com/r/zenika/terraform-azure-cli/)

# Terraform and Azure CLI Docker image

## Availables Docker image tags
Repository available on Docker Hub: [zenika/terraform-azure-cli](https://hub.docker.com/r/zenika/terraform-azure-cli)

[Debian](https://hub.docker.com/_/debian) based images ([debian.Dockerfile](https://github.com/Zenika/terraform-azure-cli/blob/master/debian.Dockerfile)):

* zenika/terraform-azure-cli:latest-debian - build on master branch
* zenika/terraform-azure-cli:X.Y-debian - build on repository tags

[Alpine](https://hub.docker.com/_/alpine) based images ([alpine.Dockerfile](https://github.com/Zenika/terraform-azure-cli/blob/master/alpine.Dockerfile)):

* zenika/terraform-azure-cli:latest - build on master branch (default image tag)
* zenika/terraform-azure-cli:latest-alpine - build on master branch
* zenika/terraform-azure-cli:X.Y-alpine - build on repository tags

> Git repository tag naming convention: `/^([0-9.]+)$/`

## Motivation
Many Docker images including the Terraform and Azure CLI already exist out there, both on the Docker Hub and Github.
But they all are quite oversized.

The goal is to create a **functional**, **minimalist** and **lightweight** image with these tools in order to reduce network and storage impact.

This image gives you the flexibility to be used for devlopement or as a base image as you see fits.

## What's inside ?
Tools included:

* [Azure CLI](https://azure.microsoft.com), see available version on the [pip repository](https://pypi.org/project/azure-cli/)
* [Terraform CLI](https://www.terraform.io/), see available versions on the [project release page](https://github.com/hashicorp/terraform/releases)

<p align="center">
  <a href="https://azure.microsoft.com"><img width="200" src="https://github.com/Zenika/terraform-azure-cli/raw/master/resources/azure-logo.png"></a>
  <a href="https://www.terraform.io/"><img width="200" src="https://github.com/Zenika/terraform-azure-cli/raw/master/resources/terraform-logo.png"></a>
</p>

## Usage

### Launch the CLI
Simply launch the container and use the CLI as you would on any other platform, for instance using the latest *alpine* based image:

```bash
docker container run -it --rm -v ${PWD}:/workspace zenika/terraform-azure-cli:latest
```

> The `--rm` flag will completely destroy the container and its data on exit.

### Build the image
You can build the image locally directly from the Dockerfiles.

```bash
# Build the Debian based image:
docker image build -f debian.Dockerfile -t zenika/terraform-azure-cli:debian .

# Build the Alpine based image:
docker image build -f alpine.Dockerfile -t zenika/terraform-azure-cli:alpine .
```

Optionally, it is possible to choose the tools desired versions using [Docker builds arguments](https://docs.docker.com/engine/reference/commandline/build/#set-build-time-variables---build-arg) :

```bash
# Set tools desired versions
AZURE_CLI_VERSION=2.0.65
TERRAFORM_VERSION=0.12.0

# Build the Debian based image:
docker image build --build-arg AZURE_CLI_VERSION=$AZURE_CLI_VERSION --build-arg TERRAFORM_VERSION=$TERRAFORM_VERSION -f debian.Dockerfile -t zenika/terraform-azure-cli:debian .

# Build the Alpine based image:
docker image build --build-arg AZURE_CLI_VERSION=$AZURE_CLI_VERSION --build-arg TERRAFORM_VERSION=$TERRAFORM_VERSION -f alpine.Dockerfile -t zenika/terraform-azure-cli:alpine .
```

## Roadmap & Contributions
Please refer to the [github project](https://github.com/Zenika/terraform-azure-cli/projects/1) to track new features.

Do not hesitate to contribute by [filling an issue](https://github.com/Zenika/terraform-azure-cli/issues) or [a PR](https://github.com/Zenika/terraform-azure-cli/pulls) !
