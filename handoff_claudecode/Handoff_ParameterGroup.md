# Elemental Design — Claude Code Handoff Prompt

Copy and paste this entire prompt into a new Claude Code session.

---

You are continuing work on **Elemental Design** — a native macOS and iOS design tool built in SwiftUI.

## Your first action

Read `CLAUDE.md` at the project root, then read `STATUS.md`. These two files together tell you exactly where the project stands and what needs to happen next. Do not write any code until you have read both.

## What exists

A `specs/` folder with six complete specification documents, a working Swift data model layer, and a test file. The project compiles. The data model was implemented from an earlier version of `Spec_ObjectModel.md` and is now behind the current spec.

## Your task this session

**Bring `ParameterGroup.swift` up to date with `Spec_ObjectModel.md` v0.5.**

The following parameter types are currently stubbed out with comments in `ParameterGroup.swift`. Implement each one fully from the spec:

1. `TextParameter` — content, styleRole (display/title/body/label/mono), truncation (clip/ellipsis/none), maxLines
2. `ImageParameter` — source (URL?), fitMode (fill/fit/tile)
3. `IconParameter` — asset (SF Symbol name), size (small/medium/large)
4. `ShadowParameter` — kind (drop/inner), color, radius, offsetX, offsetY, opacity
5. `BorderParameter` — color, width, position (inside/center/outside), style (solid/dashed/dotted)
6. `AnimationParameter` — preset (none/fade/slide/scale), direction (up/down/left/right), duration (0.1–0.6, default 0.25)
7. `AccessibilityParameter` — label (String?), hint (String?), trait (button/image/header/link/none)

The following existing types also need updating:

8. `StructureParameters` — add `scalesWithContent: Bool` (default `true` for all subtypes)
9. `ElementalEdgeInsets` — add `unit: PaddingUnit` (`.pt` or `.relative`, default `.pt`)

After implementing the types:
- Uncomment the stubbed properties in `ContentParameters` and `BehaviorParameters`
- Update `ParameterGroup.defaults(for:)` to include the new parameters with correct defaults from §8 of the spec
- Update `ObjectModelTests.swift` to cover the new parameter types — at minimum: default values, codable round-trip, and the scalesWithContent behavior

## Rules

- Read `Spec_ObjectModel.md` before writing any code — the spec is the source of truth
- All naming must match the spec exactly
- All constraints explicit in the spec (ranges, defaults, rules) must be enforced or documented in code comments
- Do not implement any UI — this is the data model layer only
- If you encounter anything that is underspecified or contradictory, stop and report it rather than inventing behavior
- Update `STATUS.md` when the task is complete
