# Task: Redesign Panel Tabs to Match Figma

## What to change

Replace the current stub panel tabs in `poc/elemental-poc.html` with properly designed tabs that match the Figma designs. The current tabs are simple colored bars with text labels. The new tabs should have icons, proper corner radii, and widths determined by content.

## Current state

The POC has two tabs:
- `.panel-tab-el` — "Elements" tab above the Elements panel (gray background)
- `.panel-tab-cv` — "Component : **Card Container**" tab above the Canvas panel (darker gray background)

There is no Agent tab currently — the POC doesn't have an Agent panel, but we need to add the Agent tab above the Elements panel (since the Agent panel would sit to its left in the full app).

## Figma design reference

Two Figma nodes were pulled. Here's what they show:

### Agent tab (node 256:705)
- Background: `#1F1F1F` (surface-agent color)
- Size: 187×46px in Figma, but **width should be determined by title content** (not fixed)
- Corner radius: **straight left side** (0 on top-left, 0 on bottom-left), **23px on top-right**, 0 on bottom-right
- Contains an icon-title lockup: icon_agent.svg (23×23px) + "Agent" label
- Label: Barlow Medium 16px, white
- The icon and title sit together as a horizontal lockup with ~5px gap

### Elements tab (node 256:719)
- Background: `#373737` (surface-elements color)
- Size: 187×46px in Figma, but **width should be determined by title content** (not fixed)
- Corner radius: **23px on top-left**, **23px on top-right**, 0 on bottom (rounded top, flat bottom)
- Contains an icon-title lockup: icon_elements.svg (18×21px) + "Elements" label
- Label: Barlow Medium 16px, white

### Canvas/Component tab (not a separate Figma node provided — follow the same pattern)
- Background: canvas tab gradient (surface-tab-cv-start to surface-tab-cv-end)
- Corner radius: **23px on top-left**, **23px on top-right**, 0 on bottom
- Contains an icon-title lockup: icon_viewport.svg + "Component : **Card Container**" label
- The object name ("Card Container") should be bold weight

## Tab design rules (from Charlie)

1. **Agent tab**: straight left side (no radius), radius top-right (23px)
2. **All other tabs**: radius top-left AND top-right (23px each), flat bottom
3. **All tabs have**: an icon + a title
4. **All tabs use**: the gray background color matching their panel section
5. **Tab width**: determined by the width of the title content (not fixed 187px) — use horizontal padding to give breathing room

## Icon SVG files

The icon SVGs are at `assets/icons/`. Embed them as inline SVGs in the tab markup (same approach as the mode bar pills — inline path data, not external file references).

| Tab | Icon file | Icon dimensions |
|-----|-----------|----------------|
| Agent | `assets/icons/icon_agent.svg` | 23×23px |
| Elements | `assets/icons/icon_elements.svg` | 19×22px (has stroke="white" stroke-width="0.2") |
| Canvas | `assets/icons/icon_viewport.svg` | 20×12px |

The icon SVGs have their own viewBox and white fill. Use them at approximately the sizes listed above (scale slightly if needed for visual balance within the 46px tab height).

## Implementation details

### Tab height
46px per Figma (currently 34px in the POC). Update to 46px.

### Tab layout
Each tab is a horizontal flex row:
- Icon (vertically centered)
- Gap: ~5–8px
- Title text (Barlow Medium 16px, white, vertically centered)
- Horizontal padding: ~10–14px on each side

### Tab arrangement in the POC
The POC currently has two tab rows — one above the Elements panel, one above the Canvas area. Update both:

**Above the Elements panel section**: Show the Elements tab (with icon_elements + "Elements" label + the placed count on the right side)

**Above the Canvas section**: Show the Canvas tab (with icon_viewport + "Component : **Card Container**" label). Keep the existing dynamic content format where "Card Container" is bold.

Note: The Agent tab exists in the full app design but the POC doesn't have an Agent panel. **Do not add an Agent tab** — just update the two existing tabs to match the new design pattern.

### Background colors
- Elements tab: `#373737` (var(--surface-elements)) — solid color, not a gradient
- Canvas tab: Keep the existing gradient or use a solid color from the canvas surface tokens. The Figma design for the Elements tab uses a solid fill, so consider making the canvas tab solid too (`#2A2A2A` or similar dark value).

### What NOT to change
- Don't add an Agent panel or Agent tab
- Don't change the panel content below the tabs
- Don't change the mode bar
- Don't change the controls strip at the bottom of the Elements panel

## Spec references

Read `specs/Spec_DesignSystem.md` §8 (Panel Tabs) and §3 (Typography) before implementing.
Read `specs/Spec_Panels.md` §5–6 for tab label format.
