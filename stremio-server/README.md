# Stremio Server Add-on

Runs [stremio-server](https://github.com/Stremio/stremio-shell) inside a
Home Assistant add-on container. Used by the
[hacs-stremio](https://github.com/Kirill23/hacs-stremio) integration to
convert torrent infoHashes into HTTP URLs that Chromecast and smart TVs
can play.

## Why you might need this

If your Torrentio addon is **not** configured with a debrid service
(Real-Debrid, AllDebrid, Premiumize), the streams it returns are
torrent magnets that no consumer media device can play directly. This
add-on runs a torrent-to-HTTP server locally so those streams become
playable.

If you **do** have a debrid service configured in Torrentio, you
likely don't need this add-on — debrid output is already HTTP and the
hacs-stremio integration plays it directly.

## Configuration

| Option | Default | Description |
|---|---|---|
| `cache_size_gb` | 4 | How much disk space to use for torrent piece cache. Higher = better seeking and rewatch performance, but uses more storage on the HA host. |
| `log_level` | info | One of `debug`, `info`, `warn`, `error`. |

## After installation

1. Start the add-on. Wait ~10 seconds for stremio-server to come up.
2. Open the **hacs-stremio** integration's **Configure** options.
3. The **Torrent server URL** field should be auto-detected as
   `http://homeassistant.local:11470`. If not, paste it in manually.
4. Try playing a Torrentio stream that previously failed.

## Legal note

This add-on runs a BitTorrent client. Depending on your jurisdiction
and what you stream, that may carry legal risk (DMCA notices, ISP
throttling, etc.). Use a VPN or stick to legally-distributed content
if you're unsure.
