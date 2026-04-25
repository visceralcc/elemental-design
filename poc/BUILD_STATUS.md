# Elemental Design — Web POC · Build Status

Updated: April 24, 2026 · v0.2.4

---

## Current State: v0.2.4 — Dynamic Code Panel + Styled Parameters + Resizable Panels

A working single-file HTML demo that shows four component types composing inside a container. Interactive Elements panel with canvas preview. Padding and spacing overlays. Three scale sizes. Mobile-responsive. Four-panel workspace (Agent | Elements | Code | Component) with independent toggle pills — multiple panels can be open simultaneously, Component is always visible. Code panel updates dynamically based on element selection. Panels are resizable via drag handles.

---

## What Exists

### The demo file
`elemental-poc.html` — a single HTML file, zero dependencies (Google Fonts loaded via CDN). Opens in any browser.

### Components in the demo

| Component | Subtype | What it demonstrates |
|-----------|---------|---------------------|
| Card Container | Shape | Parent container with 20pt padding, 16pt child spacing, 16pt corner radius, dark fill |
| Hero Image | Information | Scalable image with Fill fit mode, 10pt corner radius, clips to bounds |
| Card Title | Information | Title style role text (24pt, weight 600) |
| Card Description | Information | Body style role text (16pt, weight 400) |
| Category Label | Information | Label style role text (13pt, weight 500, muted color) |
| Action Bar | Shape | Horizontal icon row (heart, share, bookmark) with 16pt spacing |

### Interactive features

| Feature | Status |
|---------|--------|
| Tap to place components one at a time | ✅ Working |
| "Place All" button for quick setup | ✅ Working |
| Elements panel with component rows | ✅ Working |
| Subtype badges (◻ shape, ℹ information) | ✅ Working |
| Selection sync (panel ↔ canvas) | ✅ Working |
| >>> expand to show parameter values | ✅ Working |
| Styled parameter rows for child components (blue gradient headers + dark value badges) | ✅ Working (v0.2.3) |
| Card Container keeps detailed monospace parameter readout | ✅ Working |
| Padding overlay (cyan dashed lines with pt labels) | ✅ Working |
| Spacing indicators (pink lines with pt labels) | ✅ Working |
| Scale control (S/M/L = 0.75×/1×/1.25×) | ✅ Working |
| Nested children in Elements panel | ✅ Working |
| Filled dot indicator for placed components | ✅ Working |
| Mobile-responsive layout | ✅ Working |
| Mode bar pills with real SVG icons — 3 pills (Agent, Elements, Code). Component has no pill (always open). | ✅ Working (v0.2.2) |
| Panel tabs redesigned per Figma (46px height, 23px top corners, icon + Barlow Medium 16px title) | ✅ Working |
| Tabs sit in a shared `#4B4B4B` strip below the mode bar so their rounded tops have contrast | ✅ Working |
| Agent panel placeholder (faded sparkle icon + "Agent panel coming soon") | ✅ Working |
| Mode pills are independent toggles. Any combination of panels may be open simultaneously. | ✅ Working |
| Fixed left-to-right panel order: Agent \| Elements \| Code \| Component. | ✅ Working (v0.2.2) |
| Default layout opens Elements + Component. Component panel cannot be toggled off. | ✅ Working |
| At least one panel must remain open — attempting to close the last open panel is ignored. | ✅ Working |
| Open panels share available width via flex — Component absorbs extra space (min 400px). | ✅ Working |
| Dynamic Code panel — file tree and code preview update based on selected element | ✅ Working (v0.2.4) |
| Code panel shows scoped file tree per element (only relevant files/folders) | ✅ Working (v0.2.4) |
| Code panel shows syntax-highlighted SwiftUI code per element | ✅ Working (v0.2.4) |
| Card Container selection shows full file tree + full composition code | ✅ Working (v0.2.4) |
| Code panel wider by default (420px, min 300px) | ✅ Working (v0.2.4) |
| Draggable resize handles between adjacent open panels | ✅ Working (v0.2.4) |
| Resize handles respect per-panel min/max width constraints | ✅ Working (v0.2.4) |
| Resize handles regenerate when panels open/close | ✅ Working (v0.2.4) |
| Resize handles hidden on mobile | ✅ Working (v0.2.4) |
| Tab row forms a continuous `#4B4B4B` strip | ✅ Working |

### Tokens implemented

All colors, fonts, spacing values, and corner radii match `Spec_DesignSystem.md`. Specific tokens used:

- Brand colors: cyan, cyan-deep, blue, blue-deep, cyan-bright, cyan-highlight, cyan-pill
- Surface colors: top-bar, elements, canvas-light, canvas-dark, tab gradients
- Gray scale: button-light, button-dark, mode-inactive, border
- Text: primary (#FFF), accent (#01BEF9), muted (50% white)
- Typography: Barlow (300–700), Barlow Condensed (300, 500), Vollkorn (placeholder for Volkhov)
- Spacing: 4pt base unit system
- Corner radii: button (4pt), tab (14pt in POC), pill (29pt)

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| v0.2.4 | Apr 24, 2026 | Dynamic Code panel (file tree + code update per selected element), wider Code panel (420px default), draggable resize handles between panels |
| v0.2.3 | Apr 24, 2026 | Styled parameter rows for child components (blue gradient headers + dark value badges). Card Container keeps monospace readout. |
| v0.2.2 | Apr 24, 2026 | Removed Plan and Viewport panels. Panel order now Agent \| Elements \| Code \| Component. Mode bar down to 3 pills. |
| v0.2.1 | Apr 24, 2026 | Toggle-based panel navigation. Independent pills, multi-panel open, fixed panel ordering. |
| v0.2 | Apr 2026 | Six-panel workspace with mode pills, panel tabs, Code mock IDE. |
| v0.1 | Apr 2026 | Initial POC — component placement, Elements panel, canvas, overlays. |

---

## What Does Not Exist Yet

### Interaction gaps
- **Drag to reorder** — Components can't be reordered in the Elements panel
- **Drag to nest** — Components can't be dragged from panel to canvas
- **Parameter editing** — Expanded parameter view is read-only; no sliders or inputs
- **Three-level control model** — No Auto/Slider/Exact Value controls
- **Parameter Picker** — No toggle sheet for choosing which parameters are visible
- **Multi-select** — No shift-click or marquee selection
- **State switching** — No hover/pressed/focused state demonstration

### Visual gaps
- **Agent panel** — Placeholder only (sparkle icon + "Agent panel coming soon"). No conversation UI yet.
- **Canvas chrome** — No size badges on selected children, no resize handles
- **Direct manipulation** — No drag-to-move or drag-to-resize on canvas
- **Animation** — No expand/collapse animations on panel rows

### Content gaps
- **Multiple containers** — Only one card composition; no side-by-side comparison
- **Different component combos** — Only showing the "card" pattern; could show a nav bar, a list item, a form field
- **Responsive behavior** — Scale control exists, but no demo of how the same component adapts across platform contexts (iOS vs. web dimensions)

---

## Known Issues

1. **Vollkorn font substitution** — The spec calls for Volkhov (bundled in the native app). Vollkorn is used as a web substitute since Volkhov isn't on Google Fonts. Only affects the wordmark area; not critical for the POC.
2. **Icon row padding overlay** — Padding overlay on the Action Bar shows but the labels can overlap the icons at small scales.
3. **Image loading** — The hero image loads from Unsplash. If offline or the URL changes, the image area will be empty. Consider embedding a base64 fallback.

---

## Next Steps (Suggested Priority)

1. **Parameter editing** — Make at least one parameter editable (e.g., container padding slider) to demonstrate the three-level control model
2. **Expand/collapse animation** — Add the 200ms slide-down / 150ms slide-up from `Spec_ProgressiveDisclosure.md`
3. **Multiple compositions** — Add a second component composition (e.g., a nav bar or list item) to show flexibility
4. **Agent panel stub** — Add the left panel with a static conversation showing the Agent creating the card
5. **Drag interaction** — Let users drag components from the panel into the container on canvas
