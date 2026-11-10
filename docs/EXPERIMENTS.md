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
- History arrows use independent visibility per the user's final correction: each unavailable direction is hidden. The integrated reserve is 0px, 36px or 72px. This restores the earlier tested behavior; the paired-visibility change was superseded. Current live checks again show Forward alone on the Example Domain tab and Back alone on About Profiles.
- Reload/Stop now uses the existing `#stop-reload-button`, CSS-anchored to the selected tab's trailing address-field area. The star is hidden and input space reserved for Reload. Clicking the relocated Reload reloaded Example Domain; switching to About Profiles moved the control with the address field. In fallback layouts it remains in the native navigation toolbar. A slow-load Stop transition is not yet visually tested.
- Bookmark star, VPN and the non-removable Extensions hub are hidden by CSS. Site identity and translation controls remain. Extensions can be managed via about:addons; bookmarks via Command-D or the menu. Customize Toolbar can still expose the hidden toolbar buttons.
- List all tabs now has a fixed trailing slot between the account button and the application menu in integrated mode, with matching space reserved in the navigation target. Its popover opened successfully; the inspected wide layout showed no overlap.
- In-tab identity, search-mode, page-action, Reload/Stop and close controls now have transparent button surfaces, including hover/press backgrounds. The user's clarification was to remove surfaces only: prior padding, glyph sizes and target sizes are retained. The Firefox identity label no longer has an inner pill. Identity/translation panels opened during the styling pass; the final spacing-preserving revision retained the same handlers. The final revision's Command-L focus ring and suggestions were inspected, and Reload was clicked successfully. Security labels, glyphs and status colors are retained.
- Subsequent sizing request: security/identity, translation and Reload glyphs are reduced to 12px, comparable to the close glyph, without reducing their click targets. Reload uses 8px internal padding inside its existing 28px target. Hover/focus-visible colors those glyphs with the system AccentColor through `--ct-icon-hover-color`; close hover uses the same token. No button background is reintroduced. The updated build was installed and restarted in compact-tabs-dev; small security and Reload glyphs were visually inspected, and the site-information control still opened its secure-connection panel. Exact hover-color appearance was obscured by the Computer Use pointer overlay and remains a manual visual check, as does the translation hover color.
- Tab preview cards are suppressed through `#tab-preview-panel { display: none !important; }`, without changing Firefox preferences. Inactive-tab inspection showed no preview card after switching selection by keyboard while leaving the pointer at the preceding tab.
- Tab cells and the adjacent New Tab button now share a 6px surface gap, implemented as 3px insets on each side. Inactive tab maximum width was reduced by the same 6px delta to preserve its previous visible surface width. Address-field and Reload anchors use the shared inset rather than the old hardcoded 6px inset. Screenshot inspection showed roughly 6px between tab surfaces and the matching adjacent-button gap. New Tab was not repositioned.
- Back, Forward and List all tabs now share an explicit 28px plate, 6px corner radius, and common native hover/pressed background tokens. List all tabs retains a separate 36px outer target in integrated mode. Its popup opened successfully after reload; its rounded active plate was inspected and the popup dismissed.

Screenshots were visually inspected in the conversation; exported evidence artifacts have not been saved. Coordinate dragging returned noWindowsAvailable, so the native Window menu was used for resizing.

## Remaining verification and refinement

Pinned selections, tab groups, fullscreen, customization, dark appearance, tab drag/reorder, unusual site identity/permission indicators, and enlarged text remain unverified. Right-clicking the active address area opens the URL context menu, as expected for a real input; full selected-tab context/drag affordances need review. The layout is still visually left weighted at low tab counts and retains Firefox's default toolbar palette; center balance and neutral materials are the next design pass.

The theme intentionally falls back rather than offering compact integration for large tab sets at this stage. No claim of historical Safari 18 pixel fidelity is made.

## Toolbar source details

Shipped `browser.xhtml` marks `#unified-extensions-button` as `removable="false"`, whereas List all tabs is removable. Shipped `IPProtection.sys.mjs` defines `ipprotection-button` as a CustomizableUI widget. Its removal callback stops the VPN proxy if the widget is removed rather than moved. This prototype only hides the VPN button with CSS; it does not remove the widget, change VPN preferences, or change the proxy state. For manual toolbar changes use Customize Toolbar; the CSS visibility rule must also be removed if the user wants that button visible outside customization.
