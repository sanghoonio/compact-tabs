// Firefox preferences the theme depends on. scripts/install-dev.py writes these
// into the profile's user.js as a marked block and touches nothing outside it.

// Load userChrome.css at all.
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// No "Search with <engine>" button under the default search row. In Firefox
// 160, browser.urlbar.contextualSearch.enabled is overridden by
// browser.urlbar.scotchBonnet.enableOverride, so this is the effective switch.
user_pref("browser.urlbar.suggest.engines", false);

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

// Development only: enable the Browser Toolbox (Tools > Browser Tools), whose
// Inspector shows Firefox's own interface instead of the web page.
user_pref("devtools.chrome.enabled", true);
user_pref("devtools.debugger.remote-enabled", true);
