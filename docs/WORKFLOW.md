# Coordinated workflow

## Research stage

Three independent investigations feed one prototype plan:

| Track | Question | Output |
| --- | --- | --- |
| Safari survey | What makes the Sequoia compact tab bar feel balanced? | Geometry, spacing, visual hierarchy, state behavior and source confidence |
| Firefox feasibility | Which Firefox mechanisms can reproduce that layout while retaining Firefox icons? | Architecture options, prior art, constraints and small experiments |
| Validation | How do we judge resemblance and usability without an oversized test project? | Reference matrix, manual checks and isolated-profile procedure |

## Synthesis gate

Record confirmed observations separately from estimates. Resolve source/version conflicts. Establish the smallest useful prototype, the address-field experiment, and the Firefox/macOS test environment. Carry unresolved evidence gaps forward explicitly.

## Prototype and refinement

Build in an isolated Firefox profile. Compare equivalent reference states at consistent logical window sizes. Iterate on toolbar height, control reserves, tab widths, gaps, alignment, and focus behavior. Preserve Firefox iconography and browser functionality.

## Delivery

Document tested versions, installation, rollback, known limitations, and the update maintenance process. Add meaningful visual evidence before claiming a close match.

## Repository initialization

`git init -b main` succeeded after automatic approval review became available. No remote has been configured.
