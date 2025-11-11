# Makefile for core-fonts repository

WEB_APPS_DIR?=../web-apps

# Default target
.PHONY: help
help:
	@echo "Makefile targets:"
	@echo "  allfontsgen   - run the allfontsgen tool inside onlyoffice/documentserver container"

.PHONY: allfontsgen
allfontsgen:
	@mkdir -p deploy
	@echo "Running allfontsgen inside onlyoffice/documentserver..."
	@docker run --rm \
		-v "$(PWD):/workspace" \
		-w /workspace \
		--entrypoint "" \
		-e LD_LIBRARY_PATH=/var/www/onlyoffice/documentserver/server/FileConverter/bin \
		onlyoffice/documentserver \
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
