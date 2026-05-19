# Changelog

## 1.0.3 — 2026-05-19

- **Pre-built multi-arch images on GHCR.** CI now publishes
  `ghcr.io/kirill23/{arch}-addon-stremio-server:<version>` for aarch64,
  amd64, and armv7 on every master push. Supervisor pulls the image
  instead of building locally on the user's device — first install
  drops from 5-10 minutes (local build on Pi) to ~30 seconds (image
  pull). The `image:` field in config.yaml directs Supervisor to use
  the pre-built image; the Dockerfile is now only used by CI.

## 1.0.2 — 2026-05-19

- Fix Dockerfile `COPY --from=upstream` path. The server bundle in
  `stremio/server:latest` lives at `/stremio/server.js`, not
  `/srv/server.js` (verified by inspecting the upstream image:
  WORKDIR is `/stremio`, entrypoint is `node server.js`). The 1.0.1
  build progressed past the ARG fix but failed at the COPY step with
  `"/srv/server.js": not found`. Update the path; bundle is a
  self-contained 6.6MB webpack output so no other files are needed.

## 1.0.1 — 2026-05-19

- Fix Dockerfile multi-stage `ARG BUILD_FROM` placement. Docker
  BuildKit requires `BUILD_FROM` to be declared as a global ARG
  (before the first `FROM`) so that subsequent FROM stages can
  resolve it. Previously it was declared between stages, causing
  Supervisor builds to fail with `base name (${BUILD_FROM}) should
  not be blank`.

## 1.0.0 — 2026-05-17

- Initial release: wraps the official stremio-server Node.js application
  as a Home Assistant Add-on. Exposes port 11470 for the hacs-stremio
  integration to use as a torrent-to-HTTP gateway.
