[![CircleCI](https://circleci.com/gh/Zenika/terraform-azure-cli.svg?style=svg)](https://circleci.com/gh/Zenika/terraform-azure-cli)
[![](https://images.microbadger.com/badges/image/zenika/terraform-azure-cli.svg)](https://microbadger.com/images/zenika/terraform-azure-cli)
[![Docker Pulls](https://img.shields.io/docker/pulls/zenika/terraform-azure-cli.svg)](https://hub.docker.com/r/zenika/terraform-azure-cli/)

# Terraform and Azure CLI Docker image

## Supported tags and respective Dockerfile links
Repository available on Docker Hub: [zenika/terraform-azure-cli](https://hub.docker.com/r/zenika/terraform-azure-cli)

* [zenika/terraform-azure-cli:latest](https://github.com/Zenika/terraform-azure-cli/blob/master/alpine.Dockerfile)
* [zenika/terraform-azure-cli:latest-debian](https://github.com/Zenika/terraform-azure-cli/blob/master/debian.Dockerfile)
* [zenika/terraform-azure-cli:3.0-alpine](https://github.com/Zenika/terraform-azure-cli/blob/3.0/alpine.Dockerfile)
* [zenika/terraform-azure-cli:3.0-debian](https://github.com/Zenika/terraform-azure-cli/blob/3.0/debian.Dockerfile)
* [zenika/terraform-azure-cli:2.1-alpine](https://github.com/Zenika/terraform-azure-cli/blob/2.1/alpine.Dockerfile)
* [zenika/terraform-azure-cli:2.1-debian](https://github.com/Zenika/terraform-azure-cli/blob/2.1/debian.Dockerfile)
* [zenika/terraform-azure-cli:1.0](https://github.com/Zenika/terraform-azure-cli/blob/v1.0/Dockerfile) - Debian only

:warning: alpine build support is deprecated, new versions will only be debian based.

## Motivation
Many Docker images including the Terraform and Azure CLI already exist out there, both on the Docker Hub and Github.
But they all are quite oversized.

The goal is to create a **minimalist** and **lightweight** image with these tools in order to reduce network and storage impact.

This image gives you the flexibility to be used for development or as a base image as you see fits.

## What's inside ?
Tools included:

* [Azure CLI](https://docs.microsoft.com/cli/azure/?view=azure-cli-latest), see available version on the [pip repository](https://pypi.org/project/azure-cli/)
* [Terraform CLI](https://www.terraform.io/docs/commands/index.html), see available versions on the [project release page](https://github.com/hashicorp/terraform/releases)

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
You can build the image locally directly from the Dockerfiles, using the build script:

```bash
# launch build script
./dev-build.sh
```

Optionally, it is possible to choose the tools desired versions using [Docker builds arguments](https://docs.docker.com/engine/reference/commandline/build/#set-build-time-variables---build-arg) :

```bash
# Set tools desired versions
AZURE_CLI_VERSION=2.0.74
TERRAFORM_VERSION=0.12.9

# launch the build script with parameters
./dev-build.sh $AZURE_CLI_VERSION $TERRAFORM_VERSION
```

## Roadmap & Contributions
Please refer to the [github project](https://github.com/Zenika/terraform-azure-cli/projects/1) to track new features.

Do not hesitate to contribute by [filling an issue](https://github.com/Zenika/terraform-azure-cli/issues) or [a PR](https://github.com/Zenika/terraform-azure-cli/pulls) !
