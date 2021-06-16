[![lint-dockerfile](https://github.com/Zenika/terraform-azure-cli/workflows/lint-dockerfile/badge.svg)](https://github.com/Zenika/terraform-azure-cli/actions?query=workflow%3Alint-dockerfile)
[![build-test](https://github.com/Zenika/terraform-azure-cli/workflows/build-test/badge.svg)](https://github.com/Zenika/terraform-azure-cli/actions?query=workflow%3Abuild-test)
[![push-latest](https://github.com/Zenika/terraform-azure-cli/workflows/push-latest/badge.svg)](https://github.com/Zenika/terraform-azure-cli/actions?query=workflow%3Apush-latest)
[![release](https://github.com/Zenika/terraform-azure-cli/workflows/release/badge.svg)](https://github.com/Zenika/terraform-azure-cli/actions?query=workflow%3Arelease)

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Docker Pulls](https://img.shields.io/docker/pulls/zenika/terraform-azure-cli.svg)](https://hub.docker.com/r/zenika/terraform-azure-cli/)

<p align="center">
  <a href="https://azure.microsoft.com"><img width="200" src="https://github.com/Zenika/terraform-azure-cli/raw/master/resources/azure-logo.png"></a>
  <a href="https://www.terraform.io/"><img width="200" src="https://github.com/Zenika/terraform-azure-cli/raw/master/resources/terraform-logo.png"></a>
</p>

# Terraform and Azure CLI Docker image

## 📦 Supported tags and respective Dockerfile links
Available image tags can be found on the Docker Hub registry: [zenika/terraform-azure-cli](https://hub.docker.com/r/zenika/terraform-azure-cli/tags)

Supported versions are listed in the [`supported_versions.json` ](https://github.com/Zenika/terraform-azure-cli/blob/master/supported_versions.json) file in project root folder.

The following image tag strategy is applied:
* `zenika/terraform-azure-cli:latest` - build from master
  * Included CLI versions can be found in the [Dockerfile](https://github.com/Zenika/terraform-azure-cli/blob/master/Dockerfile)
* `zenika/terraform-azure-cli:release-S.T_terraform-UU.VV.WW_azcli-XX.YY.ZZ` - build from releases
  * `release-S.T` is the release tag
  * `terraform-UU.VV.WWW` is the included Terraform CLI version
  * `azcli-XX.YY.ZZ` is the included Azure CLI version

Please report to the [releases page](https://github.com/Zenika/terraform-azure-cli/releases) for the changelogs.

> Any other tags are not supported even if available.

## 💡 Motivation
The goal is to create a **minimalist** and **lightweight** image with these tools in order to reduce network and storage impact.

This image gives you the flexibility to be used either for development or as a base image as you see fits.

## 🔧 What's inside ?
* [Azure CLI](https://docs.microsoft.com/cli/azure/?view=azure-cli-latest):
  * Included version indicated in the image tag: `azcli-XX.YY.ZZ`
* [Terraform CLI](https://www.terraform.io/docs/commands/index.html):
  * Included version indicated in the image tag: `terraform-XX.YY.ZZ`
* [Git](https://git-scm.com/)
* [Python 3](https://www.python.org/)
* This image use a non root user with a GID and UID of 1001 to conform with docker security best practices.

## 🚀 Usage

### Launch the CLI
Simply launch the container and use the CLI as you would on any other platform, for instance using the latest image:

```bash
docker container run -it --rm --mount type=bind,source="$(pwd)",target=/workspace zenika/terraform-azure-cli:latest
```

> The `--rm` flag will completely destroy the container and its data on exit.

### Build the image
You can build the image locally directly from the Dockerfile, using the build script.

It will :
* Lint the Dockerfile with [Hadolint](https://github.com/hadolint/hadolint);
* Build and tag the image `zenika/terraform-azure-cli:dev`;
* Execute [container structure tests](https://github.com/GoogleContainerTools/container-structure-test) on the image.

```bash
# launch build script using latest supported versions for both Azure and Terraform CLI
./build.sh
```

Optionally, it is possible to choose the tools desired versions:

```bash
# Set desired tool versions
AZURE_CLI_VERSION=2.24.2
TERRAFORM_VERSION=0.15.5

# launch build script with parameters
./build.sh $AZURE_CLI_VERSION $TERRAFORM_VERSION
```

## 🙏 Roadmap & Contributions
Please refer to the [github project](https://github.com/Zenika/terraform-azure-cli/projects/1) to track new features.

Do not hesitate to contribute by [filling an issue](https://github.com/Zenika/terraform-azure-cli/issues) or [opening a PR](https://github.com/Zenika/terraform-azure-cli/pulls) !

## ⬆️ Dependencies upgrades checklist

* Supported versions:
  * check Azure CLI version (only keep 2 latest releases), available on the [project release page](https://github.com/Azure/azure-cli/releases)
  * check Terraform CLI version (keep all minor versions from 0.11), available on the [project release page](https://github.com/hashicorp/terraform/releases)
* Dockerfile:
  * check base image version on DockerHub
  * check OS package versions on Debian package repository
    * Available Git versions on the [Debian Packages repository](https://packages.debian.org/search?suite=buster&arch=any&searchon=names&keywords=git)
    * Available Python versions on the [Debian packages repository](https://packages.debian.org/search?suite=buster&arch=any&searchon=names&keywords=python3)
    * same process for all other packages
  * check Pip package versions on [pypi](https://pypi.org/)
* Github actions:
  * check [runner version](https://github.com/actions/virtual-environments#available-environments)
  * check each action release versions
* Build scripts:
  * check container tags:
    * [Hadolint releases](https://github.com/hadolint/hadolint/releases)
    * [Container-structure-test](https://github.com/GoogleContainerTools/container-structure-test/releases)
* Readme:
  * update version in code exemples

## Similar repositories

* For AWS: [zenika-open-source/terraform-aws-cli](https://github.com/zenika-open-source/terraform-aws-cli)

## 📖 License
This project is under the [Apache License 2.0](https://raw.githubusercontent.com/Zenika/terraform-azure-cli/master/LICENSE)

[![with love by zenika](https://img.shields.io/badge/With%20%E2%9D%A4%EF%B8%8F%20by-Zenika-b51432.svg)](https://oss.zenika.com)
