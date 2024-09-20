SHELL := /bin/bash

.PHONY: help
help: ## show this message
	@awk \
		'BEGIN {FS = ":.*##"; printf "\nUsage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' \
		$(MAKEFILE_LIST)
	@if [[ -f general-resources.mk ]]; then \
		$(MAKE) --no-print-directory -f .general-resources.mk help; \
	fi

nodes: ## ansible: run the "nodes" playbook
	@ansible-playbook playbooks/nodes.yml;

setup: ## ansible: perform setup actions
	@if [[ -f "requirements.yml" ]]; then \
		ansible-galaxy install --role-file requirements.yml
	fi

upgrade: ## ansible: run the "upgrade" playbook
	@ansible-playbook playbooks/upgrade.yml;
