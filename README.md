# Compact Tabs

A Firefox theme project inspired by Safari 18's compact tab bar on macOS Sequoia, before Liquid Glass.

The priorities are layout, spacing, and visual balance. Firefox icons and their meaning stay recognizable.

## Status

Early prototype. Git is initialized. The geometry stylesheet has been installed only into an isolated `compact-tabs-dev` profile. Visual verification of Firefox and the two layout experiments is pending; the profile manager's launch button produced no visible result.

## Try the development build

The development profile already exists on the current Mac. Launch it separately:

```sh
/Applications/Firefox.app/Contents/MacOS/firefox -no-remote -P compact-tabs-dev
```

The installer targets only the uniquely named `compact-tabs-dev` profile and refuses to overwrite an unmanaged stylesheet:

```sh
python3 scripts/install-dev.py --dry-run
python3 scripts/install-dev.py --mode geometry
python3 scripts/install-dev.py --mode single-row
python3 scripts/install-dev.py --mode anchor-probe
```

Choose one mode, then restart only that profile. Modes are alternatives, not cumulative. `geometry` is the current installed mode. It requires `toolkit.legacyUserProfileCustomizations.stylesheets=true`, already set in the development profile's `user.js`.

- `geometry`: native two-row layout with proposed tab proportions.
- `single-row`: experimental shared toolbar row at window widths of at least 1150 CSS pixels, with native layout fallback for narrower windows, fullscreen, customization and vertical tabs.
- `anchor-probe`: geometry plus a pink marker intended to track the selected tab. It does not reposition the URL bar. Successful parsing is not proof that tracking works.

Rollback:

```sh
python3 scripts/install-dev.py --remove
```

Restart the development profile. This removes only the managed entry stylesheet; profile data and copied CSS assets remain. This is a local custom stylesheet project, not an Add-ons Store theme.

## One workflow

1. Survey the Sequoia Safari compact toolbar and record sources, estimates, and unknowns.
2. Assess Firefox layout mechanisms and relevant prior art.
3. Define reference captures and a small visual/interaction acceptance matrix.
4. Consolidate findings into a prototype brief, including the selected-tab/address-field decision.
5. Build and inspect a Firefox prototype in an isolated profile.
6. Refine spacing and balance against references, then document installation and rollback.

The first three steps are parallel research tracks within this single workflow. Implementation follows their synthesis.

See [the project brief](docs/BRIEF.md) and [the workflow](docs/WORKFLOW.md).
