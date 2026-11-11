# Firefox notes

How Firefox 160's interface behaves where it matters for this theme. Most of this was read from the shipped source or measured in a running Firefox.

## Reading Firefox's source

The shipped interface lives in `/Applications/Firefox.app/Contents/Resources/browser/omni.ja` (browser UI, tab CSS, `browser.xhtml`) and `.../Resources/omni.ja` (toolkit, `xul.css`, `moz-src/` modules such as the urlbar providers). Python's `zipfile` rejects them ("Bad magic number for central directory"); `unzip -q <file> -d <dir>` extracts them with warnings. Useful files:

- `chrome/browser/content/browser/browser.xhtml`: toolbar and panel markup.
- `chrome/browser/content/browser/tabbrowser/tab.mjs`: tab markup.
- `chrome/browser/skin/classic/browser/tabbrowser/tabs.css`, `tab.tokens.css`: tab sizing and variables.
- `chrome/browser/content/browser/browser-places.js`, `browser.js`: bookmarking and `ConfirmationHint`.

## Structure

- `#TabsToolbar` and `#nav-bar` are sibling toolbars in `#navigator-toolbox`. The theme lays the toolbox out as a grid and overlays the navigation bar on the tab row.
- Ordinary tabs are children of `#tabbrowser-arrowscrollbox`; pins live in a separate `#pinned-tabs-container` before it.
- `tab-group` is `display: contents`. Its first rendered box is `.tab-group-label-container`, so anything aimed at "the first item in the row" must target the chip when a group comes first.
- Tab content order: icon stack, audio button, label container, note icon, Close. Firefox's favicon end margin (`--tab-icon-margin-inline-end`, 5.5px) is on the images inside `.tab-icon-stack`, not on the stack.
- The label fades over its last `--tab-label-mask-size` (1em, 2em on hover) when the title overflows.

## Cascade

- `userChrome.css` is a user-origin sheet: a user `!important` beats Firefox's author `!important`.
- Firefox's own `xul.css` is agent origin. Its `[flex="1"] { flex: 1 !important; }` cannot be overridden by a theme.
- `::part()` works from `userChrome.css` only as a plain top-level selector; nested inside `:is()` it is ignored.

## Anchor positioning

- `anchor-name`, `position-anchor`, `anchor()`, `anchor-size()` and `position-visibility` all work on browser interface elements.
- Anchor names set through `::part()` do not resolve.
- When the anchor scrolls, the anchored box only translates; insets and clamps such as `max()` against another anchor are not recomputed. A field clamped to the visible strip therefore slides under the scroll arrows.
- When the anchor element moves (tab reorder) without its anchor name changing, the anchored box can stay at the old spot. Removing the name during a drag (`[movingtab]`) and re-adding it on drop forces a fresh lookup.

## Tab strip

- `#tabbrowser-arrowscrollbox::part(scrollbox)` has `contain: inline-size`, so the strip's intrinsic width measures as near zero. `max-content` sizing of the strip collapses it, which is why pins and tabs cannot be centred together in CSS.
- `[overflowing]` on the arrowscrollbox is set by Firefox's overflow events and can lag behind a resize.
- `position: sticky` on the selected tab works inside the scrollport and keeps it fully visible while the strip scrolls.
- Firefox hides `.titlebar-spacer[type="post-tabs"]` at 500px and below, so the theme replaces it with a margin.
- A selected tab carries `[selected]`; drags set `[movingtab]` on `#tabbrowser-tabs` and `[dragtarget]` on the dragged tab or group chip.

## Address field

- `browser.urlbar.scotchBonnet.enableOverride` (on by default) also switches on `trimHttps` and `untrimOnUserInteraction` regardless of their own values. `trimWww` is a plain pref and stays off unless set. There is no domain-only display.
- The search-engine switcher's "Search with" row is controlled by `browser.urlbar.suggest.engines`. `browser.urlbar.contextualSearch.enabled` has no effect in 160 because `browser.urlbar.scotchBonnet.enableOverride` overrides it.
- Cmd+D needs the bookmark star to have a nonzero layout box, so the star is kept as an invisible 1×12px out-of-flow box instead of `display: none`.
- Container queries work on the anchored `#urlbar-container` (`container: ct-field / inline-size`), which is how page actions hide by field width.

## Window types

- Popup windows (`window.open` without a toolbar) get `popup-window` on the root; extension popups `web-extension-popup-window`; chromeless windows `chromeless-window`. They still contain a tab strip with a selected tab, so a layout keyed only on the selected tab also matches them.
- Private windows have `privatebrowsingmode="temporary"` on the root. With Nova (`browser.nova.enabled`, on in 160) the indicator is `.private-browsing-indicator-button`, a toolbar button at the end of `#TabsToolbar`; the labelled `.private-browsing-indicator-with-label` is hidden.

## Split view, density, vertical tabs, dragging

- Split view (`browser.tabs.splitView.enabled`, on in 160) wraps two tabs in `tab-split-view-wrapper`: a two-column grid, `[hasactivetab]` when it holds the selected tab, `max-width: var(--tab-max-width)`. A widened selected tab spills out of it unless the wrapper is widened too. `gBrowser.addTabSplitView([tabA, tabB])` creates one.
- `gUIDensity` in `browser.js` auto-compacts under Nova when `browser.uidensity` has no user value: if `36 / innerHeight > browser.compactmode.auto.threshold` (0.05, so under 720px tall) or, with the sidebar launcher collapsed, `56 / innerWidth > 0.05` (under 1120px wide). It sets `uidensity="compact"` on the root.
- Vertical tabs (`sidebar.verticalTabs`) read `--tab-min-height` and `--tab-margin-block` from `:root` too; they use `--tab-margin-block-vertical` (2px). Root overrides meant for the horizontal row have to be wrapped in `@media not -moz-pref("sidebar.verticalTabs")`.
- `xul.css` makes every `toolbar` draggable (`-moz-window-dragging: drag`) and `toolbaritem`, `toolbarbutton`, `tab`, `input` and similar no-drag. `<tabs id="tabbrowser-tabs">` is not on the no-drag list, so empty strip space drags the window. The property is not readable through `getComputedStyle`.
- Container tabs draw `.tab-context-line` inside `.tab-background` (Nova: 2px, `--tab-context-line-block-offset` from the top). Multi-selected tabs get `[multiselected]`.
- Tab notes are off by default (`browser.tabs.notes.enabled=false`).

## Tab states

- A loading tab has `busy` on `.tabbrowser-tab`. No load percentage is exposed as an attribute.
- Sound state (`soundplaying`, `muted`, `activemedia-blocked`) is on the tab and copied to `.tab-audio-button`, a `moz-button` whose glyph is a `background-image` on `::part(button)`. Firefox only shows it on unpinned horizontal tabs; pinned tabs get a badge on `.tab-icon-overlay` instead.

## Popups

- `ConfirmationHint` ("Saved to bookmarks") anchors to the Library or Bookmarks Menu button if either is in the toolbar, otherwise to the application menu button, opening `bottomleft topleft`. It stops showing once `browser.bookmarks.editDialog.confirmationHintShowCount` reaches 3.
- Panels use `--popup-border-radius` and `--panel-menuitem-border-radius`; `menupopup` uses `--menuitem-border-radius`.

## Toolbar widgets

- `#unified-extensions-button` is `removable="false"`, so it is hidden with CSS.
- The VPN button is a CustomizableUI widget whose removal callback stops the VPN proxy. The theme only hides it with CSS.
- Firefox's `»` overflow menu is driven by JavaScript measuring the navigation bar. Buttons the theme positions with `position: fixed` never count as overflowing.

## Measuring a layout

For questions that need real coordinates, a headless Firefox with a throwaway profile and Marionette works: launch with `-headless -marionette -profile <temp>` and `MOZ_REMOTE_ALLOW_SYSTEM_ACCESS=1`, switch to the chrome context, and read `getBoundingClientRect()` of interface elements. Delete the temp profile afterwards.
