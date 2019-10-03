# Setup build arguments with default versions
ARG AZURE_CLI_VERSION=2.0.74
ARG TERRAFORM_VERSION=0.12.9

# Download Terraform binary
FROM debian:stretch-20190506-slim as terraform
ARG TERRAFORM_VERSION
RUN apt-get update
# hadolint ignore=DL3015
RUN apt-get install -y curl=7.52.1-5+deb9u9
RUN apt-get install -y unzip=6.0-21+deb9u2 --no-install-recommends
RUN apt-get install -y gnupg=2.1.18-8~deb9u4 --no-install-recommends
RUN curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS
RUN curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig
COPY hashicorp.asc hashicorp.asc
RUN gpg --import hashicorp.asc
RUN gpg --verify terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig terraform_${TERRAFORM_VERSION}_SHA256SUMS
# hadolint ignore=DL4006
RUN grep terraform_${TERRAFORM_VERSION}_linux_amd64.zip terraform_${TERRAFORM_VERSION}_SHA256SUMS | sha256sum -c -
RUN unzip -j terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install az CLI using PIP
FROM debian:stretch-20190506-slim as azure-cli-pip
ARG AZURE_CLI_VERSION
RUN apt-get update
RUN apt-get install -y python3=3.5.3-1 --no-install-recommends
# hadolint ignore=DL3015
RUN apt-get install -y python3-pip=9.0.1-2+deb9u1
RUN pip3 install azure-cli==${AZURE_CLI_VERSION}
# Fix an pyOpenSSL package issue... (see https://github.com/erjosito/ansible-azure-lab/issues/5)
RUN pip3 uninstall -y pyOpenSSL cryptography
RUN pip3 install pyOpenSSL==19.0.0
RUN pip3 install cryptography==2.7

# Build final image
FROM debian:stretch-20190506-slim
ENV PYTHON_MAJOR_VERSION=3.5
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates=20161130+nmu1+deb9u1 \
    python3=${PYTHON_MAJOR_VERSION}.3-1 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && update-alternatives --install /usr/bin/python python /usr/bin/python${PYTHON_MAJOR_VERSION} 1
COPY --from=terraform /terraform /usr/local/bin/terraform
COPY --from=azure-cli-pip /usr/local/bin/az* /usr/local/bin/
COPY --from=azure-cli-pip /usr/local/lib/python3.5/dist-packages /usr/local/lib/python3.5/dist-packages
COPY --from=azure-cli-pip /usr/lib/python3/dist-packages /usr/lib/python3/dist-packages
WORKDIR /workspace
CMD ["bash"]
