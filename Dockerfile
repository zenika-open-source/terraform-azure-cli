ARG TERRAFORM_VERSION=0.11.13
ARG AZ_CLI_VERSION=2.0.64

# Download Terraform binary
FROM debian:stretch-20190506-slim as terraform
ARG TERRAFORM_VERSION
RUN apt update
RUN apt install -y curl=7.52.1-5+deb9u9
RUN apt install -y unzip=6.0-21+deb9u1
RUN curl -sSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform-${TERRAFORM_VERSION}.zip
# FIXME: validate terraform signature & checksum
RUN unzip -j terraform-${TERRAFORM_VERSION}.zip

# Install az CLI using PIP
FROM debian:stretch-20190506-slim as azure-cli-pip
ARG AZ_CLI_VERSION
RUN apt update
RUN apt install -y python3=3.5.3-1
RUN apt install -y python3-pip=9.0.1-2+deb9u1
RUN pip3 install azure-cli==${AZ_CLI_VERSION}
# Fix an pyOpenSSL package issue... (see https://github.com/erjosito/ansible-azure-lab/issues/5)
RUN pip3 uninstall -y pyOpenSSL cryptography
RUN pip3 install pyOpenSSL==19.0.0
RUN pip3 install cryptography==2.6.1

# Build final image
FROM debian:stretch-20190506-slim
RUN apt update \
  # TODO: Handle potentialdownload issue when adding multiples packages with APT
  && apt install -y python3=3.5.3-1 \
  && ln -s /usr/bin/python3 /usr/bin/python
COPY --from=terraform /terraform /usr/local/bin/terraform
COPY --from=azure-cli-pip /usr/local/bin/az* /usr/local/bin/
COPY --from=azure-cli-pip /usr/local/lib/python3.5/dist-packages /usr/local/lib/python3.5/dist-packages
COPY --from=azure-cli-pip /usr/lib/python3/dist-packages /usr/lib/python3/dist-packages
CMD ["bash"]
