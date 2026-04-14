# Elemental Design — Project Status

Updated: April 13, 2026

---

## Current State: Data Model Complete, Specs Cleaned Up

The data model layer from `Spec_ObjectModel.md` is fully implemented. All specs have been renamed from "Surface" to "Elemental Design" and are in sync with the code. No UI has been built.

---

## What Exists

### Project structure
- `Package.swift` — Swift Package targeting macOS 14+ and iOS 17+
- `specs/` — Six spec files, all using Elemental Design naming
- `ElementalDesign/Models/` — Data model layer (5 files, ~900 lines)
- `ElementalDesignTests/` — Unit tests (1 file, ~500 lines)
- Empty folders scaffolded for `DesignSystem/`, `Agent/`, `Canvas/`, `Panels/`

### Data model files

| File | What it contains |
|------|-----------------|
| `Enums.swift` | `Platform`, `ComponentSubtype`, `RelationshipKind` |
| `Relationship.swift` | `Relationship` struct |
| `ParameterGroup.swift` | All parameter types (see below) and `ParameterGroup` with defaults |
| `ComponentState.swift` | `ComponentState`, `BuiltInState` with subtype applicability |
| `ElementalObject.swift` | `ElementalObject` protocol, `Screen`, `Component`, `AnyElementalObject` |

### Parameter types implemented in `ParameterGroup.swift`

| Type | Status | Notes |
|------|--------|-------|
| `ParameterGroup` | ✅ Complete | Structure/Content/Behavior groups, `defaults(for:)`, `screenDefaults(for:)` |
| `StructureParameters` | ✅ Complete | Includes `scalesWithContent: Bool` (default `true`) |
| `SizeParameter` / `SizeDimension` | ✅ Complete | `.fixed(CGFloat)` and `.hugContent` |
| `PositionParameter` | ✅ Complete | |
| `ElementalEdgeInsets` | ✅ Complete | Includes `unit: PaddingUnit` (`.pt` / `.relative`, default `.pt`) |
| `ElementalAlignment` | ✅ Complete | `.leading`, `.center`, `.trailing` |
| `ContentParameters` | ✅ Complete | All optional content params wired up |
| `ColorParameter` / `ColorFill` | ✅ Complete | `.none`, `.solid`, `.gradient`, `.dynamic` |
| `ElementalColor` | ✅ Complete | RGBA + semantic statics |
| `GradientDefinition` | ✅ Complete | Stops, angle, linear/radial |
| `TextParameter` | ✅ Complete | Content, styleRole, truncation, maxLines |
| `ImageParameter` | ✅ Complete | Source, fitMode (fill/fit/stretch/original) |
| `IconParameter` | ✅ Complete | Name (SF Symbol), size |
| `ShadowParameter` | ✅ Complete | Color, radius, offset, isInner |
| `BorderParameter` | ✅ Complete | Color, width, position (inside/center/outside) |
| `BehaviorParameters` | ✅ Complete | Interaction, animation, accessibility, activeStateName |
| `InteractionParameter` | ✅ Complete | Action (tap/press/swipe/drag), targetID |
| `AnimationParameter` | ✅ Complete | Preset (none/fade/slide/scale), duration |
| `AccessibilityParameter` | ✅ Complete | Label, hint, traits |

### Test coverage

| Area | Tests |
|------|-------|
| Shape defaults (§8) | Size 200×200, padding 16 all, cornerRadius 12, clip on, systemBackground |
| Information defaults (§8) | Hug content, padding 0, cornerRadius 0, clip off, transparent, text present |
| Widget defaults (§8) | Hug content, padding 12h/8v, cornerRadius 8, clip on, systemAccent, tap interaction |
| Screen platform sizes | iOS 390×844, macOS 1280×800, web 1440×900 |
| States (§6) | Default always present, custom states addable, built-in applicability by subtype |
| Nesting (§4) | Screen → Component, deep nesting, tree from §4 example |
| Relationships (§5) | Spatial vs explicit, all four kinds |
| TextParameter | Defaults, custom values, all 5 style roles |
| ImageParameter | Defaults, custom values, all 4 fit modes |
| IconParameter | Defaults, custom values |
| ShadowParameter | Defaults, inner shadow |
| BorderParameter | Defaults, all 3 positions |
| AnimationParameter | Defaults, all 4 presets |
| AccessibilityParameter | Defaults, traits |
| PaddingUnit | Default `.pt`, `.relative` option |
| scalesWithContent | Component default `true`, Screen default `false` |
| Codable round-trip | Component, Screen with children, all content types, animation, accessibility |

---

## What Does Not Exist Yet

- **Any UI** — No SwiftUI views, no panels, no canvas.
- **Agent integration** — No API calls, no system prompt generation.
- **Persistence** — No file save/load beyond Codable conformance.
- **Specs not yet written** — ComponentDocs, PreviewMode, ElementMap.

---

## Spec Cleanup — Completed

All specs now use "Elemental Design" naming consistently. The following changes were made:

1. **`Spec_ObjectModel.md`** — rewritten to v0.3. Added §7.1–7.7 (full parameter type definitions for Text, Image, Icon, Shadow, Border, Animation, Accessibility). Added scalesWithContent and PaddingUnit. §8 expanded with new default rows and Screen defaults table. §9 updated to match implemented code (`ElementalObject`, `AnyElementalObject`).

2. **`Spec_Agent.md`, `Spec_Canvas.md`, `Spec_ProgressiveDisclosure.md`, `Spec_DocumentSystem.md`** — renamed all "Surface" references to "Elemental Design" throughout. Content unchanged.

3. **`Spec_Concept_Surface.md`** — removed. Fully superseded by `Spec_Concept_Elemental.md`.

---

## Next Steps (Suggested)

1. Build the UI shell — three-panel layout with mode bar, empty states, and `>>>` expansion pattern. Handoff prompt ready at `handoff_claudecode/Handoff_ClaudeCode_UIShell.md`.
2. Remaining unwritten specs: ComponentDocs, PreviewMode, ElementMap.
