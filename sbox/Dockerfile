# ---------------------------------------
# Yolk for S&box based on generic wine 10 image
# ---------------------------------------
FROM        ghcr.io/parkervcp/yolks:wine_10

# S&box specific
ENV         WINEDLLOVERRIDES="mscoree=n"
ENV         WINDOWS_INSTALL="1"
ENV         SRCDS_APPID="1892930"
ENV         WINETRICKS_INSTALL="dotnet9 dotnet48"

COPY        --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh
ENTRYPOINT  ["/usr/bin/tini", "-g", "--"]
CMD         ["/entrypoint.sh"]
