---
date: 2026-11-11
status: complete
model: Claude Opus 5.5
description: Keep the one-row compact layout working when Firefox 160 tab groups exist
---

# Tab groups in the compact layout

## Problem

`experiments/selected-address.css` switches the whole window back to the native two-row layout whenever any `tab-group` exists (`:not(:has(#tabbrowser-tabs tab-group))` on the toolbox). Firefox 160 creates a group when a dragged tab is held over another tab for 240 ms (`browser.tabs.dragDrop.createGroup.delayMS`), so a slow drag silently flips the window into two rows. The user chose to support groups in the compact layout rather than disable them.

## How Firefox 160 builds a group (read from the shipped omni.ja)

- `tab-group` (`MozTabbrowserTabGroup`, `tabbrowser/tabgroup.mjs`) is a direct child of `#tabbrowser-arrowscrollbox`. Its tabs are its own light-DOM children, slotted between a `.tab-group-label-container` (the coloured name chip) and a `.tab-group-overflow-count-container` ("+N").
- States: `[collapsed]`, `[hasactivetab]`, `[hasmultipletabs]`. A collapsed group that contains the selected tab keeps that tab visible and shows "+N" for the rest.
- Label size comes from `--tab-group-label-size`, which defaults to `--tab-min-height`; the theme sets that to 28px, so the chip already matches tab height.
- A coloured line (`--tab-group-line-thickness`, 2px) runs under the group's tabs.
- During a drag, Firefox sets `[movingtab]`, `[movingtab-group]`, `[movingtab-ungroup]` and `[movingtab-addToGroup]` on `#tabbrowser-tabs`, and `[dragtarget]` on the dragged tab or `.tab-group-label-container`.
- Split view (`tab-split-view-wrapper`) is a second wrapper type that can sit in the same row.

## What has to change

1. **Remove the group guard** so the integrated layout stays on with groups present.
2. **Centering margin.** The leading `margin-inline-start: auto` currently goes on the first `.tabbrowser-tab` in the row. With groups, the first item in the row can be a `tab-group` (its label comes first) or a split-view wrapper, and tabs inside a group are not children of the arrowscrollbox. Move the margin to the first in-row item of any kind: `:nth-child(1 of :is(.tabbrowser-tab, tab-group, tab-split-view-wrapper):not([dragtarget], [hidden]))`.
3. **Single-tab rule.** `&:not(:has(.tabbrowser-tab ~ .tabbrowser-tab))` treats "no sibling tabs" as "one tab". A lone group holding two tabs passes that test, so the 40vw single-tab width would wrongly apply. Count tabs across the whole strip instead: apply the rule only when the strip has exactly one tab, with or without groups.
4. **Group chip styling.** Fit the label chip and "+N" counter to the compact row: 28px tall, `--ct-radius` corners, `--ct-tab-gap` spacing before and after, vertically centred with the tab surfaces.
5. **Group line.** The native line sits under the tabs relative to the native tab margins. The theme changes `--tab-margin-block` to 10px, so the line has to be repositioned to sit just under the 28px surfaces rather than at the row's bottom edge.
6. **Selected tab inside a group.** The anchored address field already follows `.tabbrowser-tab[selected]` wherever it is. Check that the wider selected tab (300–480px) inside a group doesn't clip the group line or label, and that a collapsed group with the active tab still shows the address field over that tab.
7. **Tab group CSS in fallback mode.** `geometry.css` alone (narrow windows) also needs the chip and line adjustments, or groups look wrong there too.

## Decisions & ownership

| Decision | Owner / status | Note |
| --- | --- | --- |
| Support groups instead of disabling them | user-owned, surfaced | User chose this over disabling groups or blocking drag-to-group only. |
| Keep the centered tab row and patch drag | user-owned, surfaced | Already applied: centering margin no longer travels with a dragged or hidden tab. The half-tab shift at drag start remains; CSS can't know the dragged tab's width to reserve it. |
| Drag-to-group turned off | user-owned, surfaced | `browser.tabs.dragDrop.createGroup.enabled=false` in the dev profile's `user.js`. The half-tab shift at drag start plus the wide selected tab made a still-held drag overlap a neighbour by more than 20%, which created groups by accident. Groups now come only from the tab context menu. |
| Chip and "+N" match tab height and radius | AI-owned, defended | Matches the existing tab cell (28px, 6px radius) so groups read as part of the same row. |
| Line placed directly under tab surfaces | AI-owned, default | Firefox places it relative to its own margins; placing it under our surfaces is a guess at the intended look. Needs a visual check. |
| Split-view wrappers handled by the same centering rule | silently implied | Split view is a different 160 feature, but the centering selector has to name it or a leading split view breaks centering the same way. No other split-view styling is planned. |
| Collapsed-group "+N" counter keeps native colours | AI-owned, default | Only size and radius change. |
| Fallback (`geometry.css`) gets the same chip and line fixes | AI-owned, defended | Otherwise groups look different in narrow windows than wide ones. |

## What this changes elsewhere

- **Drag behaviour with groups.** Dragging a group label lifts `.tab-group-label-container`, not the `tab-group`, so the group itself stays in flow and keeps the centering margin. Expanding or collapsing a group during a drag changes the row's total width, so the centered row re-centres; expect the same half-width shifts as ungrouped drags.
- **Address field position.** Groups add a label chip and gaps before their tabs, which moves tabs right. The address field follows the selected tab, so it moves too, which is expected.
- **Overflow.** Groups make the row longer, so overflow (still unverified per the README) arrives sooner. Safe centering keeps the first item reachable, but the address field may sit over the scroll edge when the selected tab is scrolled partly out of view.
- **README and experiment ledger.** The README's statement that grouped tabs fall back to native behaviour becomes false and must be rewritten.
- **Prefs.** Drag-to-group is already off in `user.js`; this plan adds no further pref changes.

## Verification (user, in the dev profile)

1. Create a group from the tab context menu with two tabs; the window stays one row, the chip and tabs are centred, the line sits under the tabs.
2. Select a tab inside the group; the address field sits on it. Select a tab outside; it moves.
3. Collapse the group with and without the active tab in it; "+N" appears and the address field stays correct.
4. Drag a tab into and out of an existing group, and drag the group label to reorder. Dragging over an ungrouped tab must not create a group.
5. Narrow the window below 1100px; groups look right in the two-row fallback.
6. A single ungrouped tab still gets the wide centered field; a single group holding two tabs does not.

## Implementation log

2026-11-11, installed in `compact-tabs-dev`, not yet checked live.

- `experiments/selected-address.css`: removed the `tab-group` guard from the toolbox selector. The leading centering margin now goes on the first in-row item of any kind (tab, group, split-view wrapper) that is not dragged or hidden; for a group it lands on `.tab-group-label-container`, because `tab-group` is `display: contents`. The single-tab width rule now also requires that no `tab-group` exists. The selected tab keeps `anchor-name` always, but its 300–480px widening is skipped while Firefox shrinks a dragged collapsed group (`tab-group[collapsed][movingtabgroup]`), since our user-origin `min-width !important` would otherwise beat Firefox's `max-width: 0`.
- `chrome/geometry.css` (both modes): hidden tabs in a collapsed group get `padding-inline: 0`, since the theme's 5px tab inset beats Firefox's `padding: 0` and would leave a 10px gap per hidden tab. Group label chip, hover highlight and "+N" counter use `--ct-radius`; counter is 28px (`--tab-group-counter-size`); label container spacing uses `--ct-tab-inset` on each side; `--tab-group-line-toolbar-border-distance` is set so the line sits 3px under the tab surfaces.
- Not verified: which box `.tab-group-line` is positioned against. Both it and the label/counter `::after` lines use the same distance variable, so they should stay level with each other; the 3px placement assumes they measure from the bottom of the 48px row.
- README and the experiment header comment updated.
- First live report: after reordering by drag, the address field and Reload stayed at the selected tab's pre-drag slot while the tab itself moved. Firefox appears not to re-resolve anchored boxes when the anchor element moves without the anchor name changing. `anchor-name` is now applied only while `#tabbrowser-tabs` lacks `[movingtab]`; during a drag the field and Reload are transparent and the selected tab shows its title, and dropping re-applies the name, forcing a fresh anchor lookup. Not yet confirmed live.
- Drag-to-group turned off through `scripts/prefs.js`, so accidental groups no longer form. The re-anchoring after drops was not reported again. Point 5 of the verification (narrow-window fallback) no longer applies: the one-row layout now runs at every width, so groups are only ever shown in the compact row. Open visual check carried to `docs/VALIDATION.md`: the group line level with the chip and counter lines.
