#!/bin/bash
. .env
chmod a+x ./scripts/update-port.sh
mkdir -p passwd
docker run --rm -it httpd:2.4-alpine htpasswd -Bbn ${RU_USERNAME:-admin} ${RU_PASSWORD:-salasana} > ./passwd/rpc.htpasswd
docker run --rm -it httpd:2.4-alpine htpasswd -Bbn ${RU_USERNAME:-admin} ${RU_PASSWORD:-salasana} > ./passwd/rutorrent.htpasswd

docker-compose up -d

# Install inotify-tools on host (if needed)
if ! command -v inotifywait >/dev/null; then
  echo "Installing inotify-tools..."
  sudo apt-get update && sudo apt-get install -y inotify-tools || \
  sudo yum install -y inotify-tools || \
  sudo apk add --no-cache inotify-tools
fi

while true; do
  if [ ! -f "./gluetun/forwarded_port" ]; then
    echo "Waiting for forwarded_port file..."
    sleep 2
  else
     break
  fi
done

# run once at start
docker exec -it rtorrent-rutorrent /scripts/update-port.sh
# run again if port changes
while true; do
  inotifywait -q -e modify ./gluetun/forwarded_port
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] Port changed - updating rTorrent"
  docker exec -it rtorrent-rutorrent /scripts/update-port.sh
done



