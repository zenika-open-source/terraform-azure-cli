[![](https://images.microbadger.com/badges/image/zenika/terraform-azure-cli.svg)](https://microbadger.com/images/zenika/terraform-azure-cli)

# Terraform and Azure CLI Docker image
Docker Image including Azure and Terraform CLI tools.

## Availables Docker image tags
Repository available on the Docker Hub: [zenika/terraform-azure-cli](https://hub.docker.com/r/zenika/terraform-azure-cli)
* zenika/terraform-azure-cli:latest - latest image build on master branch
* zenika/terraform-azure-cli:vX.Y - versionned image build on specific repository tag

## Motivation
Many Docker images including the Terraform and Azure CLI already exist out there, both on the Docker Hub and Github.
But they all are quite oversized.

The goal is to create a functional, minimalist and lightweight image with these tools in order to reduce network and storage impact.

## What's inside ?
This image uses [Debian Stretch](https://hub.docker.com/_/debian) as a base.

Tools included:

* Azure CLI **v2.0.64**
* Terraform CLI **v0.11.13**

<p align="center">
  <a href="https://azure.microsoft.com"><img width="200" src="resources/azure-logo.png"></a>
  <a href="https://www.terraform.io/"><img width="200" src="resources/terraform-logo.png"></a>
</p>

## Usage

### launch the CLI
Simply launch the container and use the CLI as you would on any other platform:
```bash
docker container run -it --rm zenika/terraform-azure-cli
```

> The `--rm` flag will completely destroy the container and its data on exit.

### Build the image
Use Docker to build the image from the Dockerfile:
```bash
docker image build -t zenika/terraform-azure-cli .
```

## Roadmap & Contributions
Please refer to the [github project](https://github.com/Zenika/terraform-azure-cli/projects/1) to track new features.

Do not hesitate to contribute by [filling an issue](https://github.com/Zenika/terraform-azure-cli/issues) or [a PR](https://github.com/Zenika/terraform-azure-cli/pulls) !
