# Task: Code Panel Side-by-Side IDE Layout

**POC Version:** v0.2.5 → v0.2.6
**File:** `poc/elemental-poc.html`

---

## What to do

Restructure the Code panel's internal layout so the file tree and code editor sit **side by side** — file tree on the left, code on the right — like a real IDE (VS Code, Xcode, etc.).

Currently the file tree (`.code-tree`) and code editor (`.code-editor`) are stacked vertically inside the Code panel's `.panel-body`. After this change, they sit in a horizontal row.

---

## Layout

```
┌──────────────────────────────────────────────┐
│  Code : Hero Image                    [tab]  │
├──────────────┬───────────────────────────────┤
│              │                               │
│  ▾ Compo…/   │  // HeroImage.swift           │
│    HeroIm…   │  import SwiftUI               │
│  ▾ Assets/   │                               │
│    mount…    │  struct HeroImage: View {     │
│              │      var body: some View {    │
│              │          Image("mountain...")  │
│              │              .resizable()      │
│              │              ...               │
│              │      }                        │
│              │  }                            │
│              │                               │
├──────────────┴───────────────────────────────┤
```

### File tree (left sub-section)
- Fixed width: **160px**
- Full height of the panel body
- Background: slightly darker than the code area — use `#1E1E1E` (a very dark gray, typical IDE sidebar)
- Border-right: `1px solid rgba(255,255,255,0.06)` — very subtle separator
- Overflow-y: auto (scrolls if many files)
- The existing `.code-tree` styling (font, colors, indentation, active file highlight) stays the same

### Code editor (right sub-section)
- Fills remaining width (`flex: 1`)
- Full height of the panel body
- Background: keep the current Code panel background (`var(--surface-code)` / `#2A2A2A`)
- Overflow: auto (scrolls both directions if needed)
- The existing `.code-editor` styling (font, colors, syntax highlighting) stays the same

---

## Implementation

1. **Wrap the two containers** in a new flex parent inside `.panel-body`. The HTML structure inside the Code panel body should become:

   ```html
   <div class="panel-body">
     <div class="code-ide-layout">
       <div class="code-tree" id="codeTree"></div>
       <div class="code-editor" id="codeEditor"></div>
     </div>
   </div>
   ```

   Or, if `renderCodePanel()` generates the HTML dynamically, make sure the wrapper is in place and the function fills the two child containers.

2. **Add CSS** for the new layout:

   ```css
   .code-ide-layout {
     display: flex;
     flex: 1;
     min-height: 0;
     overflow: hidden;
   }
   .code-tree {
     width: 160px;
     min-width: 160px;
     flex-shrink: 0;
     overflow-y: auto;
     overflow-x: hidden;
     background: #1E1E1E;
     border-right: 1px solid rgba(255,255,255,0.06);
     /* keep existing padding, font, color rules */
   }
   .code-editor {
     flex: 1;
     min-width: 0;
     overflow: auto;
     /* keep existing padding, font, color rules */
   }
   ```

3. **Remove the existing `border-bottom`** on `.code-tree` if there is one — it was a horizontal divider between stacked sections that no longer applies.

4. **Adjust `.code-tree` text** — with only 160px width, long file names will need to truncate. Add:
   ```css
   .code-tree .tree-file,
   .code-tree .tree-group {
     overflow: hidden;
     text-overflow: ellipsis;
     white-space: nowrap;
   }
   ```

5. **Check `renderCodePanel()`** — make sure it still targets `#codeTree` and `#codeEditor` by ID. The function shouldn't need logic changes, just make sure the DOM structure matches.

---

## What NOT to change

- Do not change the dynamic content logic (file tree and code still update based on selected element)
- Do not change syntax highlighting colors or classes
- Do not change file tree content (folders, files, active states)
- Do not change the Code panel tab, toggle behavior, or resize handle behavior
- Do not change any other panel

---

## Verification

1. Open the Code panel — file tree appears on the left, code on the right, side by side
2. The file tree is narrow (~160px) with a slightly darker background
3. Long file names truncate with ellipsis rather than wrapping
4. The code editor fills the remaining space
5. Selecting different elements still updates both the file tree and code
6. Both sections scroll independently if content overflows
7. Resizing the Code panel wider/narrower works — the code editor grows/shrinks, file tree stays fixed at 160px
8. No console errors
9. Mobile layout still works (the side-by-side may stack or the Code panel may just be full-width — as long as it doesn't break)

---

## Files to read first

- `poc/CLAUDE.md` — POC rules
- `poc/elemental-poc.html` — the file you're editing
