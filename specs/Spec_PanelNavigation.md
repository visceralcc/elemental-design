# Elemental Design — Panel Navigation Specification

**How mode pills toggle panels, and how panels arrange, resize, and collapse**

Version 0.3 | April 2026 | Charlie Denison

---

## Version History
| Version | Date | Changes |
|---------|------|---------|
| 0.1 | Apr 2026 | Initial draft (Spec_Panels.md). Three-panel layout, single-mode switching. |
| 0.2 | Apr 2026 | Revised panel model: pills toggle panels independently, multiple panels visible simultaneously, fixed panel ordering, flexible widths. |
| **0.3** | **Apr 2026** | **Corrected panel ordering: Code moves between Elements and Component. Component and Viewport anchor right. Added Code panel IDE vision (§3.1). Clarified Component vs. Viewport purpose.** |

---

## 1. Overview

The panel system defines how Elemental Design's workspace is organized. Panels are the persistent zones where different views of the work live — conversation (Agent), planning (Plan), structure (Elements), code (Code), single-component canvas (Component), and full-layout preview (Viewport).

**Design principle: Panels are additive, not exclusive.** Each mode pill toggles its panel open or closed independently. Multiple panels can be visible at the same time. The user composes their workspace by opening the panels they need and closing the ones they don't. This is fundamentally different from a tab metaphor where selecting one view hides another.

### What this spec covers
- How mode pills control panel visibility (toggle behavior)
- Panel ordering (fixed, left to right)
- Panel sizing (flexible widths, responsive content)
- Tab display rules (tabs appear when panels are open)
- The Code panel's role as an integrated IDE

### Scope boundary — what this spec does NOT cover
- Panel content (what's inside each panel) — each panel has its own spec
- The `>>>` expansion pattern inside the Elements panel → `router→ Spec_ProgressiveDisclosure.md`
- Agent conversation behavior → `router→ Spec_Agent.md`
- Canvas interaction, zoom, selection → `router→ Spec_Canvas.md`

---

## 2. The Six Panels

Elemental Design has six panels. Five have corresponding mode pills in the primary navigation bar. The Component panel has no pill — it is always open.

| Panel | Pill icon | Purpose | Default state |
|-------|-----------|---------|---------------|
| **Agent** | Sparkle (✦) | Conversational AI collaborator | Closed |
| **Plan** | Document/flowchart | Project planning and flow view | Closed |
| **Elements** | 3D cube | Structural hierarchy of the current view | Open |
| **Code** | `</>` brackets | Integrated IDE — files and code for the selected element | Closed |
| **Component** | Eye | Single-component canvas — focus on one component in isolation | Open |
| **Viewport** | Eye | Full-layout preview — see the broader context (web page, app screen) | Closed |

### Default state on launch
Only **Elements** and **Component** are open by default. This matches the core workflow — structure on the left, canvas on the right. The user opens additional panels as needed.

### Component vs. Viewport
These two panels serve distinct purposes:
- **Component** is for focused work on a single component in isolation — editing its properties, seeing it at its declared size, refining its states.
- **Viewport** is for seeing how that component (and others) sit within a broader layout — a full web page, an app screen, a multi-component composition. It answers "how does this fit in the bigger picture?"

Both can be open simultaneously. A designer might have Elements + Code + Component + Viewport all visible — editing structure on the left, seeing the code in the center, the focused component next to it, and the full page layout on the right.

---

## 3. Panel Ordering

Panel order is fixed. When multiple panels are open, they always appear in this left-to-right sequence:

```
Agent | Plan | Elements | Code | Component | Viewport
```

The user cannot reorder panels. This fixed order ensures spatial consistency — the user always knows where to look.

### Why this order
The order follows a conceptual flow: intent (Agent) → planning (Plan) → structure (Elements) → implementation (Code) → focused output (Component) → broader context (Viewport). Moving left to right is moving from abstract to concrete, from intent to result.

The Code panel sits between Elements and Component because it shows the code *for* whatever is selected in Elements. The visual output of that code appears to its right in Component. This creates a natural left-to-right reading: select an element → see its code → see its visual output.

Component and Viewport anchor to the right side because they are the visual output — the destination of all the work happening in the panels to their left.

### 3.1 The Code Panel — Integrated IDE (Future Vision)

The Code panel is not a simple code viewer. The long-term vision is a fully integrated IDE, architecturally built on VS Code (which is open source). When the user selects an element in the Elements panel, the Code panel shows only the files and folders relevant to that element — not the entire project. This is a departure from the "everything all at once" approach of traditional IDEs.

**In the current POC:** The Code panel shows a placeholder approximation — a mock file tree and code view. It does not need real IDE functionality. The important thing is that the panel exists in the correct position, toggles correctly, and communicates the concept.

**In the native app (future):** The Code panel will embed a VS Code-based editor with file tree, syntax highlighting, and the ability to edit code that maps back to the selected component's parameters. The exact integration approach (Monaco editor, VS Code extension API, or full embedded VS Code) will be specced separately.

router→ Spec_CodePanel.md — (not yet written) full IDE integration spec

---

## 4. Toggle Behavior

### How pills work
Each mode pill is a **toggle**. Clicking a pill:
- If the panel is **closed** → opens it (pill becomes active/cyan)
- If the panel is **open** → closes it (pill becomes inactive/gray)

Multiple pills can be active simultaneously. There is no "only one active at a time" constraint.

### Active/inactive pill colors
| State | Fill color |
|-------|-----------|
| Active (panel open) | `#00B2F3` (`brand-cyan-pill`) |
| Inactive (panel closed) | `#848484` (`gray-mode-inactive`) |

### Minimum panels
At least one panel must remain open at all times. If the user tries to close the last remaining open panel, the action is ignored — the pill stays active.

### Tab visibility
A panel's tab is only visible in the tab row when its panel is open. Closing a panel removes its tab from the tab row. Opening a panel adds its tab back in the correct position (per the fixed ordering in §3).

---

## 5. Panel Sizing

### Flexible widths
When multiple panels are open, they share the available window width. Panels have minimum and maximum widths, but within those bounds, they flex to fill the space.

| Panel | Min width | Default width | Max width |
|-------|-----------|---------------|-----------|
| Agent | 200px | 260px | 360px |
| Plan | 200px | 260px | 400px |
| Elements | 220px | 260px | 400px |
| Code | 240px | 300px | 500px |
| Component | 400px | Remaining space | No max |
| Viewport | 300px | 400px | No max |

The **Component** panel (canvas) is the primary flexible panel — it absorbs extra space when the window is wide and gives up space first when the window is narrow (down to its 400px minimum).

### Resize handles
A vertical drag handle sits between adjacent open panels. Dragging a handle resizes the two panels on either side. Handles are 1px wide with a 12px invisible hit target on each side.

### Responsive content
Content inside each panel should adapt to the panel's current width. Text wraps, rows reflow, and controls adjust. No horizontal scrolling within panels — content always fits.

### Window resize behavior
When the overall window is resized narrower:
1. Component panel shrinks first (it's the most flexible)
2. Once Component hits its minimum (400px), other panels shrink proportionally
3. If total minimums exceed window width, panels collapse from the outside in (leftmost and rightmost non-essential panels first)
4. Component never collapses — it's always visible

---

## 6. Tab Row

The tab row is a horizontal strip between the mode bar and the panel content area. It has a dark background (`#4B4B4B` matching the mode bar) so the tab shapes have contrast.

### Tab appearance rules
- Each open panel has a tab in the tab row, positioned above its panel content
- Tabs are content-width (icon + title + padding), not full panel width
- Tabs align to the left edge of their panel's content area

### Tab styling by panel

| Panel | Background | Corner radius | Special rules |
|-------|-----------|---------------|---------------|
| Agent | `#1F1F1F` | 0 top-left, 23px top-right | Straight left side (hugs window edge) |
| Plan | `#373737` | 23px top-left, 23px top-right | — |
| Elements | `#373737` | 23px top-left, 23px top-right | Shows placed count on right |
| Code | `#2A2A2A` | 23px top-left, 23px top-right | Shows selected element name in bold |
| Component | `#2A2A2A` | 23px top-left, 23px top-right | Shows object name in bold |
| Viewport | `#2A2A2A` | 23px top-left, 23px top-right | — |

All tabs are 46px tall. All use Barlow Medium 16px white text with an inline SVG icon.

### Tab icons
Each tab uses the icon from `assets/icons/`:

| Tab | Icon file | Icon size |
|-----|-----------|-----------|
| Agent | icon_agent.svg | 23×23px |
| Plan | icon_plan.svg | 14×18px |
| Elements | icon_elements.svg | 19×22px |
| Code | icon_code.svg | 19×15px |
| Component | icon_viewport.svg | 20×12px |
| Viewport | icon_viewport.svg | 20×12px |

---

## 7. Keyboard Shortcuts (Future — Not in POC)

In the native app, keyboard shortcuts will toggle panels:

| Shortcut | Action |
|----------|--------|
| Cmd+1 | Toggle Agent panel |
| Cmd+2 | Toggle Plan panel |
| Cmd+3 | Toggle Elements panel |
| Cmd+4 | Toggle Code panel |
| Cmd+5 | Toggle Component panel (no-op — always open?) |
| Cmd+6 | Toggle Viewport panel |
| Cmd+0 | Reset to default layout (Elements + Component) |

These are not implemented in the web POC.

---

## 8. Mobile Behavior (Future — Not in POC)

On narrow screens (iPhone, iPad split-screen), panels cannot sit side by side. Mobile uses a tab bar at the bottom to switch between panels — only one visible at a time. This is a fundamentally different interaction model from desktop and will be specced separately.

---

## 9. What This Spec Does Not Cover

- Content and behavior inside each panel → each panel has its own spec
- The `>>>` expansion pattern inside Elements → `router→ Spec_ProgressiveDisclosure.md`
- Agent conversation behavior → `router→ Spec_Agent.md`
- Canvas interaction, zoom, selection → `router→ Spec_Canvas.md`
- Preview mode interaction playback → `router→ Spec_PreviewMode.md`
- Code panel IDE integration → `router→ Spec_CodePanel.md` (not yet written)
- Mode bar pill visual design → `router→ Spec_DesignSystem.md` §6.7
