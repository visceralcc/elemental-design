# Elemental Design — Claude Code Handoff: UI Shell

Copy and paste this entire prompt into a new Claude Code session.

---

You are continuing work on **Elemental Design** — a native macOS and iOS design tool built in SwiftUI.

## Your first action

Read `CLAUDE.md` at the project root. It tells you how this project is organized. Then read the specs listed below — they are your source of truth for this session.

## What exists already

The Xcode project is scaffolded. The data model layer (protocols, structs, enums from `Spec_ObjectModel.md` §9) is implemented and has passing unit tests. No UI exists yet.

## Your task this session: Build the UI shell

Implement the three-panel layout, mode bar, and design system tokens. This is the visual skeleton of the app — no object creation, no parameter editing, no Agent AI calls. Just the shell with empty states.

### Specs to read (in this order)

| Spec file | What you need from it |
|-----------|----------------------|
| `Spec_DesignSystem.md` | **Read this first.** Every color, font, spacing value, button style, and corner radius. This is the token set for the entire UI. |
| `Spec_Panels.md` | Three-panel layout, sizing, minimums, resize handles, collapse behavior, empty states, keyboard shortcuts. |
| `Spec_ModeBar.md` | Five mode buttons, tab strip, switching behavior, what each mode shows and hides. |
| `Spec_Canvas.md` §2–3 | Canvas surface background (dark gradient), zoom/pan (the canvas panel content). |
| `Spec_Agent.md` §2 | Agent panel internal layout — header, conversation area, input bar. |
| `Spec_ProgressiveDisclosure.md` §2 | Elements panel row structure (you won't build the expansion behavior yet, but understand the row format). |

### What to build

**Phase 1 — Design system tokens**
1. Create a `DesignSystem/` folder under `ElementalDesign/`
2. Implement color tokens as SwiftUI `Color` extensions matching `Spec_DesignSystem.md` §2 — all brand colors, surface colors, grays, and text colors
3. Implement typography styles — register Barlow (Light, Medium, SemiBold, Bold), Barlow Condensed (Light, Medium), and Volkhov (Regular) as custom fonts. Create `Font` extensions or a type style enum matching §3
4. Implement spacing constants matching §4
5. Implement corner radius constants matching §5

**Phase 2 — Mode bar**
1. Build the mode bar as a horizontal strip across the top of the window — 44pt tall on macOS, 48pt on iOS
2. Five pill-shaped mode buttons (54×29pt, fully rounded capsule) with icons — active state uses `brand-cyan-pill`, inactive uses `gray-mode-inactive`
3. Wordmark in the top-right: "elemental" in `brand-cyan-bright` Barlow Condensed Light + "design" in white Barlow Condensed Medium, 20pt
4. Wire up Cmd+Shift+1 through Cmd+Shift+5 keyboard shortcuts
5. Tab strip to the right of the mode buttons — empty for now (no tabs until objects exist)

**Phase 3 — Three-panel layout**
1. Agent panel (left), Elements panel (center), Canvas panel (right) in a horizontal stack
2. Default widths: Agent 280pt, Elements 300pt, Canvas fills remaining space
3. Minimum widths: Agent 240pt, Elements 260pt, Canvas 600pt
4. Vertical drag handles between panels (1pt wide, 12pt invisible hit target per side)
5. Panel collapse to 36pt rail with Cmd+1 (Agent) and Cmd+2 (Elements), Cmd+0 to reset
6. Panel tabs between mode bar and panel content: Agent tab (black→#1F1F1F gradient, "Agent" label), Elements tab (#282828→#3B3B3B gradient, "Elements" label), Canvas tab (#1C1C1C→#2A2A2A gradient, empty for now)

**Phase 4 — Panel content (empty states)**
1. Agent panel: dark background (#1F1F1F), Volkhov "What do you want to build today?" at 32pt white text, four action buttons (a Website, an App, a Component, Open...) using cyan gradient button style, input bar pinned to bottom with "let's talk..." placeholder and mic button
2. Elements panel: mid-gray background (#373737), centered empty state text "Nothing here yet." with muted instructions
3. Canvas panel: dark gradient background (#2C2C2C top → #161616 bottom), "Hello!" in Volkhov Bold Italic 64pt centered (the canvas greeting before any objects exist)

**Phase 5 — Mode switching**
1. Agent mode: all three panels visible, input bar focused
2. Elements mode: all three panels visible (same layout as Agent mode, different mode bar highlight)
3. Settings mode: center panel content swaps to show "Settings" header with project name field
4. Code mode: center panel content swaps to show "Code" header with "Select an object to see its code" message
5. Preview mode: Agent and Elements panels hidden (not collapsed — fully hidden), canvas fills window, mode bar stays visible

### What NOT to build

- No object creation flow (no + button behavior, no New Object sheet)
- No Parameter Picker
- No `>>>` expansion or parameter controls
- No Agent AI calls or conversation logic
- No canvas object rendering, selection, or manipulation
- No persistence or file saving

### Rules

- Read the spec before writing code for any system
- All color values, font names, sizes, spacing, and corner radii must match `Spec_DesignSystem.md` exactly — do not approximate
- All panel widths, minimums, and collapse behavior must match `Spec_Panels.md` exactly
- Font files for Barlow, Barlow Condensed, and Volkhov need to be added to the Xcode project bundle — download them from Google Fonts
- If something is not specced, say so — do not invent behavior
- Stop and report back after each phase before moving to the next
