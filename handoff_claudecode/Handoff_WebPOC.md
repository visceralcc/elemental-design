# Elemental Design — Web POC · Claude Code Handoff

Copy and paste this entire prompt into a new Claude Code session.

---

You are working on the **Elemental Design Web POC** — a standalone HTML/CSS/JS demo that proves how the Elemental Design component model works. This is NOT the native SwiftUI app.

## Your first action

Read these files in this order before touching any code:

1. `poc/CLAUDE.md` — what this POC is, rules, file structure
2. `poc/BUILD_STATUS.md` — current state, what works, what's next, known issues
3. `poc/TECH_SPEC.md` — architecture, data model, token system, rendering
4. `poc/DESIGN_INTENT.md` — what the demo should communicate
5. `poc/elemental-poc.html` — the actual demo

Do not make changes until you have read all five files.

## What this project is

A single HTML file (`poc/elemental-poc.html`) that simulates the Elemental Design tool. It shows components composing inside a container with built-in padding, spacing, and intelligent defaults. Zero dependencies — vanilla HTML/CSS/JS with Google Fonts via CDN.

## Rules

- **Single file.** Everything stays in `elemental-poc.html` unless explicitly told otherwise.
- **No frameworks.** No React, no npm, no build tools. If someone double-clicks the file, it works.
- **Match the specs.** Every color, font, spacing value, and corner radius must come from `specs/Spec_DesignSystem.md`. Component defaults must match `specs/Spec_ObjectModel.md` §8.
- **Read before writing.** If your task touches a system defined in `specs/`, read that spec first.
- **Update BUILD_STATUS.md when done.** Add what you changed, update the feature table, note any new issues.

## Your task

[PASTE SPECIFIC TASK HERE]

## Authoritative specs (read if your task touches these systems)

| Topic | Spec file |
|-------|-----------|
| Component types, subtypes, parameter defaults | `specs/Spec_ObjectModel.md` |
| Color tokens, typography, spacing, corner radii | `specs/Spec_DesignSystem.md` |
| >>> pattern, three-level control model | `specs/Spec_ProgressiveDisclosure.md` |
| Panel layout, sizing, collapse, empty states | `specs/Spec_Panels.md` |
| Agent behavior, input modes, authorship | `specs/Spec_Agent.md` |
| Canvas interaction, selection, placement | `specs/Spec_Canvas.md` |
