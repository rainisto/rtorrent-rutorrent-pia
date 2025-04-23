#!/bin/bash
. .env
chmod a+x ./scripts/update-port.sh
mkdir -p passwd
docker run --rm -it httpd:2.4-alpine htpasswd -Bbn ${RU_USERNAME:-admin} ${RU_PASSWORD:-salasana} > ./passwd/rpc.htpasswd
docker run --rm -it httpd:2.4-alpine htpasswd -Bbn ${RU_USERNAME:-admin} ${RU_PASSWORD:-salasana} > ./passwd/rutorrent.htpasswd

docker-compose up -d
