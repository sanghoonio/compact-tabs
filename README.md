# Compact Tabs

Compact Tabs is a Firefox `userChrome.css` theme that recreates the compact tab bar of Safari 18 on macOS Sequoia, before Liquid Glass. Tabs and toolbar share one row, and Firefox's own address field sits inside the selected tab. Layout, spacing and balance follow Safari. Icons and behavior stay Firefox's.

It requires macOS and Firefox 160 or later, and was tested on Firefox 160.0 with macOS 15.7.4. It is pure CSS, so no scripts run inside Firefox.

## Install

```sh
git clone https://github.com/sanghoonio/compact-tabs.git
cd compact-tabs
./install.sh
```

The installer lists your Firefox profiles and asks which one to use. To skip the question, name the profile, for example `./install.sh --profile default-release`. Restart Firefox afterward, and run the installer again after pulling updates.

## Uninstall

```sh
./uninstall.sh
```

Quit Firefox first. The uninstaller then also resets the theme's preferences to Firefox's defaults, except the bookmark message count, so the "Saved to bookmarks" message stays off. If Firefox is running, it removes the theme and asks you to quit and run it again.

## What the installer changes

Only the chosen profile is changed. The installer:

- copies `chrome/compact-tabs/` into the profile's `chrome/` folder
- adds two `@import` lines at the top of the profile's `chrome/userChrome.css`, between `/* BEGIN compact-tabs */` and `/* END compact-tabs */`, and creates the file if it does not exist
- adds the preferences from [`user.js`](user.js) at the end of the profile's `user.js`, between `// BEGIN compact-tabs` and `// END compact-tabs`

Anything else in those files is left as it is, and the uninstaller removes exactly those blocks. Both scripts accept `--profile NAME`, `--profile-path DIR` and `--yes` (no confirmation). `install.sh --dev` also adds the Browser Toolbox preferences from `scripts/dev-prefs.js`.

## Manual install

1. In `about:support`, click **Open Folder** next to **Profile Folder**.
2. Copy this repo's `chrome` folder into it. If the profile already has a `chrome/userChrome.css`, copy only `chrome/compact-tabs/`, and put the two `@import` lines from this repo's `userChrome.css` at the very top of yours.
3. Copy the lines from [`user.js`](user.js) into the profile's `user.js` (create it if it does not exist), or set the same preferences in `about:config`.
4. Restart Firefox.

## Preferences the theme sets

- `toolkit.legacyUserProfileCustomizations.stylesheets=true` makes Firefox load `userChrome.css`.
- `browser.urlbar.suggest.engines=false` removes the "Search with <engine>" row that appears when typed text matches a search engine's name.
- `browser.uidensity=0` keeps normal density. Without it, Firefox switches itself to compact density in windows under 720px tall, or under 1120px wide when the sidebar launcher is collapsed.
- `browser.urlbar.trimWww=true` shows `wikipedia.org` instead of `www.wikipedia.org`. Firefox 160 already hides `https://` and shows the full address when you click into the field.
- `browser.tabs.dragDrop.createGroup.enabled=false` stops a tab held over another during a drag from creating a tab group. Groups can still be created from the tab context menu.
- `browser.bookmarks.editDialog.confirmationHintShowCount=3` stops the "Saved to bookmarks" message, which Firefox attaches to the menu button at the window's right edge, where it runs off the window.

## Options

Set `compact-tabs.two-rows` to `true` in `about:config` (create it as a boolean) to keep Firefox's two rows, tabs above the toolbar, with the rest of the styling. The change applies immediately.

## Known limitations

- After a window is widened, the scroll arrows can stay until Firefox rechecks whether the tabs overflow.
- In a very narrow selected tab, many permission icons can run into Reload, because those icons never hide.
- Safari moves its trailing buttons into a `»` menu in narrow windows. CSS cannot move buttons into a menu, and Firefox's own overflow menu never picks up these buttons.
- In fullscreen, Safari shows the window buttons inside its toolbar row when the menu bar slides down. Firefox shows them in a separate strip above the toolbar, which CSS cannot change, so the row keeps its full width instead of making room for them.
- Safari shows only the domain until you click into the field. Firefox can only hide `https://` and `www.`.
- A background tab that plays sound and has shrunk to its favicon may cut off its sound button.
- The layout assumes Firefox's default toolbar buttons: Sidebar, Back and Forward on the left, New Tab, List All Tabs and the menu on the right. Other toolbar customizations may overlap.
- Not yet checked by eye: the alignment of the group line with the group name and counter, the spacing around `@` search mode labels, the selected tab's background in an inactive window while tabs scroll, and dragging the window by empty space in the row.

## Files

- `chrome/userChrome.css` imports the two stylesheets.
- `chrome/compact-tabs/base.css` holds everything except the single-row layout: tab proportions, Close placement, address field icon order, button sizes, dropdowns and hidden buttons.
- `chrome/compact-tabs/one-row.css` holds the single-row layout. It applies on macOS only.
- `user.js` lists the required preferences, and `scripts/dev-prefs.js` the development ones.
- `install.sh`, `uninstall.sh` and `scripts/common.sh` make up the installer.
- `docs/` holds the [brief](docs/BRIEF.md), the [Safari reference](docs/SAFARI-REFERENCE.md), [notes on Firefox internals](docs/FIREFOX-NOTES.md) and a [checklist of manual checks](docs/VALIDATION.md).
- `plans/` holds dated plans and implementation logs.

## Development

Work in a separate Firefox profile so your everyday one is untouched. The author's is named `compact-tabs-dev`.

```sh
/Applications/Firefox.app/Contents/MacOS/firefox -no-remote -P compact-tabs-dev
./install.sh --profile compact-tabs-dev --dev --yes
```

Reinstall after each change and restart that profile. The Browser Toolbox (Tools > Browser Tools) inspects Firefox's own interface.

## License

MIT. See [LICENSE](LICENSE).
