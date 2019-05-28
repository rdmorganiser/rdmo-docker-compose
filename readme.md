[![Build Status](https://travis-ci.org/rdmorganiser/rdmo-docker-compose.svg?branch=master)](https://travis-ci.org/rdmorganiser/rdmo-docker-compose)
# RDMO Docker Compose

## Synopsis
This repository contains RDMO docker images that are held together by [docker compose](https://github.com/docker/compose/releases) which obviously is required to make use of it. If not configured differently the built RDMO instance should be available at `localhost:8484`. Please see below how setting can be changed.


## Structure
### Dockers
Three containers are going to be created running `Apache`, `PostgreSQL` and `RDMO`.

### Volumes
During build four folders later used as volumes will be created under `vol/`. They contain the following:

1. `log` log files
1. `postgres` database
1. `rdmo-app` installation
1. `ve` python's virtual environment

![](./architecture.png)


## Configuration & Usage
1. Declare your settings in `variables.local`

    Default settings are stored in the `variables.env`. You may want to change things to adjust RDMO to your local needs. As `variables.env` is part of the repo and would get overwritten if you pulled again the `makefile` contains a logic that lets you use a file called `variables.local` instead. If such a file exists the settings will be loaded from there. Simply copy `variables.env` to `variables.local` and feel free to change whatever you want.

1. Build by running `make`

1. Maybe create an RDMO user

    Note that we decided not to automatically create any user account for the freshly created RDMO instance. You may want to do this manually.

    ```shell
    # connect to the docker
    docker exec -ti rdc-rdmo bash

    # do either
    python manage.py createsuperuser
    # or
    python manage.py create_admin_user
    ```

1. Import data from rdmo-catalog

    A fresh RDMO installation does not contain any data. You may want to import `conditions`, `domains`, `options`, `questions`, `tasks` and `views`. In the `RDMO container` there is a shell script that automatically clones the [rdmo-catalog repo](https://github.com/rdmorganiser/rdmo-catalog) and imports everything in it. If you consider it being helpful you could do `import-github-catalogues.sh`.

## Multiple RDMO Instances on a Single Docker Host
You can have multiple running RDMO instances on a single docker host as long as you pay attention to three things.

1. Use different folders containing the `rdmo-docker-compose` repo to make sure docker-compose considers your build attempts to be different projects. Unfortunately currently there is no manual configuration for this because the `COMPOSE_PROJECT_NAME` option seems to be broken.
1. Make sure to use different `GLOBAL_PREFIX` settings in your `variables.local` to avoid conflicts between your docker containers and volumes.
1. And obviously change the `FINALLY_EXPOSED_PORT` settings to make sure to use a free port to expose RDMO.
