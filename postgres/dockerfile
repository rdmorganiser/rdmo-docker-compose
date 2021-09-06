FROM postgres:latest

ENV PATH="${PATH}:/opt"

RUN apt update && apt upgrade -y && apt install -y \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# not necessary, but for sake of clarity
CMD ["postgres"]
