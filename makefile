CURDIR=$(shell pwd)
VOLDIR=$(CURDIR)/vol
DC_MASTER="dc_master.yaml"
DC_TEMP="docker-compose.yaml"
VARS_ENV=$(shell if [ -f variables.local ]; then echo variables.local; else echo variables.env; fi)
GLOBAL_PREFIX=$(shell cat ${CURDIR}/${VARS_ENV} | grep -Po "(?<=GLOBAL_PREFIX=).*")
FINALLY_EXPOSED_PORT=$(shell cat ${CURDIR}/${VARS_ENV} | grep -Po "(?<=FINALLY_EXPOSED_PORT=)[.:0-9]+")
RESTART_POLICY=$(shell cat ${CURDIR}/${VARS_ENV} | grep -Po "(?<=RESTART_POLICY=).*")
DOCKER_IN_GROUPS=$(shell groups | grep "docker")
MYID=$(shell id -u)


ifeq ($(strip $(DOCKER_IN_GROUPS)),)
	DC_CMD=sudo docker-compose
else
	DC_CMD=docker-compose
endif


all: root_check preparations run_pull run_build tail_logs
preps: root_check preparations
build: root_check preparations run_pull run_build
restart: run_restart
fromscratch: root_check preparations run_remove run_pull run_build
remove: root_check run_remove


root_check:
	@if [ "${MYID}" = "0" ]; then \
		echo Please do not run as root. It is neither recommended nor would it work.; \
	fi
	@exit

preparations:
	mkdir -p ${VOLDIR}/log
	mkdir -p ${VOLDIR}/postgres
	mkdir -p ${VOLDIR}/rdmo-app
	mkdir -p ${VOLDIR}/ve
	cat ${DC_MASTER} \
		| sed 's|<HOME>|${HOME}|g' \
		| sed 's|<CURDIR>|${CURDIR}|g' \
		| sed 's|<VOLDIR>|${VOLDIR}|g' \
		| sed 's|<GLOBAL_PREFIX>|${GLOBAL_PREFIX}|g' \
		| sed 's|<FINALLY_EXPOSED_PORT>|${FINALLY_EXPOSED_PORT}|g' \
		| sed 's|<RESTART_POLICY>|${RESTART_POLICY}|g' \
		| sed 's|<VARIABLES_FILE>|${VARS_ENV}|g' \
		> ${DC_TEMP}

	cat nginx/dockerfile_master \
		| sed 's|<UID>|$(MYID)|g' \
		> nginx/Dockerfile

	cat rdmo/dockerfile_master \
    	| sed 's|<UID>|$(MYID)|g' \
    	> rdmo/Dockerfile

run_pull:
	$(DC_CMD) pull

run_build:
	$(DC_CMD) up --build -d

run_remove:
	$(DC_CMD) down --rmi all
	$(DC_CMD) rm --force

run_restart:
	$(DC_CMD) restart

tail_logs:
	$(DC_CMD) logs -f
