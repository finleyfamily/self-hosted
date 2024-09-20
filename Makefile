SHELL := /bin/bash

ifeq ($(CI), yes)
	POETRY_OPTS = "-v"
	PRE_COMMIT_OPTS = --show-diff-on-failure --verbose
endif

.PHONY: help
help: ## show this message
	@awk \
		'BEGIN {FS = ":.*##"; printf "\nUsage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' \
		$(MAKEFILE_LIST)
	@if [[ -f ansible/Makefile ]]; then \
		$(MAKE) --no-print-directory -C ansible help; \
	fi

fix: run-pre-commit ## run all automatic fixes

nodes: ## ansible: run the "nodes" playbook
	@$(MAKE) --no-print-directory -C ansible nodes;

run-pre-commit: ## run pre-commit for all files
	@poetry run pre-commit run $(PRE_COMMIT_OPTS) \
		--all-files \
		--color always

setup: setup-poetry setup-pre-commit setup-npm ## setup development environment
	# @$(MAKE) --no-print-directory -C ansible setup;

setup-npm: ## install node dependencies with npm
	@npm ci;

setup-poetry: ## setup python virtual environment
	@poetry install $(POETRY_OPTS) --sync;

setup-pre-commit: ## install pre-commit git hooks
	@poetry run pre-commit install;

spellcheck: ## run cspell
	@echo "Running cSpell to checking spelling..."
	@npm exec --no -- cspell lint . \
		--color \
		--config .vscode/cspell.json \
		--dot \
		--gitignore \
		--must-find-files \
		--no-progress \
		--relative \
		--show-context

upgrade: ## ansible: run the "upgrade" playbook
	@$(MAKE) --no-print-directory -C ansible upgrade;
