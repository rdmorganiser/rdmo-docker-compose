FROM postgres:latest

ENV PATH="${PATH}:/opt"

ARG UID

RUN apt update && apt upgrade -y && apt install -y \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

RUN chown -R ${UID} /var/lib/postgresql

USER ${UID}
CMD ["postgres"]
