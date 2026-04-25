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

Replace the stub text-character mode bar pills with real SVG button icons from the Figma designs.

### Context

The current mode bar uses plain text characters (`✦`, `☰`, `⚙`, `</>`, `👁`) inside small colored divs (32×22px). These need to be replaced with the actual designed buttons from the SVG assets.

### SVG source files

The SVG files are at `assets/buttons/`. Each file contains a Figma component set with **two variants** of the same button:

- **First variant (top):** The **active** state — a 54×29px rounded capsule with `#00B2F3` fill and a white icon centered inside
- **Second variant (bottom):** The **inactive** state — same shape and icon, but with `#848484` fill

Each SVG file also has a dashed purple border rect (`stroke="#8A38F5" stroke-dasharray="10 5"`) — this is Figma's component set frame and should be ignored entirely.

### Button-to-file mapping (left to right in the mode bar)

| Position | Mode name | SVG file | Icon description |
|----------|-----------|----------|-----------------|
| 1 | Agent | `assets/buttons/button_agent.svg` | Three sparkle/star shapes (the ✦ spark) |
| 2 | Elements | `assets/buttons/button_elements.svg` | 3D cube wireframe |
| 3 | Plan | `assets/buttons/button_plan.svg` | Document with flowchart graphic |
| 4 | Code | `assets/buttons/button_code.svg` | Code brackets `</>` |
| 5 | Viewport | `assets/buttons/button_viewport.svg` | Eye icon |

### What to do

**Step 1: Read the SVG files**

Read all 5 SVG files from `assets/buttons/`. Understand the structure — each has:
```
<svg viewBox="0 0 94 118">
  <rect ... stroke-dasharray="10 5"/>   ← Figma frame border — IGNORE
  <rect x="20" y="20" ... fill="#00B2F3"/>  ← Active state pill background
  <path ... fill="white"/>                   ← Active state icon (may be multiple paths)
  <rect x="20" y="69" ... fill="#848484"/>   ← Inactive state pill background
  <path ... fill="white"/>                   ← Inactive state icon (same paths, shifted down by 49px)
</svg>
```

**Step 2: Extract the icon paths for each button**

For each SVG file, extract the white icon `<path>` elements from the **active variant only** (the paths between the `#00B2F3` rect and the `#848484` rect — roughly y-coordinates 20–49). The inactive variant uses the same icon paths shifted down, so you only need one set.

**Step 3: Embed as inline SVGs in the mode bar**

Replace each `.mode-pill` div's text content with an inline `<svg>` element containing the extracted icon paths. The approach:

- Each pill should be an inline SVG with a `viewBox` that frames just the icon paths (not the full 94×118 source viewBox)
- The pill background color (active vs inactive) is already handled by CSS — do NOT include the pill `<rect>` in the inline SVG. Only embed the white icon paths.
- Set the SVG to a reasonable display size within the pill (roughly 16–19px icon area, centered)
- The icon paths from the source SVGs are positioned relative to a pill at (20, 20). You'll need to adjust the viewBox or translate the paths so they render centered. The simplest approach: set the SVG `viewBox` to cover just the icon area (e.g., for Agent the sparkle paths span roughly x=39–55, y=27–43, so `viewBox="39 27 16 16"`). Examine each file's paths to find the right bounds.

**Step 4: Update pill sizing to match the design spec**

Update the `.mode-pill` CSS to match `Spec_DesignSystem.md` §6.7:
- Width: **54px**
- Height: **29px**
- Corner radius: **29px** (fully rounded capsule)
- Active fill: `#00B2F3`
- Inactive fill: `#848484`
- Icon: white, centered within the pill

Update the mobile breakpoint (`@media max-width: 640px`) proportionally — suggest ~42×22px on mobile.

**Step 5: Update the mode bar layout**

The mode bar may need minor layout adjustments (gap between pills, overall height) to accommodate the larger pill size. Check that it still looks balanced. The mode bar height should remain 44px per spec. Adjust vertical alignment so the pills are centered.

### Active/inactive state mapping

In the current POC, the first two pills (Agent, Elements) are active and the rest are inactive. Maintain this:

| Pill | State | Background |
|------|-------|------------|
| Agent | active | `#00B2F3` |
| Elements | active | `#00B2F3` |
| Plan | inactive | `#848484` |
| Code | inactive | `#848484` |
| Viewport | inactive | `#848484` |

### Important notes

- The Viewport button SVG (`button_viewport.svg`) has both variants with `fill="#00B2F3"` — this appears to be a Figma export issue. The inactive state should use `#848484` like all other inactive buttons. The CSS class handles this, so just extract the white icon paths and don't worry about the background fill.
- The icon paths may include `stroke="white"` attributes in addition to or instead of `fill="white"` (specifically the Elements cube icon). Preserve those stroke attributes.
- Keep the SVG paths exactly as exported — don't simplify or modify the path data.

### Spec references

Read `specs/Spec_DesignSystem.md` §6.7 (Mode Bar Pill) and §9.2 (Core Icons) before implementing.

## Authoritative specs (read if your task touches these systems)

| Topic | Spec file |
|-------|-----------|
| Component types, subtypes, parameter defaults | `specs/Spec_ObjectModel.md` |
| Color tokens, typography, spacing, corner radii | `specs/Spec_DesignSystem.md` |
| >>> pattern, three-level control model | `specs/Spec_ProgressiveDisclosure.md` |
| Panel layout, sizing, collapse, empty states | `specs/Spec_Panels.md` |
| Agent behavior, input modes, authorship | `specs/Spec_Agent.md` |
| Canvas interaction, selection, placement | `specs/Spec_Canvas.md` |
