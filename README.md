# Compact Tabs

A Firefox theme project inspired by Safari 18's compact tab bar on macOS Sequoia, before Liquid Glass.

The priorities are layout, spacing, and visual balance. Firefox icons and their meaning stay recognizable.

## Status

Early prototype, tested in Firefox 159.0.1 on macOS 15.7.4. The isolated `compact-tabs-dev` profile currently runs the experimental `selected-address` mode: the real Firefox address field follows the selected tab in one row. Native Firefox icons, site identity controls, address editing and suggestions remain in use. Your regular profile has not had theme CSS installed.

This is a bounded proof of concept, not a finished daily-use theme. Integration is limited to wide windows with ungrouped tabs and an ordinary selected tab. Opening additional ordinary tabs keeps the integrated address field; four and five tabs have been checked live. Large overflowing tab sets still need verification. Narrow windows, grouped tabs, pinned selections, fullscreen and customization fall back to the geometry baseline. Pinned, grouped, fullscreen and customization behavior still need live verification.

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
python3 scripts/install-dev.py --mode selected-address
```

Choose one mode, then restart only that profile. Modes are alternatives, not cumulative. `selected-address` is the current installed mode; `geometry` is the installer's conservative default. Stylesheet loading requires `toolkit.legacyUserProfileCustomizations.stylesheets=true`, already set in the development profile's `user.js`.

- `geometry`: native two-row layout with proposed tab proportions.
- `single-row`: experimental shared toolbar row at window widths of at least 1150 CSS pixels, with native layout fallback for narrower windows, fullscreen, customization and vertical tabs.
- `anchor-probe`: geometry plus a pink marker that was observed following tab selection. It does not reposition the URL bar.
- `selected-address`: the real address field anchored over a wider selected tab; native navigation controls remain at the leading edge and actions at the trailing edge. Applies at widths of at least 1100 CSS pixels within the limits above.

In integrated mode, Reload/Stop sits at the trailing side of the selected address tab and follows selection. The bookmark star is hidden; Command-D and the Bookmarks menu remain available. Unavailable Back/Forward arrows hide independently. VPN and the Extensions hub are hidden by CSS, without changing VPN state or installed extensions; manage extensions through `about:addons`. List all tabs has a separate trailing slot beside the application menu.

Controls inside tabs use flat, transparent button surfaces without nested pill or hover backgrounds. Security, page-action (including Reader Mode and translation) and Reload glyphs are 12px, comparable to the tab close glyph, with a compact 20px horizontal slot for trailing page actions, Reload and Close in integrated mode. Hover uses the system accent color, configured by `--ct-icon-hover-color` in `chrome/geometry.css`; tab Close uses Firefox’s red palette (`--color-red-70` in light appearance, `--color-red-20` in dark appearance) via `--ct-close-hover-color`. The translated-language badge is 16px and retains its status indication. Keyboard focus indicators and resting security status labels/colors are preserved.

Tab hover preview cards are suppressed by CSS. Tabs and the adjacent New Tab button use the shared `--ct-tab-gap` (10px); the button retains its native toolbar placement so it can be moved later. List all tabs uses native navigation-toolbar padding for its hover/pressed background (32px in the inspected normal-density layout), rather than the smaller tab-toolbar sizing.

The address input uses the same root font size as tab labels, overriding macOS Firefox’s larger address-bar text. Sidebar keeps native toolbar button sizing; the navigation group’s gap before the tabs is tightened separately. The bookmarks row shares the compact bar’s underlying theme background.

When editing an address, the selected tab draws a single inset focus outline around the combined bar. Suggestions appear as a separate panel below it; the native expanding input background is suppressed in integrated mode to avoid clipping around Reload and Close.

VPN is also a removable toolbar widget through Customize Toolbar. The shipped Extensions hub is marked non-removable, so this project hides it in CSS. To restore either button visually, remove its selector from the visibility rule in `chrome/geometry.css`, reinstall, and restart the development profile.

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
