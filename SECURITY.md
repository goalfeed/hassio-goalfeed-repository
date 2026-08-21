# Security Policy

## Reporting a vulnerability

Please report security vulnerabilities using **GitHub's private security advisory**
feature rather than a public issue:

- For anything in the Goalfeed service itself (goal detection, the REST/WebSocket API,
  the web UI, how it talks to Home Assistant): open a private advisory at
  [github.com/goalfeed/goalfeed/security/advisories/new](https://github.com/goalfeed/goalfeed/security/advisories/new).
- For anything specific to this add-on's packaging (its Docker image, `config.json`,
  `run.sh`): open a private advisory at
  [github.com/goalfeed/hassio-goalfeed-repository/security/advisories/new](https://github.com/goalfeed/hassio-goalfeed-repository/security/advisories/new).

If you're not sure which of the two it is, either one is fine — it will get routed to the
right place. Do not report vulnerabilities by email; there is no monitored security
inbox for this project.

## Scope

In scope:
- The Goalfeed service (`goalfeed/goalfeed`) and its API, WebSocket feed, and web UI.
- This add-on's packaging: its Dockerfile, `run.sh` entrypoint, and manifest files.

Out of scope:
- Home Assistant core/Supervisor itself — report those upstream to the
  [Home Assistant project](https://www.home-assistant.io/help/reporting_a_bug/).
- The third-party, unofficial league APIs Goalfeed polls (NHL, MLB, NFL, CFL) —
  Goalfeed doesn't control those services.

## Known security posture

Goalfeed's REST/WebSocket API has **no authentication**, and its CORS policy is wide
open (all origins allowed, credentials permitted). This is a deliberate, known trade-off,
not an oversight: the add-on is designed to sit behind Home Assistant's ingress (or on a
trusted local network) and to be reachable only by devices you already trust on that
network.

**Do not expose this add-on's port (8080 by default) directly to the internet** — for
example, via port forwarding or a reverse proxy without its own authentication in front.
Anyone who can reach the API can read and change which teams are watched and read
Goalfeed's event/log history; there is currently no way to restrict that.

If you need remote access, use Home Assistant's own remote-access mechanisms (e.g. Home
Assistant Cloud, or a VPN into your home network) rather than exposing the add-on
directly.
