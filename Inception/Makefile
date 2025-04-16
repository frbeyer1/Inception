DOCKER_COMPOSE_FILE := ./srcs/docker-compose.yml
ENV_FILE := srcs/.env
DATA_DIR := $(HOME)/data
WORDPRESS_DATA_DIR := $(DATA_DIR)/wordpress
MARIADB_DATA_DIR := $(DATA_DIR)/mariadb

name = inception

# Default target to create dirs and bring up the containers
all: create_dirs make_dir_up

# Build and start the containers
build: create_dirs make_dir_up_build

# Stop and remove containers
down:
	@printf "Stopping configuration ${name}...\n"
	@docker compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) down

down-v:
	@printf "Stopping configuration and removes volumes ${name}...\n"
	@docker compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) down -v
# Rebuild the containers
re: down-v create_dirs make_dir_up_build

# Clean up containers and volumes
clean:
	@printf "Cleaning configuration ${name}...\n"
	@docker system prune -a
	@if [ -d "$(WORDPRESS_DATA_DIR)" ]; then sudo rm -rf $(WORDPRESS_DATA_DIR)/*; fi
	@if [ -d "$(MARIADB_DATA_DIR)" ]; then sudo rm -rf $(MARIADB_DATA_DIR)/*; fi

# Full clean (prune networks, volumes, and system resources)
fclean:
	@printf "Total clean of all configurations docker\n"
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@docker volume rm mariadb wordpress || true
	@if [ -d "$(WORDPRESS_DATA_DIR)" ]; then sudo rm -rf $(WORDPRESS_DATA_DIR)/*; fi
	@if [ -d "$(MARIADB_DATA_DIR)" ]; then sudo rm -rf $(MARIADB_DATA_DIR)/*; fi

# Show container logs
logs:
	@docker compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) logs -f
	# Or for specific service logs:
	# @docker compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) logs -f wordpress

# Create necessary data directories with correct permissions
create_dirs:
	@printf "Creating data directories...\n"
	@mkdir -p $(WORDPRESS_DATA_DIR)
	@mkdir -p $(MARIADB_DATA_DIR)
	@sudo chown -R $(USER):$(USER) $(WORDPRESS_DATA_DIR) $(MARIADB_DATA_DIR)

# Bring up the containers without rebuilding
make_dir_up:
	@printf "Launching configuration ${name}...\n"
	@docker compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) up -d

# Build and bring up the containers
make_dir_up_build:
	@printf "Building configuration ${name}...\n"
	@docker compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) up -d --build

remove_volumes:
	@printf "Removing old volumes...\n"
	@docker volume rm mariadb wordpress || true

.PHONY: all build down re clean fclean logs create_dirs make_dir_up make_dir_up_build
