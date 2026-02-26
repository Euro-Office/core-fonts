# Makefile for core-fonts repository

WEB_APPS_DIR?=../web-apps
IMAGE?=ghcr.io/euro-office/documentserver:latest

# Default target
.PHONY: help
help:
	@echo "Makefile targets:"
	@echo "  allfontsgen   - run the allfontsgen tool inside $(IMAGE) container"

.PHONY: allfontsgen
allfontsgen:
	@mkdir -p deploy
	@echo "Pulling $(IMAGE) if not present..."
	@docker image inspect $(IMAGE) > /dev/null 2>&1 || docker pull $(IMAGE)
	@echo "Running allfontsgen inside $(IMAGE)..."
	@docker run --rm \
		-v "$(PWD):/workspace" \
		-w /workspace \
		--entrypoint "" \
		-e LD_LIBRARY_PATH=/var/www/onlyoffice/documentserver/server/FileConverter/bin \
		$(IMAGE) \
		/var/www/onlyoffice/documentserver/server/tools/allfontsgen \
		--input="/workspace" \
		--allfonts-web="./deploy/AllFonts-web.js" \
		--allfonts="./deploy/AllFonts.js" \
		--images="./deploy" \
		--output-web="./deploy" \
		--selection="./deploy/font_selection.bin"

.PHONY: install
install: allfontsgen
	@echo "Installing generated files to $(WEB_APPS_DIR)/
	@cp deploy/AllFonts-web.js $(WEB_APPS_DIR)/deploy/sdkjs/common/AllFonts.js
