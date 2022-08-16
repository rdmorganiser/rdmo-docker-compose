FROM alpine:latest

ENV USER="caddy"
ENV HOME="/home/caddy"

ENV PATH=${PATH}:${HOME}/bin:${HOME}/sh

ARG UID
ARG GID

RUN apk --update add \
    bash \
    curl \
    grep

COPY ./rootfs /

RUN addgroup -g "${GID}" -S "${USER}" \
 && adduser -s "/bin/bash" -h "${HOME}" -u "${UID}" -S "${USER}"

RUN chown -R ${UID}.${GID} ${HOME}
RUN chmod -R 777 /tmp

USER ${USER}
RUN ${HOME}/sh/install-from-github.sh \
    "caddyserver/caddy/releases/latest" \
    "(?<=href\=\").*_linux_amd64.tar.gz" \
    "${HOME}/bin"

WORKDIR ${HOME}/conf
CMD ["caddy", "run", "--watch"]
