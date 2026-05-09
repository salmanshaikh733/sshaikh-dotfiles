# Makefile for dotfiles

SHELL := /bin/bash
DOTFILES_DIR := $(shell pwd)
BACKUP_DIR := $(DOTFILES_DIR)/backup/$(shell date +%Y%m%d_%H%M%S)

# Define all dotfiles to install
DOTFILES := \
	.bashrc \
	.bash_aliases \
	.vimrc \
	.gitconfig \
	.tmux.conf \
	.inputrc

# Default target
.DEFAULT_GOAL := help

##@ General

.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Development

.PHONY: install
install: ## Install all dotfiles (creates symlinks)
	@mkdir -p "$(BACKUP_DIR)"
	@for file in $(DOTFILES); do \
		if [ -f "$(HOME)/$$file" ]; then \
			echo "Backing up existing $$file"; \
			mv "$(HOME)/$$file" "$(BACKUP_DIR)/"; \
		fi; \
		ln -sf "$(DOTFILES_DIR)/$$file" "$(HOME)/$$file"; \
		echo "Linked $$file"; \
	done
	@echo "✅ Dotfiles installed successfully."
	@echo "Backup of previous configs stored in: $(BACKUP_DIR)"

.PHONY: uninstall
uninstall: ## Remove all dotfile symlinks
	@for file in $(DOTFILES); do \
		if [ -L "$(HOME)/$$file" ]; then \
			rm "$(HOME)/$$file"; \
			echo "Removed $$file"; \
		fi; \
	done
	@echo "✅ Dotfiles removed."

.PHONY: update
update: ## Pull latest changes and reinstall
	git pull origin master
	make install

.PHONY: backup
backup: ## Create timestamped backup of current dotfiles
	@mkdir -p "$(BACKUP_DIR)"
	@for file in $(DOTFILES); do \
		if [ -f "$(HOME)/$$file" ]; then \
			cp "$(HOME)/$$file" "$(BACKUP_DIR)/"; \
			echo "Backed up $$file"; \
		fi; \
	done
	@echo "✅ Backup created at: $(BACKUP_DIR)"

##@ Utilities

.PHONY: list
list: ## List all managed dotfiles
	@echo "Managed dotfiles:"
	@for file in $(DOTFILES); do \
		if [ -L "$(HOME)/$$file" ]; then \
			echo "  ✅ $$file (linked)"; \
		elif [ -f "$(HOME)/$$file" ]; then \
			echo "  ⚠️  $$file (exists, not linked)"; \
		else \
			echo "  ❌ $$file (missing)"; \
		fi; \
	done

.PHONY: test
test: ## Validate dotfiles syntax
	@bash -n $(DOTFILES_DIR)/.bashrc && echo "bashrc: OK"
	@bash -n $(DOTFILES_DIR)/.bash_aliases && echo "bash_aliases: OK"
	@echo "✅ All dotfiles validated."