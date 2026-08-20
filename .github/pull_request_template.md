## What does this change?

<!-- Briefly describe what this PR changes and why. -->

## Checklist

- [ ] This change is about add-on packaging (manifest, Dockerfile, `run.sh`, docs) —
      not Goalfeed's own behavior. (Service changes belong in
      [goalfeed/goalfeed](https://github.com/goalfeed/goalfeed).)
- [ ] `goalfeed/config.json` is still valid JSON (`jq . goalfeed/config.json`), and if I
      bumped `version`, it matches what the release/builder workflow expects (no
      hand-invented version strings).
- [ ] If this changes the Docker image Goalfeed runs, `GOALFEED_VERSION` in
      `goalfeed/Dockerfile` is **pinned** to a specific released tag of
      [goalfeed/goalfeed](https://github.com/goalfeed/goalfeed/releases) — never `latest`
      or a moving reference. This repo only packages a release that already exists; it
      does not build the service from source.
- [ ] Every architecture listed in `goalfeed/config.json`'s `arch` array has a matching
      base image in `goalfeed/build.json`, and I haven't added/removed an architecture in
      one file without the other — the builder workflow builds one image per entry in
      that array and will fail (or silently skip) on a mismatch.
- [ ] [`goalfeed/DOCS.md`](../goalfeed/DOCS.md) is updated if a configuration option
      changed.
- [ ] I did not hand-edit `goalfeed/CHANGELOG.md`'s version entries (the release
      workflow maintains those).
