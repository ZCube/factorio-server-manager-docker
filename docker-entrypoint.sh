#!/bin/bash
until [ -f /factorio/config/rconpw ]
do
     sleep 5
done

if [ -f /factorio/conf.json ]; then
    jq -M --rawfile rconpw /factorio/config/rconpw '.rcon_pass=($rconpw|gsub("[\\n\\t]"; ""))' \
    /factorio/conf.json > /tmp/conf.json && mv /tmp/conf.json /factorio/conf.json
else
    jq -M --rawfile rconpw /factorio/config/rconpw '.rcon_pass=($rconpw|gsub("[\\n\\t]"; ""))' \
    /conf.json > /tmp/conf.json && mv /tmp/conf.json /factorio/conf.json
fi


cd /factorio
if [[ $(id -u) = 0 ]]; then
  usermod -o -u "$PUID" factorio
  groupmod -o -g "$PGID" factorio
  SU_EXEC="gosu factorio"
else
  SU_EXEC=""
fi
ln -sf /app /factorio/app
exec $SU_EXEC /factorio-server-manager
