FROM debian:latest

ARG UID GID
ENV USER=rdmo
ENV HOME="/home/rdmo"
ENV PATH="${PATH}:${HOME}/.local/bin:${HOME}/sh"
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt update -y && apt upgrade -y && apt install -y \
  python3 python3-dev python3-pip locales
RUN rm "$(find /usr/lib -type f -regex ".*python.*EXTERNALLY-MANAGED.*")"
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN python3 -m pip install --upgrade pip

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && \
  update-locale LANG=en_US.UTF-8

RUN apt update -y && apt install -y curl git micro procps vim
RUN apt update -y && apt install -y pandoc texlive-xetex
RUN rm -rf /var/lib/apt/lists/*

COPY ./rootfs /
RUN chmod -R 777 /tmp

RUN groupadd -g "${GID}" "${USER}"
RUN useradd -m -u "${UID}" -g "${GID}" -s /bin/bash "${USER}"

RUN curl --output ${HOME}/.bashrc \
  https://raw.githubusercontent.com/triole/ghwfe/master/bashrc/default.sh

RUN cat ${HOME}/tpl/add_to_bashrc >> ~/.bashrc
RUN chown -R "${USER}:${USER}" "${HOME}"

USER "${USER}"
RUN  python3 -m pip install rdmo[allauth,postgres,gunicorn]

CMD ["/drun.sh"]
