FROM postgres:${POSTGRES_VERSION}

ARG UID GID
ENV PATH="${PATH}:/opt:${HOME}/sh"

RUN apt update && apt upgrade -y && apt install -y postgresql-client vim
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p "${HOME}/sh"
COPY ./sh/* ${HOME}/sh/

RUN sed -i -r "s/postgres:x:([0-9]+):([0-9]+)/postgres:x:${UID}:${GID}/g" /etc/passwd
RUN sed -i -r "s/postgres:x:([0-9]+)/postgres:x:${GID}/g" /etc/group

RUN chown -R ${UID}:${GID} /var/lib/postgresql
RUN mkdir -p /var/run/postgresql
RUN chown -R ${UID}:${GID} /var/run/postgresql

USER ${UID}
CMD ["postgres"]
