# Task: Replace Placeholder Parameter Content with Styled Dummy Controls

**POC Version:** v0.2.2 → v0.2.3
**File:** `poc/elemental-poc.html`

---

## What to do

Replace the current monospace text dump that appears when you expand a component row (the `el-params` block with `size: 200pt × auto`, `padding: 20/20/20/20pt`, etc.) with **styled dummy parameter rows** that look like real design tool controls.

**Do NOT touch the Card Container's expanded content.** Only replace the expanded content for: Hero Image, Card Title, Card Description, Category Label, and Action Bar.

The Card Container keeps its current parameter readout as-is (it serves a different purpose — showing the full parameter model).

---

## Visual pattern (match this style)

Each parameter is shown as:

1. **A blue gradient header row** — the parameter name on the left, `>>>` chevron indicator on the right. Same styling as the element rows but used for individual parameters.
   - Background: `linear-gradient(to right, var(--brand-blue), var(--brand-blue-deep))` (the blue gradient, same as a selected element row)
   - Height: ~33px
   - Border radius: 4px
   - Padding: 7px 10px
   - Text: Barlow Bold 13px, white
   - `>>>` chevrons on the right, same style as element rows

2. **Dark value badges below** — rounded dark rectangles showing the parameter's current value(s)
   - Background: `rgba(255,255,255,0.06)` (very subtle dark fill, similar to the existing `el-params` background but applied per-badge)
   - Border radius: 6px
   - Padding: 6px 12px
   - Text: Barlow Medium 13px, white
   - Badges sit in a horizontal row with 6px gap, wrapping if needed
   - Badge container has 6px top margin from the header row

These are **static/read-only** — no interactivity needed. They just need to look like real parameter controls.

---

## What each component should show

### Hero Image
Parameter row 1: **Size**
- Badges: `fill` `180h`

Parameter row 2: **Image**
- Badges: `Fill` `mountain-vista.jpg`

Parameter row 3: **Corner Radius**
- Badge: `10`

### Card Title
Parameter row 1: **Text**
- Badges: `Title` `"Mountain Vista"`

Parameter row 2: **Size**
- Badges: `hug` `hug`

### Card Description
Parameter row 1: **Text**
- Badges: `Body` `"A breathtaking alpine…"`

Parameter row 2: **Max Lines**
- Badge: `unlimited`

### Category Label
Parameter row 1: **Text**
- Badges: `Label` `"ADVENTURE · NATURE"`

Parameter row 2: **Color**
- Badge with a small color swatch (white circle at 50% opacity, ~8px, inline before the text): `50% White`

### Action Bar
Parameter row 1: **Direction**
- Badge: `Horizontal`

Parameter row 2: **Spacing**
- Badge: `16pt`

Parameter row 3: **Children**
- Badges: `Heart` `Share` `Bookmark`

---

## Implementation approach

Replace the `renderParams(comp)` function's output for non-container components. One approach:

1. In `renderParams()`, check if `comp.id === 'container'` — if so, keep the existing monospace readout.
2. For all other components, call a new function like `renderStyledParams(comp)` that returns the styled HTML based on the component's id.
3. The styled params can be hardcoded per component — this is a POC with dummy content, not a dynamic system.

### CSS to add

```css
/* Styled parameter rows */
.param-row {
  margin-bottom: 8px;
}
.param-row:last-child {
  margin-bottom: 0;
}
.param-header {
  background: linear-gradient(to right, var(--brand-blue), var(--brand-blue-deep));
  border-radius: 4px;
  padding: 7px 10px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-family: 'Barlow', sans-serif;
  font-size: 13px;
  font-weight: 700;
  color: var(--text-primary);
}
.param-header .el-chevron {
  font-size: 10px;
  opacity: 0.6;
  letter-spacing: -1px;
}
.param-badges {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-top: 6px;
}
.param-badge {
  background: rgba(255,255,255,0.06);
  border-radius: 6px;
  padding: 6px 12px;
  font-family: 'Barlow', sans-serif;
  font-size: 13px;
  font-weight: 500;
  color: var(--text-primary);
  display: flex;
  align-items: center;
  gap: 6px;
}
.param-color-swatch {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  flex-shrink: 0;
}
```

---

## What NOT to change

- Do not change the Card Container's expanded parameter readout — keep it exactly as it is
- Do not change any element row styling, selection behavior, or toggle logic
- Do not change canvas rendering
- Do not add interactivity to the parameter badges (no click handlers, no hover states)
- Do not change the expand/collapse behavior — `>>>` on element rows still toggles the expanded content

---

## Verification

After the change:
1. Clicking a placed component row expands it to show styled parameter rows (blue headers + dark badges)
2. Card Container still shows the original monospace parameter readout
3. Each component shows different, relevant parameters (not all the same)
4. The parameter rows look polished — a designer would see this and think "that's a real tool"
5. `>>>` chevron on element rows still toggles expand/collapse
6. No console errors
7. Mobile layout still works

---

## Files to read first

- `poc/CLAUDE.md` — POC rules
- `poc/elemental-poc.html` — the file you're editing
- `specs/Spec_DesignSystem.md` §6 — button styles and color tokens (for reference)
- `specs/Spec_ObjectModel.md` §7 — parameter definitions (for reference on what parameters exist)
