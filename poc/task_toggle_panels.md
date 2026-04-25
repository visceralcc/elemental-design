# Task: Implement Toggle-Based Panel Navigation with Corrected Order

## Summary

Rewrite the mode pill → panel relationship. Pills are independent toggles (not radio buttons). Multiple panels can be visible simultaneously. Fixed left-to-right order. The Code panel sits between Elements and Component.

## Spec reference

Read `specs/Spec_PanelNavigation.md` (v0.3) — this is the authoritative source. Key sections:
- §2 — the six panels and default states
- §3 — fixed ordering: **Agent | Plan | Elements | Code | Component | Viewport**
- §4 — toggle behavior
- §5 — flexible sizing
- §6 — tab row

## What changes from the current implementation

The current POC treats pills as radio buttons — one active at a time. The new behavior:

1. **Pills are toggles.** Clicking an active pill closes that panel. Clicking an inactive pill opens it. Multiple pills can be active (cyan) simultaneously.

2. **Multiple panels visible at once.** If Elements, Code, and Component are all open, all three appear side by side.

3. **Corrected fixed order:** `Agent | Plan | Elements | Code | Component | Viewport`. This is different from the previous task — Code now sits between Elements and Component, not on the far right. Component and Viewport anchor to the right.

4. **Component panel always visible.** Cannot be toggled off.

5. **Flexible widths.** Open panels share available space. Component absorbs extra space.

## State model

Replace `state.mode` with `state.panels`:

```javascript
state.panels = {
  agent: false,
  plan: false,
  elements: true,
  code: false,
  component: true,   // always true, cannot close
  viewport: false
};
```

The PANEL_ORDER array defines rendering sequence:
```javascript
const PANEL_ORDER = ['agent', 'plan', 'elements', 'code', 'component', 'viewport'];
```

## togglePanel function

```javascript
function togglePanel(panel) {
  if (panel === 'component') return;
  const openCount = Object.values(state.panels).filter(v => v).length;
  if (state.panels[panel] && openCount <= 1) return;
  state.panels[panel] = !state.panels[panel];
  render();
}
```

## Pill click handlers

Update each pill's onclick to `togglePanel('xxx')`. In render, set pill active/inactive based on `state.panels[panel]`.

## Panel layout

Use a flex container. On each render, iterate PANEL_ORDER and for each open panel, display its content div. Closed panels get `display: none`.

### Panel sizing (CSS)

| Panel | CSS |
|-------|-----|
| Agent | `width: 260px; min-width: 200px; flex-shrink: 1;` |
| Plan | `width: 260px; min-width: 200px; flex-shrink: 1;` |
| Elements | `width: 260px; min-width: 220px; flex-shrink: 1;` |
| Code | `width: 300px; min-width: 240px; flex-shrink: 1;` |
| Component | `flex: 1; min-width: 400px;` |
| Viewport | `width: 400px; min-width: 300px; flex-shrink: 1;` |

### Panel backgrounds

| Panel | Background |
|-------|-----------|
| Agent | `#1F1F1F` |
| Plan | `#373737` |
| Elements | `#373737` |
| Code | `#2A2A2A` |
| Component | Existing canvas gradient |
| Viewport | `#2A2A2A` |

## Panel content

| Panel | Content |
|-------|---------|
| Agent | Existing Agent placeholder (sparkle icon + "Agent panel coming soon") |
| Plan | Placeholder: "Plan view coming soon" centered, muted text |
| Elements | **Existing Elements panel — all interactive functionality preserved** |
| Code | Mock IDE placeholder (see below) |
| Component | **Existing canvas area — always visible** |
| Viewport | Placeholder: "Viewport coming soon" centered, muted text |

### Code panel placeholder

The Code panel should show a mock IDE-like layout to communicate the concept. It does NOT need real functionality. Suggested layout:

```
┌─────────────────────────────┐
│ [mock file tree]            │
│                             │
│ ▸ Components/               │
│   ▸ CardContainer.swift     │
│   ▸ HeroImage.swift         │
│   ▸ CardTitle.swift          │
│                             │
│─────────────────────────────│
│ // CardContainer.swift      │
│ struct CardContainer: View { │
│   var body: some View {      │
│     VStack(spacing: 16) {    │
│       // children            │
│     }                        │
│     .padding(20)             │
│   }                          │
│ }                            │
│                             │
└─────────────────────────────┘
```

Use a monospace font (system monospace or Barlow) for the code area. Use muted colors for the file tree. This is purely visual — no interactivity needed. The file names can reference the existing component names in the POC.

## Tab row

Render tabs dynamically based on which panels are open. Each tab appears above its panel in the fixed order. Tab designs:

| Panel | Tab bg | Corner radius | Icon | Title |
|-------|--------|---------------|------|-------|
| Agent | `#1F1F1F` | 0 23px 0 0 | icon_agent.svg | "Agent" |
| Plan | `#373737` | 23px 23px 0 0 | icon_plan.svg | "Plan" |
| Elements | `#373737` | 23px 23px 0 0 | icon_elements.svg | "Elements" + placed count |
| Code | `#2A2A2A` | 23px 23px 0 0 | icon_code.svg | "Code : **[selected name]**" |
| Component | `#2A2A2A` | 23px 23px 0 0 | icon_viewport.svg | "Component : **Card Container**" |
| Viewport | `#2A2A2A` | 23px 23px 0 0 | icon_viewport.svg | "Viewport" |

All tabs 46px tall, Barlow Medium 16px white.

## What NOT to change

- Don't change the canvas rendering, component data, or interactive features
- Don't change mode bar pill SVG icons or wordmark
- Don't add real IDE functionality — the Code panel is a visual placeholder only
- Keep mobile breakpoint as-is (multi-panel won't work on mobile — that's fine for now)

## Specs to read

- `specs/Spec_PanelNavigation.md` — the full panel navigation spec (v0.3)
- `specs/Spec_DesignSystem.md` §2.2 (surface colors), §6.7 (pill styles), §8 (tab styles)
