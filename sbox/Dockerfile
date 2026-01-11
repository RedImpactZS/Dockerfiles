# ---------------------------------------------
# Steam Proton image based on https://raw.githubusercontent.com/pelican-eggs/yolks/refs/heads/master/steamcmd/proton/Dockerfile by Torsten Widmann (info@goover.de)
# ---------------------------------------------
FROM        debian:trixie-slim

# Install required packages
RUN         dpkg --add-architecture i386 && apt update && \
            apt install -y --no-install-recommends \
                curl \
                ca-certificates \
                iproute2 \
                xvfb \
                dbus \
                tini \
                lib32gcc-s1 \
                libfreetype6 \
                libfreetype6:i386 \
                libgnutls30 \
                libgnutls30:i386 \
                winbind \
                libgl1 \
                libgl1:i386 \
            && rm -rf "/var/lib/apt/lists/*"

# Download Proton GE
RUN         curl -LJsO "$(curl -s "https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest" | grep browser_download_url | cut -d\" -f4 | egrep .tar.gz)" \
            && tar -xzf GE-Proton*.tar.gz -C "/usr/local/" --strip-components=2 \
            && rm GE-Proton*.*

# Proton Fix machine-id
RUN         rm -f /etc/machine-id \
            && dbus-uuidgen --ensure=/etc/machine-id \
            && rm /var/lib/dbus/machine-id \
            && dbus-uuidgen --ensure

# Set up Winetricks
RUN	    curl -LJso "/usr/local/bin/winetricks" "https://raw.githubusercontent.com/deinferno/winetricks/master/src/winetricks" \
            && chmod +x "/usr/local/bin/winetricks"

# Setup user and working directory
RUN         useradd -m -d "/home/container" -s "/bin/bash" "container"
USER        "container"
ENV         USER="container" HOME="/home/container"
WORKDIR     "/home/container"

# S&box specific
ENV         WINEDEBUG="-all" \
            WINEDLLOVERRIDES="mscoree=n;mshtml=;icu.dll=d" \
            WINEPREFIX="/home/container/.wine" \
            DISPLAY=":0" \
            DISPLAY_WIDTH="1024" \
            DISPLAY_HEIGHT="768" \
            DISPLAY_DEPTH="16" \
            XVFB="1" \
            WINDOWS_INSTALL="1" \
            SRCDS_APPID="1892930" \
            WINETRICKS_INSTALL="dotnet10 dotnet48"

STOPSIGNAL  SIGINT

COPY        --chown=container:container "entrypoint.sh" "/entrypoint.sh"
RUN         chmod +x "/entrypoint.sh"
ENTRYPOINT  ["/usr/bin/tini", "-g", "--"]
CMD         ["/entrypoint.sh"]
