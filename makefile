CURDIR=$(shell pwd)
DC_MASTER="dc_master.yaml"
DC_TEMP="docker-compose.yaml"
FINALLY_EXPOSED_PORT=$(shell cat variables.env | grep -Po "(?<=FINALLY_EXPOSED_PORT=)[0-9]+")

all: preparations run_build tail_logs
build: preparations run_build
fromscratch: preparations run_remove run_build
remove: run_remove

preparations:
	mkdir -p ${CURDIR}/vol/log
	mkdir -p ${CURDIR}/vol/rdmo-app
	mkdir -p ${CURDIR}/vol/ve
	cat ${DC_MASTER} \
		| sed 's|<HOME>|${HOME}|g' \
		| sed 's|<CURDIR>|${CURDIR}|g' \
		| sed 's|<FINALLY_EXPOSED_PORT>|${FINALLY_EXPOSED_PORT}|g' \
		> ${DC_TEMP}

run_build:
	sudo docker-compose up --build -d

run_remove:
	sudo docker-compose down --rmi all
	sudo docker-compose rm --force

tail_logs:
	sudo docker-compose logs -f
