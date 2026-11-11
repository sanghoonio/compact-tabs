# Project brief

## Direction

- **Reference:** Safari's compact tab layout on macOS Sequoia, before Liquid Glass. The working reference is the locally installed Safari 26.3 in Compact mode ([observations](SAFARI-REFERENCE.md)); it is not frozen Safari 18 imagery.
- **Target:** Firefox on macOS. Chrome is out of scope.
- **Priorities:** toolbar layout, spacing, proportions and visual balance.
- **Icons:** keep Firefox's icons and their meaning; do not transplant Safari symbols.
- **Always one row.** Never fall back to two rows for narrow windows, many tabs, pins or groups. Only Customize Toolbar, webpage/video fullscreen and popup windows use Firefox's normal layout.
- **Real controls.** The address field in the selected tab is Firefox's own `#urlbar`, positioned with CSS anchor positioning. Site identity, address editing, suggestions and keyboard navigation stay native.
- **CSS only.** No privileged startup scripts or autoconfig.
- **Isolated profile.** Development happens in `compact-tabs-dev`; the regular profile is only touched by an explicit install.
- **Shareable.** Conventional layout (`chrome/`, `user.js`, `install.sh`, `uninstall.sh`), MIT licensed.

## Decisions

| Decision | Reason |
| --- | --- |
| Address field anchored to the selected tab | Anchor positioning works in Firefox's own interface; no JavaScript needed. |
| Close replaces the favicon at the leading edge | Matches Safari; avoids text shifting when Close appears. |
| Pins at the leading edge with a divider, not centred with the tabs | Matches Safari. Centring pins and tabs together is not possible in CSS (see [Firefox notes](FIREFOX-NOTES.md)). |
| Tab groups supported in the row; drag-to-group off | The user's choice over disabling groups. Accidental groups came from slow drags. |
| Search-engine switcher and "Search with" row hidden | Searches use the default engine; `@` shortcuts remain. |
| Sticky selected tab when tabs overflow | Anchored boxes do not re-clamp on scroll, so the tab itself is kept inside the visible strip. |
| Continuous spacing, no width breakpoints | Avoids jumps while resizing. |
