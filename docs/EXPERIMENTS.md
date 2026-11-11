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
- The first hover normalization forced Back, Forward and List all tabs to 28px backgrounds. The user correctly observed that this was smaller than other toolbar buttons. This approach is superseded by the native-metric correction below.
- List all tabs now captures the root navigation-toolbar inner padding before TabsToolbar overrides it based on tab height. Its background uses `16px + 2 * native inner padding`, inspected at approximately 32px in normal density, while Back/Forward revert to untouched native styling. Its outer target spans the full 48px row with native horizontal padding so the background is not squeezed by the old 36px target's 4px padding. Native hover/pressed colors are inherited rather than approximated. The dev profile was restarted; its larger active background was visually inspected and the popup opened successfully, then dismissed.
- Fixed the clipped focus surface reported by the user. Firefox's native joint URL-input/results background expands past the input and clips at a seam; in our anchored layout it produced a second shape ending before Reload/Close. Integrated mode now hides only `.urlbar-background`, removes input growth and input-local outlines, and draws a 2px inset focus outline on the complete selected tab. The native results view remains functional but paints an independent rounded panel 6px below the input. Live inspection with the long Mozilla Support URL fully selected showed one complete outline including Reload/Close and a separate suggestions panel, without the expanded/clipped background. The native two-row fallback is unchanged.

- Tightened integrated trailing controls to 22px horizontal slots, including page actions (translation/reader mode), Reload/Stop and the selected tab close button. Reload retains its 12px glyph; Close also remains 12px. Reduced the reserved Reload area to match. Restarted compact-tabs-dev and visually checked Reader View, Reload and Close together on the Mozilla Support article; translation was not visible on that page.

- Refined spacing to 10px between tab surfaces and before New Tab, preserving inactive surface width. Trailing action slots are now 20px, with 12px page-action glyphs including Reader Mode and translation. The translation locale badge is reduced to 16px with compact margins; its active multi-part button retains automatic width. Reader Mode and translation were visually checked together on French Wikipedia after restarting the dev profile. The translated badge state remains unverified. Account remains before List All Tabs and the menu, as requested.

- Removed the early three-tab integration limit after opening a fourth tab reproduced a separate navigation row. Four-tab New Tab selection and opening a fifth tab now keep the real search input and toolbar icons in the selected tab. Entering example.com in the fifth tab navigated successfully; the added test tab was closed, leaving the user’s original four tabs. Native overflowing tab sets remain unverified. This supersedes the earlier four-tab fallback observations.

- Corrected the sidebar spacing interpretation: restored its native icon padding/hover dimensions to match other toolbar controls and reduced the separate navigation-group-to-tabs reserve to 24px plus history width. Removed macOS Firefox’s 1.25em URL-bar font scaling in integrated mode, using the root/tab-label size and inherited input font. Tab and bookmarks rows now have transparent backgrounds over the same toolbox theme material. Restarted compact-tabs-dev and visually compared focused URL text with inactive labels, navigation with Back visible, and the bookmarks row on New Tab.

- Matched the minimum New Tab-to-right-controls gap to the navigation-group-to-tabs gap with `--ct-navigation-tab-spacing`, compensating for native trailing spacers. Bookmarks toolbar icons are 12px. Reproduced the bookmark shortcut failure with the star removed from layout; Firefox’s `panelAnchorNodeForAction` requires a nonzero visible-layout anchor. The star now remains transparent, out of flow, and noninteractive with a 1×12px anchor rect. After restarting compact-tabs-dev, Cmd+D opened the Add bookmark dialog on French Wikipedia. Smaller bookmark icons and the group spacing were inspected live.

- Hid the dev profile’s bookmarks toolbar with the native Cmd+Shift+B control; it stayed hidden after restart. Home settings showed New tabs = Blank Page; this setting was left unchanged. Added an inactive-main-window visibility guard for `#editBookmarkPanel`. Cmd+D still opened Edit bookmark while Firefox was active; a temporary Finder window showed no bookmark overlay, then was closed. The popup remained available when returning to Firefox and was dismissed with Escape. This is a visibility guard, not a change to native popup lifecycle or window level. Firefox updated itself to 160 during this restart and opened its What’s New tab.

- Enabled compact integration for macOS window fullscreen by removing the `[inFullscreen]` exclusion while preserving the `[inDOMFullscreen]` exclusion for webpage/video fullscreen. Adjusted the leading reserve when macOS removes traffic-light spacing, and anchored the trailing group to the toolbox top rather than viewport y=0. Installed and reopened compact-tabs-dev. Live fullscreen verification is pending because regular default-release is also running and the native UI connector selects that process instead. Neither regular-profile theme files nor its settings were changed.

- Corrected the fullscreen leading treatment from the supplied Safari screenshot: retain the native TabsToolbar window-button box and pre-tab reserve in the compact row rather than moving navigation into that space. Center the actual arrowscrollbox scrollbox with safe centering and compensate for unequal leading/trailing reserves. Selected tabs can reach 480px with multiple tabs, and the single-tab field approximately 40vw. Installed and restarted compact-tabs-dev. Visual verification remains pending because CUA continues selecting default-release even after the dev process is activated; no regular-profile theme files were modified.

- After the user quit regular Firefox, CUA accessed compact-tabs-dev reliably. Scrollbox justification alone did not center the tab surfaces; automatic margins on the first tab and trailing periphery did. Removed the trailing toolbar spring, let the tabs box fill the available width, and balanced its padding for the unequal control groups. Inspected centered one- and two-tab groups after restarts. Native macOS fullscreen retained the single compact row and centered two-tab group. The connector did not reveal the fullscreen traffic lights at the top edge, so their revealed placement remains unverified. Returned to the normal window and closed the temporary New Tab.

- Corrected the second Safari reference spacing after initially moving the sidebar inward, which was the wrong interpretation. Restored navigation’s 80px leading reserve and increased the native traffic-light box’s leading margin from 12px to 20px. The lights move inward by 8px while the sidebar retains its earlier position. The normal-window screenshot showed approximately equal 21 CSS-pixel visible gaps before the red light and after the green light. Subsequently set both visible gaps to the user-requested 25px: native light-box margin 24px, navigation leading padding 88px, with matching tab-reserve compensation. Restarted and visually checked the 25px spacing. The final user adjustment supersedes that: 20px before red and 28px after green, using a 19px light-box margin and 86px navigation leading padding. Installed, restarted, and visually checked these final gaps. Compensated the tab reserve to preserve the centered field. Installed and restarted only compact-tabs-dev; no commit was created.

Screenshots were visually inspected in the conversation; exported evidence artifacts have not been saved. Coordinate dragging returned noWindowsAvailable, so the native Window menu was used for resizing.

## Remaining verification and refinement

Pinned selections, tab groups, native fullscreen traffic-light reveal, customization, dark appearance, tab drag/reorder, unusual site identity/permission indicators, and enlarged text remain unverified. Right-clicking the active address area opens the URL context menu, as expected for a real input; full selected-tab context/drag affordances need review. Low-count tab groups are now centered. The layout retains Firefox's default toolbar palette; neutral materials remain a future design pass.

The theme no longer falls back solely based on ordinary tab count; large overflowing tab sets still require validation. No claim of historical Safari 18 pixel fidelity is made.

## Toolbar source details

Shipped `browser.xhtml` marks `#unified-extensions-button` as `removable="false"`, whereas List all tabs is removable. Shipped `IPProtection.sys.mjs` defines `ipprotection-button` as a CustomizableUI widget. Its removal callback stops the VPN proxy if the widget is removed rather than moved. This prototype only hides the VPN button with CSS; it does not remove the widget, change VPN preferences, or change the proxy state. For manual toolbar changes use Customize Toolbar; the CSS visibility rule must also be removed if the user wants that button visible outside customization.

Latest spacing adjustment: retain 20px before red and 27px from green to the sidebar glyph. The sidebar-to-Back gap was initially matched to 27px, then reduced to the user-requested 24px by reducing the sidebar’s extra trailing margin from 6px to 3px and compensating the history reserve. Preserve the native sidebar hover target dimensions. Account for the added spacing in the history reserve and centered tab layout. Installed, restarted compact-tabs-dev, and visually checked with Back visible.

Sized the direct `.urlbar-go-button` image to a 12px glyph in the same 20px action slot as the other in-tab controls. Removed its hover background and applied the shared icon hover color. Installed and restarted compact-tabs-dev, restored its previous two-tab session through History, and inspected the arrow with temporary unsubmitted search text. Cancelled the edit and returned to the existing Google tab.

Restored the original sidebar-to-Back spacing at the user’s request by removing the extra trailing sidebar margin and restoring the 72px/36px history reserves. Kept the 27px green-to-sidebar gap and 20px before red. Installed, restarted compact-tabs-dev, and visually checked.

Reduced the green-to-sidebar gap from 27px to 26px, preserving the original sidebar-to-Back gap and the 20px leading red inset. Installed, restarted the dev profile, restored its two tabs, and visually checked.

Current spacing: 20px before red, 25px after green, original sidebar-to-Back spacing. Reduced the green gap by another 1px at the user’s request; installed, restarted, restored the two tabs, and visually checked.
