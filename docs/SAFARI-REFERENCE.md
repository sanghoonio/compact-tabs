# Safari reference

Observations of the locally installed Safari 26.3 in Compact mode on macOS 15.7.4, which the user accepted as the visual reference. It is not verified Safari 18 imagery. Screenshots were inspected during the work and not saved.

## Structure

Safari's accessibility tree reports `TabBar?isSeparate=false`. Inactive tabs contain a favicon and title; the selected tab contains the real `WEB_BROWSER_ADDRESS_AND_SEARCH_FIELD`. Apple documents Compact as moving tabs into the toolbar, with the active tab as the Smart Search field, pinned sites on the left, and a right-side overflow control when toolbar items do not fit.

Sources: [window customization](https://support.apple.com/en-ca/guide/safari/ibrw1012/mac), [Tabs settings](https://support.apple.com/guide/safari/tabs-ibrw1045/mac), [pinned sites](https://support.apple.com/en-bw/guide/safari/ibrw0495694f/mac).

## Geometry

Estimates from screenshots, in returned image pixels unless stated, with about 1–3px uncertainty on straight edges. Screenshot scale was not recorded, so these are proportions, not CSS pixels.

Wide window, 1378 × 828 screenshot:

| Feature | Observation |
| --- | --- |
| Shared vertical centre of controls and tabs | y ≈ 26 |
| Tab cell height | ≈ 28 (y 12–40) |
| Corner radius | ≈ 6 |
| Traffic-light centres | x ≈ 26, 46, 66 (20px pitch) |
| Sidebar / Back centres | x ≈ 107 / 169 |
| Trailing action centres | x ≈ 1276, 1312, 1350 |
| Single-tab field | x 411–967 (556 wide), centred on the window |
| Three tabs: inactive cells | ≈ 148 wide each |
| Three tabs: selected cell | ≈ 439 wide |
| Gaps between tabs | ≈ 12 |
| Three-tab group | x 309–1068, centred on the window |

About 1512pt-wide window, one to six tabs: groups stay centred and grow with tab count; inactive tabs ≈ 148pt, the selected field with several tabs ≈ 480pt, and a single field ≈ 40% of the window.

Narrowed to about 852 image pixels with three tabs: tab height and centre unchanged; inactive cells stayed ≈ 148 while the selected field shrank to ≈ 250, so the active/inactive ratio is adaptive, not fixed.

Pinned tab, narrow window: a selected pin holds the address field (≈ 177 wide there); an inactive pin is a favicon-only cell ≈ 32 wide followed by a subtle vertical divider.

## Visual hierarchy

- Wide empty shoulders around a centred tab group carry much of the balance; tabs do not fill the row when there are few.
- Inactive cells have quiet pale fills and modest rounding; the selected cell is a stronger grey. Shallow rounded rectangles, not capsules.
- Inactive titles sit left-aligned beside favicons and truncate; crowded tabs drop to favicons.
- Controls are unbezeled at rest and share the tabs' vertical centre.
- ⌘L adds a blue focus outline round the existing cell; no extra row appears and the field does not expand.
- Selecting another tab moves the wide field to that tab's position and reallocates the others.
- Close replaces the favicon: always on the selected tab, on hover for others.
- In fullscreen, the revealed traffic lights sit inline at the leading edge of the same row.
- In narrow windows, the trailing buttons collapse into a `»` overflow menu.

## Not observed

Dark appearance, inactive-window materials, page-tinted toolbar, suggestion-panel geometry and drag behaviour were not measured.
