.PHONY: help \
	init network \
	build up run restart stop down logs ps pull clean \
	migrate-up migrate-down migrate-status migrate-create \
	seed-create seed-up
	

COMPOSE_FILE := docker-compose.yml
NETWORK := bythen-network

ifneq (,$(wildcard .env))
include .env
export
endif

.DEFAULT_GOAL := help

help: ## Show available commands
	@printf "\nUsage: make <target>\n\n"
	@printf "Available targets:\n"
	@grep -hE '^[a-zA-Z0-9_%-]+:.*?##' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS=":.*?##";}{printf "  %-15s %s\n", $$1, $$2}'

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
	docker compose -f $(COMPOSE_FILE) ps -a

clean: down ## Stop and remove containers, networks, and volumes
	docker compose -f $(COMPOSE_FILE) down -v


GOOSE := go run github.com/pressly/goose/v3/cmd/goose@v3.27.2
GOOSE_DSN := $(MYSQL_USER):$(MYSQL_PASSWORD)@tcp(localhost:$(MYSQL_PORT))/$(MYSQL_DATABASE)

migrate-up: network ## Run goose migrations up
	docker compose -f $(COMPOSE_FILE) up -d mysql
	$(GOOSE) -dir database/migrations mysql "$(GOOSE_DSN)" up

migrate-down: network ## Run goose migrations down
	docker compose -f $(COMPOSE_FILE) up -d mysql
	$(GOOSE) -dir database/migrations mysql "$(GOOSE_DSN)" down

migrate-status: network ## Show goose migration status
	docker compose -f $(COMPOSE_FILE) up -d mysql
	$(GOOSE) -dir database/migrations mysql "$(GOOSE_DSN)" status

migrate-create: ## Create a new goose migration file: make migrate-create NAME=create_posts
	@ if [ -z "$(NAME)" ]; then \
		printf "Usage: make migrate-create NAME=<name>\n"; \
		exit 1; \
	fi
	$(GOOSE) create -dir database/migrations "$(NAME)" sql

seed-create: ## Create a new goose seeder file: make seed-create NAME=seed_posts
	@ if [ -z "$(NAME)" ]; then \
		printf "Usage: make migrate-create NAME=<name>\n"; \
		exit 1; \
	fi
	$(GOOSE) create -dir database/seeds "$(NAME)" sql

seed-up: network ## Run goose seed files
	docker compose -f $(COMPOSE_FILE) up -d mysql
	$(GOOSE) -dir database/seeds mysql "$(GOOSE_DSN)" up

