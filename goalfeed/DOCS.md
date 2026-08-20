# Home Assistant Add-on: Goalfeed

Goalfeed watches live games for the teams you care about and fires a Home Assistant
event the moment something happens — a goal, a touchdown, a home run — so an automation
can blow the goal horn and flash the lights in your team's colours.

## About

Goalfeed polls the same unofficial, undocumented public score APIs your browser already
talks to when you check the score (nothing scraped, nothing paid for), and turns score
changes into a Home Assistant event. It also ships a small web UI (scoreboard, team
manager, event feed) and a REST/WebSocket API, reachable from the Home Assistant sidebar
or directly on port 8080.

**Leagues configurable through this add-on's Configuration tab today: NHL and MLB.**
The underlying Goalfeed service also has goal detection for CFL and NFL, but the add-on's
Configuration UI doesn't expose options for those two leagues yet — see
[Limitations](#limitations-and-known-issues) below if you want to watch a CFL or NFL team.

IIHF data is reachable through Goalfeed's web API (schedules, upcoming games, team lookups)
but is **not** wired into the live goal-detection loop, so no Home Assistant event fires
for IIHF games. There is no EPL/soccer support of any kind.

## Installation

1. In Home Assistant, go to **Settings → Add-ons → Add-on Store**, open the **⋮** menu in
   the top right, choose **Repositories**, and add:
   ```
   https://github.com/goalfeed/hassio-goalfeed-repository
   ```
   (Or use the "Add repository to my Home Assistant" badge on the
   [repository's README](https://github.com/goalfeed/hassio-goalfeed-repository) to do
   this in one click.)
2. Find **Goalfeed** in the Add-on Store and click **Install**.
3. Switch to the **Configuration** tab, enter the team codes you want (see below), and
   save.
4. Start the add-on. It runs in web mode on port 8080 with the Home Assistant Supervisor
   auto-detected — you do not need to set a Home Assistant URL or access token; the
   add-on talks to Home Assistant directly through the Supervisor API.
5. Check the **Log** tab to confirm it started cleanly.

## Accessing the web UI

Once the add-on is running, open its web interface either:

- from the Home Assistant **sidebar** — Goalfeed appears there via ingress, or
- directly at `http://homeassistant.local:8080` (or your Home Assistant host's address).

The web UI has a live scoreboard, a per-league team manager, an event feed, an
application-log viewer, and a Home Assistant connection status panel.

## Configuration

```yaml
nhl_teams: "TOR,WPG"
mlb_teams: "TOR,NYY"
test_goals: false
```

### Option: `nhl_teams`

A comma-separated list of two-or-three-letter NHL team codes to watch, e.g. `TOR`, `WPG`,
`MTL`. Leave empty to watch no NHL teams.

### Option: `mlb_teams`

A comma-separated list of two-or-three-letter MLB team codes to watch, e.g. `NYY`, `TOR`,
`BOS`. Leave empty to watch no MLB teams.

> **Note:** the underlying Goalfeed service supports a `*` wildcard to watch every team in
> a league when configured through its own `config.yaml`/environment variables. This
> add-on's `nhl_teams`/`mlb_teams` fields are filtered down to two-or-three-character
> alphanumeric codes before being passed to Goalfeed, so `*` does not pass through — enter
> explicit team codes here.

### Option: `test_goals`

When `true`, Goalfeed fires a synthetic `goal` event once a minute for every configured
team, so you can build and test automations without waiting for a real game. Turn this
off once you're done testing — remember to restart the add-on after changing it.

**Watching CFL or NFL teams:** the add-on's Configuration tab has no `cfl_teams` or
`nfl_teams` option today, even though the Goalfeed binary itself supports both leagues.
There is currently no supported way to watch those leagues through this add-on's UI.

## What fires, and what it looks like

Every event Goalfeed sends to Home Assistant — real goals, period-start notices, and test
goals alike — arrives as the **same Home Assistant event type: `goal`**. Filter your
automations on the event data (`teamCode`, `leagueId`), not on the event type, since
there's only one event type to trigger on.

The event payload is a flattened JSON object with (at minimum) these fields:

```json
{
  "id": "…",
  "teamCode": "WPG",
  "teamName": "Winnipeg Jets",
  "opponentCode": "TOR",
  "opponentName": "Toronto Maple Leafs",
  "leagueId": 1,
  "leagueName": "NHL",
  "gameCode": "…",
  "period": 2,
  "gameState": { "home": { "...": "..." }, "away": { "...": "..." }, "status": "active" }
}
```

Goal detection is a raw score diff, not a play-by-play feed: Goalfeed compares a watched
team's last-seen score to its current score once a second and fires one `goal` event per
point of increase. For NHL and MLB that's one event per goal or run, which is what you
want. This matters if you ever configure a CFL or NFL team another way (see
[Limitations](#limitations-and-known-issues)): a 7-point touchdown-plus-conversion fires
**seven separate `goal` events** in the same tick, not one "touchdown" event.

## Example automation

A complete automation — goal horn plus a light flash — for the Winnipeg Jets:

```yaml
automation:
  - alias: "Goalfeed - Jets score"
    trigger:
      - platform: event
        event_type: goal
        event_data:
          teamCode: WPG
    action:
      - service: media_player.play_media
        target:
          entity_id: media_player.living_room_speaker
        data:
          media_content_id: /local/sounds/goal_horn.mp3
          media_content_type: music
      - service: light.turn_on
        target:
          entity_id: light.living_room
        data:
          color_name: blue
          flash: long
      - delay: "00:00:03"
      - service: light.turn_on
        target:
          entity_id: light.living_room
        data:
          color_name: white
```

Enable `test_goals` above and restart the add-on to trigger this automation once a minute
without waiting for a real game.

## API and WebSocket

Goalfeed also runs a REST API, a WebSocket feed, and Swagger docs on the same port as the
web UI (`8080` by default):

- `GET /api/games` — currently active games
- `GET /api/leagues` — current per-league watch configuration
- `GET /api/events` — recent goal/score events
- `GET /api/teams?leagueId=` — teams for a league
- `ws://<host>:8080/ws` — real-time WebSocket stream
- `http://<host>:8080/swagger/index.html` — full API reference

There is no authentication on this API and CORS is wide open. This is fine behind Home
Assistant ingress or on a trusted home network; see [SECURITY.md](../SECURITY.md) for why
you should not expose it directly to the internet.

## Troubleshooting

- **No goal events are firing.** Confirm the team code is correct (two or three letters,
  e.g. `WPG` not `Winnipeg`), that a game for that team is actually live, and that the add-on
  has been restarted since the last configuration change. Enable `test_goals` to confirm
  the Home Assistant event pipeline itself works, independent of any real game.
- **The add-on can't reach Home Assistant.** This add-on auto-detects Home Assistant
  through the Supervisor, so there's normally nothing to configure. Check the add-on log
  and the web UI's Home Assistant status panel for connection errors.
- **I configured a CFL or NFL team and nothing happens.** Expected — see
  [Limitations](#limitations-and-known-issues); those leagues aren't exposed in this
  add-on's Configuration UI yet.
- **Still stuck?** Check the add-on's **Log** tab first, then open an issue — see
  [Support](#support) for which repository to use.

## Limitations and known issues

- **Only NHL and MLB are configurable through this add-on's Configuration tab.** The
  Goalfeed binary itself also detects CFL and NFL goals, but this add-on doesn't yet
  expose `cfl_teams`/`nfl_teams` options.
- **IIHF is API-only.** Schedule/team/upcoming-game data is available through the web API,
  but no live goal events fire for IIHF games.
- **There is no EPL/soccer support.** It exists only as an internal, unused identifier —
  never a real feature.
- **Goal detection is a raw score diff.** A single high-scoring play (e.g. an NFL
  touchdown plus conversion) can fire multiple `goal` events in quick succession rather
  than one event describing the play. Debounce in your automation if this matters to you.
- **The Home Assistant event type is always `goal`**, for real goals, period-start
  notices, and test goals alike. Filter on `teamCode`/`leagueId` in your automation, not
  on event type.
- **All upstream sports data comes from unofficial, undocumented APIs** run by the
  leagues/broadcasters themselves. Any of them can change shape or go away without
  notice, and Goalfeed has no fallback when that happens.
- **No authentication on the API, and CORS is wide open.** Keep this add-on behind Home
  Assistant ingress / your home network — don't expose port 8080 to the internet.

## Support

- **Add-on packaging issues** (this repository, its `config.json`/`build.json`,
  installation into Home Assistant, the Docker image) — open an issue at
  [github.com/goalfeed/hassio-goalfeed-repository](https://github.com/goalfeed/hassio-goalfeed-repository/issues).
- **Everything else** — incorrect goal detection, missing leagues, the web UI, the API,
  Home Assistant event content — belongs to the main service and should be reported at
  [github.com/goalfeed/goalfeed](https://github.com/goalfeed/goalfeed/issues).
- General information and full documentation: [goalfeed.ca](https://goalfeed.ca)
