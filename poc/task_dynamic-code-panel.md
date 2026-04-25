# Task: Dynamic Code Panel Content + Wider Panel + Draggable Resize Handles

**POC Version:** v0.2.3 → v0.2.4
**File:** `poc/elemental-poc.html`

---

## What to do — THREE things in this task

### Part A: Make Code panel content change based on selected element
### Part B: Make the Code panel wider by default
### Part C: Add draggable resize handles between all adjacent panels

---

# Part A: Dynamic Code Panel Content

Make the Code panel's content (file tree + code preview) change dynamically based on which component is currently selected in the Elements panel.

Currently the Code panel is completely static — it always shows the same hardcoded file tree and `CardContainer.swift` code regardless of what's selected. After this change, selecting a different component updates both the file tree and the code block to show only what's relevant to that component.

The Code tab title already updates to show the selected component name (via `renderCodeTab()`). This task makes the panel body match.

### Core concept

**Only show what's relevant.** When Hero Image is selected, you don't need to see CardTitle.swift or CategoryLabel.swift in the file tree. You see only the files that matter to Hero Image. This mirrors the Elemental Design philosophy: complexity is available, never imposed.

**Exception: Card Container shows everything.** Since the container is the parent that composes all children, selecting it shows the full file tree with all component files and the full composition code.

### File tree content per component

The file tree sits at the top of the Code panel (the `.code-tree` div). It should update to show only relevant folders and files. The currently "active" file should be highlighted with `brand-cyan-bright` color (same as the existing `.tree-file.active` class).

#### Card Container (id: `container`)
```
▾ Components/
  ▸ CardContainer.swift        ← active
  ▸ HeroImage.swift
  ▸ CardTitle.swift
  ▸ CardDescription.swift
  ▸ CategoryLabel.swift
  ▸ ActionBar.swift
```

#### Hero Image (id: `image`)
```
▾ Components/
  ▸ HeroImage.swift            ← active
▾ Assets/
  ▸ mountain-vista.jpg
```

#### Card Title (id: `title`)
```
▾ Components/
  ▸ CardTitle.swift             ← active
```

#### Card Description (id: `body`)
```
▾ Components/
  ▸ CardDescription.swift      ← active
```

#### Category Label (id: `label`)
```
▾ Components/
  ▸ CategoryLabel.swift         ← active
```

#### Action Bar (id: `icon-row`)
```
▾ Components/
  ▸ ActionBar.swift             ← active
▾ Assets/Icons/
  ▸ heart.svg
  ▸ share.svg
  ▸ bookmark.svg
```

#### Nothing selected (state.selected is null)
```
▾ Components/
  ▸ CardContainer.swift        ← active (default)
  ▸ HeroImage.swift
  ▸ CardTitle.swift
  ▸ CardDescription.swift
  ▸ CategoryLabel.swift
  ▸ ActionBar.swift
```
(Same as Card Container — show everything as the default view)

### Code content per component

The code block sits below the file tree (the `.code-editor` div). It should update to show syntax-highlighted SwiftUI code relevant to the selected component.

Use the same CSS classes for syntax coloring that already exist:
- `.cm-kw` — keywords (purple): `import`, `struct`, `var`, `some`
- `.cm-ty` — types (light blue): `SwiftUI`, `View`, `Image`, `Text`, `Color`, `HStack`, `VStack`
- `.cm-fn` — functions (green): available if needed
- `.cm-nm` — numbers (yellow): `16`, `20`, `10`, `0.5`
- `.cm-cm` — comments (faded italic): `// filename.swift`
- `.cm-st` — strings (red/salmon): `"Mountain Vista"`, `"mountain-vista"`

#### Card Container
```swift
// CardContainer.swift
import SwiftUI

struct CardContainer: View {
    var body: some View {
        VStack(spacing: 16) {
            HeroImage()
            CardTitle()
            CardDescription()
            CategoryLabel()
            ActionBar()
        }
        .padding(20)
        .background(Color("CardSurface"))
        .cornerRadius(16)
    }
}
```
(This is the existing code — keep it as-is)

#### Hero Image
```swift
// HeroImage.swift
import SwiftUI

struct HeroImage: View {
    var body: some View {
        Image("mountain-vista")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 180)
            .cornerRadius(10)
            .clipped()
    }
}
```

#### Card Title
```swift
// CardTitle.swift
import SwiftUI

struct CardTitle: View {
    var body: some View {
        Text("Mountain Vista")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
```

#### Card Description
```swift
// CardDescription.swift
import SwiftUI

struct CardDescription: View {
    var body: some View {
        Text("A breathtaking alpine landscape at golden hour. Perfect for adventurers seeking serenity.")
            .font(.body)
            .foregroundColor(.white.opacity(0.75))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
```

#### Category Label
```swift
// CategoryLabel.swift
import SwiftUI

struct CategoryLabel: View {
    var body: some View {
        Text("ADVENTURE · NATURE")
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.white.opacity(0.5))
            .tracking(0.2)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
```

#### Action Bar
```swift
// ActionBar.swift
import SwiftUI

struct ActionBar: View {
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "heart")
            Image(systemName: "square.and.arrow.up")
            Image(systemName: "bookmark")
        }
        .foregroundColor(.white.opacity(0.55))
        .padding(.top, 8)
    }
}
```

#### Nothing selected
Show the Card Container code as the default.

### Implementation for Part A

1. **Remove the static HTML** for the file tree and code block from the Code panel's `.panel-body` div. Replace with empty containers that have IDs:
   ```html
   <div class="code-tree" id="codeTree"></div>
   <div class="code-editor" id="codeEditor"></div>
   ```

2. **Add a `renderCodePanel()` function** that is called from the main `render()` function. It reads `state.selected`, looks up the appropriate file tree and code content, and sets `innerHTML` on both containers.

3. **The file tree HTML** uses the same classes that already exist: `.tree-group` for folder headers, `.tree-file` for files, `.tree-file.active` for the highlighted file.

4. **The code HTML** uses the same syntax-color span classes that already exist: `.cm-kw`, `.cm-ty`, `.cm-nm`, `.cm-cm`, `.cm-st`.

5. **Call `renderCodePanel()`** from the existing `render()` function, alongside the existing `renderCodeTab()` call.

---

# Part B: Wider Code Panel Default

The Code panel is currently 300px default / 240px min, which is too narrow for code. Update the CSS:

```css
.panel-code { width: 420px; min-width: 300px; flex-shrink: 1; }
```

This gives code blocks breathing room by default while still allowing the panel to shrink if needed.

---

# Part C: Draggable Resize Handles Between Panels

Add draggable resize handles between every pair of adjacent open panels. This lets the user widen the Code panel (or any panel) by dragging the edge between panels.

### Visual design
- The handle is a **1px vertical line** between adjacent panels
- Color: `rgba(255,255,255,0.08)` (very subtle — nearly invisible until hovered)
- On hover: color brightens to `rgba(255,255,255,0.25)` and cursor becomes `col-resize`
- The **invisible hit target** is 12px wide (6px on each side of the line), making it easy to grab
- No visible grip dots or icons — just the line

### Behavior
- **Drag** the handle left or right to resize the two panels on either side of it
- Both panels resize simultaneously — one grows, the other shrinks
- Each panel respects its min-width (see CSS values). Dragging stops when either panel hits its minimum.
- The Component panel (canvas) is the flexible panel — it absorbs/gives space when other panels resize, but it also respects its 400px minimum.
- **On mouseup**, dragging stops and the new widths stick for the session
- Panel widths set by dragging are stored in state (not persisted across page reloads)

### Implementation approach

1. **Add resize handle elements** — do NOT hardcode them in the HTML. Instead, **generate them dynamically in JavaScript** based on which panels are currently open. Every time panels open/close (in `renderPanels()`), re-render the resize handles between adjacent visible panels.

2. **Position handles** — each handle sits between two adjacent open panels. Use `position: absolute` or insert them as flex siblings between panel divs. The simplest approach: insert thin `<div class="resize-handle">` elements between panel divs in `.panels-wrap`, and show/hide them based on which panels are open.

3. **Drag logic** — on `mousedown` on a handle, track which two panels are on either side. On `mousemove`, calculate the delta and adjust both panels' widths (using `style.width` or flex-basis). On `mouseup`, stop tracking. Use `e.preventDefault()` during drag to avoid text selection.

4. **Store widths** — when the user drags a handle, update `state.panelWidths` (a new state object) with the custom widths. The `renderPanels()` function should apply these widths if they exist, falling back to CSS defaults if not.

5. **Touch support** — add `touchstart`/`touchmove`/`touchend` handlers alongside mouse events so it works on iPad.

### CSS to add
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
.resize-handle::after {
  content: '';
  width: 1px;
  background: rgba(255,255,255,0.08);
  transition: background 0.15s ease;
}
.resize-handle:hover::after {
  background: rgba(255,255,255,0.25);
}
.resize-handle.dragging::after {
  background: var(--brand-cyan-pill);
}
```

### Constraints during drag
- Agent panel: min 200px, max 400px
- Elements panel: min 220px, max 480px
- Code panel: min 300px, max 600px
- Component panel: min 400px, no max (absorbs remaining space)

### Mobile
On mobile (under 640px), hide resize handles entirely — panels stack vertically and take full width.

---

## What NOT to change

- Do not change the Code panel's toggle behavior (pill on/off)
- Do not change Elements panel behavior or canvas rendering
- Do not add interactivity to the code (no editing, no clicking files to switch views)
- Do not change the file tree or code editor font/size/color styling
- Do not change the panel tab row or mode bar behavior

---

## Verification

After all three parts:

### Part A verification
1. With Elements + Code + Component panels open, click Hero Image → Code panel shows HeroImage.swift file tree and code
2. Click Card Title → Code panel updates to CardTitle.swift
3. Click Card Container → Code panel shows full file tree with all 6 files and the composition code
4. Click Action Bar → Code panel shows ActionBar.swift + Assets/Icons/ folder
5. Code tab title still updates to show selected component name
6. When nothing is selected, Code panel shows the Card Container (default) view
7. Syntax coloring matches the existing style

### Part B verification
8. When the Code panel is toggled on, it opens at 420px width (wider than before)

### Part C verification
9. Hovering between two adjacent panels shows a subtle resize cursor
10. Dragging the handle between Elements and Code makes Elements wider and Code narrower (or vice versa)
11. Dragging respects min-widths — you can't shrink a panel below its minimum
12. Resize handles only appear between panels that are actually open
13. Opening/closing a panel correctly adds/removes resize handles
14. No console errors
15. Mobile layout still works (no resize handles on mobile)

---

## Files to read first

- `poc/CLAUDE.md` — POC rules
- `poc/elemental-poc.html` — the file you're editing
- `specs/Spec_PanelNavigation.md` §5.2 — resize handle spec (for reference)
