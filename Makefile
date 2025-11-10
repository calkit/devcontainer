.PHONY: devcontainer-local
devcontainer-local:
	@echo "Creating devcontainer spec for testing"
	@jq 'del(.image) | .build = {"dockerfile": "Dockerfile"}' devcontainer.json > .devcontainer.json
