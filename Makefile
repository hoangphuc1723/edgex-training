# /*******************************************************************************
#  * Copyright 2021 Intel
#  *
#  * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
#  * in compliance with the License. You may obtain a copy of the License at
#  *
#  * http://www.apache.org/licenses/LICENSE-2.0
#  *
#  * Unless required by applicable law or agreed to in writing, software distributed under the License
#  * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
#  * or implied. See the License for the specific language governing permissions and limitations under
#  * the License.
#  *
#  *******************************************************************************/

.PHONY: help portainer portainer-down pull run pull-ui run-ui down-ui down clean get-token
.SILENT: help get-token

help:
	echo "See README.md in this folder"

ARGS:=$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(ARGS):;@:)

OPTIONS:=" amd64 no-secty app-sample " # Must have spaces around words for `filter-out` function to work properly

# Current default is to use stand alone docker-compose.
# Since compose V2 with the new "docker compose" command in the docker CLI has been released
# we are supporting both versions. In EdgeX 3.0 we'll just support compose V2.
DOCKER_COMPOSE=docker-compose
ifeq (, $(shell which docker-compose))
	DOCKER_COMPOSE=docker compose
endif

ifeq (amd64, $(filter amd64,$(ARGS)))
	amd64=-amd64
	amd64_OPTION=amd64
endif
ifeq (no-secty, $(filter no-secty,$(ARGS)))
	NO_SECURITY:=-no-secty
endif
ifeq (app-sample, $(filter app-sample,$(ARGS)))
	APP_SAMPLE:=-with-app-sample
endif

SERVICES:=$(filter-out $(OPTIONS),$(ARGS))

define COMPOSE_DOWN
	${DOCKER_COMPOSE} -p edgex -f docker-compose.yml -f docker-compose-with-app-sample.yml down $1
endef

# Define additional phony targets for all options to enable support for tab-completion in shell
# Note: This must be defined after the options are parsed otherwise it will interfere with them
.PHONY: $(OPTIONS)

portainer:
	${DOCKER_COMPOSE} -p portainer -f docker-compose-portainer.yml up -d

portainer-down:
	${DOCKER_COMPOSE} -p portainer -f docker-compose-portainer.yml down

pull:
	docker  -f docker-compose${NO_SECURITY}${amd64}.yml pull ${SERVICES}

run:
	docker compose -p edgex -f docker-compose.yml up -d 

down:
	docker compose -p edgex -f docker-compose.yml down -v --remove-orphans

clean:
	docker compose -p edgex -f docker-compose.yml down -v --remove-orphans -v

get-token:
	DEV=$(DEV) \
	ARCH=$(ARCH) \
	cd ./compose-builder; sh get-api-gateway-token.sh

get-consul-acl-token:
	DEV=$(DEV) \
	ARCH=$(ARCH) \
	cd ./compose-builder; sh ./get-consul-acl-token.sh
