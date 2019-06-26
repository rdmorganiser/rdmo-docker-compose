CURDIR=$(shell pwd)
DC_MASTER="dc_master.yaml"
DC_TEMP="docker-compose.yaml"
VARS_ENV=$(shell if [ -f variables.local ]; then echo variables.local; else echo variables.env; fi)
GLOBAL_PREFIX=$(shell cat ${CURDIR}/${VARS_ENV} | grep -Po "(?<=GLOBAL_PREFIX=).*")
FINALLY_EXPOSED_PORT=$(shell cat ${CURDIR}/${VARS_ENV} | grep -Po "(?<=FINALLY_EXPOSED_PORT=)[0-9]+")

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

run_build:
	sudo docker-compose up --build -d

run_remove:
	sudo docker-compose down --rmi all
	sudo docker-compose rm --force

tail_logs:
	sudo docker-compose logs -f
