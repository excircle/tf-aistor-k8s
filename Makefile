# Default target
all: prereqs setup-env set-secrets

# Check and create data directories if they don't exist
prereqs:
	@echo "Checking if gh is installed..."
	@if ! command -v gh > /dev/null; then \
		echo "Error: gh (GitHub CLI) is not installed. Please install it via Homebrew with 'brew install gh'."; \
		exit 1; \
	else \
		echo "gh is installed."; \
	fi
	@echo "Checking if jq is installed..."
	@if ! command -v jq > /dev/null; then \
		echo "Error: jq (JSON QUERY) is not installed. Please install it via Homebrew with 'brew install jq'."; \
		exit 1; \
	else \
		echo "jq is installed."; \
	fi
	@echo "Checking if target.json is installed..."
	@if [ ! -f target.json ]; then \
		echo "Error: target.json is not found. Please create it with the required secrets."; \
		exit 1; \
	else \
		echo "target.json is found."; \
	fi

setup-env:
	@export GH_TOKEN=$$(jq -r '.PA_TOKEN' target.json); \
	export GH_PAGER=""; \
	export REPO=$$(jq -r '.GHA_REPO' target.json) \

# Set secrets in the repository
set-secrets: setup-env
	@for secret in AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY PA_TOKEN; do \
		VALUE=$$(jq -r --arg secret $$secret ".$$secret" target.json); \
		gh secret set $$secret -b"$$VALUE" -R $$REPO; \
	done
	@SSHKEY_PATH=$$(jq -r '.SSHKEY_LOCATION' target.json); \
	if [ -f "$$SSHKEY_PATH" ]; then \
		SSHKEY_B64=$$(base64 < "$$SSHKEY_PATH"); \
		gh secret set SSHKEY -b"$$SSHKEY_B64" -R $$REPO; \
	else \
		echo "Error: SSH key file not found at $$SSHKEY_PATH"; \
		exit 1; \
	fi

.PHONY: all prereqs setup-env set-secrets