# Elemental Design — POC: Design System Integration & Editable Parameters

**Feature Specification — Evolving the HTML POC to support loadable design systems and interactive parameter editing**

Version 0.1 | April 2026 | Charlie Denison | Elemental Design

**CONFIDENTIAL**

---

## Version History
| Version | Date | Changes |
|---------|------|---------|
| 0.1 | Apr 2026 | Initial draft. Design system loader, Minimal One integration, editable parameters, three-level control model. |

---

## 1. Overview

This spec defines the next evolution of the Elemental Design HTML POC (`poc/elemental-poc.html`). The current POC (v0.2.4) demonstrates component placement, an Elements panel with `>>>` expansion, read-only parameter display, a dynamic Code panel, and an S/M/L scale toggle. This spec adds two capabilities that transform the POC from a viewer into a working design tool:

1. **Design System Loader** — The POC reads a design system definition file (JSON) and uses its tokens and component defaults instead of hardcoded values. The first design system is **Minimal One**, defined in the Elemental Design System Specification (`Spec_Elemental_DesignSystem.md`).

2. **Editable Parameters** — When a user expands a parameter via `>>>`, they see interactive controls (numeric fields, sliders, color pickers) instead of read-only text. Changes update the canvas in real time.

**Design Principle: The design system is the source of truth, not the code.** Every color, radius, spacing value, and font in the POC must come from the loaded design system file. Changing the design system file changes every component's defaults. This is the foundation that makes Elemental useful — the tool doesn't have opinions, the design system does.

**What this spec does NOT cover:**
- Drag-to-reorder or drag-to-canvas interactions (future)
- The Agent panel or AI conversation UI (future)
- Multiple compositions / component patterns beyond the existing card (future, but noted in §8)
- Export to React Native code (future — handled by a separate spec)
- The native macOS/iOS Elemental app (separate codebase)
- Animation or transitions on expand/collapse (nice-to-have, not required)

---

## 2. Design System File Format

The design system is a JSON file that the POC loads at startup. It defines tokens and component defaults.

### 2.1 File Location & Loading

The design system file lives at `poc/design-systems/minimal-one.json`. The POC loads it via a `<script>` tag or inline `fetch()` at startup. If the file fails to load, the POC falls back to its current hardcoded values and shows a subtle warning banner.

A future version will support a design system selector dropdown, but v1 loads `minimal-one.json` by default.

### 2.2 File Structure

```json
{
  "name": "Minimal One",
  "version": "0.1",
  "author": "Charlie Denison",
  "meta": {
    "description": "A structural, modern design system built for assembly.",
    "defaultMode": "light"
  },
  "tokens": {
    "colors": {
      "neutral": {
        "50": "#FAFAFA",
        "100": "#F5F5F5",
        "200": "#E5E5E5",
        "300": "#D4D4D4",
        "400": "#A3A3A3",
        "500": "#737373",
        "600": "#525252",
        "700": "#404040",
        "800": "#262626",
        "850": "#1C1C1C",
        "900": "#171717",
        "950": "#0A0A0A"
      },
      "blue": {
        "50": "#EFF6FF",
        "100": "#DBEAFE",
        "200": "#BFDBFE",
        "300": "#93C5FD",
        "400": "#60A5FA",
        "500": "#3B82F6",
        "600": "#2563EB",
        "700": "#1D4ED8",
        "800": "#1E40AF",
        "900": "#1E3A8A"
      },
      "status": {
        "success": "#22C55E",
        "warning": "#F59E0B",
        "error": "#EF4444",
        "info": "#3B82F6"
      }
    },
    "semantic": {
      "light": {
        "background": "neutral.50",
        "surface": "#FFFFFF",
        "surfaceElevated": "neutral.100",
        "border": "neutral.200",
        "borderSubtle": "neutral.100",
        "textPrimary": "neutral.900",
        "textSecondary": "neutral.500",
        "textTertiary": "neutral.400",
        "textInverse": "neutral.50",
        "accentPrimary": "blue.500",
        "accentPressed": "blue.600",
        "accentSurface": "blue.50",
        "accentText": "blue.700"
      },
      "dark": {
        "background": "neutral.900",
        "surface": "neutral.850",
        "surfaceElevated": "neutral.800",
        "border": "neutral.700",
        "borderSubtle": "neutral.800",
        "textPrimary": "neutral.50",
        "textSecondary": "neutral.400",
        "textTertiary": "neutral.600",
        "textInverse": "neutral.900",
        "accentPrimary": "blue.400",
        "accentPressed": "blue.500",
        "accentSurface": "blue.900",
        "accentText": "blue.300"
      }
    },
    "typography": {
      "fontPrimary": "Barlow",
      "fontCondensed": "Barlow Condensed",
      "scale": {
        "displayLarge":  { "size": 32, "weight": 700, "lineHeight": 1.2, "font": "condensed" },
        "displayMedium": { "size": 28, "weight": 700, "lineHeight": 1.2, "font": "condensed" },
        "displaySmall":  { "size": 24, "weight": 600, "lineHeight": 1.25, "font": "condensed" },
        "headingLarge":  { "size": 20, "weight": 600, "lineHeight": 1.3, "font": "primary" },
        "headingMedium": { "size": 18, "weight": 600, "lineHeight": 1.3, "font": "primary" },
        "headingSmall":  { "size": 16, "weight": 600, "lineHeight": 1.35, "font": "primary" },
        "bodyLarge":     { "size": 16, "weight": 400, "lineHeight": 1.5, "font": "primary" },
        "bodyMedium":    { "size": 14, "weight": 400, "lineHeight": 1.5, "font": "primary" },
        "bodySmall":     { "size": 12, "weight": 400, "lineHeight": 1.5, "font": "primary" },
        "labelLarge":    { "size": 14, "weight": 500, "lineHeight": 1.3, "font": "primary" },
        "labelMedium":   { "size": 12, "weight": 500, "lineHeight": 1.3, "font": "primary" },
        "labelSmall":    { "size": 10, "weight": 500, "lineHeight": 1.3, "font": "condensed" },
        "stat":          { "size": 20, "weight": 700, "lineHeight": 1.1, "font": "condensed" }
      }
    },
    "spacing": {
      "xxs": 2, "xs": 4, "sm": 8, "md": 12, "lg": 16, "xl": 24, "xxl": 32, "xxxl": 48
    },
    "radius": {
      "none": 0, "sm": 4, "md": 6, "lg": 8, "full": 9999
    },
    "shadow": {
      "sm": { "x": 0, "y": 1, "blur": 2, "opacity": 0.05 },
      "md": { "x": 0, "y": 4, "blur": 6, "opacity": 0.07 },
      "lg": { "x": 0, "y": 10, "blur": 15, "opacity": 0.1 }
    }
  },
  "componentDefaults": {
    "container": {
      "padding": "lg",
      "radius": "md",
      "backgroundColor": "surface",
      "spacing": "md"
    },
    "button": {
      "height": 44,
      "paddingH": "lg",
      "radius": "md",
      "fontSize": "labelLarge",
      "variant": "primary"
    },
    "text": {
      "variant": "bodyMedium",
      "color": "textPrimary"
    },
    "listItem": {
      "minHeight": 48,
      "paddingH": "lg",
      "paddingV": "md",
      "avatarSize": 40,
      "showDivider": true
    },
    "image": {
      "radius": "sm",
      "fit": "cover"
    }
  }
}
```

### 2.3 Token Resolution

Semantic token values like `"neutral.50"` are dot-path references to the raw palette. The POC resolves them at load time:

```
"textPrimary": "neutral.900" → resolves to → "#171717"
```

Values that are already hex strings (like `"surface": "#FFFFFF"`) are used directly.

---

## 3. Refactoring the POC to Use Design System Tokens

### 3.1 What Changes

Currently, the POC has colors, fonts, spacing, and radii hardcoded throughout the CSS and JS. This refactoring extracts all visual values into CSS custom properties that are set from the design system JSON at load time.

**CSS custom properties to generate from the design system:**

| Property | Source |
|----------|--------|
| `--ds-bg` | `semantic[mode].background` |
| `--ds-surface` | `semantic[mode].surface` |
| `--ds-surface-el` | `semantic[mode].surfaceElevated` |
| `--ds-border` | `semantic[mode].border` |
| `--ds-text-pri` | `semantic[mode].textPrimary` |
| `--ds-text-sec` | `semantic[mode].textSecondary` |
| `--ds-text-ter` | `semantic[mode].textTertiary` |
| `--ds-text-inv` | `semantic[mode].textInverse` |
| `--ds-accent` | `semantic[mode].accentPrimary` |
| `--ds-accent-pressed` | `semantic[mode].accentPressed` |
| `--ds-accent-surface` | `semantic[mode].accentSurface` |
| `--ds-accent-text` | `semantic[mode].accentText` |
| `--ds-font-primary` | `typography.fontPrimary` |
| `--ds-font-condensed` | `typography.fontCondensed` |
| `--ds-radius-sm` | `radius.sm` + `px` |
| `--ds-radius-md` | `radius.md` + `px` |
| `--ds-radius-lg` | `radius.lg` + `px` |
| `--ds-space-sm` | `spacing.sm` + `px` |
| `--ds-space-md` | `spacing.md` + `px` |
| `--ds-space-lg` | `spacing.lg` + `px` |
| `--ds-space-xl` | `spacing.xl` + `px` |

**Important:** These `--ds-*` properties drive the **canvas preview** (the user's composed card). The Elemental tool chrome (mode bar, Elements panel, tab strip) keeps its existing dark theme — the design system only affects the content area.

### 3.2 Theme Toggle

Add a small toggle in the Component panel header area to switch between light and dark mode. When toggled, the POC re-resolves semantic tokens from the other mode and updates the `--ds-*` CSS properties. The canvas preview re-renders with the new colors. The Elemental tool chrome does not change.

The toggle should be a simple two-state pill: `Light | Dark`.

### 3.3 Design System Name Display

Show the loaded design system name in the Component panel header: `"Minimal One"` in small text. This confirms which design system is active and sets up the future design system selector.

---

## 4. Editable Parameters — The Three-Level Control Model

This is the core interaction change. Currently, expanding `>>>` on a component shows read-only parameter values. After this update, it shows interactive controls.

### 4.1 Control Layout

When a parameter row is expanded, three levels of control appear inline, stacked vertically:

```
  Padding                             ^^^
  ┌─────────────────────────────────────┐
  │  [Auto]                             │  ← Level 1: Auto pill
  │                                     │
  │  [━━━━━●──────────] 16              │  ← Level 2: Slider + readout
  │                                     │
  │  [ 16 ]  pt                         │  ← Level 3: Exact value field
  └─────────────────────────────────────┘
```

All three levels are visible simultaneously. They are not tabs — they are one coherent control surface.

### 4.2 Level 1 — Auto Pill

A small pill-shaped button labeled "Auto". When active (default state for new components), it has the accent color fill. When inactive, it's outlined/ghost style.

- **Active:** The parameter value is managed by the design system defaults. The slider and input show the current auto-resolved value but are dimmed.
- **Inactive:** The user has overridden the value. The slider and input are fully interactive.
- **Clicking Auto when inactive:** Returns the parameter to its design system default. The slider and input update to show the default value and dim.
- **Adjusting the slider or typing an exact value:** Automatically deactivates Auto.

### 4.3 Level 2 — Slider

A horizontal slider with a round thumb. The track fill (left of thumb) uses the accent color. To the right of the slider, a numeric readout shows the current value.

**Slider ranges by parameter type:**

| Parameter | Min | Max | Step |
|-----------|-----|-----|------|
| Padding (any side) | 0 | 64 | 1 |
| Corner Radius | 0 | 32 | 1 |
| Spacing | 0 | 64 | 1 |
| Width | 0 | 800 | 1 |
| Height | 0 | 800 | 1 |
| Font Size | 8 | 72 | 1 |
| Opacity | 0 | 100 | 1 |
| Border Width | 0 | 16 | 0.5 |

**Real-time update:** As the slider is dragged, the canvas updates live. No need to release — continuous feedback.

### 4.4 Level 3 — Exact Value Field

A small text input showing the current value. The unit label (`pt`, `px`, `%`) appears to the right of the field, outside the input.

- Accepts numeric input only.
- Pressing Enter or Tab commits the value.
- Values outside the slider range are accepted — the slider thumb moves to the nearest boundary.
- Invalid input (non-numeric, negative where not allowed) reverts to previous value.

### 4.5 Non-Numeric Controls

Some parameters use different control types instead of the three-level slider model:

| Parameter | Control Type | Behavior |
|-----------|-------------|----------|
| Background Color | Color swatch grid | Show the semantic colors from the design system as a grid of swatches. Clicking a swatch applies it. Include a text input for arbitrary hex values. |
| Text Content | Inline text input | Single-line input that expands to multiline if the text wraps. |
| Font Size | Slider (per §4.3) | Uses the type scale as labeled snap points on the slider. |
| Fit Mode (Image) | Segmented picker | Horizontal pills: `Fill | Fit | Stretch`. |
| Corner Radius | Slider (per §4.3) | Standard slider. |
| Clip | Toggle | On/Off switch. |

### 4.6 Parameter Groups

Parameters within an expanded component row are organized under group headers:

- **Structure** — Size, Padding, Corner Radius, Spacing, Clip
- **Content** — Color, Opacity, Text, Image
- **Behavior** — (Empty for v1 — Interaction and State controls are future)

Group headers use the same styled treatment as the current POC's parameter section headers (if they exist) or a subtle divider with a small uppercase label.

---

## 5. Canvas Updates

When a parameter value changes (via slider, exact input, or color swatch), the canvas preview updates immediately. The update flow:

```
User adjusts slider → Component data model updates → Canvas re-renders → Code panel updates
```

### 5.1 What Updates on the Canvas

| Parameter Changed | Canvas Effect |
|-------------------|---------------|
| Padding | Internal spacing between container edge and children adjusts. If padding overlay is active, overlay labels update. |
| Corner Radius | Container corners visually round/sharpen. |
| Spacing | Gap between child elements adjusts. If spacing overlay is active, spacing indicators update. |
| Background Color | Container fill color changes. |
| Font Size | Text element resizes. |
| Opacity | Element becomes more/less transparent. |
| Width / Height | Element resizes (if applicable). |
| Text Content | Text content updates in place. |

### 5.2 Code Panel Updates

The Code panel already updates based on selected element (v0.2.4). When a parameter value changes, the code preview should reflect the new value. For example, if the user changes padding from 16pt to 24pt, the code should show `.padding(24)` instead of `.padding(16)`.

---

## 6. Replacing the S/M/L Scale Toggle

The current S/M/L scale toggle (0.75× / 1× / 1.25×) is replaced by an explicit canvas zoom control. The new control appears in the same location (bottom of Component panel) but offers:

- A zoom slider: 50% to 200%, default 100%
- A reset button that returns to 100%
- A zoom readout showing the current percentage

The zoom scales the entire canvas preview uniformly. It does not affect parameter values — a 16pt padding still reads as 16pt even when the canvas is zoomed to 150%.

---

## 7. Edge Cases & Rules

### 7.1 Design System Load Failure
If `minimal-one.json` fails to load (network error, invalid JSON), the POC falls back to its current hardcoded values. A small warning banner appears at the top of the Component panel: "Design system failed to load — using defaults."

### 7.2 Value Conflicts
If a user overrides a parameter and then switches the design system's theme mode (light → dark), the user's override persists. The override is to the value itself, not to the theme-specific token. For example: if the user sets background to `#FF0000`, it stays `#FF0000` in both light and dark mode.

### 7.3 Canvas Zoom vs. Parameter Values
Zoom is purely visual. All parameter values, slider positions, and exact value fields always show the true value, not the zoomed value.

### 7.4 Minimum Touch Targets
All sliders, inputs, and buttons must have a minimum clickable area of 32px height in the Elements panel. This ensures usability even though the panel may be narrow.

### 7.5 Undo
No undo system in v1. The user can click Auto to return any parameter to its default. A future version may add Cmd+Z support.

---

## 8. Relationship to Other Systems

| System / File | Relationship | Notes |
|---------------|-------------|-------|
| `Spec_Elemental_DesignSystem.md` | Source of truth for Minimal One tokens | The JSON file in §2.2 is a serialized version of the token tables in that spec. |
| `Spec_ObjectModel.md` | Defines parameter types and defaults | §4 and §8 of the Object Model spec define which parameters exist per subtype. This POC implements a subset. |
| `Spec_ProgressiveDisclosure.md` | Defines the three-level control model | §4–6 of that spec define Auto/Slider/Exact behavior. This POC implements the web equivalent. |
| `Spec_Canvas.md` | Future — canvas interaction | Direct manipulation (drag-to-resize) is not in this POC. |
| `Spec_Agent.md` | Future — Agent panel | No Agent functionality in this POC. |
| Native Elemental app (`ElementalDesign/`) | Parallel codebase | This POC is independent. Learnings from the POC may inform the native app, but there is no code sharing. |

### No Direct Interaction
- **Supabase / Backend** — The POC is entirely client-side. No backend calls.
- **React Native / Expo** — The POC outputs no React Native code. It's an HTML demo only.
- **GitHub / CI/CD** — The POC is a single HTML file with a JSON sidecar. No build pipeline.

---

## 9. Data Model (Internal to the POC)

The POC maintains a simple in-memory data model. No persistence.

```javascript
// Loaded design system
const designSystem = {
  name: "Minimal One",
  tokens: { /* resolved token values */ },
  componentDefaults: { /* per-component defaults */ }
};

// Active theme mode
let activeMode = "light"; // or "dark"

// Component instances (one per placed component)
const components = [
  {
    id: "card-container",
    type: "shape",
    name: "Card Container",
    parameters: {
      structure: {
        padding: { value: 16, auto: true, unit: "pt" },
        cornerRadius: { value: 6, auto: true, unit: "pt" },
        spacing: { value: 12, auto: true, unit: "pt" },
        clip: { value: true, auto: true }
      },
      content: {
        backgroundColor: { value: "#FFFFFF", auto: true, tokenRef: "surface" },
        opacity: { value: 100, auto: true, unit: "%" }
      }
    },
    children: [ /* child component IDs */ ]
  }
  // ... more components
];

// When auto is true, the value comes from designSystem.componentDefaults
// When auto is false, the value is user-overridden
```

---

## 10. Build Sequence

### Phase 1 — Design System JSON & Loader
1. Create `poc/design-systems/minimal-one.json` with the full token set from §2.2.
2. Add a `loadDesignSystem()` function that fetches the JSON, resolves token references (dot-path to hex), and sets CSS custom properties on the canvas area.
3. Add fallback behavior per §7.1.
4. Display the design system name in the Component panel header per §3.3.
5. Verify: the canvas card should look identical to before, but all colors/spacing/radii now come from CSS custom properties set by the JSON.

### Phase 2 — Theme Toggle
1. Add a `Light | Dark` toggle pill in the Component panel header.
2. Wire it to re-resolve semantic tokens from the selected mode and update CSS custom properties.
3. The Elemental tool chrome (mode bar, tabs, Elements panel) must NOT change — only the canvas content area switches theme.
4. Verify: toggling between light and dark mode should show the card with correct colors for each mode.

### Phase 3 — Editable Parameters (Numeric — Slider + Input)
1. Refactor the existing `>>>` expansion to show the three-level control layout (§4.1).
2. Implement the Auto pill with active/inactive states (§4.2).
3. Implement the slider with real-time canvas update (§4.3).
4. Implement the exact value input (§4.4).
5. Start with these parameters only: Padding, Corner Radius, Spacing.
6. Verify: adjusting Padding slider on the Card Container should visibly change the container's padding on the canvas. The code panel should reflect the new value.

### Phase 4 — Editable Parameters (Color + Non-Numeric)
1. Implement the color swatch grid for Background Color (§4.5). Populate swatches from the design system's semantic colors.
2. Implement the text content inline editor for Text elements.
3. Implement the toggle for Clip.
4. Wire Font Size as a slider using the type scale snap points.
5. Verify: changing the card's background color via swatch should update the canvas and code panel.

### Phase 5 — Canvas Zoom Replacement
1. Remove the S/M/L scale toggle.
2. Add the zoom slider (50%–200%) with readout and reset button (§6).
3. Verify: zooming does not affect parameter values, only visual scale.

### Phase 6 — Polish & Integration Test
1. Ensure all parameter changes persist correctly when expanding/collapsing `>>>` rows.
2. Ensure the filled dot indicator (`•`) appears on parameters that have been overridden from their Auto default.
3. Test theme switching with user-overridden values per §7.2.
4. Test all parameter types across all components in the card composition.
5. Update `BUILD_STATUS.md` with the new version and feature list.

---

## 11. Files Affected (Summary)

| File / Path | Change |
|-------------|--------|
| `poc/elemental-poc.html` | Major refactor: design system loader, CSS custom properties, editable parameter controls, theme toggle, zoom replacement |
| `poc/design-systems/minimal-one.json` | **New file** — Minimal One design system definition |
| `poc/BUILD_STATUS.md` | Update with new version, features, and known issues |
| `poc/DESIGN_INTENT.md` | Minor update to reflect the design system loader concept |

---

## 12. Future Considerations (Not in This Spec)

- **Design System Selector** — A dropdown to switch between multiple loaded design systems
- **Component Palette** — The ability to add new component types (Button, ListItem, Header, Modal) beyond the existing card composition
- **Design System Editor** — Edit token values directly in the POC and export an updated JSON
- **Shared Folder Sync** — Read/write design system files from the local filesystem via the MCP server, enabling real-time collaboration between the Elemental tool and Claude
- **Export to React Native** — Generate component code from the current composition

---

## Claude Code Handoff Prompt

```claude-code-handoff
Project: Elemental Design (POC) | Repo: visceralcc/elemental-design (or local) | Branch: main

Spec file: poc/Spec_POC_DesignSystemIntegration.md
→ If this file doesn't exist yet, create it first with the full spec content.

Follow the Build Sequence in §10 of the spec, phase by phase.

Key constraints:
- The POC is a SINGLE HTML file (`poc/elemental-poc.html`) with zero build dependencies (fonts loaded via embedded base64 or CDN). Keep it that way — no npm, no bundler.
- Design system tokens drive the CANVAS PREVIEW only. The Elemental tool chrome (mode bar, Elements panel, tabs) keeps its existing dark theme unchanged.
- All parameter values use the data model in §9. When `auto: true`, the value comes from `designSystem.componentDefaults`. When `auto: false`, the user has overridden it.
- The design system JSON file lives at `poc/design-systems/minimal-one.json`. The POC fetches it at startup.

Start with: Phase 1 — Create the `minimal-one.json` file and implement the `loadDesignSystem()` function that sets CSS custom properties from the resolved tokens. The canvas card should look identical to before, but all visual values now come from the JSON.

Work phase by phase. After completing each phase, stop and check in before moving on.
Commit after each phase with a message like "feat(poc): Phase 1 — design system loader and Minimal One JSON".
```
