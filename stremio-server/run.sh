#!/bin/bash
# Plain bash entrypoint. Avoids `with-contenv bashio` (which requires
# s6-overlay's /run/s6/container_environment to exist). Supervisor
# launches us with `init: false`, so s6 isn't initialized — bashio
# would fail on startup with:
#   s6-envdir: fatal: unable to envdir /run/s6/container_environment
# Read add-on options directly from /data/options.json via jq.
set -euo pipefail

OPTIONS_PATH=/data/options.json
CACHE_SIZE_GB=$(jq -r '.cache_size_gb // 4' "${OPTIONS_PATH}")
LOG_LEVEL=$(jq -r '.log_level // "info"' "${OPTIONS_PATH}")

echo "[INFO] Starting stremio-server"
echo "[INFO]   cache size:  ${CACHE_SIZE_GB} GB"
echo "[INFO]   log level:   ${LOG_LEVEL}"
echo "[INFO]   cache dir:   /share/stremio-server-cache"
echo "[INFO]   listen port: 11470 (mapped by HA Supervisor)"

# Environment variables stremio-server respects
export APP_PATH=/share/stremio-server-cache
export NO_CORS=1
export CACHE_SIZE_BYTES=$((CACHE_SIZE_GB * 1024 * 1024 * 1024))

# Stremio's server is a single Node.js bundle pulled in at build time
# from the upstream stremio/server Docker image (see Dockerfile).
exec node /opt/stremio-server/server.js
