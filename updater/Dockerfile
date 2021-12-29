# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: glibc
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM        node:8-alpine

LABEL       author="Michael Parker" maintainer="parker@pterodactyl.io"

COPY        ./luamin /usr/local/lib/node_modules/luamin
RUN         ln -s /usr/local/lib/node_modules/luamin/bin/luamin /usr/local/bin/luamin

RUN         apk add --no-cache --update parallel dos2unix git rsync libc6-compat bash \
            && adduser -D -h /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
