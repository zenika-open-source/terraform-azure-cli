# Setup build arguments with default versions
ARG AZURE_CLI_VERSION=2.0.65
ARG TERRAFORM_VERSION=0.11.14

# Download Terraform binary
FROM alpine:3.9.4 as terraform
ARG TERRAFORM_VERSION
RUN apk update
RUN apk add curl=7.64.0-r1
RUN apk add unzip=6.0-r4
RUN apk add gnupg=2.2.12-r0
RUN curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS
RUN curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig
COPY hashicorp.asc hashicorp.asc
RUN gpg --import hashicorp.asc
RUN gpg --verify terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig terraform_${TERRAFORM_VERSION}_SHA256SUMS
RUN grep terraform_${TERRAFORM_VERSION}_linux_amd64.zip terraform_${TERRAFORM_VERSION}_SHA256SUMS | sha256sum -c -
RUN unzip -j terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install az CLI using PIP
FROM alpine:3.9.4 as azure-cli
ARG AZURE_CLI_VERSION
RUN apk update
RUN apk add python3=3.6.8-r2
RUN apk add python3-dev=3.6.8-r2
RUN apk add py3-setuptools=40.6.3-r0
RUN apk add gcc=8.3.0-r0
RUN apk add musl-dev=1.1.20-r4
RUN apk add libffi-dev=3.2.1-r6
RUN apk add openssl-dev=1.1.1b-r1
RUN apk add make=4.2.1-r2
RUN pip3 install azure-cli==${AZURE_CLI_VERSION}

# Build final image
FROM alpine:3.9.4
RUN apk --no-cache add python3=3.6.8-r2 bash=4.4.19-r1 ca-certificates=20190108-r0 \
  && ln -s /usr/bin/python3 /usr/bin/python
COPY --from=terraform /terraform /usr/bin/terraform
COPY --from=azure-cli /usr/bin/az* /usr/bin/
COPY --from=azure-cli /usr/lib/python3.6/site-packages /usr/lib/python3.6/site-packages
WORKDIR /workspace
CMD ["bash"]
