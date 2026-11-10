# Experiment status

## Current state

- Git initialized on `main`.
- Created `compact-tabs-dev` through `about:profiles`.
- Restored `default-release` as the default after the creation wizard changed it.
- Enabled stylesheet loading through the development profile's `user.js` only.
- Installed `geometry` mode in the development profile.
- Launch-profile button produced no visible result after two attempts. Computer Use rejected Terminal access, so no Terminal launch was attempted.

## Source inspection

Read the installed Firefox browser archive's local ZIP records into temporary files, because generic ZIP tools could not read its optimized central directory. The shipped `browser.xhtml` confirms sibling `#TabsToolbar` and `#nav-bar` containers, horizontal `#tabbrowser-tabs`, selected-tab attributes and the real `#urlbar-container`. Shipped tab CSS includes a native 225px maximum tab width and 76px minimum before extra icons. Proposed theme values override these only in horizontal mode.

Extracted source files remain outside the repository in `/private/tmp/compact-tabs-source`. No Firefox application files were modified.

## Results ledger

| Experiment | Prepared | Installed | Visually verified |
| --- | --- | --- | --- |
| Geometry baseline | Yes | Development profile only | No |
| Single shared row | Yes | No | No |
| Selected-tab anchor marker | Yes | No | No |
| Real URL bar follows selected tab | No | No | No |

The single-row experiment tests grid layout of native sibling toolbars. It intentionally retains a separate real address field, so even success will not establish Safari-style selected-tab integration.

The anchor marker tests alignment without hiding or moving critical browser controls. If it follows selection, test scroll edges, pinning, resize, tab dragging and clipping before trying the real URL bar. It does not reserve tab width by itself.

## Completed verification

Installer dry run resolves exactly one named development profile. A temporary-profile smoke check verified all modes, no-write dry run, removal of the managed entry stylesheet, and refusal to overwrite an unrelated stylesheet. Local documentation links checked. These checks do not establish CSS rendering or interaction correctness.

## Next observation

Launch `compact-tabs-dev` using the README command, verify its identity via `about:profiles`, then capture geometry mode and unmodified baseline. Inspect tab text/close controls at 28px height, traffic lights, narrow windows, pinned tabs and Command-L. Only then run the single-row and anchor modes and record results here.
