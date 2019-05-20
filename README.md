[![Docker Build Status](https://img.shields.io/docker/cloud/build/zenika/terraform-azure-cli.svg)](https://hub.docker.com/r/zenika/terraform-azure-cli/)
[![](https://images.microbadger.com/badges/image/zenika/terraform-azure-cli.svg)](https://microbadger.com/images/zenika/terraform-azure-cli)
[![Docker Pulls](https://img.shields.io/docker/pulls/zenika/terraform-azure-cli.svg)](https://hub.docker.com/r/zenika/terraform-azure-cli/)

# Terraform and Azure CLI Docker image

## Availables Docker image tags
Repository available on Docker Hub: [zenika/terraform-azure-cli](https://hub.docker.com/r/zenika/terraform-azure-cli)

One images uses [Debian](https://hub.docker.com/_/debian) and the other one uses [Alpine](https://hub.docker.com/_/alpine) as a base.

Debian-based images ([debian.Dockerfile](https://github.com/Zenika/terraform-azure-cli/blob/master/debian.Dockerfile)):

* zenika/terraform-azure-cli:latest-latest - latest image build on master branch
* zenika/terraform-azure-cli:X.Y-debian - versionned image build on repository tags

Alpine-based images ([alpine.Dockerfile](https://github.com/Zenika/terraform-azure-cli/blob/master/alpine.Dockerfile)):

* zenika/terraform-azure-cli:alpine-latest - latest image build on master branch
* zenika/terraform-azure-cli:X.Y-alpine - versionned image build on repository tags

> Git repository tag naming convention: `/^([0-9.]+)$/`

## Motivation
Many Docker images including the Terraform and Azure CLI already exist out there, both on the Docker Hub and Github.
But they all are quite oversized.

The goal is to create a **functional**, **minimalist** and **lightweight** image with these tools in order to reduce network and storage impact.

## What's inside ?
Tools included:

* Azure CLI **v2.0.64**
* Terraform CLI **v0.11.13**

<p align="center">
  <a href="https://azure.microsoft.com"><img width="200" src="resources/azure-logo.png"></a>
  <a href="https://www.terraform.io/"><img width="200" src="resources/terraform-logo.png"></a>
</p>

## Usage

### Launch the CLI
Simply launch the container and use the CLI as you would on any other platform, for instance using the *alpine* based image:
```bash
docker container run -it --rm zenika/terraform-azure-cli:alpine-latest
```

> The `--rm` flag will completely destroy the container and its data on exit.

### Build the image
You can build the image locally directly from the Dockerfiles:
```bash
# build the Debian based image:
docker image build -f debian.Dockerfile -t zenika/terraform-azure-cli:debian .

# build the Alpine based image:
docker image build -f alpine.Dockerfile -t zenika/terraform-azure-cli:alpine .
```

> You can use [Docker build arguments](https://docs.docker.com/engine/reference/commandline/build/#set-build-time-variables---build-arg) to  set custom Terraform & Azure CLI version.

## Roadmap & Contributions
Please refer to the [github project](https://github.com/Zenika/terraform-azure-cli/projects/1) to track new features.

Do not hesitate to contribute by [filling an issue](https://github.com/Zenika/terraform-azure-cli/issues) or [a PR](https://github.com/Zenika/terraform-azure-cli/pulls) !
