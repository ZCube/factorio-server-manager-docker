# syntax=docker/dockerfile:1.4
FROM golang:1.19-bullseye AS backend

WORKDIR /app

# COPY src/go.mod .

# RUN go mod download

# COPY src/ .

# RUN CGO_ENABLED=1 go build -o factorio-server-manager .

RUN git clone https://github.com/OpenFactorioServerManager/factorio-server-manager .

COPY src/ ./src/

RUN cd src && go mod download

RUN cd src && CGO_ENABLED=1 go build -o ../factorio-server-manager .

FROM node:16 AS frontend

WORKDIR /app

# COPY package.json package-lock.json /app/

# RUN npm install

# COPY *.js .
# COPY ui/ ui/

# RUN npm run build

RUN git clone https://github.com/OpenFactorioServerManager/factorio-server-manager .

RUN npm install

RUN npm run build

FROM debian:bullseye-slim

ARG USER=factorio
ARG GROUP=factorio
ARG PUID=845
ARG PGID=845

ENV PUID="$PUID" \
    PGID="$PGID"

RUN apt-get update && apt-get install -y curl tar xz-utils unzip jq ssh sshpass gosu && rm -rf /var/lib/apt/lists/*

COPY --from=backend /app/factorio-server-manager /factorio-server-manager
COPY --from=frontend /app/app/ /app/
# COPY app/index.html app/
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY conf.json.docker conf.json

RUN chmod +x /*.sh \
 && addgroup --gid "$PGID" "$GROUP" --shell /bin/sh 
RUN  adduser  --disabled-password --uid "$PUID" "$USER" --gid "$PGID" --gecos "" --shell /bin/sh \
 && mkdir -p /factorio \
 && chown -R "$USER":"$GROUP" /factorio

EXPOSE 80/tcp 34197/udp

ENV FSM_DIR=/factorio

WORKDIR /factorio

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD []