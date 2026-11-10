# Project brief

## Confirmed direction

- Reference: macOS Sequoia / Safari 18 compact tab layout, before Liquid Glass.
- Primary target: Firefox on macOS. Chrome feasibility is background context, not a second implementation target yet.
- Highest priorities: toolbar layout, spacing, proportions, and visual balance.
- Retain Firefox icons rather than replacing them with Safari symbols.
- Keep research, decisions, implementation, and verification in this repository.
- Use one coordinated workflow.

## Open decisions

- Whether the first prototype must integrate the real address field with the selected tab, or can establish overall layout first.
- Exact Firefox build and macOS version to support, to be recorded before implementation validation.
- Reference screenshots and their provenance; distinguish observed geometry from proposed theme values.

## Working approach

Use native Firefox controls wherever possible. Research CSS feasibility before adding privileged scripting. Treat the active-tab/address-field integration as an explicit experiment rather than assuming it is either impossible or solved.

No normal browser profile should be changed during research. Prototype validation should use a separate profile. Native security indicators, address editing, and keyboard navigation need to remain usable.

## Research deliverables

- `SAFARI-SURVEY.md`: visual structure, proportions, state changes, evidence and confidence.
- `FIREFOX-FEASIBILITY.md`: implementation options, prior art and targeted experiments.
- `VALIDATION.md`: reference captures and visual/interaction checks.
- `PROTOTYPE-PLAN.md`: consolidated recommendation and next implementation steps.
