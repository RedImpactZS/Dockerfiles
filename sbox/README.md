# To run this container with docker run
docker run --rm -it -v sbox-server-data-volume:/home/container ghcr.io/redimpactzs/sbox:latest /entrypoint.sh wine ./sbox-server.exe +game facepunch.walker garry.scenemap +hostname My Dedicated Server

# To run this container in pterodactyl
Create your own egg and use this image as yolk it should be compatible with Pterodactyl if STARTUP env var specified
