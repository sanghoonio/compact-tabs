---
date: 2026-11-11
status: complete
model: Claude Opus 5.5
description: Keep the one-row layout when a pinned tab is selected; centre pins with the tabs behind a divider
---

# Pinned tabs in the compact layout

## Problem

`experiments/selected-address.css` only applies when the selected tab is unpinned (`.tabbrowser-tab[selected]:not([pinned])` in the toolbox `:has()`), so selecting a pinned tab drops the window into Firefox's two-row layout. In Firefox 160, pinned tabs live in their own `#pinned-tabs-container` arrowscrollbox, placed before `#tabbrowser-arrowscrollbox` inside `#tabbrowser-tabs`. The unpinned tabs are centred inside the second scrollbox only, so with pins the group sits right of the window centre.

The user's local Safari inspection (`docs/SAFARI-REFERENCE.md`) recorded an active pin holding the address field and an inactive pin as a favicon-only cell followed by a subtle vertical divider.

## Changes

1. **Selected pin keeps the compact row.** Drop the `:not([pinned])` guards on the toolbox condition, the anchor name and the selected-tab widening. A selected pin gets the normal selected width (300–480px) with the address field inside.
2. **No Close reserve on a pin.** Pinned tabs have no Close button, so when the selected tab is pinned the address field starts at the tab's leading edge inset instead of after a Close slot.
3. **Pins and tabs centred as one group.** When pins exist, centre at the `#tabbrowser-tabs` level instead of inside the unpinned scrollbox: `margin-inline-start: auto` on the pinned container, `margin-inline-end: auto` and `flex: 0 1 auto` on the unpinned scrollbox so it sizes to its tabs and still shrinks and scrolls when crowded. With no pins, the existing centering is untouched.
4. **Divider after pins.** A 1px, 16px-tall divider in the tab gap after the pinned container, in a muted text colour.
5. **Single-tab rule counts pins.** One pinned plus one ordinary tab is no longer treated as a single tab, so it does not get the 40vw field.

## Decisions & ownership

| Decision | Owner / status | Note |
| --- | --- | --- |
| Selected pin uses the normal selected width | user-owned, surfaced | Chosen over a narrower active pin. |
| Pins centred with the tabs, followed by a divider | user-owned, surfaced | User proposed the divider; matches the recorded Safari inactive-pin divider. |
| Divider is 1px × 16px, muted text colour, in the existing 10px gap | AI-owned, default | Size is a guess; Safari's was described only as subtle. |
| Outer centering only when pins exist | AI-owned, defended | Leaves the tested no-pin layout exactly as it is. |
| Inactive pin cell keeps Firefox's native pinned width | AI-owned, default | Safari's was about 32px; not matched yet. |
| One pin plus one tab is not a "single tab" | AI-owned, defended | Resolves the open question from the audit; the selected tab gets the multi-tab width. |

## What this changes elsewhere

- **Narrow windows** still fall back to two rows below 1100px; unchanged.
- **Dragging** an unpinned tab with pins present: the unpinned scrollbox now sizes to its content, so lifting a tab shrinks it and re-centres the whole group, the same half-tab shift as without pins.
- **Overflow** with many pins: the pinned container keeps Firefox's own maximum width and scrolls on its own.
- **README** limits paragraph: pinned selections no longer fall back.

## Verification (user)

1. Pin one tab, select it: one row, address field inside the wide pinned tab, no × on it.
2. Select an ordinary tab: the pin shrinks to its favicon cell, the divider shows after it, the whole group is centred.
3. Two pins and three tabs: group centred, divider only once, after the last pin.
4. Unpin all: the layout is exactly as before.

## Implementation log

2026-11-11, installed in `compact-tabs-dev`, not yet checked live. All in `experiments/selected-address.css`: removed the three `:not([pinned])` guards; a selected pin sets `--ct-tab-close-reserve` to the edge inset; with pins present, `#pinned-tabs-container` takes `margin-inline-start: auto` and `#tabbrowser-arrowscrollbox` becomes `flex: 0 1 auto` with `margin-inline-end: auto`; the divider is `#pinned-tabs-container::after` (assumes the arrowscrollbox host lays out its `::after` as a flex item after its shadow content); the single-tab rule also requires no pins. README limits paragraph updated.
- First live check: the divider rendered but the group was not centred; the pin stayed at the strip's leading edge. Cause, read from Firefox's `xul.css`: `[flex="1"] { flex: 1 !important; }`, an agent-origin `!important` that outranks the user sheet, so `flex: 0 1 auto` on `#tabbrowser-arrowscrollbox` was ignored. Replaced with `max-width: max-content`, which leaves the forced flex-grow in place but stops it at the tabs' width. Not yet confirmed live.
- Second live check: `max-width: max-content` collapsed `#tabbrowser-arrowscrollbox` to almost nothing (only its scroll arrows showed), because the arrowscrollbox's intrinsic width resolves near zero: its scrollbox and slot are flex items with a zero flex basis. Reverted the joint centering; pins sit at the leading edge with the divider, and ordinary tabs centre in the remaining space. Centering pins with the tabs is open; see options in the chat.
- Third attempt (user asked to try CSS once more): restored joint centering with `max-width: max-content` on `#tabbrowser-arrowscrollbox`, plus `flex: 1 0 auto !important` on its `::part(items-wrapper)` slot (shadow author rule, so a user `!important` wins) on the theory that the slot's zero basis made the measured width near zero. `min-width: min(300px, 100%)` is a floor so a failed measurement leaves a 300px strip rather than a collapsed one. The scrollbox between host and slot still has the agent-forced `flex: 1`, which may keep the measurement wrong. Not yet confirmed live.
- Third attempt, live result: pins and tabs centred together, so the slot override fixed the measurement. Two side effects: tabs measured at their content (selected tab at its 300px minimum, others at title width), and the 300px floor left a gap after the divider when a pin was selected. Fix: inside the pins block, unselected unpinned tabs get `width: var(--tab-max-width)` and the selected tab `width: 480px`. These only feed the intrinsic measurement; layout still follows the flex basis. Floor reduced to one minimum tab width. Not yet confirmed live.
- Correction to the third attempt: the "almost" result was the 300px min-width floor, not a working measurement. Lowering the floor to one tab width collapsed the strip to that width, showing the intrinsic width still resolves near zero; the `::part(items-wrapper)` basis override had no effect, so the agent-forced `flex: 1` on the inner scrollbox is the likely cause. Reverted to pins at the leading edge with the divider. Remaining CSS-only option: compute the strip's width from counted tabs.
- User direction after the revert: keep pins at the leading edge, as Safari does; when a pin is selected, ordinary tabs move left to sit beside the divider. Implemented with `justify-content: flex-start` on the unpinned scrollbox parts and zero leading margins while `#pinned-tabs-container` holds the selected tab. Joint centering dropped.
- Later the same day the 1100px minimum was removed, so "Narrow windows" above no longer falls back; pins behave the same at every width.
