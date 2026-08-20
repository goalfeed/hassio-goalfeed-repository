# Contributing

Thanks for looking at Goalfeed. This repository is one of three that make up the
project, and most contributions belong somewhere other than here:

| Repository | What lives there |
|---|---|
| [goalfeed/goalfeed](https://github.com/goalfeed/goalfeed) | The actual Goalfeed service — league clients, goal-detection logic, the Home Assistant event sender, the REST/WebSocket API, and the React web UI. **Almost all bug reports and feature requests belong here.** |
| [goalfeed/hassio-goalfeed-repository](https://github.com/goalfeed/hassio-goalfeed-repository) (this repo) | Packages the Goalfeed binary as a Home Assistant Supervisor add-on: the add-on manifest, its Dockerfile, and this documentation. |
| goalfeed.wiki (part of `goalfeed/goalfeed`) | Longer-form guides. |

If you're not sure which repo an issue belongs to, ask yourself: *is this about what
Goalfeed detects/does, or about how it's packaged and installed as a Home Assistant
add-on?* The former is `goalfeed/goalfeed`; the latter is here.

Examples of issues that belong **here**:
- The add-on doesn't show up in the Add-on Store after adding the repository.
- The add-on's Configuration tab is missing an option, or an option doesn't do what
  [`goalfeed/DOCS.md`](goalfeed/DOCS.md) says it does.
- The add-on's Docker image fails to build or start on your architecture.
- Something in this repo's own documentation is wrong.

Examples of issues that belong in **`goalfeed/goalfeed`**:
- A goal didn't fire, fired late, or fired the wrong number of times.
- A league isn't supported, or behaves differently than another league.
- The web UI, REST API, or WebSocket feed has a bug.
- Anything about how Goalfeed talks to Home Assistant (event payload shape, entities,
  sensors).

## Repository layout

```
goalfeed/
  config.json   # Add-on manifest: name, version, supported arch, options/schema
  build.json     # Maps HA base images to each supported architecture
  Dockerfile     # Fetches a goalfeed release binary and runs it via run.sh
  run.sh         # Add-on entrypoint — reads Supervisor config, builds the goalfeed CLI invocation
  DOCS.md        # Rendered in the add-on's Documentation tab in Home Assistant
  CHANGELOG.md   # Per-version add-on changelog
  icon.png, logo.png
repository.json  # Repository manifest (name/url/maintainer) read by the Supervisor
```

## How the add-on image is built

On every push to `main` (and on pull requests, in test mode), the
[`Builder` workflow](.github/workflows/onpush_builder.yaml):

1. Detects whether anything under `goalfeed/config.*` changed (via
   [`.github/paths-filter.yml`](.github/paths-filter.yml)).
2. Runs the Home Assistant add-on linter (`frenck/action-addon-linter`) against
   `goalfeed/config.json`.
3. Builds the add-on image for each architecture listed in `goalfeed/config.json`'s
   `arch` array, using `home-assistant/amd64-builder` and the base images pinned in
   `goalfeed/build.json`, and pushes to `ghcr.io/goalfeed/hassio-{arch}-goalfeed` (pushes
   are skipped — `--test` mode — on pull requests).
4. Bumps `goalfeed/CHANGELOG.md` for the new version.

The add-on's `Dockerfile` doesn't build Goalfeed from source — it downloads a prebuilt
release binary from [goalfeed/goalfeed's GitHub Releases](https://github.com/goalfeed/goalfeed/releases)
(pinned via the `GOALFEED_VERSION` build arg) matching the container's architecture, and
runs it via `run.sh`, which translates the add-on's Supervisor configuration options
(`nhl_teams`, `mlb_teams`, `test_goals`) into `goalfeed` CLI flags.

If you're changing what Goalfeed itself does, you need to change and release
`goalfeed/goalfeed`, then bump `GOALFEED_VERSION` in this repo's `Dockerfile` — changes to
the service's source code do not belong in this repository.

## Testing locally

- **Validate the add-on manifest**: `jq . goalfeed/config.json` (must be valid JSON), and
  ideally run it through the same linter CI uses:
  [`frenck/action-addon-linter`](https://github.com/frenck/action-addon-linter).
- **Run it inside a real Supervisor**: this repo includes a
  [`.devcontainer/devcontainer.json`](.devcontainer/devcontainer.json) based on
  `ghcr.io/home-assistant/devcontainer:addons`, which boots a local Home Assistant
  Supervisor with this repository mounted as a local add-on repository. Open the repo in
  the devcontainer, then use the **Start Home Assistant** VS Code task (see
  [`.vscode/tasks.json`](.vscode/tasks.json)) to launch it, add/install the Goalfeed
  add-on from the local repository, and iterate.
- **Build the Docker image directly**, if you just want to confirm it builds for an
  architecture:
  ```bash
  docker build --build-arg BUILD_FROM=ghcr.io/home-assistant/amd64-base:latest \
    -t goalfeed-addon-test goalfeed/
  ```

## Pull requests

- Keep changes to this repository scoped to add-on packaging (manifest, Dockerfile,
  `run.sh`, docs) — not to Goalfeed's own behaviour.
- Update [`goalfeed/DOCS.md`](goalfeed/DOCS.md) if you add or change a configuration
  option.
- Don't hand-edit `goalfeed/CHANGELOG.md`'s version entries; the release workflow
  maintains those.
