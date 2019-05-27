# Setup build arguments with default versions
ARG AZURE_CLI_VERSION=2.0.65
ARG TERRAFORM_VERSION=0.11.14

# Download Terraform binary
FROM debian:stretch-20190506-slim as terraform
ARG TERRAFORM_VERSION
RUN apt-get update
RUN apt-get install -y curl=7.52.1-5+deb9u9
RUN apt-get install -y unzip=6.0-21+deb9u1
RUN curl -sSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform-${TERRAFORM_VERSION}.zip
# FIXME: validate terraform signature & checksum
RUN unzip -j terraform-${TERRAFORM_VERSION}.zip

# Install az CLI using PIP
FROM debian:stretch-20190506-slim as azure-cli-pip
ARG AZURE_CLI_VERSION
RUN apt-get update
RUN apt-get install -y python3=3.5.3-1
RUN apt-get install -y python3-pip=9.0.1-2+deb9u1
RUN pip3 install azure-cli==${AZURE_CLI_VERSION}
# Fix an pyOpenSSL package issue... (see https://github.com/erjosito/ansible-azure-lab/issues/5)
RUN pip3 uninstall -y pyOpenSSL cryptography
RUN pip3 install pyOpenSSL==19.0.0
RUN pip3 install cryptography==2.6.1

# Build final image
FROM debian:stretch-20190506-slim
RUN apt-get update --no-install-recommends \
  # TODO: Handle potential download issue when adding multiples packages with APT
  && apt-get install -y python3=3.5.3-1 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && ln -s /usr/bin/python3 /usr/bin/python
COPY --from=terraform /terraform /usr/local/bin/terraform
COPY --from=azure-cli-pip /usr/local/bin/az* /usr/local/bin/
COPY --from=azure-cli-pip /usr/local/lib/python3.5/dist-packages /usr/local/lib/python3.5/dist-packages
COPY --from=azure-cli-pip /usr/lib/python3/dist-packages /usr/lib/python3/dist-packages
WORKDIR /workspace
CMD ["bash"]
