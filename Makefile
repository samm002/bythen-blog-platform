.PHONY: help init network up run restart stop down logs ps pull build clean

COMPOSE_FILE := docker-compose.yml
NETWORK := bythen-network

.DEFAULT_GOAL := help

help: ## Show available commands
	@printf "\nUsage: make <target>\n\n"
	@printf "Available targets:\n"
	@grep -E '^[a-zA-Z0-9_%-]+:.*?##' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS=":.*?##";}{printf "  %-15s %s\n", $$1, $$2}'

init: ## Initialize Docker prerequisites (env, network)
	@printf "Initializing Docker environment...\n"
	@$(MAKE) --no-print-directory env
	@$(MAKE) --no-print-directory network
	@printf "Docker environment initialized!\n"

env: ## Create .env from .env.example if missing
	@if [ ! -f .env ]; then \
		if [ -f .env.example ]; then \
			cp .env.example .env; \
			printf "Created .env from .env.example\n"; \
		else \
			printf "ERROR: .env.example not found\n" >&2; \
			exit 1; \
		fi; \
	else \
		printf ".env already exists, skipping\n"; \
	fi

network: ## Ensure external Docker network exists
	@if ! docker network inspect $(NETWORK) >/dev/null 2>&1; then \
		docker network create $(NETWORK); \
		printf "Created network '%s'\n" "$(NETWORK)"; \
	else \
		printf "Network '%s' already exists, skipping\n" "$(NETWORK)"; \
	fi

build: ## Build Docker Compose services
	docker compose -f $(COMPOSE_FILE) build

up: network ## Start services in detached mode
	docker compose -f $(COMPOSE_FILE) up -d

run: network ## Start services attached and rebuild if needed
	docker compose -f $(COMPOSE_FILE) up -d --build

restart: ## Restart running services
	docker compose -f $(COMPOSE_FILE) restart

stop: ## Stop services
	docker compose -f $(COMPOSE_FILE) stop

down: ## Stop and remove containers
	docker compose -f $(COMPOSE_FILE) down

logs: ## Tail logs for app
	docker compose -f $(COMPOSE_FILE) logs -f app

ps: ## Show current service status
	docker compose -f $(COMPOSE_FILE) ps

clean: down ## Stop and remove containers, networks, and volumes
	docker compose -f $(COMPOSE_FILE) down -v


