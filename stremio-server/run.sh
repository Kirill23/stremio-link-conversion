#!/usr/bin/with-contenv bashio

# Read options from the add-on's UI
CACHE_SIZE_GB=$(bashio::config 'cache_size_gb')
LOG_LEVEL=$(bashio::config 'log_level')

bashio::log.info "Starting stremio-server"
bashio::log.info "  cache size:  ${CACHE_SIZE_GB} GB"
bashio::log.info "  log level:   ${LOG_LEVEL}"
bashio::log.info "  cache dir:   /share/stremio-server-cache"
bashio::log.info "  listen port: 11470 (mapped by HA Supervisor)"

# Environment variables stremio-server respects
export APP_PATH=/share/stremio-server-cache
export NO_CORS=1
export CACHE_SIZE_BYTES=$((CACHE_SIZE_GB * 1024 * 1024 * 1024))

# Stremio's server is a single Node.js bundle pulled in at build time
# from the upstream stremio/server Docker image (see Dockerfile).
exec node /opt/stremio-server/server.js
