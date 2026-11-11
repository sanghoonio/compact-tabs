---
date: 2026-11-11
status: complete
model: Claude Opus 5.5
description: Restructure the repo into the usual userChrome theme layout, with install and uninstall scripts and an MIT license
---

# Conventional layout, installers, license

## Goal

Make the repo look and install like other shared `userChrome.css` themes: a `chrome/` folder that can be copied into any profile, a `user.js` with the required prefs, `install.sh` and `uninstall.sh`, and an MIT license. The user asked for this after a summary of how such themes are normally shared.

## Layout

```
chrome/
  userChrome.css            imports the two files below
  compact-tabs/
    base.css                was chrome/geometry.css
    one-row.css             was experiments/selected-address.css
user.js                     required prefs (was scripts/prefs.js)
install.sh
uninstall.sh
LICENSE                     MIT
README.md, docs/, plans/
```

Removed: `experiments/`, `scripts/install-dev.py`, `scripts/prefs.js`, the dev-only `chrome/compact-tabs` copies of old modes. Browser Toolbox prefs move to `scripts/dev-prefs.js`, added only with `install.sh --dev`.

## Scripts

- **Profile choice:** read `profiles.ini`; `--profile NAME` or `--profile-path DIR`, otherwise list profiles and ask. Never pick one silently.
- **install.sh:** copies `chrome/compact-tabs/` into the profile; puts the two `@import` lines in a fenced block at the top of the profile's `userChrome.css` (created if missing, prepended if it exists, since `@import` must come first); writes `user.js` as a fenced block at the end of the profile's `user.js`. Rerunning replaces both blocks. Recognises the old `install-dev.py` markers and replaces them.
- **uninstall.sh:** removes both blocks and `chrome/compact-tabs/`; deletes `userChrome.css` or `user.js` if nothing else is left in them. If Firefox is not running that profile, also clears the theme's prefs from `prefs.js` so defaults return, except the stylesheet pref when other custom CSS remains.
- **Running check:** a profile is in use if a process holds its `.parentlock` open (`lsof`).
- **Platform:** macOS only (the one-row layout is macOS-only); other systems get a clear error.

## Option

The former `geometry` mode becomes a pref: setting `compact-tabs.two-rows` to `true` in `about:config` keeps Firefox's two rows with the rest of the styling. `one-row.css` is wrapped in `@media not -moz-pref("compact-tabs.two-rows")`, which updates live.

## Decisions & ownership

| Decision | Owner / status | Note |
| --- | --- | --- |
| MIT license | user-owned, surfaced | User chose MIT. |
| Install and uninstall scripts | user-owned, surfaced | User asked for both. |
| Shell scripts, not Python | AI-owned, defended | Convention for these themes; macOS has no Python by default. |
| Fenced blocks in `userChrome.css` and `user.js` instead of overwriting | AI-owned, defended | Keeps any CSS or prefs the user already has; uninstall is exact. |
| Always ask for the profile unless named | AI-owned, defended | The default profile here is the user's regular one. |
| Two-row mode as an `about:config` pref | AI-owned, default | Replaces the installer modes; matches how themes expose options. |
| File names `base.css` and `one-row.css` | AI-owned, default | Describe what each does now that nothing is experimental. |
| Dev prefs behind `--dev` | AI-owned, defended | Users should not get Browser Toolbox prefs. |
| macOS only | AI-owned, defended | The layout is gated on macOS already. |

## What this changes elsewhere

- **Dev profile:** reinstalling with `./install.sh --profile compact-tabs-dev --dev` replaces the old managed files; the stale `anchor-probe.css`, `single-row.css`, `geometry.css` and `selected-address.css` copies are removed.
- **Docs and plans:** paths change (`geometry.css` → `base.css`, `selected-address.css` → `one-row.css`, `scripts/prefs.js` → `user.js`). Current docs are updated; dated plans keep their original paths as history.
- **Uninstall resetting prefs:** a pref the user had set to the same value before installing (for example the stylesheet pref) is reset too; the stylesheet pref is kept when other custom CSS remains.

## Implementation log

2026-11-11: implemented as planned.

- Files moved with `git mv`: `chrome/geometry.css` → `chrome/compact-tabs/base.css`, `experiments/selected-address.css` → `chrome/compact-tabs/one-row.css`, `scripts/prefs.js` → `user.js`; `scripts/install-dev.py` deleted; Browser Toolbox prefs split into `scripts/dev-prefs.js`.
- `one-row.css` wrapped in `@media not -moz-pref("compact-tabs.two-rows")` inside the macOS block. `-moz-pref()` from `userChrome.css` was already shown to work by the vertical-tabs rule; the two-rows pref itself is not yet checked live.
- `install.sh`, `uninstall.sh`, `scripts/common.sh` (bash 3.2 compatible). Tested on throwaway profile folders: fresh profile; a profile with its own `userChrome.css` and `user.js` (kept, with a clash note); an old `install-dev.py` install (markers replaced, stale files removed); rerun is byte-identical; uninstall restores the user's files exactly, deletes files left empty, and clears the theme's prefs from `prefs.js` while keeping the stylesheet pref when other custom CSS remains.
- Bug found in testing: macOS awk rejects newlines in `-v` values, so the pref list is passed through `ENVIRON`.
- Running check: `lsof` on `.parentlock`, plus a Firefox process whose command line holds the profile path. Not checked against a running Firefox (none was running).
- Installed into `compact-tabs-dev` with `--dev`; the user's two own `user.js` lines kept.
- README rewritten for a fresh user (install, manual install, prefs, options, files, development, license); `docs/VALIDATION.md` and `docs/BRIEF.md` updated.
