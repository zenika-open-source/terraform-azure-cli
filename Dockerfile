# Build arguments
ARG AZURE_CLI_VERSION
ARG TERRAFORM_VERSION
ARG PYTHON_MAJOR_VERSION=3.11
ARG DEBIAN_VERSION=bookworm-20240211-slim

# Download Terraform binary
FROM debian:${DEBIAN_VERSION} as terraform-cli
ARG TERRAFORM_VERSION
RUN apt-get update
RUN apt-get install --no-install-recommends -y curl=7.88.1-10+deb12u5
RUN apt-get install --no-install-recommends -y ca-certificates=20230311
RUN apt-get install --no-install-recommends -y unzip=6.0-28
RUN apt-get install --no-install-recommends -y gnupg=2.2.40-1.1
WORKDIR /workspace
RUN curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS
RUN curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig
COPY hashicorp.asc hashicorp.asc
RUN gpg --import hashicorp.asc
RUN gpg --verify terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig terraform_${TERRAFORM_VERSION}_SHA256SUMS
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN grep terraform_${TERRAFORM_VERSION}_linux_amd64.zip terraform_${TERRAFORM_VERSION}_SHA256SUMS | sha256sum -c -
RUN unzip -j terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install az CLI using PIP
FROM debian:${DEBIAN_VERSION} as azure-cli
ARG AZURE_CLI_VERSION
ARG PYTHON_MAJOR_VERSION
RUN apt-get update
RUN apt-cache show gnupg | grep Version
RUN apt-get install -y --no-install-recommends python3=${PYTHON_MAJOR_VERSION}.2-1+b1
RUN apt-get install -y --no-install-recommends python3-pip=23.0.1+dfsg-1
# Without '--break-system-packages' option we get an error installing items with
# pip and without using a venv. It's not necessary to do this in a container.
RUN pip3 install --no-cache-dir setuptools==60.8.2 --break-system-packages
RUN pip3 install --no-cache-dir azure-cli==${AZURE_CLI_VERSION} --break-system-packages

# Build final image
FROM debian:${DEBIAN_VERSION}
LABEL maintainer="bgauduch@github"
ARG PYTHON_MAJOR_VERSION
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  ca-certificates=20230311 \
  git=1:2.39.2-1.1 \
  python3=${PYTHON_MAJOR_VERSION}.2-1+b1 \
  python3-distutils=${PYTHON_MAJOR_VERSION}.2-3 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && update-alternatives --install /usr/bin/python python /usr/bin/python${PYTHON_MAJOR_VERSION} 1
WORKDIR /workspace
COPY --from=terraform-cli /workspace/terraform /usr/local/bin/terraform
COPY --from=azure-cli /usr/local/bin/az* /usr/local/bin/
COPY --from=azure-cli /usr/local/lib/python${PYTHON_MAJOR_VERSION}/dist-packages /usr/local/lib/python${PYTHON_MAJOR_VERSION}/dist-packages
COPY --from=azure-cli /usr/lib/python3/dist-packages /usr/lib/python3/dist-packages

RUN groupadd --gid 1001 nonroot \
  # user needs a home folder to store azure credentials
  && useradd --gid nonroot --create-home --uid 1001 nonroot \
  && chown nonroot:nonroot /workspace
USER nonroot

CMD ["bash"]
