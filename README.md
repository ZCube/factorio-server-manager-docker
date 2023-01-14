# factorio-server-manager-docker

* https://github.com/OpenFactorioServerManager/factorio-server-manager builder

# Usage

docker-compose.yaml 
```
version: '3.5'

services:
  factorio:
    image: ghcr.io/zcube/factorio-docker-ssh:1.1.74
    restart: unless-stopped
    environment:
      - TZ=UTC
    ports:
     - "34197:34197/udp"
     - "27015:27015/tcp"
    volumes:
     - /etc/localtime:/etc/localtime:ro
     - factorio:/factorio
  fsm:
    image: ghcr.io/zcube/factorio-server-manager-docker:latest
    restart: unless-stopped
    environment:
      - TZ=UTC
      - FSM_DIR=/factorio
      - FSM_FACTORIO_IP=factorio
      - FSM_RCON_PORT=27015
      - SSH_HOST=factorio
      - SSH_PORT=2222
    ports:
     - "80:80/tcp"
    volumes:
     - /etc/localtime:/etc/localtime:ro
     - factorio:/factorio

volumes:
  factorio:
```