# Download Terraform binary and Azure CLI in a dedicated stage
FROM debian:stretch-20190506 as download
ARG TERRAFORM_VERSION=0.11.13
ARG AZURE_CLI_VERSION=2.0.0
RUN apt-get update
RUN apt-get install -y \
  curl=7.52.1-5+deb9u9 \
  unzip=6.0-21+deb9u1 \
  apt-transport-https=1.4.9 \
  lsb-release=9.20161125 \
  gnupg=2.1.18-8~deb9u4
# Terraform binary
RUN curl -sSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform-${TERRAFORM_VERSION}.zip
RUN unzip -j terraform-${TERRAFORM_VERSION}.zip
# Azure CLI
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc \
  | gpg --dearmor \
  | tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
RUN AZ_REPO=$(lsb_release -cs) \
  && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" \
  | tee /etc/apt/sources.list.d/azure-cli.list
RUN apt-get update
RUN apt-get install -y \
  azure-cli=2.0.64-1~stretch

# Build final image
FROM debian:stretch-20190506-slim
RUN apt-get update && apt-get install --no-install-recommends --no-upgrade -y \
  # python3-pip \
  # python3-dev=3.5.3-1 \
  python3=3.5.3-1
# ENV PATH="/usr/lib/python3.5:${PATH}"
# RUN ln -fs /usr/lib/python3.5/plat-x86_64-linux-gnu/_sysconfigdata.py /usr/lib/python3.5/
ENV PYTHONPATH="/usr/lib/python3.5"
ENV PYTHONHOME="/usr/lib/python3.5"
COPY --from=download /terraform /usr/local/bin/terraform
COPY --from=download /usr/bin/az /usr/local/bin/az
COPY --from=download /opt/az/bin/python3 /opt/az/bin/python3
CMD bash
