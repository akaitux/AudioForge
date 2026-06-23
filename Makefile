PNPM ?= $(shell command -v pnpm 2>/dev/null || echo $(HOME)/.local/bin/pnpm)

.PHONY: all build package clean install-pnpm

all: package

# Install pnpm locally if not found on PATH
install-pnpm:
	@if ! command -v pnpm >/dev/null 2>&1 && [ ! -f $(HOME)/.local/bin/pnpm ]; then \
		echo "Installing pnpm to ~/.local/bin ..."; \
		npm install -g pnpm --prefix $(HOME)/.local; \
	fi

# Build the frontend JS bundle
build: install-pnpm
	CI=true $(PNPM) run build

# Build and package into out/AudioForge.zip
package: build
	bash package.sh

clean:
	rm -rf dist out
