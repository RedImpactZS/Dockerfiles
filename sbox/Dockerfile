# ---------------------------------------
# Yolk for S&box based on generic wine 10 image
# ---------------------------------------
FROM        ghcr.io/parkervcp/yolks:wine_10

# Set the locale
RUN         sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV         LANG="en_US.UTF-8"
ENV         LANGUAGE="en_US:en"
ENV         LC_ALL="en_US.UTF-8"

# S&box specific
ENV         WINEDLLOVERRIDES="mscoree=n"
ENV         WINDOWS_INSTALL="1"
ENV         SRCDS_APPID="1892930"
ENV         WINETRICKS_INSTALL="dotnet9 dotnet48"

# Setup user and working directory
RUN         useradd -m -d /home/container -s /bin/bash container
USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

STOPSIGNAL  SIGINT

COPY        --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
