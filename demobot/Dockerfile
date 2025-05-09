# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Source Engine
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM        ubuntu:22.04

LABEL       author="Pterodactyl Software" maintainer="support@pterodactyl.io"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
 && echo steam steam/license note '' | debconf-set-selections

ENV         DEBIAN_FRONTEND noninteractive
# Install Dependencies
RUN         dpkg --add-architecture i386 \
            && apt-get update \
            && apt-get upgrade -y \
            && apt-get install -y steamcmd bubblewrap ca-certificates python3-apt xterm x11vnc xz-utils zenity wget dbus-x11 locales tar curl gcc g++ lib32gcc-s1 libgcc1 libcurl4-gnutls-dev:i386 libssl3:i386 libcurl4:i386 libtinfo5 libtinfo5:i386 lib32z1 lib32stdc++6 libncurses5:i386 libcurl3-gnutls:i386 iproute2 gdb libsdl1.2debian libfontconfig telnet net-tools netcat-traditional xvfb psmisc zip unzip \
            && useradd -m -G video -d /home/container container

RUN dpkg-statoverride --update --add root root 0755 /usr/bin/bwrap

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

ENV	    DISPLAY :99

# https://github.com/ValveSoftware/steam-for-linux#getting-started
# http://media.steampowered.com/client/installer/steam.deb redirects to https://repo.steampowered.com/steam/archive/precise/steam_latest.deb
# https://repo.steampowered.com/steam/archive/precise/?C=M&O=D
# https://repo.steampowered.com/steam/archive/precise/?C=N&O=D
# "steam_latest.deb" is a symlink to "steam-launcher_X.X.X.X_all.deb"
# https://repo.steampowered.com/steam/dists/precise/steam/binary-amd64/Packages (current version, current SHA256)
ENV STEAM_VERSION 1.0.0.81
ENV STEAM_SHA256 afd2b922f9771a9ca7ee0cb416bdd4fceabf3e75a2c5b65f654a10419762960d
RUN set -eux; \
	wget -O steam.deb "https://repo.steampowered.com/steam/archive/stable/steam-launcher_${STEAM_VERSION}_all.deb"; \
	echo "$STEAM_SHA256 *steam.deb" | sha256sum --strict --check -; \
	apt-get update; \
	apt-get install -y ./steam.deb; \
	rm -rf steam.deb /var/lib/apt/lists/*

RUN set -eux; \
	dpkg --add-architecture i386; \
	apt-get update; \
	apt-get install -y \
# let's head off a few of the things steam will want to install immediately
		libgl1-mesa-dri:i386 \
		libgl1-mesa-glx:i386 \
		libc6:i386 \
# installing libfontconfig1 from Ubuntu stops some runtime-related fontconfig errors/warnings (https://github.com/ValveSoftware/steam-for-linux/issues/3307#issuecomment-506650268)
		libfontconfig1:i386 \
                libxtst6:i386 \
		libxrandr2:i386 \
                libxi6:i386 \
		libglib2.0-0:i386 \
                libgtk2.0-0:i386 \
		libpipewire-0.3-0:i386 \
                libpulse0:i386 \
		libgdk-pixbuf2.0-0:i386 \
                libxcb-res0:i386 \
		libva2:i386 \
                libvdpau1:i386 \
		libbz2-1.0:i386 \
	; \
	rm -rf /var/lib/apt/lists/*

USER        container
ENV         HOME /home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
