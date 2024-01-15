GIT_TLD=$(shell git rev-parse --show-toplevel)
include $(GIT_TLD)/test/sre-stack/.env
include $(GIT_TLD)/.env
include $(GIT_TLD)/test/sre-stack/makefile
SRE_STACK_DIR := $(GIT_TLD)/test/sre-stack
RUNWHEN_SETUP_SCRIPT_PATH=setup/runwhen-local/setup.sh

RUNWHEN_REQUIRED_VARS := RUNWHEN_PLATFORM_TOKEN
$(foreach var,$(RUNWHEN_REQUIRED_VARS),$(if $(value $(var)),,$(error $(var) is not set)))

setup-sre-stack:
	$(MAKE) setup -C $(SRE_STACK_DIR)

cleanup-sre-stack:
	$(MAKE) cleanup -C $(SRE_STACK_DIR)

setup-runwhen: 
	$(GIT_TLD)/$(RUNWHEN_SETUP_SCRIPT_PATH)

cleanup-runwhen: 
	helm uninstall ${HELM_RELEASE_NAME} -n ${NAMESPACE}

setup-runwhen-all: setup-sre-stack setup-runwhen

cleanup-runwhen-all: cleanup-runwhen cleanup-sre-stack
