# Compact Tabs

A Firefox `userChrome.css` theme that recreates Safari's compact tab bar on macOS Sequoia (Safari 18, before Liquid Glass): one row, with the real Firefox address field living inside the selected tab. Layout, spacing and balance come from Safari; icons and behaviour stay Firefox's.

Tested in Firefox 160.0 on macOS 15.7.4, in an isolated profile named `compact-tabs-dev`. Your regular profile has no theme CSS installed. It is pure CSS, with no privileged scripts.

## Install

Launch the development profile on its own:

```sh
/Applications/Firefox.app/Contents/MacOS/firefox -no-remote -P compact-tabs-dev
```

Install into it, then restart only that profile:

```sh
python3 scripts/install-dev.py --mode selected-address   # full theme, one row
python3 scripts/install-dev.py --mode geometry           # same styling, Firefox's two rows
python3 scripts/install-dev.py --dry-run                 # show what would change
python3 scripts/install-dev.py --remove                  # roll back
```

The installer only touches the profile named `compact-tabs-dev`, and writes two things there:

- `chrome/userChrome.css`, which imports copies of the stylesheets from `chrome/compact-tabs/`. It refuses to overwrite a `userChrome.css` it did not create.
- A block in `user.js` between `// BEGIN compact-tabs managed prefs` and `// END compact-tabs managed prefs`, holding `scripts/prefs.js`. Only that block is rewritten; other lines stay. If one of these prefs is also set elsewhere in `user.js`, it says so, and the block's value wins.

The prefs:

- `toolkit.legacyUserProfileCustomizations.stylesheets=true`: load `userChrome.css` at all.
- `browser.urlbar.suggest.engines=false`: no "Search with <engine>" row when typed text matches an engine name.
- `browser.urlbar.trimWww=true`: `wikipedia.org` instead of `www.wikipedia.org`. Firefox 160 already hides `https://` and shows the full address again when you click in.
- `browser.tabs.dragDrop.createGroup.enabled=false`: holding a dragged tab over another reorders, never creates a group. Groups still come from the tab context menu.
- `browser.bookmarks.editDialog.confirmationHintShowCount=3`: the "Saved to bookmarks" note never opens. Firefox anchors it to the menu button at the window's right edge, where it runs off the window.
- `devtools.chrome.enabled=true`, `devtools.debugger.remote-enabled=true`: development only, for the Browser Toolbox (Tools > Browser Tools), whose Inspector shows Firefox's own interface.

`--remove` deletes the entry stylesheet and the `user.js` block. If Firefox is not running that profile, it also clears those prefs from `prefs.js` so Firefox's defaults return; otherwise quit Firefox and run it again. Copied CSS and all other profile data stay.

## Files

- `chrome/geometry.css`: everything except the one-row layout. Tab proportions, Close placement, address-field icon order, toolbar button sizing, dropdowns, hidden controls. Applies in both modes.
- `experiments/selected-address.css`: the one-row layout. Only active on macOS, with CSS anchor positioning, outside Customize Toolbar and webpage/video fullscreen.
- `scripts/install-dev.py`, `scripts/prefs.js`: installer and prefs.
- `docs/`: [brief](docs/BRIEF.md), [Safari reference](docs/SAFARI-REFERENCE.md), [Firefox notes](docs/FIREFOX-NOTES.md), [manual checks](docs/VALIDATION.md).
- `plans/`: dated plans and implementation logs.

## Layout

**Row.** Traffic lights, Sidebar, Back/Forward, the tabs, then New Tab, List All Tabs and the application menu, all in one 48px row. Tab surfaces are 28px tall with 6px corners and 10px gaps. Back and Forward each hide when unavailable. Downloads and up to three pinned extension buttons line up left of New Tab when shown, and the tabs narrow equally on both sides to stay centred. Account, VPN, the Extensions button and the bookmark star are hidden by CSS (⌘D and the Bookmarks menu still work; extensions are in `about:addons`). Customize Toolbar, webpage/video fullscreen and popup windows (sign-in windows, `window.open` without a toolbar, extension popups) use Firefox's normal layout. In private windows, Firefox's private-browsing button sits left of New Tab. macOS window fullscreen keeps the compact row.

**Tabs.** Tabs are centred on the window. The selected tab is 300–480px wide (minimum 25% of the window when narrow); a lone tab gets about 40% of the window. Other tabs shrink to a 44px favicon cell; once fewer than about two title characters would show, the title is dropped and the favicon centred. Close replaces the favicon at the leading edge, as in Safari: always on the selected tab, and on other tabs only while the cursor is over the favicon. Tab hover previews are hidden.

**Address field.** The real `#urlbar` sits over the selected tab, after its Close button, with Reload/Stop at the tab's trailing edge. While the tab plays sound, is muted or has blocked media, Firefox's sound button sits just before Reload; clicking it mutes or unmutes. It follows selection. Text comes first; site identity, tracking protection, permissions and page actions sit at the trailing end on a 20px pitch with 12px glyphs. Icons never squeeze: the text gives way first, then page actions other than Reader View hide below a 110px field, and Reader View below 90px (the field excludes Reload and the sound button); the shield and permission icons always stay. The search-engine switcher is hidden; `@` shortcuts still enter search modes. Editing draws one focus outline round the whole tab. Suggestions open 4px below the tab, centred on it and 6px wider each side, with dense rows and an accent-coloured selection (spacing in the `--ct-suggestions-*` variables).

**Narrow windows.** The one-row layout applies at every width. Spacing scales with the window: the gap between each button group and the tabs runs from 8px at 600px to 24px at 1200px, and the padding that centres the tabs on the window grows from 0 at 600px until fully balanced. When tabs still do not fit, Firefox's scroll arrows appear. The selected tab then stays sticky inside the visible strip, painted with the toolbar material so it covers tabs scrolled beneath it, which keeps the address field and Reload fully visible.

**Pinned tabs.** Pins sit at the leading edge with a 1×16px divider after the last one. A selected pin widens like any selected tab, with the address field and no Close. While a pin is selected, ordinary tabs line up right after the divider instead of centring, as Safari does.

**Tab groups.** Groups stay in the row. The name chip and collapsed "+N" counter are 28px with 6px corners and tab gaps; the group's coloured line sits 3px below the tab surfaces.

**Dragging.** While a tab is dragged, the address field and Reload hide and the selected tab shows its own title; they come back on drop. The centred row shifts by half a tab while one is lifted, since CSS cannot reserve the dragged tab's width.

**Buttons and menus.** Every toolbar button's hover square is 28px (a 16px icon with 6px padding), 8px apart. Icon hover uses the system accent colour (`--ct-icon-hover-color`); Close hover uses Firefox's red (`--ct-close-hover-color`). Firefox-drawn dropdowns (application menu, List All Tabs, Downloads, in-page `panel-list` menus) use 6px panel corners, 5px item highlights and full-width separators. Context menus and the menu bar are native macOS menus.

**Materials.** The tab and bookmarks rows use Firefox's translucent toolbar layer, the same as the sidebar launcher. Tab labels and address text share one size (root + 1pt). Background windows fade the whole compact row, as macOS fades a titlebar.

## Known limits

- **Scroll arrows can linger** after widening a window, until Firefox re-checks overflow.
- **Many permission icons** in a very narrow selected tab can still run into Reload, because those icons never hide.
- **No overflow menu.** Safari moves its trailing buttons into a `»` menu in narrow windows. CSS cannot move buttons into a menu, and Firefox's own overflow never fires for these fixed buttons.
- **Domain only is not possible.** Safari shows just the domain until you click in; Firefox can only trim `https://` and `www.`.
- **Sound in favicon-only tabs.** Firefox's sound button sits beside the favicon, so a playing background tab narrower than its favicon plus the button may clip it.
- **Toolbar layout is assumed.** The offsets assume Sidebar, Back, Forward on the left and New Tab, List All Tabs, Menu on the right. Other customizations may collide.
- **Not checked by eye yet:** the group line and chip alignment, `@`-mode label spacing, the sticky selected tab's backing in a background window, dark appearance, and the fullscreen traffic-light reveal.
