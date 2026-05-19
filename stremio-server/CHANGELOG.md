# Changelog

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
