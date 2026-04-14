# Elemental Design — Design System Specification

**Typography, color, spacing, and component tokens for Elemental Design's own interface**

Version 0.1 | April 2026 | Charlie Denison

---

## Version History
| Version | Date | Changes |
|---------|------|---------|
| 0.1 | Apr 2026 | Initial draft. Color palette, typography, spacing, corner radii, button styles, panel tokens, mode bar tokens, Parameter Picker tokens. |

---

## 1. Overview

The design system defines the visual language of Elemental Design itself — not what users create with it, but the tool's own interface: panels, buttons, mode bar, tabs, text, and controls.

**Design principle: The tool recedes.** Elemental Design's interface is dark, quiet, and typographically restrained. Color is used sparingly and with purpose — the cyan/blue gradient family signals interactive elements, white signals content, and everything else is a shade of dark gray. The user's work on the canvas should always be the brightest, most visually prominent thing on screen. The tool's chrome should never compete with it.

### Scope boundary — what this spec does NOT cover
- Default parameter values for user-created objects → `router→ Spec_ObjectModel.md`
- How controls appear inside expanded parameter rows → `router→ Spec_ProgressiveDisclosure.md`
- Canvas surface appearance and chrome → `router→ Spec_Canvas.md`
- Responsive layout and panel sizing → `router→ Spec_Panels.md`

---

## 2. Color Palette

### 2.1 Brand Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `brand-cyan` | #00C3FF | Primary interactive color — element rows, action buttons, "elemental" wordmark |
| `brand-cyan-deep` | #006B99 | Gradient endpoint for standard interactive elements |
| `brand-blue` | #0095FF | Active/selected state — component row when Parameter Picker is open |
| `brand-blue-deep` | #0449B8 | Gradient endpoint for active/selected elements |
| `brand-cyan-hover` | #00DDFF | Hover/focus state gradient start for parameter rows |
| `brand-cyan-hover-deep` | #0187C1 | Hover/focus state gradient endpoint for parameter rows |
| `brand-cyan-bright` | #01BEF9 | Wordmark accent, highlights |
| `brand-cyan-highlight` | #01D4F9 | `>>>` indicator highlight when hovered/active, "Done" button text |
| `brand-cyan-pill` | #00B2F3 | Mode bar active pill fill |

### 2.2 Surface Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `surface-top-bar` | #4B4B4B | Top bar / mode bar background |
| `surface-agent` | #1F1F1F | Agent panel background |
| `surface-elements` | #373737 | Elements panel background |
| `surface-canvas-light` | #2C2C2C | Canvas gradient start (top) |
| `surface-canvas-dark` | #161616 | Canvas gradient end (bottom) |
| `surface-tab-agent-start` | #000000 | Agent tab gradient start |
| `surface-tab-agent-end` | #1F1F1F | Agent tab gradient end |
| `surface-tab-elements-start` | #282828 | Elements tab gradient start |
| `surface-tab-elements-end` | #3B3B3B | Elements tab gradient end |
| `surface-tab-canvas-start` | #1C1C1C | Canvas/object tab gradient start |
| `surface-tab-canvas-end` | #2A2A2A | Canvas/object tab gradient end |
| `surface-picker-overlay` | rgba(255,255,255,0.09) | Parameter Picker background overlay |

### 2.3 Gray Scale (Controls & Text)

| Token | Hex | Usage |
|-------|-----|-------|
| `gray-button-light` | #9A9A9A | Gray button gradient start (Parameter Picker toggles) |
| `gray-button-dark` | #515151 | Gray button gradient end |
| `gray-mode-inactive` | #848484 | Mode bar inactive pill fill |
| `gray-border` | #888888 | Input bar border, dividers |
| `gray-placeholder` | #D9D9D9 | Default component placeholder fill on canvas |
| `gray-done-bg` | #EAEAEA | "Done" button background |

### 2.4 Text Colors

| Token | Value | Usage |
|-------|-------|-------|
| `text-primary` | #FFFFFF | All primary text — labels, names, conversation |
| `text-accent` | #01BEF9 | "elemental" in wordmark, accent labels |
| `text-done` | #00B2F3 | "Done" button text |
| `text-muted` | 50% opacity white | Inactive mode bar labels, placeholder text, secondary info |

### 2.5 Appearance Modes

Elemental Design defaults to dark mode. A light appearance is available via system settings.

- **Dark (default):** All tokens above are the dark mode values. The canvas gradient, panel backgrounds, and text colors are as specified.
- **Light:** Inverted palette — not yet defined. Light mode will be specced after dark mode is visually validated in-app. All surface tokens, text tokens, and gradient values will need light equivalents.
- **System follow:** Elemental Design respects the system appearance setting. If the user's macOS or iOS is set to light mode, Elemental Design switches to its light palette. Manual override available in Settings.

---

## 3. Typography

Elemental Design uses three typeface families, each with a distinct role.

### 3.1 Typeface Roles

| Role | Typeface | Usage |
|------|----------|-------|
| **UI chrome** | Barlow (various weights) | Mode labels, panel headers, button labels, tab labels, element row text, parameter names |
| **Wordmark** | Barlow Condensed | "elemental design" wordmark in the top-right corner |
| **Conversation** | Volkhov | Agent questions, prompts, conversational text, user input, and placeholder text in the Agent panel |

### 3.2 UI Chrome — Barlow

| Style | Weight | Size | Usage |
|-------|--------|------|-------|
| UI Label | Medium (500) | 16pt | Mode bar labels, panel headers, tab labels |
| UI Bold | Bold (700) | 16pt | Object names in element rows, bold text in tabs ("Game Tile"), parameter names in picker |
| UI Light | Light (300) | 16pt | Object type labels in element rows ("Component"), secondary descriptors |
| UI SemiBold | SemiBold (600) | 16pt | "Done" button text |

### 3.3 Wordmark — Barlow Condensed

| Style | Weight | Size | Color | Usage |
|-------|--------|------|-------|-------|
| Wordmark primary | Light (300) | 20pt | `text-accent` (#01BEF9) | "elemental" |
| Wordmark secondary | Medium (500) | 20pt | `text-primary` (#FFFFFF) | "design" |

The wordmark sits in the top-right corner of the window. "elemental" in cyan, "design" in white, Barlow Condensed. The wordmark is not interactive.

### 3.4 Conversation & Input — Volkhov

| Style | Weight | Size | Usage |
|-------|--------|------|-------|
| Agent prompt | Regular (400) | 32pt | Agent's primary question ("What do you want to build today?", "What's your component for?") |
| Agent body | Regular (400) | 16pt | Agent responses, suggestions, follow-up text |
| User message | Regular (400) | 16pt | User's typed text in the Agent input bar and conversation history |
| Input placeholder | Regular (400) | 16pt | "let's talk..." placeholder text in the input bar |

### 3.5 Typography Rules

- All text is white (#FFFFFF) unless otherwise specified
- No text in the tool's own UI uses more than two weights in a single element (light + bold is the most common pairing: "Component" light / "Game Tile" bold)
- Line height is set to "normal" (browser/system default) throughout — no custom leading values in the tool's chrome
- The serif typeface (Volkhov) is reserved exclusively for the Agent's conversational voice and user input. It never appears in panel headers, buttons, or structural UI.

---

## 4. Spacing

### 4.1 Base Unit

The spacing system uses a 4pt base unit. All spacing values are multiples of 4.

### 4.2 Common Spacing Values

| Token | Value | Usage |
|-------|-------|-------|
| `space-xs` | 4pt | Tight internal gaps (e.g., between icon and label in a button) |
| `space-sm` | 8pt | Compact padding, vertical gaps between tightly packed elements |
| `space-md` | 10pt | Standard button padding, element row internal padding |
| `space-lg` | 16pt | Panel content margins (left/right), nesting indentation per level |
| `space-xl` | 20pt | Agent prompt text margins |
| `space-2xl` | 24pt | Vertical gap between major sections |

### 4.3 Panel Margins

| Panel | Left margin | Right margin | Top margin (below header) |
|-------|------------|-------------|--------------------------|
| Agent | 15pt | 10pt | 10pt |
| Elements | 10pt | 10pt | 8pt |
| Canvas | 0 (content fills) | 0 | 0 |

### 4.4 Element Row Spacing

- Vertical gap between element rows: 10pt (gap between "Game Tile" row and "Size" row)
- Parameter Picker vertical gap between toggle buttons: 12pt
- Nesting indentation: 16pt per level

---

## 5. Corner Radii

| Token | Value | Usage |
|-------|-------|-------|
| `radius-button` | 4pt | Element row buttons, parameter toggle buttons |
| `radius-overlay` | 6pt | Parameter Picker overlay background |
| `radius-tab` | 23pt | Panel tabs (top-left and/or top-right, rounded top, flat bottom) |
| `radius-pill` | 29pt | Mode bar pills (fully rounded — radius equals half the height) |
| `radius-input` | 31pt | Agent input bar (fully rounded capsule) |
| `radius-done` | 45pt | "Done" button (fully rounded capsule) |

### Corner Radius Rules

- Buttons that represent elements or parameters use small radii (4pt) — they are rectangular with a slight softening
- Navigation elements (tabs, pills, input bar, Done button) use large radii — they are capsules or rounded shapes that feel distinct from the content they navigate

---

## 6. Button Styles

Elemental Design has a small, consistent set of button styles.

### 6.1 Element Row Button (Cyan Gradient)

The standard row in the Elements panel representing an object or visible parameter.

| Property | Value |
|----------|-------|
| Background | Linear gradient: `brand-cyan` (#00C3FF) → `brand-cyan-deep` (#006B99), left to right |
| Height | 33pt (parameter row), 48pt (component row — two-line label) |
| Corner radius | `radius-button` (4pt) |
| Padding | 10pt all sides |
| Text | Barlow Bold 16pt, white |
| `>>>` indicator | Three small chevrons, white, flush right |

### 6.2 Hover Element Row Button (Bright Cyan Gradient)

The parameter row when the user's cursor is over it or the row has focus.

| Property | Value |
|----------|-------|
| Background | Linear gradient: `brand-cyan-hover` (#00DDFF) → `brand-cyan-hover-deep` (#0187C1), left to right |
| Height | 33pt (parameter row), 48pt (component row) |
| Corner radius | `radius-button` (4pt) |
| Padding | 10pt all sides |
| Text | Barlow Bold 16pt, white |
| `>>>` indicator | Three chevrons in a highlighted capsule (`brand-cyan-highlight` #01D4F9 background, 7pt corner radius) |

### 6.3 Active Element Row Button (Blue Gradient)

The component row when the Parameter Picker is open or the element is in an active/editing state.

| Property | Value |
|----------|-------|
| Background | Linear gradient: `brand-blue` (#0095FF) → `brand-blue-deep` (#0449B8), left to right |
| Height | 48pt (two-line: type label + name) |
| Corner radius | `radius-button` (4pt) |
| Padding | 10pt all sides |
| Type label | Barlow Light 16pt, white ("Component") |
| Name | Barlow Bold 16pt, white ("Game Tile") |
| `>>>` indicator | Three chevrons in a highlighted capsule (`brand-cyan-highlight` #01D4F9 background) |

### 6.4 Parameter Toggle Button (Gray Gradient)

Parameter options in the Parameter Picker overlay.

| Property | Value |
|----------|-------|
| Background | Linear gradient: `gray-button-light` (#9A9A9A) → `gray-button-dark` (#515151), left to right |
| Width | 112pt |
| Height | 33pt |
| Corner radius | `radius-button` (4pt) |
| Padding | 10pt all sides |
| Text | Barlow Bold 16pt, white |
| Toggle icon | 16x16pt circle icon, right-aligned — green/cyan checkmark when on, empty circle when off |

### 6.5 Action Button (Cyan Gradient, Full Width)

Quick-action buttons in the Agent panel (e.g., "a Website", "an App", "a Component").

| Property | Value |
|----------|-------|
| Background | Linear gradient: `brand-cyan` (#00C3FF) → `brand-cyan-deep` (#006B99), left to right |
| Width | 233pt (Agent panel width minus margins) |
| Height | 33pt |
| Corner radius | `radius-button` (4pt) |
| Padding | 10pt all sides |
| Text | Barlow Medium 16pt, white |

### 6.6 Done Button (Light Pill)

Dismisses the Parameter Picker.

| Property | Value |
|----------|-------|
| Background | `gray-done-bg` (#EAEAEA) |
| Width | Full width of picker overlay (268pt) |
| Height | 29pt |
| Corner radius | `radius-done` (45pt, fully rounded) |
| Text | Barlow SemiBold 16pt, `text-done` (#00B2F3), right-aligned |

### 6.7 Mode Bar Pill

Mode buttons in the top mode bar.

| Property | Value |
|----------|-------|
| Background (active) | `brand-cyan-pill` (#00B2F3) |
| Background (inactive) | `gray-mode-inactive` (#848484) |
| Width | 54pt |
| Height | 29pt |
| Corner radius | `radius-pill` (29pt, fully rounded capsule) |
| Icon | White, centered, 16-18pt |

---

## 7. Input Bar

The Agent input bar is a persistent control at the bottom of the Agent panel.

| Property | Value |
|----------|-------|
| Border | 1pt solid `gray-border` (#888888) |
| Corner radius | `radius-input` (31pt, fully rounded capsule) |
| Background | Transparent (inherits panel background) |
| Height | 42pt (collapsed, single-line placeholder) |
| Max height | ~208pt (expanded, multi-line with content) |
| Padding | 13pt left, 3pt right, 2pt top, 3pt bottom |
| Placeholder text | "let's talk...", Volkhov Regular 16pt, white |
| User text | Volkhov Regular 16pt, white |
| Microphone button | 26x26pt circle, 1pt white border, centered mic icon, positioned bottom-right inside the bar |

### Input Bar Behavior

- When empty: shows placeholder text and mic button, 42pt height
- When the user types: placeholder disappears, bar grows vertically to accommodate text (up to ~208pt), mic button moves to the bottom-right
- The input bar always remains pinned to the bottom of the Agent panel

---

## 8. Panel Tabs

Panel tabs sit between the mode bar and the panel content. Each tab has a rounded top and flat bottom, creating the visual impression that the panel content extends from the tab downward.

| Property | Agent tab | Elements tab | Canvas/object tab |
|----------|-----------|-------------|-------------------|
| Background | Gradient: black to `surface-tab-agent-end` | Gradient: `surface-tab-elements-start` to `surface-tab-elements-end` | Gradient: `surface-tab-canvas-start` to `surface-tab-canvas-end` |
| Width | 187pt | 187pt | 330pt |
| Height | 46pt | 46pt | 46pt |
| Corner radius | Top-right: 23pt | Top-left: 23pt, top-right: 23pt | Top-left: 23pt, top-right: 23pt |
| Label | Barlow Medium 16pt, white | Barlow Medium 16pt, white | Barlow Medium 16pt + Bold for object name |
| Left icon | Spark icon | Gear icon | Eye icon |
| Right icon | None | Add button | Add button |

### Tab Label Format

- Agent tab: "Agent"
- Elements tab: "Elements"
- Canvas/object tab: "Component : **Game Tile**" — type in medium weight, name in bold. Separated by " : " (space-colon-space)

---

## 9. Iconography

### 9.1 Style

All icons are line-style (outlined, not filled), white, consistent stroke weight. The tool uses a small, purpose-built icon set — not SF Symbols in v1 (though SF Symbols may be adopted for the native build).

### 9.2 Core Icons

| Icon | Location | Size | Description |
|------|----------|------|-------------|
| Spark | Agent panel header, mode bar | 16pt | Four-pointed spark — identifies AI/Agent content |
| Add | Elements header, canvas tab row | 18pt | Circle with plus — create new object |
| Gear | Elements tab header | 18pt | Settings indicator |
| Eye | Canvas tab | 18pt | Preview mode indicator |
| Chevrons | Element rows | 38x19pt capsule area | Three small right-pointing triangles — progressive disclosure indicator |
| Mic | Agent input bar | 26pt circle | Microphone for voice input |
| Check | Parameter Picker toggle (on) | 16pt | Checkmark inside circle — parameter enabled |
| Empty circle | Parameter Picker toggle (off) | 16pt | Empty circle — parameter available but not enabled |

### 9.3 The Chevron Indicator

The chevron indicator is three small right-pointing triangles (polygon shapes, ~7x7pt each) arranged horizontally with minimal spacing (~0.8pt gap). They sit inside an invisible 38x19pt hit target, flush right within the element row.

When the element is in its active/expanded state (e.g., Parameter Picker open), the chevron indicator gains a background fill (`brand-cyan-highlight` #01D4F9) with a 7pt corner radius capsule, making it visually prominent.

---

## 10. Gradients

Gradients are used consistently throughout the interface. They always flow in the same direction within a given context.

| Context | Direction | Purpose |
|---------|-----------|---------|
| Buttons (element rows, toggles, actions) | Left to right | Reinforces left-to-right reading direction |
| Tab backgrounds | Bottom to top | Creates the sense that the tab rises from the panel below |
| Canvas background | Top to bottom | Darker at the bottom grounds the workspace |

### Gradient Rule

Every interactive button in the Elements panel uses a left-to-right gradient. The left color is always the brighter value. This consistency means the user can scan the left edge of any button to quickly read its state: cyan = standard, blue = active, gray = toggle option.

---

## 11. Shadows and Depth

Elemental Design's interface is intentionally flat. Depth is expressed through color difference (lighter surfaces sit on top of darker surfaces), not through drop shadows or elevation layers.

- No drop shadows on panels, buttons, or overlays in the standard interface
- The Parameter Picker overlay uses a subtle background fill (`surface-picker-overlay` at 9% white opacity) to distinguish it from the Elements panel behind it — this is a color shift, not a shadow
- The canvas may use a very subtle vignette at the edges to draw focus to the center — this is a canvas treatment, not a UI depth cue

### Exception: Canvas Objects

User-created objects on the canvas may have shadows as part of their design parameters (see `Spec_ObjectModel.md` §7.4). These are content shadows, not chrome shadows — they belong to the user's work, not to the tool.

---

## 12. Animation and Motion

### 12.1 Interface Transitions

| Interaction | Duration | Easing | Description |
|-------------|----------|--------|-------------|
| Panel collapse/expand | 200ms | ease-in-out | Panel width animates, content fades |
| Row expansion | 200ms | ease-out | Content slides down and fades in |
| Row collapse | 150ms | ease-in | Content slides up and fades out |
| Mode bar switch | Instant | None | No transition — mode change is immediate |
| Parameter Picker open | 150ms | ease-out | Overlay fades in and slides down slightly |
| Parameter Picker close | 100ms | ease-in | Overlay fades out |
| Tab switch | Instant | None | Panel content swaps immediately |

### 12.2 Motion Philosophy

- Structural changes (expand, collapse, open, close) get short, purposeful animations
- Navigation changes (mode switch, tab switch) are instant — the user is redirecting attention, not watching something happen
- No bounce, no spring, no overshoot. Every animation resolves cleanly and quickly.

---

## 13. What This Spec Does Not Cover

- User-facing parameter defaults and object styling → `router→ Spec_ObjectModel.md`
- Parameter control types and three-level tuning model → `router→ Spec_ProgressiveDisclosure.md`
- Canvas surface, zoom, selection chrome → `router→ Spec_Canvas.md`
- Panel sizing, collapse behavior, empty states → `router→ Spec_Panels.md`
- Light mode color definitions — deferred until dark mode is validated in-app
