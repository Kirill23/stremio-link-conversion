# Multi-stage build: pull the actual Stremio server.js from the upstream
# Docker Hub image, then place it onto an HA add-on base image so HA
# Supervisor conventions (ports, options, logs) work correctly.
#
# Stremio distributes its server as a single Node.js bundle (server.js)
# downloaded from dl.strem.io. The upstream `stremio/server` image bakes
# in a versioned build of that bundle — taking it from there means we
# inherit Stremio's release cadence without writing our own download
# scripts. The downside is a build-time dependency on Docker Hub; pin
# to a specific tag once one is chosen for v1.
#
# BUILD_FROM must be declared as a global ARG (before any FROM line) so
# that subsequent FROM stages can reference it. Declaring it inline
# between stages does not work with BuildKit — Docker treats the second
# FROM as a new build context that doesn't see ARGs from the previous
# stage. The HA Supervisor passes BUILD_FROM as a --build-arg keyed off
# the target architecture (see build.yaml).

ARG BUILD_FROM

FROM stremio/server:latest AS upstream

FROM ${BUILD_FROM}

# Runtime deps:
#  - nodejs runs the Stremio server bundle
#  - tini reaps zombie processes from the Node.js subprocess
#  - bash + jq are used by run.sh to read add-on options from
#    /data/options.json (we don't use bashio because it requires
#    s6-overlay init, which is off here)
RUN apk add --no-cache nodejs tini bash jq

# Copy the Stremio server bundle from the upstream image. As of
# stremio/server:latest (2026-05-19), the bundle lives at
# /stremio/server.js (the upstream image's WORKDIR is /stremio,
# entrypoint is `node server.js`). The bundle is a self-contained
# ~6.6MB webpack output — no node_modules needed at runtime.
# Note: upstream runs Node 14; we run Node 20 on the HA base. Webpack
# bundles are usually portable across major Node versions but if you
# hit runtime errors, this is the first place to look.
COPY --from=upstream /stremio/server.js /opt/stremio-server/server.js

# Cache and config dirs (mapped to /share by config.yaml's map: share:rw)
RUN mkdir -p /share/stremio-server-cache

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/run.sh"]
