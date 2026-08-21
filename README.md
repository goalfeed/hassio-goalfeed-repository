# Goalfeed Home Assistant Add-on Repository

This is the Home Assistant add-on repository for [Goalfeed](https://github.com/goalfeed/goalfeed) —
a self-hosted service that watches live sports games and fires a Home Assistant `goal`
event the instant your team scores, so you can trigger a goal horn, flash your lights,
or build any other automation around it.

Adding this repository gives your Home Assistant instance the **Goalfeed** add-on, which
runs the Goalfeed service as a Supervisor-managed container with Home Assistant
auto-detected (no URL or access token to configure) and a web UI available right from the
sidebar.

[![Add repository on my Home Assistant][repository-badge]][repository-url]

[repository-badge]: https://img.shields.io/badge/Add%20repository%20to%20my-Home%20Assistant-41BDF5?logo=home-assistant&style=for-the-badge
[repository-url]: https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fgoalfeed%2Fhassio-goalfeed-repository

## Installation

1. Click the badge above, or in Home Assistant go to **Settings → Add-ons → Add-on
   Store**, open the **⋮** menu, choose **Repositories**, and add:
   ```
   https://github.com/goalfeed/hassio-goalfeed-repository
   ```
2. Install the **Goalfeed** add-on from the store.
3. Open its **Configuration** tab, enter the team codes you want to watch, and start
   the add-on.

Full configuration reference, automation examples, and troubleshooting are in the add-on's
own documentation: [`goalfeed/DOCS.md`](goalfeed/DOCS.md) (also shown in the
**Documentation** tab of the add-on itself once installed).

## Which leagues can I configure?

Through the add-on's Configuration UI, **NHL and MLB** teams are supported today
(`nhl_teams`, `mlb_teams`, plus a `test_goals` toggle for testing automations). CFL and
NFL client code exists in the underlying Goalfeed service, but neither league is listed
as supported — live testing found both leagues' score tracking broken, so no goal event
fires for either today. See
[`goalfeed/DOCS.md`](goalfeed/DOCS.md#limitations-and-known-issues) for details.

## Links

- Main project: [github.com/goalfeed/goalfeed](https://github.com/goalfeed/goalfeed)
- Website / full documentation: [goalfeed.ca](https://goalfeed.ca)
- Add-on documentation: [`goalfeed/DOCS.md`](goalfeed/DOCS.md)

## License

[MIT](LICENSE)
