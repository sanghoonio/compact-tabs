# Compact Tabs

A Firefox `userChrome.css` theme that recreates Safari's compact tab bar on macOS Sequoia (Safari 18, before Liquid Glass): one row, with the real Firefox address field living inside the selected tab. Layout, spacing and balance come from Safari; icons and behaviour stay Firefox's.

**Requires** macOS and Firefox 160 or later (tested on Firefox 160.0, macOS 15.7.4). Pure CSS: no scripts run inside Firefox.

## Install

```sh
git clone https://github.com/sanghoonio/compact-tabs.git
cd compact-tabs
./install.sh
```

It lists your Firefox profiles and asks which one to use (or name it: `./install.sh --profile default-release`). Then restart Firefox. Run it again after pulling updates.

To remove it:

```sh
./uninstall.sh
```

Quit Firefox first, so the uninstaller can also reset the theme's prefs to Firefox's defaults; if Firefox is running it removes the theme and tells you to run it again.

**What the installer changes,** in the chosen profile only:

- copies `chrome/compact-tabs/` into the profile's `chrome/` folder;
- adds two `@import` lines at the top of `chrome/userChrome.css`, between `/* BEGIN compact-tabs */` and `/* END compact-tabs */`, creating the file if needed;
- adds the prefs from [`user.js`](user.js) at the end of the profile's `user.js`, between `// BEGIN compact-tabs` and `// END compact-tabs`.

Anything else in those files is left alone, and the uninstaller removes exactly those blocks. Options: `--profile NAME`, `--profile-path DIR`, `--yes` (no prompt), and for `install.sh`, `--dev` (also adds the Browser Toolbox prefs from `scripts/dev-prefs.js`).

### Manual install

1. In `about:support`, click **Open Folder** next to **Profile Folder**.
2. Copy this repo's `chrome` folder into it. If the profile already has a `chrome/userChrome.css`, copy only `chrome/compact-tabs/` and put the two `@import` lines from this repo's `userChrome.css` at the very top of yours.
3. Copy the lines from [`user.js`](user.js) into the profile's `user.js` (create it if missing), or set the same prefs in `about:config`.
4. Restart Firefox.

### Prefs

- `toolkit.legacyUserProfileCustomizations.stylesheets=true`: load `userChrome.css` at all.
- `browser.urlbar.suggest.engines=false`: no "Search with <engine>" row when typed text matches an engine name.
- `browser.uidensity=0`: normal density, chosen explicitly. Otherwise Firefox switches itself to compact density in windows under 720px tall, or narrower than 1120px with the sidebar launcher collapsed.
- `browser.urlbar.trimWww=true`: `wikipedia.org` instead of `www.wikipedia.org`. Firefox 160 already hides `https://` and shows the full address again when you click in.
- `browser.tabs.dragDrop.createGroup.enabled=false`: holding a dragged tab over another reorders, never creates a group. Groups still come from the tab context menu.
- `browser.bookmarks.editDialog.confirmationHintShowCount=3`: the "Saved to bookmarks" note never opens. Firefox anchors it to the menu button at the window's right edge, where it runs off the window.

### Options

- `compact-tabs.two-rows` (boolean, create it in `about:config`): `true` keeps Firefox's two rows (tabs above, toolbar below) with the rest of the styling. Takes effect immediately.

## Files

- `chrome/userChrome.css`: imports the two stylesheets.
- `chrome/compact-tabs/base.css`: everything except the one-row layout: tab proportions, Close placement, address-field icon order, toolbar button sizing, dropdowns, hidden controls.
- `chrome/compact-tabs/one-row.css`: the one-row layout. macOS only, needs CSS anchor positioning, and steps aside for Customize Toolbar, webpage/video fullscreen, popup windows and the two-rows option.
- `user.js`: required prefs. `scripts/dev-prefs.js`: Browser Toolbox prefs for development.
- `install.sh`, `uninstall.sh`, `scripts/common.sh`: installer.
- `docs/`: [brief](docs/BRIEF.md), [Safari reference](docs/SAFARI-REFERENCE.md), [Firefox notes](docs/FIREFOX-NOTES.md), [manual checks](docs/VALIDATION.md).
- `plans/`: dated plans and implementation logs.

## Development

Work in a separate profile so your everyday one is untouched. The author's is named `compact-tabs-dev`:

```sh
/Applications/Firefox.app/Contents/MacOS/firefox -no-remote -P compact-tabs-dev
./install.sh --profile compact-tabs-dev --dev --yes
```

Reinstall after each change and restart that profile. The Browser Toolbox (Tools > Browser Tools) inspects Firefox's own interface.

## Layout

**Row.** Traffic lights, Sidebar, Back/Forward, the tabs, then New Tab, List All Tabs and the application menu, all in one 48px row. Tab surfaces are 28px tall with 6px corners and 10px gaps. Back and Forward each hide when unavailable. Downloads and up to three pinned extension buttons line up left of New Tab when shown, and the tabs narrow equally on both sides to stay centred. Account, VPN, the Extensions button and the bookmark star are hidden by CSS (⌘D and the Bookmarks menu still work; extensions are in `about:addons`). Customize Toolbar, webpage/video fullscreen and popup windows (sign-in windows, `window.open` without a toolbar, extension popups) use Firefox's normal layout. In private windows, Firefox's private-browsing button sits left of New Tab. macOS window fullscreen keeps the compact row.

**Tabs.** Tabs are centred on the window. The selected tab is 300–480px wide (minimum 25% of the window when narrow); a lone tab gets about 40% of the window. Other tabs shrink to a 44px favicon cell; once fewer than about two title characters would show, the title is dropped and the favicon centred. Close replaces the favicon at the leading edge, as in Safari: always on the selected tab, and on other tabs only while the cursor is over the favicon. Tab hover previews are hidden.

**Address field.** The real `#urlbar` sits over the selected tab, after its Close button, with Reload/Stop at the tab's trailing edge. While the tab plays sound, is muted or has blocked media, Firefox's sound button sits just before Reload; clicking it mutes or unmutes. It follows selection. Text comes first; site identity, tracking protection, permissions and page actions sit at the trailing end on a 20px pitch with 12px glyphs. Icons never squeeze: the text gives way first, then page actions other than Reader View hide below a 110px field, and Reader View below 90px (the field excludes Reload and the sound button); the shield and permission icons always stay. The search-engine switcher is hidden; `@` shortcuts still enter search modes. Editing draws one focus outline round the whole tab. Suggestions open 4px below the tab, centred on it and 6px wider each side, with dense rows and an accent-coloured selection (spacing in the `--ct-suggestions-*` variables).

**Narrow windows.** The one-row layout applies at every width. Spacing scales with the window: the gap between each button group and the tabs runs from 8px at 600px to 24px at 1200px, and the padding that centres the tabs on the window grows from 0 at 600px until fully balanced. When tabs still do not fit, Firefox's scroll arrows appear. The selected tab then stays sticky inside the visible strip, painted with the toolbar material so it covers tabs scrolled beneath it, which keeps the address field and Reload fully visible.

**Pinned tabs.** Pins sit at the leading edge with a 1×16px divider after the last one. A selected pin widens like any selected tab, with the address field and no Close. While a pin is selected, ordinary tabs line up right after the divider instead of centring, as Safari does.

**Split view.** The pair holding the selected tab is as wide as a selected tab plus a favicon cell; the selected tab gets three quarters of it, with the field. Other pairs compress to two favicon cells.

**Tab groups.** Groups stay in the row. The name chip and collapsed "+N" counter are 28px with 6px corners and tab gaps; the group's coloured line sits 3px below the tab surfaces.

**Dragging.** While a tab is dragged, the address field and Reload hide and the selected tab shows its own title; they come back on drop. The centred row shifts by half a tab while one is lifted, since CSS cannot reserve the dragged tab's width.

**Buttons and menus.** Every toolbar button's hover square is 28px (a 16px icon with 6px padding), 8px apart. Icon hover uses the system accent colour (`--ct-icon-hover-color`); Close hover uses Firefox's red (`--ct-close-hover-color`). Firefox-drawn dropdowns (application menu, List All Tabs, Downloads, in-page `panel-list` menus) use 6px panel corners, 5px item highlights and full-width separators. Context menus and the menu bar are native macOS menus.

**Materials.** The tab and bookmarks rows use Firefox's translucent toolbar layer, the same as the sidebar launcher. Tab labels and address text share one size (root + 1pt). Background windows fade the whole compact row, as macOS fades a titlebar.

**Vertical tabs.** With vertical tabs on, the one-row layout switches off and Firefox's toolbar returns; tabs keep Firefox's own height and spacing. Container tabs show Firefox's coloured line inside the tab surface; several selected tabs share the selected tab's shading.

## Known limits

- **Scroll arrows can linger** after widening a window, until Firefox re-checks overflow.
- **Many permission icons** in a very narrow selected tab can still run into Reload, because those icons never hide.
- **No overflow menu.** Safari moves its trailing buttons into a `»` menu in narrow windows. CSS cannot move buttons into a menu, and Firefox's own overflow never fires for these fixed buttons.
- **Domain only is not possible.** Safari shows just the domain until you click in; Firefox can only trim `https://` and `www.`.
- **Sound in favicon-only tabs.** Firefox's sound button sits beside the favicon, so a playing background tab narrower than its favicon plus the button may clip it.
- **Toolbar layout is assumed.** The offsets assume Sidebar, Back, Forward on the left and New Tab, List All Tabs, Menu on the right. Other customizations may collide.
- **Not checked by eye yet:** the group line and chip alignment, `@`-mode label spacing, the sticky selected tab's backing in a background window, the fullscreen traffic-light reveal, and dragging the window from empty space in the row (it should work; Firefox marks only buttons, fields and tabs as non-draggable).

## License

MIT. See [LICENSE](LICENSE).
