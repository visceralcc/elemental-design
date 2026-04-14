

You are starting work on **Elemental Design** — a native macOS and iOS design tool built in SwiftUI. This is a clean Swift project. There is no existing code yet.

## Your first action

Read `CLAUDE.md` at the project root. It tells you everything you need to know about how this project is organized and how to work in it. Do not write any code until you have read it.

## What exists already

A `specs/` folder containing seven specification documents. These are your source of truth. Read the relevant spec before touching any system.

| Spec file | What it covers |
|-----------|---------------|
| `Spec_Concept_Elemental.md` | What Elemental Design is, the full philosophy |
| `Spec_DocumentSystem.md` | The router→ convention, how specs are structured |
| `Spec_ObjectModel.md` | Every object type, nesting rules, states, Swift data model |
| `Spec_ProgressiveDisclosure.md` | The >>> pattern, parameter picker, three-level control model |
| `Spec_Agent.md` | The AI Agent panel — input modes, proactivity, authorship |
| `Spec_Canvas.md` | Canvas surface, navigation, selection, object placement |

## Your first task

Scaffold the Xcode project and folder structure exactly as defined in `CLAUDE.md`, then implement the data model layer from `Spec_ObjectModel.md` — the Swift protocols, structs, and enums. No UI yet. The data model has no UI dependencies and is the right place to start.

Specifically:
1. Create the Xcode project named `ElementalDesign` targeting macOS 14+ and iOS 17+
2. Create the folder structure from `CLAUDE.md`
3. Move the spec files into `specs/`
4. Implement `SurfaceObject`, `Screen`, `Component`, `ComponentState`, `Relationship`, and all associated enums from §9 of `Spec_ObjectModel.md`
5. Write unit tests for the data model — nesting, relationship kinds, state defaults
6. Stop and report back before touching any UI

## Rules

- Read the spec before writing code for any system
- Follow `router→` links when your task touches an adjacent system
- If something is not specced, say so — do not invent behavior
- All naming must match the specs exactly
- Specs marked "(not yet written)" in `CLAUDE.md` are out of scope for this session
