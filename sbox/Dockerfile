# ---------------------------------------
# Yolk for S&box based on generic wine 10 image
# ---------------------------------------
FROM        ghcr.io/parkervcp/yolks:wine_10

# S&box specific
ENV         WINEDLLOVERRIDES="mscoree=n"
ENV         WINDOWS_INSTALL="1"
ENV         SRCDS_APPID="1892930"
ENV         WINETRICKS_INSTALL="dotnet10 dotnet48"

# Install git
RUN             apt update && apt install --install-recommends git git-lfs -y

# Install forked winetricks
RUN         wget -q -O /usr/sbin/winetricks https://raw.githubusercontent.com/deinferno/winetricks/master/src/winetricks \
            && chmod +x /usr/sbin/winetricks

COPY        --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh
ENTRYPOINT  ["/usr/bin/tini", "-g", "--"]
CMD         ["/entrypoint.sh"]
