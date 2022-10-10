AZURE_CLI_VERSION ?=
TERRAFORM_VERSION ?=
IMAGE_NAME := stroem/terraform-azure-cli
IMAGE_TAG ?= latest
NO_VERSIONS ?= 100

.PHONY: terraform-releases
terraform-releases:
	@curl --silent https://api.github.com/repos/hashicorp/terraform/releases?per_page=$(NO_VERSIONS) \
		| jq -r '.[] | .tag_name' \
		| awk '{gsub(/^v/,"");}1' \
		| grep -v - \
		| sort -r -u --version-sort

.PHONY: azure-cli-releases
azure-cli-releases:
	@curl --silent https://api.github.com/repos/azure/azure-cli/releases?per_page=$(NO_VERSIONS) \
		| jq -r '.[] | .tag_name' \
		| awk '{gsub(/^azure-cli-/,"");}1' \
		| grep -v -i "^vm-" \
		| sort -r -u --version-sort

.PHONY: lint
lint:
	@echo "Linting Dockerfile..."
	docker run --rm --interactive \
		--volume "${PWD}":/data \
		--workdir /data \
		hadolint/hadolint:2.5.0-alpine \
		/bin/hadolint --config hadolint.yaml Dockerfile
	@echo "Dockerfile successfully linted!"

.PHONY: check-terraform-release
check-terraform-release:
	@make terraform-releases | grep -q -i "^$(TERRAFORM_VERSION)$$" \
		|| ( echo "Unsupported terraform version: $(TERRAFORM_VERSION)"; exit 1 )

.PHONY: check-azure-cli-release
check-azure-cli-release:
	@make azure-cli-releases | grep -q -i "^$(AZURE_CLI_VERSION)$$" \
		|| ( echo "Unsupported azure cli version: $(AZURE_CLI_VERSION)"; exit 1 )

.PHONY: build
build: check-terraform-release check-azure-cli-release
	@echo "Building images with AZURE_CLI_VERSION=$(AZURE_CLI_VERSION) and TERRAFORM_VERSION=$(TERRAFORM_VERSION)..."
	docker image build --progress plain \
		--build-arg AZURE_CLI_VERSION="$(AZURE_CLI_VERSION)" \
		--build-arg TERRAFORM_VERSION="$(TERRAFORM_VERSION)" \
		-t $(IMAGE_NAME):$(IMAGE_TAG) .
	@echo "Image successfully builded!"

.PHONY: save
save:
	install -d build
	docker image save \
		--output build/image_${IMAGE_TAG}.tar \
		${IMAGE_NAME}:${IMAGE_TAG}

.PHONY: load
load:
	docker image load \
		--input build/image_${IMAGE_TAG}.tar

.PHONY: test
test: build
	@echo "Generating test config with AZURE_CLI_VERSION=${AZURE_CLI_VERSION} and TERRAFORM_VERSION=${TERRAFORM_VERSION}..."
	envsubst '$${AZURE_CLI_VERSION},$${TERRAFORM_VERSION}' < tests/container-structure-tests.yml.template > /tmp/container-structure-tests.yml
	@echo "Test config successfully generated!"
	@echo "Executing container structure test..."
	docker container run --rm -it \
		-v /tmp/container-structure-tests.yml:/tests.yml:ro \
		-v /var/run/docker.sock:/var/run/docker.sock:ro \
		gcr.io/gcp-runtimes/container-structure-test:v1.10.0 \
		test --image $(IMAGE_NAME):$(IMAGE_TAG) --config /tests.yml
