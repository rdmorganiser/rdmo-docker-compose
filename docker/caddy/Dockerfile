FROM alpine:latest

ENV USER="caddy"
ENV HOME="/home/caddy"

ENV PATH=${PATH}:${HOME}/bin:${HOME}/sh

ARG UID
ARG GID

RUN apk --update add \
    bash \
    curl \
    grep \
    vim

RUN mkdir -p ${HOME}
RUN curl --output ${HOME}/.bashrc \
    https://raw.githubusercontent.com/triole/ghwfe/master/bashrc/default.sh
COPY ./Caddyfile ${HOME}/Caddyfile

RUN if ! grep -q ":${GID}:" /etc/group; then
    addgroup -g "${GID}" -S "${USER}"; fi \
 && adduser -s "/bin/bash" -h "${HOME}" -u "${UID}" -S "${USER}"

RUN chown -R ${UID}.${GID} ${HOME}
RUN chmod -R 777 /tmp

USER ${USER}

RUN mkdir ${HOME}/sh
RUN curl --output ${HOME}/sh/install_from_github.sh \
    https://raw.githubusercontent.com/triole/ghwfe/master/sh/install_from_github.sh
RUN chmod +x ${HOME}/sh/install_from_github.sh
RUN ${HOME}/sh/install_from_github.sh \
    "caddyserver/caddy" "_linux_amd64.tar.gz" "${HOME}/bin"

WORKDIR ${HOME}
CMD ["caddy", "run", "--watch"]
