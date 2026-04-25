# Task: Fix Panel Tab Visual Contrast

## Problem

The panel tabs (Elements, Canvas) have the correct rounded corners and icons, but they're invisible because they blend into the mode bar. The tab backgrounds are similar grays sitting directly against the mode bar's `#4B4B4B`, so the rounded corners have no contrast to read against.

## What the comp shows

Look at the Figma comp screenshot (image 1 the user uploaded). The visual structure from top to bottom is:

1. **Mode bar** — `#4B4B4B` strip, 44px tall, contains the five pill buttons and wordmark
2. **Tab row** — a horizontal strip that sits BELOW the mode bar. The **background behind and between the tabs** is very dark (near-black, approximately the canvas dark color `#161616` or similar). The tabs themselves are colored shapes (Agent: `#1F1F1F`, Elements: `#373737`, Canvas: ~`#2A2A2A`) with rounded tops that visually "pop" off this dark background strip because of the color contrast.

The key insight: the rounded corners only work visually when there's a darker color BEHIND the tabs. Without it, the tabs just look like a continuation of the mode bar.

## What to change in `poc/elemental-poc.html`

### 1. Add a tab row container

Create a horizontal strip below the mode bar that spans the full window width. This strip should have a very dark background (e.g., `#161616` or `#111111` or black). The individual tabs sit inside this strip as colored shapes with their rounded tops.

Current structure:
```
mode-bar
main
  panel-elements
    panel-tab-el    ← tab is INSIDE the panel
    panel-scroll
  canvas-area
    panel-tab-cv    ← tab is INSIDE the canvas
    canvas-body
```

New structure:
```
mode-bar
tab-row             ← NEW: dark background strip, full width
  tab-agent-space   ← (optional: empty space or Agent tab placeholder matching Agent panel width)
  tab-el            ← Elements tab with rounded top corners
  tab-cv            ← Canvas tab with rounded top corners
main
  panel-elements
    panel-scroll    ← tab moved OUT of the panel
  canvas-area
    canvas-body     ← tab moved OUT of the canvas
```

Alternatively, keep the tabs inside each panel but add a dark background strip that runs behind both tab areas. The important thing is that the area BEHIND and BETWEEN the tab shapes is visibly darker than the tabs themselves.

### 2. Tab background colors (solid, not gradient)

| Tab | Background | Corner radius |
|-----|-----------|---------------|
| Elements | `#373737` | 23px top-left, 23px top-right, 0 bottom |
| Canvas | `#2A2A2A` | 23px top-left, 23px top-right, 0 bottom |

### 3. Dark strip behind tabs

The strip/row that contains the tabs should be approximately:
- Height: 46px (same as tab height)
- Background: very dark — `#161616` or `#111111` or even `#000000`
- The tabs sit as colored shapes WITHIN this dark strip, so the rounded corners are visible against the dark background

### 4. Tab width behavior

Tabs should NOT be full-width of their panel. Their width should be determined by their content (icon + title + padding). The remaining space in the dark strip should show the dark background through.

Look at the comp — the Elements tab only extends as wide as the icon + "Elements" text + padding. The canvas tab extends as wide as the icon + "Component : Game Tile" text + padding. The space to the right of each tab shows the dark background.

### 5. Don't break existing features

- The Elements panel content (component rows, controls strip) still needs to appear below its tab
- The Canvas area content still needs to appear below its tab
- Selection sync, parameter expansion, and all interactive features must keep working
- The placed count ("0/6 placed") should stay on the Elements tab, right-aligned within the tab shape

## Spec references

Read `specs/Spec_DesignSystem.md` §8 (Panel Tabs) for colors and dimensions.
Read `specs/Spec_Panels.md` §2 for panel layout structure.
