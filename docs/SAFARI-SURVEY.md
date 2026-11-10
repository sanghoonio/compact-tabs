# Safari 18 compact tab survey

## Status and evidence quality

Update: local Safari access now works. See [the local reference inspection](LOCAL-SAFARI-REFERENCE.md) for directly observed Compact layout and approximate screenshot geometry. It is Safari 26.3 on Sequoia, accepted by the user as a local visual reference, rather than verified Safari 18 imagery. The initial research limitations below remain relevant to historical version claims.

This is an initial behavioral and layout survey, not a completed visual measurement study. Browser/image access did not render the reference bitmap. Exact spacing, radii, colors, title alignment and tab-width rules remain unverified. Do not treat proposed values below as measured Safari dimensions.

The installed Safari is 26.3, so it cannot establish the requested Safari 18 appearance. Current Apple guides are authoritative about documented behavior but are not frozen evidence of every Safari 18 detail.

## Documented structure

Apple describes Compact as moving tabs into the toolbar, with the active tab serving as the Smart Search field. A preference allows the active webpage to influence the tab-bar background. Another controls whether website titles stay visible when space is limited.

Sources: [Safari window customization](https://support.apple.com/en-ca/guide/safari/ibrw1012/mac), [Safari Tabs settings](https://support.apple.com/guide/safari/tabs-ibrw1045/mac).

Pinned sites occupy the left side of the tab bar. Toolbar customization means the precise action order should not be assumed universal. Apple's current guide documents a right-side overflow control when toolbar items do not fit, plus a fullscreen toolbar visibility option.

Sources: [Pinned sites](https://support.apple.com/en-bw/guide/safari/ibrw0495694f/mac), [Safari toolbar and fullscreen options](https://support.apple.com/en-euro/guide/safari/ibrw1012/26.0/mac/26).

## Implications for visual balance

These are design interpretations to test against actual imagery:

- Use a single integrated row with leading space for window controls and navigation.
- Allocate usable width to the active tab/address field while keeping other tabs identifiable.
- Keep toolbar actions visually quiet at rest; use spacing and alignment to establish groups.
- Prevent tab content from extending underneath the traffic lights.
- Establish a baseline without a visible bookmarks/Favorites bar, which adds another row.
- Preserve Firefox icons and their existing function rather than transplanting Safari symbols.

Apple's [toolbar guidance](https://developer.apple.com/design/human-interface-guidelines/toolbars) supports titlebar-integrated toolbars and quiet, normally unbezeled items, but does not specify Safari's exact geometry.

## Geometry ledger

| Property | Evidence status | Prototype treatment |
| --- | --- | --- |
| Integrated toolbar/tab row | Documented behavior | Required layout direction |
| Row height | Not measured | Explore 40–48 logical units; proposal only |
| Traffic-light reserve | Exact inset not measured | Respect Firefox's actual native titlebar geometry |
| Tab gaps and dividers | Not visually verified | Compare small gaps versus subtle separators |
| Corner radii | Not measured | Tune only after reference inspection |
| Active address-field width | Role documented, width rule unknown | Measure readability and available space experimentally |
| Title alignment and truncation | Exact appearance unverified | Preserve readability; validate against reference |
| Icon size | Safari dimensions unverified | Start from Firefox's native icon sizing |
| Light/dark palette and materials | Exact values unverified | Start from Firefox/macOS appearance, then compare |

Logical units and screenshot pixels are different. At a verified 2× capture scale, 40–48 logical units would span 80–96 image pixels. A screenshot's total dimensions alone do not establish that scale.

## State survey

| State | Known or documented | Unresolved visual detail |
| --- | --- | --- |
| Active tab | Doubles as Smart Search field | Relative width, label/URL arrangement and transition |
| Inactive tabs | Site identity; title visibility preference | Fill, borders, alignment and truncation |
| Crowded tabs | Titles can give way to icons | Compression thresholds and overflow relationship |
| Pinned tabs | Leading side of tab list | Compact-mode cell width and separator treatment |
| Page color enabled | Active page influences toolbar background | Color extraction, contrast and blending rules |
| Light/dark appearance | System appearance is relevant | Exact colors and materials |
| Inactive window | General macOS guidance subdues window presentation | Safari-specific contrast and material changes |
| Address editing | Real editable address/search field | Focus ring, expansion and suggestion positioning |
| Fullscreen | Toolbar can remain shown or hide | Exact compact-mode spacing and reveal behavior |

General system references: [macOS appearance settings](https://support.apple.com/guide/mac-help/change-appearance-settings-mchlp1225/mac), [Apple window guidance](https://developer.apple.com/design/human-interface-guidelines/windows).

## Dated reference candidate

[Safari 18.4 on macOS Sequoia, Wikimedia](https://commons.wikimedia.org/wiki/File:Safari_18.4_screenshot,_on_macOS_Sequoia.png) describes a MacBook Pro screenshot dated April 13, 2025, at 1,389 × 887 pixels. Its bitmap was not successfully rendered during research. Compact mode is not confirmed. This is a provenance lead, not evidence for compact geometry. No screenshot has been copied into this repository.

## Needed to finish the visual survey

Obtain inspectable Safari 18 Compact captures with recorded logical window bounds and display scale:

1. Wide normal window with two or three tabs.
2. Same window narrowed and crowded, including pinned tabs.
3. Representative light and dark states, with page tint off and on.
4. Address field focused, inactive window, and fullscreen.

Measure row height, traffic-light reserve, control spacing, tab insets/gaps/radii, selected-field width, and title/icon centers. Record values with source and scale confidence. Until then, the full visual survey remains incomplete.
