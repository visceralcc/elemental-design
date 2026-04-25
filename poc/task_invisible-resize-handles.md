# Task: Remove Visible Resize Handle Line — Cursor Only

**POC Version:** v0.2.4 → v0.2.5
**File:** `poc/elemental-poc.html`

---

## What to do

Remove the visible 1px line from the resize handles between panels. The only visual signal should be the cursor changing to `col-resize` when the user hovers over the gap between panels.

No line. No color change on hover. No highlight while dragging. Just the cursor.

---

## CSS changes

Find the `.resize-handle` and related CSS rules and update them:

```css
.resize-handle {
  width: 12px;
  min-width: 12px;
  cursor: col-resize;
  display: flex;
  align-items: stretch;
  justify-content: center;
  flex-shrink: 0;
  z-index: 10;
}
```

**Remove entirely:**
- The `.resize-handle::after` pseudo-element (the 1px line)
- The `.resize-handle:hover::after` rule (the hover brightening)
- The `.resize-handle.dragging::after` rule (the cyan highlight while dragging)

If there's JS that adds/removes a `dragging` class on the handle, it can stay — it won't do anything visible without the CSS rule, and removing it from JS is optional cleanup.

---

## What NOT to change

- Do not change the drag behavior — resizing still works exactly the same
- Do not change the hit target width (12px) — it's invisible but still needs to be grabbable
- Do not change min/max width constraints
- Do not change mobile behavior (handles still hidden on mobile)

---

## Verification

1. Panels sit directly next to each other with no visible line or gap between them
2. Moving the cursor to the edge between two panels changes it to the resize cursor
3. Dragging still resizes panels normally
4. No visible artifact (line, color, highlight) at any point during hover or drag
5. No console errors
