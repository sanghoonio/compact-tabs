# Firefox feasibility

## Recommendation

Use Firefox's real tabs, URL bar and buttons. Build the integrated row as a small CSS experiment, retaining native Firefox icons. Native Compact density provides a comparison baseline, but does not deliver Safari's one-row layout.

The research agent found a potentially useful alternative to privileged JavaScript: CSS anchor positioning. This makes the earlier assumption that selected-tab following probably needs JavaScript less certain. Test it before choosing an architecture; no browser-chrome compatibility has been demonstrated yet.

## Layout evidence

Current Firefox source places `#tabbrowser-tabs` inside `#TabsToolbar`, and the selected tab has a `selected` attribute. A separate sibling `#nav-bar` contains navigation buttons and `#urlbar-container`.

Source snapshot inspected by the agent: 2026-11-09. Local installed Firefox: 159.0.1. Main-branch source is not a guarantee of identical release markup.

- [Tab toolbar](https://searchfox.org/firefox-main/source/browser/base/content/navigator-toolbox.inc.xhtml#75)
- [Selected-tab markup](https://searchfox.org/firefox-main/source/browser/base/content/navigator-toolbox.inc.xhtml#144)
- [Navigation toolbar](https://searchfox.org/firefox-main/source/browser/base/content/navigator-toolbox.inc.xhtml#238)
- [URL bar container](https://searchfox.org/firefox-main/source/browser/base/content/navigator-toolbox.inc.xhtml#335)

One-row styling must coordinate these separate containers, tab compression, navigation controls, titlebar drag space, overflow and fullscreen.

## Options

| Approach | Use | Limitation |
| --- | --- | --- |
| Native Compact density | Supported baseline for spacing | Retains separate rows |
| Custom CSS integrated row | Main layout experiment | Internal markup and native layout may constrain it |
| CSS anchor-positioned real URL bar | Selected-tab tracking experiment | Unverified across browser chrome, scrolling and clipping |
| Privileged startup JavaScript | Fallback if required integration cannot work through CSS | More installation complexity and dependence on internals |

Mozilla documents native Compact density from Firefox 157: [Compact mode](https://support.mozilla.org/en-US/kb/compact-mode-workaround-firefox). Custom UI CSS can resize/reposition elements but is unsupported and update-sensitive: [Mozilla customization guide](https://support.mozilla.org/en-US/kb/contributors-guide-firefox-advanced-customization).

Firefox 147 added default CSS anchor-positioning support. Web-content support does not establish browser-chrome support: [release notes](https://developer.mozilla.org/en-US/docs/Mozilla/Firefox/Releases/147), [anchor positioning guide](https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Anchor_positioning/Using).

A conventional theme add-on does not expose arbitrary browser-UI rearrangement. The experimental `theme_experiment` mechanism is restricted and is not a stable-release packaging solution: [Mozilla documentation](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/theme_experiment).

## Prior art, inspected 2026-11-10

- [WhiteSurFirefoxThemeMacOS](https://github.com/AdamXweb/WhiteSurFirefoxThemeMacOS): MIT; agent found release v2.0.1 dated 2026-09-01. Useful spacing/proportion reference, with optional compact tab-height styling. Firefox 159 compatibility and exact desired layout are unverified. [Releases](https://github.com/AdamXweb/WhiteSurFirefoxThemeMacOS/releases).
- [Surfox](https://github.com/Zonz-Ly/Surfox): MIT; documents compact layout and centered URL bar using autoconfig files in the Firefox application bundle. README recommends disabling updates; do not adopt that recommendation. Current release compatibility was not established. Architectural reference only.
- [Safari Firefox](https://github.com/gauravrocks009/safari-firefox): claims CSS one-row/expanding-address styling. Current compatibility and suitability were not established. Do not run bundled installers as part of research.

No code has been copied or installed. Confirm licenses and preserve notices if code is later reused.

## Bounded experiments

1. Capture native default and Compact density as baselines in an isolated profile.
2. Arrange existing toolbar controls and tabs into one row; inspect wide/narrow windows before decorative tuning.
3. Test whether a neutral element can anchor to `.tabbrowser-tab[selected]`, following selection, resize and scroll. This is a disposable experiment, not implementation-ready CSS.
4. If anchoring works, test the real URL bar with focus, suggestions, clipping, pinned tabs, tab drag, fullscreen and overflow.
5. Consider privileged scripting only if CSS fails and selected-tab integration is required.
