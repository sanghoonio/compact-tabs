# Manual checks

Run in `compact-tabs-dev` after installing and restarting. Environment: macOS 15.7.4, Firefox 160.0; reference Safari 26.3 in Compact mode.

## Layout

| State | Check |
| --- | --- |
| One tab, wide window | Field about 40% of the window, centred; equal space either side |
| Four tabs, wide | 10px gaps; selected tab 300–480px; group centred on the window |
| Drag the window from 1200px to 600px | Spacing changes smoothly, no jumps; inactive tabs drop to centred favicons |
| Many tabs, narrow | Scroll arrows appear; selected tab stays fully visible and covers tabs behind it; field and Reload never under an arrow |
| Pin a tab, select it | One row; pin widens with the field, no Close; ordinary tabs sit right after the divider |
| Select an ordinary tab with pins | Pin shrinks to a favicon cell; ordinary tabs centred |
| Split view (two tabs, right-click > split) | Pair holds both tabs; selected one has the field; switching sides moves it |
| Tab group from the context menu | Chip and "+N" match tab height; line 3px under tabs, level with chip and counter lines |
| Downloads button visible | Sits left of New Tab without overlap; tabs stay centred |
| Private window (⇧⌘P) | Purple private button left of New Tab; nothing under ☰; tabs centred |
| Popup window (a site's sign-in popup) | Firefox's normal layout with a visible address field |
| Background window | Whole row fades evenly, including the selected tab's backing when tabs scroll |
| macOS window fullscreen | Compact row kept; traffic lights reveal inline |
| Drag the window by empty space in the row; double-click it | Window moves; double-click zooms |

## Behaviour

- Selecting a tab moves the field and Reload to it; Reload works.
- ⌘L selects the URL; one focus outline round the tab; suggestions open below it, centred.
- `@bookmarks` shows the search-mode label with even spacing to the icons beside it.
- Hover a background tab's favicon: Close appears only over the favicon; text does not shift.
- Drag to reorder: field hides during the drag and returns to the selected tab on drop; no group is created.
- Play a video: speaker before Reload on the selected tab; click mutes and shows the muted icon. Same on a selected pin.
- Address shows `wikipedia.org` without `https://www.`; clicking in shows the full address.
- Narrow selected tab: icons stay 20px apart; translate hides first, then Reader View.
- ⌘D opens the bookmark dialog; no "Saved to bookmarks" note.
- Customize Toolbar shows Firefox's normal layout; leaving it restores the compact row.
- `compact-tabs.two-rows` set to `true` in `about:config`: Firefox's two rows return at once with the rest of the styling; `false` restores the one row.
- `./uninstall.sh` with Firefox closed, then start it: stock Firefox returns, and `about:config` shows the theme's prefs at their defaults.
