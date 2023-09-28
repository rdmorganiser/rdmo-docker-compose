DOCKER_COMPOSE_COMMAND=$(shell sh/prepare.sh)
DOCKER_IN_GROUPS=$(shell groups | grep "docker")
LOCAL_UID=$(shell id -u)

all: root_check run_pull run_build logs
build: root_check run_pull run_build
restart: run_restart
fromscratch: root_check run_remove run_pull run_build
remove: root_check run_remove

root_check:
	@if [ "${LOCAL_UID}" = "0" ]; then \
		echo Please do not run as root. It is neither recommended nor would it work.; \
	fi
	@exit

prep:
	sh/prepare.sh

run_pull:
	$(DOCKER_COMPOSE_COMMAND) pull

run_build:
	${DOCKER_COMPOSE_COMMAND} up --build -d

run_remove:
	$(DOCKER_COMPOSE_COMMAND) down --rmi all
	$(DOCKER_COMPOSE_COMMAND) rm --force

run_restart:
	$(DOCKER_COMPOSE_COMMAND) restart

logs:
	$(DOCKER_COMPOSE_COMMAND) logs -f
