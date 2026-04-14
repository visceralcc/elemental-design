# Elemental Design — Project Status

Updated: April 14, 2026

---

## Current State: UI Shell Complete

The data model layer and the UI shell are both fully implemented. The app builds and runs, showing the three-panel layout with mode bar, empty states, and mode switching. No object creation, parameter editing, or Agent AI calls exist yet.

---

## What Exists

### Project structure
- `Package.swift` — Two targets: `ElementalDesign` (library: models + design system + views) and `ElementalDesignApp` (executable: `@main` entry point). `Resources/Fonts` processed at build time.
- `specs/` — Nine spec files, all using Elemental Design naming
- `ElementalDesign/Models/` — Data model layer (5 files, ~900 lines)
- `ElementalDesign/DesignSystem/` — Color tokens, typography, spacing/radius constants
- `ElementalDesign/ModeBar/` — Mode bar strip, pill buttons, wordmark
- `ElementalDesign/Panels/` — Panel layout, resize handles, collapse rails, panel tabs, empty states
- `ElementalDesign/Agent/` — Agent empty state, action buttons, input bar
- `ElementalDesign/Canvas/` — Canvas empty state greeting
- `ElementalDesignTests/` — Unit tests (1 file, ~500 lines)

### UI shell files

| Folder | Files | What they do |
|--------|-------|-------------|
| `DesignSystem/` | `Colors.swift`, `Typography.swift`, `Tokens.swift` | All brand/surface/gray/text colors, gradient shorthands, 8 custom fonts registered via CTFont, spacing/radius/panel-width constants |
| `ModeBar/` | `ModeBarView.swift`, `ModePillButton.swift`, `WordmarkView.swift` | 44pt horizontal bar, five 54×29pt capsule pills with SF Symbols, Cmd+Shift+1–5 shortcuts, "elemental design" wordmark |
| `Panels/` | `PanelLayoutView.swift`, `ResizeHandleView.swift`, `CollapsedRailView.swift`, `PanelTabView.swift`, `AgentPanelView.swift`, `ElementsPanelView.swift`, `CanvasPanelView.swift`, `ElementsEmptyStateView.swift`, `SettingsPanelContentView.swift`, `CodePanelContentView.swift` | Three-panel layout with drag-to-resize (clamped to min/max), collapse to 36pt rail via Cmd+1/Cmd+2, Cmd+0 reset, gradient tab headers, Settings/Code center panel swap |
| `Agent/` | `AgentEmptyStateView.swift`, `ActionButtonView.swift`, `AgentInputBarView.swift` | "What do you want to build today?" prompt, four cyan gradient action buttons, input bar with placeholder and mic button |
| `Canvas/` | `CanvasEmptyStateView.swift` | "Hello!" in Volkhov Bold Italic 64pt centered on canvas gradient |
| Root | `AppState.swift`, `AppRootView.swift` | Observable app state (mode, panel widths, collapse flags), root VStack with mode bar + panel layout, min window 1100×600, dark mode forced |

### Mode switching behavior

| Mode | What happens |
|------|-------------|
| Agent | All three panels visible, input bar focused |
| Elements | All three panels visible, same layout |
| Settings | Center panel swaps to project settings (name field, platform picker) |
| Code | Center panel swaps to "Select an object to see its code" placeholder |
| Preview | Agent and Elements panels fully hidden, canvas fills window, mode bar stays visible |

### Fonts bundled (8 TTF files)
Barlow Light, Medium, SemiBold, Bold · Barlow Condensed Light, Medium · Volkhov Regular, Bold Italic

### Data model files

| File | What it contains |
|------|-----------------|
| `Enums.swift` | `Platform`, `ComponentSubtype`, `RelationshipKind` |
| `Relationship.swift` | `Relationship` struct |
| `ParameterGroup.swift` | All parameter types and `ParameterGroup` with defaults |
| `ComponentState.swift` | `ComponentState`, `BuiltInState` with subtype applicability |
| `ElementalObject.swift` | `ElementalObject` protocol, `Screen`, `Component`, `AnyElementalObject` |

### Test coverage
All data model tests passing — shape/information/widget defaults, screen platform sizes, states, nesting, relationships, all parameter types (text, image, icon, shadow, border, animation, accessibility), padding unit, scalesWithContent, codable round-trip.

---

## What Does Not Exist Yet

- **Object creation** — No + button behavior, no New Object sheet, no Parameter Picker
- **`>>>` expansion** — No parameter controls or three-level tuning in the Elements panel
- **Agent integration** — No API calls, no conversation logic, no system prompt generation
- **Canvas rendering** — No object rendering, selection, drag, or resize on the canvas
- **Persistence** — No file save/load beyond Codable conformance
- **Specs not yet written** — ComponentDocs, PreviewMode, ElementMap

---

## Spec Status

| Spec | Status |
|------|--------|
| `Spec_Concept_Elemental.md` | ✅ Written |
| `Spec_DocumentSystem.md` | ✅ Written |
| `Spec_ObjectModel.md` | ✅ Written (v0.3) |
| `Spec_ProgressiveDisclosure.md` | ✅ Written |
| `Spec_Agent.md` | ✅ Written |
| `Spec_Canvas.md` | ✅ Written |
| `Spec_Panels.md` | ✅ Written |
| `Spec_ModeBar.md` | ✅ Written |
| `Spec_DesignSystem.md` | ✅ Written |
| `Spec_ComponentDocs.md` | ❌ Not yet written |
| `Spec_PreviewMode.md` | ❌ Not yet written |
| `Spec_ElementMap.md` | ❌ Not yet written |

---

## Next Steps (Suggested)

1. **Run the app and review the UI shell visually** — check that colors, fonts, spacing, and layout match your Figma explorations. Note anything that needs adjusting.
2. **Object creation flow** — the + button, New Object sheet, and placing objects on the canvas. This connects the data model to the UI for the first time.
3. **`>>>` expansion and parameter controls** — the core interaction pattern. Depends on objects existing on the canvas.
4. **Remaining unwritten specs** — ComponentDocs, PreviewMode, ElementMap. None of these block the next build phases.
