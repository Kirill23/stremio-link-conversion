ARG BUILD_FROM
FROM ${BUILD_FROM}

# Install Node.js (Alpine-based HA add-on bases)
RUN apk add --no-cache nodejs npm tini

# Install stremio-server from npm (official package by Stremio)
RUN npm install --global --production stremio-server

# Cache and config dirs (mapped to /share by config.yaml's map: share:rw)
RUN mkdir -p /share/stremio-server-cache

COPY run.sh /run.sh
RUN chmod +x /run.sh

# tini reaps zombie processes correctly when stremio-server crashes mid-stream
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/run.sh"]
