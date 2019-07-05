CURDIR=$(shell pwd)
DC_MASTER="dc_master.yaml"
DC_TEMP="docker-compose.yaml"
VARS_ENV=$(shell if [ -f variables.local ]; then echo variables.local; else echo variables.env; fi)
GLOBAL_PREFIX=$(shell cat ${CURDIR}/${VARS_ENV} | grep -Po "(?<=GLOBAL_PREFIX=).*")
FINALLY_EXPOSED_PORT=$(shell cat ${CURDIR}/${VARS_ENV} | grep -Po "(?<=FINALLY_EXPOSED_PORT=)[0-9]+")
DOCKER_IN_GROUPS=$(shell groups | grep "docker")
MYID=$(shell id -u)

ifeq ($(strip $(DOCKER_IN_GROUPS)),)
SUDO_CMD=sudo 
else
SUDO_CMD=
endif

all: preparations run_build tail_logs
preps: preparations
build: preparations run_build
fromscratch: preparations run_remove run_build
remove: run_remove

preparations:
	mkdir -p ${CURDIR}/vol/log
	mkdir -p ${CURDIR}/vol/postgres
	mkdir -p ${CURDIR}/vol/rdmo-app
	mkdir -p ${CURDIR}/vol/ve
	cat ${DC_MASTER} \
		| sed 's|<HOME>|${HOME}|g' \
		| sed 's|<CURDIR>|${CURDIR}|g' \
		| sed 's|<GLOBAL_PREFIX>|${GLOBAL_PREFIX}|g' \
		| sed 's|<FINALLY_EXPOSED_PORT>|${FINALLY_EXPOSED_PORT}|g' \
		| sed 's|<VARIABLES_FILE>|${VARS_ENV}|g' \
		> ${DC_TEMP}
		
	cat rdmo/dockerfile_master \
    	| sed 's|<UID>|$(MYID)|g' \
    	> rdmo/dockerfile
 
	cat apache/dockerfile_master \
    	| sed 's|<UID>|$(MYID)|g' \
    	> apache/dockerfile

run_build:
	$(SUDO_CMD)docker-compose up --build -d

run_remove:
	$(SUDO_CMD)docker-compose down --rmi all
	$(SUDO_CMD)docker-compose rm --force

tail_logs:
	$(SUDO_CMD)docker-compose logs -f