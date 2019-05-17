# Terraform and Azure CLI Docker image
Container image including Azure and Terraform CLI tools, build with Docker.

## Motivation
Many Docker image including the Terraform and Azure CLI exist out there both on the Docker Hub and Github, but they all are quite oversized (600+ Mo).

The goal is to create a functionnal, minimalist and lightweight image with these tools in order to reduce network impact.

## Usage

### Build
```bash
./scripts/build.sh
```
