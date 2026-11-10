# Prototype validation

## Environment observed

Read from application bundles and `sw_vers` on 2026-11-10:

- macOS 15.7.4, build 24G517.
- Firefox 159.0.1, build 15926.11.2.
- Safari 26.3, build 20623.2.7.18.1.

Installed Safari is newer than the design reference. Its toolbar must not be treated as evidence of Safari 18 styling merely because the OS is Sequoia.

## Reference captures

Compare reference Safari imagery, unmodified Firefox, and the prototype at equivalent logical window dimensions. Record display scale, browser version, appearance, window focus, toolbar configuration, and tab state. Reference screenshots may have unknown metadata; record those gaps rather than deriving exact values from them.

Use a small initial set:

| State | What to inspect |
| --- | --- |
| One tab, wide window | Toolbar height, vertical centers and empty-space balance |
| Four ordinary tabs, wide window | Gaps, label alignment and active/inactive separation |
| Same four tabs, narrow window | Compression, truncation and control collisions |
| Pinned and ordinary tabs, one loading | Pin widths, loading indicator, close controls and alignment |
| Long selected title, second window | Truncation, window focus and consistency |

Check representative wide and narrow states in both light and dark appearance. Add fullscreen and overflow checks before delivery.

## Acceptance checks

- Firefox icons remain recognizable and retain their meaning.
- Controls, labels and favicons share deliberate vertical alignment.
- Active tabs are immediately distinguishable without overwhelming the row.
- Resizing does not overlap controls or make them unreachable.
- Tabs compress and truncate predictably; pinned tabs remain identifiable.
- Address editing, suggestions, site identity indicators, and Command-L work.
- Tab selection, close, reorder, pinning and tab overflow continue to work.
- Restart preserves the customization; disabling it restores the baseline.

These checks establish usability. A claim of measured Safari resemblance additionally requires dated Safari 18 evidence and a comparison at known scale.

## Development profile

Create a separate profile through `about:profiles`, launch it, and verify its identity before any installation. Keep Sync off during iteration. Work with its Root Directory, placing the stylesheet at `chrome/userChrome.css`. Enable `toolkit.legacyUserProfileCustomizations.stylesheets` in that profile and restart.

Rollback: rename/remove that stylesheet or disable the preference, then restart. Avoid deleting profile data as a rollback mechanism. No profile has been created or modified by this research workflow.

Sources: [Mozilla profile management](https://support.mozilla.org/en-US/kb/profile-manager-create-remove-switch-firefox-profiles), [Mozilla advanced customization](https://support.mozilla.org/eu/kb/contributors-guide-firefox-advanced-customization), [Mozilla Configuration Editor](https://support.mozilla.org/en-US/kb/about-config-editor-firefox).
