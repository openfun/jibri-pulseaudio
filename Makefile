# /!\ /!\ /!\ /!\ /!\ /!\ /!\ DISCLAIMER /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\
#
# This Makefile is only meant to be used for DEVELOPMENT purpose as we are
# changing the user id that will run in the container.
#
# PLEASE DO NOT USE IT FOR YOUR CI/PRODUCTION/WHATEVER...
#
# /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\
#
# Note to developpers:
#
# While editing this file, please respect the following statements:
#
# 1. Every variable should be defined in the ad hoc VARIABLES section with a
#    relevant subsection
# 2. Every new rule should be defined in the ad hoc RULES section with a
#    relevant subsection depending on the targeted service
# 3. Rules should be sorted alphabetically within their section
# 4. When a rule has multiple dependencies, you should:
#    - duplicate the rule name to add the help string (if required)
#    - write one dependency per line to increase readability and diffs
# 5. .PHONY rule statement should be written after the corresponding rule
# ==============================================================================
# VARIABLES

# -- Docker
# Get the current user ID to use for docker run and docker exec commands
DOCKER_UID           = $(shell id -u)
DOCKER_GID           = $(shell id -g)
DOCKER_USER          = $(DOCKER_UID):$(DOCKER_GID)
COMPOSE              = DOCKER_USER=$(DOCKER_USER) docker-compose
COMPOSE_RUN          = $(COMPOSE) run --rm
COMPOSE_RUN_APP      = $(COMPOSE_RUN) jibri

# ==============================================================================
# RULES

default: help

# -- Project

.env:
	cp .env.sample .env
	sed -e "s#JICOFO_AUTH_PASSWORD=.*#JICOFO_AUTH_PASSWORD=$$(openssl rand -hex 16)#g" \
	  -e "s#JVB_AUTH_PASSWORD=.*#JVB_AUTH_PASSWORD=$$(openssl rand -hex 16)#g" \
	  -e "s#JIGASI_XMPP_PASSWORD=.*#JIGASI_XMPP_PASSWORD=$$(openssl rand -hex 16)#g" \
	  -e "s#JIBRI_RECORDER_PASSWORD=.*#JIBRI_RECORDER_PASSWORD=$$(openssl rand -hex 16)#g" \
	  -e "s#JIBRI_XMPP_PASSWORD=.*#JIBRI_XMPP_PASSWORD=$$(openssl rand -hex 16)#g" \
	  -i .env

bootstrap: ## Prepare Docker images for the project
bootstrap: \
	.env \
	build
.PHONY: bootstrap

# -- Docker/compose
build: ## build the app container
	@$(COMPOSE) build jibri
.PHONY: build

down: ## stop and remove containers, networks, images, and volumes
	@$(COMPOSE) down
.PHONY: down

logs: ## display app logs (follow mode)
	@$(COMPOSE) logs -f jibri
.PHONY: logs

logs-all: ## display the entire jitsi stack logs (follow mode)
	@$(COMPOSE) logs -f
.PHONY: logs-all

run: ## start the development server using Docker
	@$(COMPOSE) up -d prosody jicofo web jvb jibri
.PHONY: run

status: ## an alias for "docker-compose ps"
	@$(COMPOSE) ps
.PHONY: status

stop: ## stop the development server using Docker
	@$(COMPOSE) stop
.PHONY: stop

# -- Misc
help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help
