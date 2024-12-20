#!/bin/bash

# https://github.com/pi-hole/docker-pi-hole/blob/master/README.md
set -x 

PIHOLE_BASE="${PIHOLE_BASE:-$(pwd)}"
[[ -d "$PIHOLE_BASE" ]] || mkdir -p "$PIHOLE_BASE" || { echo "Couldn't create storage directory: $PIHOLE_BASE"; exit 1; }

# Note: FTLCONF_LOCAL_IPV4 should be replaced with your external ip.
sudo docker run -d \
    --name pihole \
    -p 53:53/tcp -p 53:53/udp \
    -p 80:80 \
    -e TZ="Berlin/Europe" \
    -v "${PIHOLE_BASE}/etc-pihole:/etc/pihole" \
    -v "${PIHOLE_BASE}/etc-dnsmasq.d:/etc/dnsmasq.d" \
    --dns=127.0.0.1 --dns=1.1.1.1 \    --restart=unless-stopped \
    --hostname pi.hole \
    -e VIRTUAL_HOST="pi.hole" \
    -e PROXY_LOCATION="pi.hole" \
    -e WEBPASSWORD="Cobra112!"\
    -e FTLCONF_LOCAL_IPV4="127.0.0.1" \
    -e REV_SERVER="true"\
    -e REV_SERVER_DOMAIN="fritz.box"\
    -e REV_SERVER_TARGET="192.168.178.1"\
    -e REV_SERVER_CIDR="192.168.178.0/24"\
    pihole/pihole:latest
