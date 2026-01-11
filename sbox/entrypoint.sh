#!/bin/bash -e

#
# Copyright (c) 2021 Matthew Penner
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

# Switch to the container's working directory
cd /home/container || exit 1

# Download steamcmd
if [ ! -f "${HOME}/steamcmd/steamcmd.sh" ]; then
    curl "http://media.steampowered.com/installer/steamcmd_linux.tar.gz" --output "steamcmd.tar.gz" --silent
    mkdir -p "steamcmd"
    tar -xzf "steamcmd.tar.gz" -C "steamcmd"
    rm "steamcmd.tar.gz"
fi

## just in case someone removed the defaults.
if [ "${STEAM_USER}" == "" ]; then
    echo -e "steam user is not set.\n"
    echo -e "Using anonymous user.\n"
    STEAM_USER=anonymous
    STEAM_PASS=""
    STEAM_AUTH=""
else
    echo -e "user set to ${STEAM_USER}"
fi

## if auto_update is not set or to 1 update
if [ -z ${AUTO_UPDATE} ] || [ "${AUTO_UPDATE}" == "1" ]; then 
    # Update Source Server
    if [ ! -z ${SRCDS_APPID} ]; then
	    ./steamcmd/steamcmd.sh +force_install_dir /home/container +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH} $( [[ "${WINDOWS_INSTALL}" == "1" ]] && printf %s '+@sSteamCmdForcePlatformType windows' ) +app_update 1007 +app_update ${SRCDS_APPID} $( [[ -z ${SRCDS_BETAID} ]] || printf %s "-beta ${SRCDS_BETAID}" ) $( [[ -z ${SRCDS_BETAPASS} ]] || printf %s "-betapassword ${SRCDS_BETAPASS}" ) $( [[ -z ${HLDS_GAME} ]] || printf %s "+app_set_config 90 mod ${HLDS_GAME}" ) $( [[ -z ${VALIDATE} ]] || printf %s "validate" ) +quit
    else
        echo -e "No appid set. Starting Server"
    fi
else
    echo -e "Not updating game server as auto update was set to 0. Starting Server"
fi

# Alias steamcmd's steamclient.so for native steam networking to work
mkdir -p "${HOME}/.steam"
ln -s "${HOME}/steamcmd/linux32" "${HOME}/.steam/sdk32" &> /dev/null || true
ln -s "${HOME}/steamcmd/linux64" "${HOME}/.steam/sdk64" &> /dev/null || true
ln -s "${HOME}/.steam/sdk32/steamclient.so" "${HOME}/.steam/sdk32/steamservice.so" &> /dev/null || true
ln -s "${HOME}/.steam/sdk64/steamclient.so" "${HOME}/.steam/sdk64/steamservice.so" &> /dev/null || true

[ "${XVFB}" -eq "1" ] && Xvfb "${DISPLAY}" &

if [ ! -d "${WINEPREFIX}" ]; then
    echo "Installing ${WINETRICKS_INSTALL}, delete ${WINEPREFIX} to trigger this process again"
    for i in $WINETRICKS_INSTALL; do
        winetricks -q $i
    done
fi

# Pterodactyl/Pelican run
if [ -n "${STARTUP}" ]; then
    # Default the TZ environment variable to UTC.
    export TZ="${TZ:-UTC}"

    # Set environment variable that holds the Internal Docker IP
    export INTERNAL_IP="$(ip route get 1 | awk '{print $(NF-2);exit}')"

    # Replace Startup Variables
    MODIFIED_STARTUP="$(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')"
    echo -e ":/home/container$ ${MODIFIED_STARTUP}"

    # Run the Server
    eval ${MODIFIED_STARTUP}

# Basic run
else
    eval $@
fi
