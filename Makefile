# Makefile
venv_bin := .venv/bin/

all: help

.PHONY: init
init: setup-venv install-deps

.PHONY: lock
lock: requirements.txt dev-requirements.txt

.PHONY: setup-venv
setup-venv:
	python3 -m venv .venv \
	&& source $(venv_bin)activate \
	&& pip install --upgrade pip \
	&& pip install pip-tools

.PHONY: install-deps
install-deps:
	$(venv_bin)pip-sync requirements/requirements.txt

.PHONY: install-dev-deps
install-dev-deps:
	$(venv_bin)pip-sync requirements/dev-requirements.txt

requirements.txt:
	$(venv_bin)pip-compile --generate-hashes --resolver=backtracking -o requirements/requirements.txt pyproject.toml

dev-requirements.txt:
	$(venv_bin)pip-compile --generate-hashes --resolver=backtracking --extra dev -o requirements/dev-requirements.txt pyproject.toml

.PHONY: run-game
run-game:
	source $(venv_bin)activate \
	&& cd game \
	&& pyxel run main.py

.PHONY: lint
lint:
	flake8

.PHONY: type
type:
	mypy

.PHONY: format
format:
	black .

help:
	@echo "Use \`make <target>' where <target> is one of"
	@echo "  init                       - setup a venv and install dependencies for dev"
	@echo "  lock                       - lock/freeze all dependencies stored in pyproject.toml"
	@echo "  run-game                   - run pyxel game"
	@echo "  lint                       - check style using flake8"
	@echo "  type                       - run static type check using mypy"
	@echo "  format                     - format code using black"