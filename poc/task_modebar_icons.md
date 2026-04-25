# Task: Replace Mode Bar Stub Icons with SVG Buttons

## What to change

Replace the 5 text-character mode bar pills in `poc/elemental-poc.html` with real SVG icons from `assets/buttons/`.

## Current state

The mode bar uses plain text characters (`✦`, `☰`, `⚙`, `</>`, `👁`) inside small colored divs (32×22px). These are placeholders.

## SVG source files

The 5 SVG files are at `assets/buttons/`. Each file is a Figma component set export containing **two variants** of the same button:

- **First variant (top half):** The **active** state — a 54×29px rounded capsule with `#00B2F3` fill and a white icon centered inside
- **Second variant (bottom half):** The **inactive** state — same capsule and icon, but with `#848484` fill

Each file also has a dashed purple border rect (`stroke="#8A38F5" stroke-dasharray="10 5"`) — this is just the Figma component set frame. Ignore it.

### Structure of each SVG file
```
<svg viewBox="0 0 94 118">
  <rect ... stroke-dasharray="10 5"/>       ← Figma frame — IGNORE
  <rect x="20" y="20" ... fill="#00B2F3"/>  ← Active pill background
  <path ... fill="white"/>                   ← Active icon (may be multiple paths)
  <rect x="20" y="69" ... fill="#848484"/>  ← Inactive pill background
  <path ... fill="white"/>                   ← Inactive icon (same paths, shifted down 49px)
</svg>
```

### Button mapping (left to right in mode bar)

| Position | Mode | SVG file | Current stub |
|----------|------|----------|-------------|
| 1 | Agent | `assets/buttons/button_agent.svg` | `✦` |
| 2 | Elements | `assets/buttons/button_elements.svg` | `☰` |
| 3 | Plan | `assets/buttons/button_plan.svg` | `⚙` |
| 4 | Code | `assets/buttons/button_code.svg` | `</>` |
| 5 | Viewport | `assets/buttons/button_viewport.svg` | `👁` |

### Active/inactive states to maintain

| Pill | State | Background |
|------|-------|------------|
| Agent | active | `#00B2F3` |
| Elements | active | `#00B2F3` |
| Plan | inactive | `#848484` |
| Code | inactive | `#848484` |
| Viewport | inactive | `#848484` |

## Implementation steps

1. **Read all 5 SVG files** from `assets/buttons/`
2. **Extract only the white icon paths** from the active variant (top half) of each file. The inactive variant uses the same icon shifted down — you only need one set of paths per button.
3. **Embed as inline SVGs** in each `.mode-pill` div. Only include the white icon `<path>` elements — the pill background is handled by CSS. Set a `viewBox` that frames just the icon paths (crop to the icon bounds, not the full 94×118 source).
4. **Update `.mode-pill` CSS** to match `Spec_DesignSystem.md` §6.7:
   - Width: **54px**, Height: **29px**
   - Corner radius: **29px** (fully rounded capsule)
   - Active fill: `#00B2F3`, Inactive fill: `#848484`
5. **Update mobile breakpoint** (`@media max-width: 640px`) proportionally — ~42×22px pills
6. **Adjust mode bar layout** if needed so pills sit centered in the 44px bar height

## Notes

- The Viewport SVG (`button_viewport.svg`) has both variants exported with `#00B2F3` fill — this is a Figma export quirk. The CSS class handles the inactive color, so just extract the white icon paths.
- The Elements cube icon uses `stroke="white"` attributes — preserve those.
- Keep SVG path data exactly as exported. Don't simplify paths.

## Specs to read

- `specs/Spec_DesignSystem.md` §6.7 (Mode Bar Pill) and §9.2 (Core Icons)
