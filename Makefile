VENV        := .venv
PYTHON      := $(VENV)/bin/python
PIP         := $(VENV)/bin/pip
PIP_COMPILE := $(VENV)/bin/pip-compile

BACKEND_DIR  := src/backend
FRONTEND_DIR := src/frontend
FRONTEND_PORT := 8080

.DEFAULT_GOAL := help

.PHONY: help install run frontend lint format compile clean

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

$(VENV)/bin/activate: $(BACKEND_DIR)/requirements.txt
	python3 -m virtualenv $(VENV) 2>/dev/null || python3 -m venv $(VENV)
	$(PIP) install --quiet --upgrade pip
	$(PIP) install --quiet -r $(BACKEND_DIR)/requirements.txt
	touch $(VENV)/bin/activate

install: $(VENV)/bin/activate ## Create venv and install dependencies

run: install ## Start the Flask backend (http://localhost:5000)
	$(PYTHON) $(BACKEND_DIR)/app.py

frontend: ## Serve the frontend (http://localhost:$(FRONTEND_PORT))
	python3 -m http.server $(FRONTEND_PORT) --directory $(FRONTEND_DIR)

compile: install ## Regenerate requirements.txt from requirements.in
	$(PIP) install --quiet pip-tools
	$(VENV)/bin/pip-compile $(BACKEND_DIR)/requirements.in --output-file $(BACKEND_DIR)/requirements.txt

lint: install ## Run Black check + yamllint + bandit
	$(VENV)/bin/black --check $(BACKEND_DIR)
	yamllint $(shell git ls-files '*.yml' '*.yaml')
	$(VENV)/bin/bandit -ll $(BACKEND_DIR)/app.py $(BACKEND_DIR)/models.py

format: install ## Auto-format Python files with Black
	$(VENV)/bin/black $(BACKEND_DIR)

clean: ## Remove the virtual environment
	rm -rf $(VENV)
