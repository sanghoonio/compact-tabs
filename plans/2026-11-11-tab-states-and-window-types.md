---
date: 2026-11-11
status: in-progress
model: Claude Opus 5.5
description: Sound indicator on the selected tab, popup and private windows, and www trimming
---

# Tab states and window types

## Problem

1. The selected tab hides its favicon (Close takes its place) and the address field covers its content, so a tab playing sound shows no speaker while selected.
2. For the same reason a loading selected tab only shows Reload turning into Stop.
3. Popup windows (`window.open` without a toolbar) still contain a selected tab, so the one-row layout matched them; the address field would anchor to a hidden tab.
4. In private windows Firefox's private-browsing button sits at the end of `#TabsToolbar`, under the fixed application menu button.
5. Safari shows only the domain until the field is clicked.

## Changes

1. Firefox's own `.tab-audio-button` on the selected tab is positioned in a 20px slot just before Reload. The address field now ends before Reload (and before the sound slot when shown) instead of reserving Reload's space with padding, so both buttons are clicked on the tab underneath. The narrow-field icon limits drop by 20px (110px and 90px) to keep the same text allowance. A selected pin gets the button too, with Firefox's glyphs supplied through top-level `::part(button)` rules.
2. `.tabbrowser-tab[selected][busy]` draws a 2px accent line along the bottom of the tab surface, growing on a fixed 10s curve to 90%; reduced motion shows a full static line.
3. The layout's root condition excludes `[popup-window]`, `[chromeless-window]` and `[web-extension-popup-window]`.
4. The private button is fixed left of New Tab; `--ct-private-extra` adds one button width to the strip margins and the navigation target's end padding, so Downloads and extension buttons shift left and the tabs stay centred.
5. `browser.urlbar.trimWww=true`. Firefox 160 already trims `https://` and untrims on click through `scotchBonnet.enableOverride`. Domain-only display does not exist.

## Decisions & ownership

| Decision | Owner / status | Note |
| --- | --- | --- |
| Do 1–4 and 12 from the gap list | user-owned, surfaced | User picked these. |
| Sound button between the field icons and Reload | AI-owned, default | Keeps Reload fixed at the trailing edge. |
| Reload moved outside the field's box | AI-owned, defended | Needed so the sound slot is clickable; Reload's position is unchanged. |
| Loading line pace is fake | AI-owned, defended | Firefox exposes no progress value to CSS. |
| Popups use Firefox's layout | AI-owned, defended | Their toolbar is reduced; the address field must stay visible for security. |
| Private button kept, not hidden | AI-owned, default | It opens Firefox's private-browsing info panel. |
| `trimWww` added to managed prefs | AI-owned, default | Closest available step to Safari's domain display. |

## What this changes elsewhere

- The field is 20px narrower than before at every width (it no longer extends under Reload); the icon-hiding limits were lowered to match, so the visible text width is unchanged.
- `--remove` resets `trimWww` with the other managed prefs.
- Background favicon-only tabs playing sound are unchanged and may clip the sound button.

## Implementation log

2026-11-11: all five implemented in `experiments/selected-address.css` and `scripts/prefs.js`, installed in `compact-tabs-dev`; README, `docs/VALIDATION.md`, `docs/FIREFOX-NOTES.md` and `docs/BRIEF.md` updated. Not yet checked live.
- First live check: the whole selected tab turned accent-coloured while loading. The line was a background layer on `.tab-background`, whose size came from an animation, but `geometry.css` sets the `background` shorthand with `!important`, which resets `background-size` and outranks animations, so the layer filled the surface. Now drawn as `::after` on Firefox's `.tab-loading-burst`, which fills the tab surface, inherits its corners and clips; the keyframes animate `width`. Firefox's native effects are separate: a 375ms burst from the favicon at load start, and a favicon spinner that is hidden on the selected tab.
- User chose to drop the loading line and rely on Firefox's own burst at load start. The rule and keyframes were removed; change 2 above is withdrawn.
- Gap list follow-up (user: "check the gap list things that you can do"; speaker clipping in favicon cells and dark mode accepted as is). Measured in a throwaway headless Firefox with the same CSS and prefs:
  - Split view: the wrapper stayed 158px while the selected tab inside grew to 300px, spilling 186px. Fixed in `selected-address.css`: the active wrapper takes the selected width plus a favicon cell, columns 3fr/1fr towards the selected side; other wrappers compress to two favicon cells. Re-measured at 1400px and 700px with either side selected: both tabs, the field and Reload stay inside the wrapper, and the row stays centred.
  - Vertical tabs: the root `--tab-margin-block: 10px` made each vertical tab 53px tall. Row metrics in `geometry.css` are now inside `@media not -moz-pref("sidebar.verticalTabs")`; vertical tabs measure 41px (Firefox's own), horizontal unchanged.
  - Auto-compact density: confirmed `uidensity="compact"` at a 650px-tall window. `browser.uidensity=0` added to `scripts/prefs.js`, which stops it.
  - Container tabs: Firefox's line sits inside the surface, 4px from the top. Multi-selected tabs share the selected shading. No change.
  - Tab notes: off by default in 160. No change.
  - Window dragging: from Firefox's rules, empty row space is draggable; not testable headless.
