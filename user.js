// Compact Tabs: Firefox preferences the theme depends on.
// install.sh adds these to the profile's user.js as a marked block, leaving
// any other lines alone; uninstall.sh removes the block. To install by hand,
// copy these lines into user.js in your profile folder.

// Load userChrome.css at all.
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// No "Search with <engine>" button under the default search row. In Firefox
// 160, browser.urlbar.contextualSearch.enabled is overridden by
// browser.urlbar.scotchBonnet.enableOverride, so this is the effective switch.
user_pref("browser.urlbar.suggest.engines", false);

// Normal density, chosen explicitly. With Nova, Firefox 160 switches to
// compact density on its own in windows under 720px tall (or narrow ones with
// the sidebar launcher collapsed), changing sizes mid-resize. Any explicit
// value turns that off.
user_pref("browser.uidensity", 0);

// Show "wikipedia.org" rather than "www.wikipedia.org", closer to Safari's
// domain display. Firefox 160 already hides "https://" and restores the full
// address on click (browser.urlbar.scotchBonnet.enableOverride, on by default).
user_pref("browser.urlbar.trimWww", true);

// Dragging a tab over another reorders only; it never creates a tab group.
// Groups are still available from the tab context menu.
user_pref("browser.tabs.dragDrop.createGroup.enabled", false);

// No "Saved to bookmarks" note. Firefox shows it for the first three
// bookmarks only and anchors it to the menu button at the window's right
// edge, where it runs off the window; a count of 3 means it never opens.
user_pref("browser.bookmarks.editDialog.confirmationHintShowCount", 3);
