FROM debian:11

ENV USER=rdmo
ENV HOME="/home/rdmo"

ARG UID
ARG GID
ARG RDMO_INSTALL_URL

ENV PATH=${PATH}:${HOME}/.local/bin:${HOME}/sh

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt update && apt upgrade -y && apt install -y \
        python3 python3-dev python3-pip locales \
 && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN pip3 install --upgrade pip wheel setuptools

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

# build dependencies
RUN apt update && apt install -y \
        build-essential \
        curl \
        git \
        libxml2-dev \
        libxslt-dev \
        zlib1g-dev \
        procps \
        vim \
 && rm -rf /var/lib/apt/lists/*

# postgres
RUN apt update && apt install -y \
        libpq-dev \
        postgresql \
        postgresql-client \
 && rm -rf /var/lib/apt/lists/*

RUN pip3 install psycopg2

# for document export
RUN apt update && apt install -y \
        pandoc \
        texlive-xetex \
 && rm -rf /var/lib/apt/lists/*

COPY ./rootfs /
RUN chmod -R 777 /tmp

RUN groupadd -g "${GID}" "${USER}" \
 && useradd -m -u ${UID} -g ${GID} -s /bin/bash "${USER}"
RUN chown -R "${USER}:${USER}" "${HOME}"

USER "${USER}"

RUN if [ -n "${RDMO_INSTALL_URL}" ]; then \
        pip install "${RDMO_INSTALL_URL}"; else pip install rdmo; fi

CMD ["/drun.sh"]
