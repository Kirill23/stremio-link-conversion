# Changelog

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
