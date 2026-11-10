# Consolidated prototype plan

## Outcome of the first research pass

Firefox offers a plausible path to the requested layout while preserving its native icons. [Local Safari Compact inspection](LOCAL-SAFARI-REFERENCE.md) now provides direct visual observations and approximate screenshot geometry. The full visual survey remains incomplete for narrow, pinned, dark and overflow states, and historical Safari 18 fidelity is unverified.

The research produced three tracks in one workflow: [Safari survey](SAFARI-SURVEY.md), [Firefox feasibility](FIREFOX-FEASIBILITY.md), and [validation](VALIDATION.md).

## Next steps within the same workflow

1. Use the user-authorized local Safari Compact layout as the working visual reference. Complete narrow, pinned, dark and overflow observations and establish capture scale before claiming measured fidelity. Obtain Safari 18 imagery only if strict historical matching is needed.
2. Capture a Firefox 159 baseline in a separate development profile, including native Compact density.
3. Run two small CSS experiments: an integrated toolbar/tab row, and selected-tab CSS anchoring. Preserve native iconography, address handling and site identity controls.
4. Choose the prototype architecture from those results. Selected-tab integration remains an open priority decision; the default is to test it separately while establishing overall layout.
5. Refine control reserves, row height, tab widths, gaps and alignment against the reference. Test narrow/crowded states early, followed by light/dark and focus states.
6. Deliver versioned CSS, visual comparison evidence, installation/rollback instructions and documented limitations.

## Decisions made

- Firefox is the first implementation target.
- Firefox icons remain intact.
- Native browser controls are reused wherever possible.
- No existing theme is adopted wholesale.
- CSS anchor positioning is worth a test before assuming privileged JavaScript is needed.
- Implementation has begun in `compact-tabs-dev` only. Geometry CSS is installed; single-row and anchor-probe modes are prepared but unverified.

## Remaining blockers

- Exact logical Safari dimensions and the remaining state matrix still need verification; local screenshot estimates are available.
- Git initialization now succeeds. No remote has been requested.
- The profile manager's launch action produced no visible result; user launch of `compact-tabs-dev` is needed before visual validation. Computer Use blocks Terminal, so that launch route was not used.

See the README for the isolated-profile launch command and mode installation/rollback.
