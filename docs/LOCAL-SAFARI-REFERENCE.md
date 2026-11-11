# Local Safari Compact reference

## Inspection

Safari native-app access succeeded after the account switch. The first attempt timed out; a retry returned the app's accessibility tree and screenshots. No policy error was returned on retry. This establishes current access, not the cause of the earlier policy block.

The application bundle was previously identified as Safari 26.3 on macOS 15.7.4. These observations describe the user's local reference appearance; they do not establish Safari 18 version fidelity. The user authorized the installed browser as a reference.

The accessibility tree explicitly reports `TabBar?isSeparate=false`. Inactive tabs contain favicon and title elements; the selected tab contains `WEB_BROWSER_ADDRESS_AND_SEARCH_FIELD`. This directly confirms integration of the real address field into the selected tab in this local layout.

## Observed states

- Original wide window: seven ordinary tabs, selected tab at the right; native controls and tabs share one row.
- Separate reference window: one tab, then three tabs, using Example Domain, Mozilla and Wikipedia.
- Three tabs with rightmost selection, then middle selection and Command-L focus.
- Closed the reference window and removed the extra Start Page tab created by the initial New Window shortcut. Original seven-tab window and selection restored.

No Safari settings were changed. Screenshots were inspected in the conversation, not saved in the repository. The reference windows are now closed.

## Approximate screenshot geometry

These values are visual estimates from a 1,378 × 828 returned window screenshot. Units are **returned image pixels**, not verified CSS pixels or macOS points. Allow approximately 1–3 pixels uncertainty on straight boundaries and more on rounded edges. Screenshot scaling metadata was not available.

| Feature | Observation |
| --- | --- |
| Common control/tab vertical center | Approximately y=26 |
| Tab cell vertical extent | Approximately y=12–40, about 28 pixels tall |
| Corner radius | Visually about 6 pixels; estimate only |
| Window control centers | Approximately x=26, 46, 66; about 20-pixel pitch |
| Sidebar center | Approximately x=107 |
| Back control center when available | Approximately x=169 |
| Trailing action centers | Approximately x=1276, 1312, 1350 |
| Single-tab address field | Approximately x=411–967, width 556; centered near window midpoint |
| Three-tab inactive cells | Approximately x=309–457 and x=469–617; widths about 148 |
| Three-tab active cell, rightmost | Approximately x=629–1068; width about 439 |
| Tab gaps | Approximately 12 pixels in this three-tab state |
| Three-tab group bounds | Approximately x=309–1068, visually centered in the window |
| Middle-tab selection | Active field moves to approximately x=469–908; right inactive tab shifts to approximately x=920–1068 |

The nearly 3:1 active/inactive width ratio is an observation in this one three-tab configuration, not a universal width rule. The single-tab field is wider. The original crowded window also presents a different ratio, so the layout is adaptive.

The toolbar/content boundary is not consistently visible when their backgrounds match. Do not infer toolbar height from tab height alone. The former 40–48-unit toolbar proposal remains a proposal.

## Visual hierarchy

- Wide empty shoulders around a centered tab group contribute strongly to balance. Filling all unused width with tabs would miss this quality in low-tab-count windows.
- Inactive cells have quiet pale fills and modest rounding; the selected address cell has a stronger gray fill. The shape is a shallow rounded rectangle rather than a full-height capsule.
- Inactive titles sit beside favicons and truncate with an ellipsis. Labels appear left aligned within each cell.
- The single-tab resting domain appears centered; in the three-tab active field the domain appears toward the leading side. Do not assume one text-alignment rule for all states.
- Controls are largely unbezeled at rest and share the tabs' vertical center.
- Command-L selects the URL and adds a blue focus outline around the existing active cell. It does not introduce another toolbar row. In the inspected state, the field does not visibly need to expand further to edit.
- Selecting another tab transfers the wide editable cell into that tab's list position and reallocates the neighboring cells.

## Implications for Firefox

Start with shallow cells, a shared vertical center, quiet inactive fills, and deliberate free space. Preserve Firefox glyphs, site identity controls and URL behavior. A one-row layout with every tab equally stretched would reproduce neither the observed hierarchy nor the empty-space balance.

Test flexible active-cell allocation separately from moving the real Firefox URL bar. CSS anchoring may solve alignment but does not by itself reserve space in the tab list, resolve clipping or handle hit testing. Those need independent checks.

## Still to inspect

Narrow windows, pinned tabs, dark appearance, hover/close states, tab dragging, suggestion panels, overflow and focused/inactive window differences remain unmeasured. The original wide window lacked visible traffic lights while the separate normal window showed them; do not assert a fullscreen state without verifying it.

## Follow-up: narrow and pinned states

A second temporary normal window used three Example Domain tabs. It was resized from a returned screenshot width of 1,378 to approximately 852 image pixels. Tab height remained approximately 28 image pixels and the vertical center remained about y=26.

At the narrow width, the two inactive cells remained about 148 pixels wide, while the active rightmost field shrank to approximately 250 pixels (x=477–727). The group moved closer to the leading controls. This directly shows that the earlier 3:1 active/inactive ratio is not a fixed rule.

Pinning the first survey tab through Window > Pin Tab demonstrated two states:

- Active pin: the real address field still appears inside the pinned tab; in this narrow configuration its cell was approximately 177 image pixels wide.
- Inactive pin: a favicon-only cell approximately 32 pixels wide (x=161–193), followed by a subtle vertical divider. Selecting an ordinary tab restored a larger address field there.

The pin was explicitly removed and the accessibility tree confirmed all three survey tabs were unpinned. Closing the temporary window was attempted, but both the close action and the subsequent observation timed out; final closure could not be confirmed. Existing user tabs were not edited. Dark, overflow, drag, suggestion-panel and window-focus states remain outstanding.

## Follow-up: centered groups and fullscreen reference (2026-11-11)

Temporary Safari windows with one, two, three and six tabs confirmed centered groups with growing occupancy. In the roughly 1512-point-wide window, inactive tabs were approximately 148pt wide and selected fields with multiple tabs approximately 480pt wide. A single field occupied roughly 40% of the window. These are screenshot estimates, not AX frame measurements.

The user supplied a fullscreen reveal screenshot showing the native traffic lights inline at the leading edge of the compact toolbar, before Sidebar and the tab group. They do not occupy an additional strip above that row. Earlier claims about the reveal based on app-only screenshots were inconclusive and should not be treated as verified.

The second user-supplied reference shows balanced horizontal whitespace around the traffic-light group: window edge → red light and green light → sidebar glyph. Match the visible edge spacing, preserving Firefox’s sidebar icon and native window controls.
