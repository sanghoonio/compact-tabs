# Experiment status

## Current state

- Git initialized on `main`.
- Created `compact-tabs-dev` through `about:profiles`.
- Restored `default-release` as the default after the creation wizard changed it.
- Enabled stylesheet loading through the development profile's `user.js` only.
- Initially installed `geometry`; currently running `selected-address` mode in the development profile.
- User launched the isolated instance. Computer Use initially attached to the regular instance. Closing the regular instance allowed attachment to the development instance. After restart, rebind the app and verify identity; stale connections can select another process or return no windows. No Terminal automation was used.

## Source inspection

Read the installed Firefox browser archive's local ZIP records into temporary files, because generic ZIP tools could not read its optimized central directory. The shipped `browser.xhtml` confirms sibling `#TabsToolbar` and `#nav-bar` containers, horizontal `#tabbrowser-tabs`, selected-tab attributes and the real `#urlbar-container`. Shipped tab CSS includes a native 225px maximum tab width and 76px minimum before extra icons. Proposed theme values override these only in horizontal mode.

Extracted source files remain outside the repository in `/private/tmp/compact-tabs-source`. No Firefox application files were modified.

## Results ledger

| Experiment | Prepared | Installed | Visually verified |
| --- | --- | --- | --- |
| Geometry baseline | Yes | Previously | Yes, shallow tab cells after correcting the native margin variable |
| Single shared row | Yes | Previously | Yes; native toolbars occupy one row |
| Selected-tab anchor marker | Yes | Previously | Yes; marker moved from right tab to middle tab |
| Real URL bar follows selected tab | Yes | Current development mode | Yes; selection, editing, suggestions, navigation and tab closure |

The single-row experiment tests grid layout of native sibling toolbars. It intentionally retains a separate real address field, so even success will not establish Safari-style selected-tab integration.

The anchor marker established alignment across browser UI containers. The selected-address experiment then reserved more width for the selected tab and positioned the real `#urlbar-container` against it. It preserves the tab close button and Firefox's native URL controls. This uses no privileged JavaScript.

The first integrated rendering exposed overlapping trailing actions and displaced traffic lights. Moving tab reserves onto the toolbar-items container, preserving native titlebar reserve, and giving the navigation target an explicit flex layout corrected the inspected wide-window arrangement.

Avoid switching the entire layout based on the native `overflow` attribute: changing tab width can change that attribute, making the layout condition self-invalidating. The current experiment uses a stable tab-count guard instead: four or more ordinary sibling tabs or any tab group use the baseline layout.

## Completed verification

Installer dry run resolves exactly one named development profile. A temporary-profile smoke check verified installation modes, no-write dry run, removal of the managed entry stylesheet, and refusal to overwrite an unrelated stylesheet. Local documentation links checked.

Live observations in Firefox 159.0.1:

- `about:profiles` explicitly identified compact-tabs-dev as the current profile, with default-release still the default.
- Selected-address layout rendered in one roughly 48px row at a returned screenshot width of 1280px.
- Selecting a different ordinary tab moved the real address field into that tab's position.
- Command-L selected the actual URL; native suggestions appeared beneath the relocated input without clipping in the inspected state.
- Typing `https://example.org` and pressing Return loaded that URL.
- Command-W closed the selected tab and moved the address field to the remaining selection.
- Native Window > Move & Resize > Left produced a roughly 950px-wide window; the layout returned to two rows. Return to Previous Size restored integration.
- Adding a fourth ordinary tab triggered two rows. Closing it restored one-row integration at three tabs. Temporary extra tabs were removed afterward.
- Unavailable Back and Forward buttons are hidden outside toolbar customization. With neither history direction available, both disappeared; navigating to another URL revealed Back only; returning to the initial URL revealed Forward only. The integrated tab reserve adjusts by 36px per available history action, reclaiming the hidden controls' space.

Screenshots were visually inspected in the conversation; exported evidence artifacts have not been saved. Coordinate dragging returned noWindowsAvailable, so the native Window menu was used for resizing.

## Remaining verification and refinement

Pinned selections, tab groups, fullscreen, customization, dark appearance, tab drag/reorder, unusual site identity/permission indicators, and enlarged text remain unverified. Right-clicking the active address area opens the URL context menu, as expected for a real input; full selected-tab context/drag affordances need review. The layout is still visually left weighted at low tab counts and retains Firefox's default toolbar palette; center balance and neutral materials are the next design pass.

The theme intentionally falls back rather than offering compact integration for large tab sets at this stage. No claim of historical Safari 18 pixel fidelity is made.
