# RDMO Docker Compose

## Synopsis
This repository contains RDMO docker images that are held together by [docker compose](https://github.com/docker/compose/releases) which obviously is required to make use of the file.

## Structure
### Dockers
Three containers are going to be created running `Apache`, `PostgreSQL` and `RDMO`.

### Volumes
During build three folders used as volumes are going to be created. They will be stored under `vol/` and contain the following.

1. `log` log files
1. `rdmo-app` installation
1. `ve` python's virtual environment

## Usage
1. Make your changes in the `variables.env`

1. Build by running `make`

1. Create a user
Note that we decided not to automatically create a new admin user account for the freshly created RDMO instance. You may want to do this manually.

    ```shell
    # connect to the docker
    docker exec -ti rdc-rdmo bash

    # do either
    python manage.py createsuperuser
    # or
    python manage.py create_admin_user
    ```
