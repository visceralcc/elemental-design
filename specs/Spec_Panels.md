# Elemental Design — Panels Specification

**The three-panel layout — structure, sizing, empty states, and mode behavior**

Version 0.1 | April 2026 | Charlie Denison

---

## Version History
| Version | Date | Changes |
|---------|------|---------|
| 0.1 | Apr 2026 | Initial draft. Three-panel layout, sizing, resize, collapse, empty states, selection sync, parameter picker, mode behavior. |

---

## 1. Overview

The panel system is Elemental Design's persistent spatial layout. Three panels — Agent, Elements, and Canvas — divide the window into distinct zones for conversation, structure, and visual work. They are always present in the same order. No panel floats, tabs behind another, or repositions.

**Design principle: The layout follows the workflow.** Agent on the left because conversation starts first. Elements in the center because structure mediates between intent and canvas. Canvas on the right because it is the largest space and the destination of every action. Each panel can be collapsed when it is not needed, but the order is fixed — the left-to-right progression from intent to structure to output is the natural reading of the work.

### Scope boundary — what this spec does NOT cover
- The `>>>` expansion pattern and three-level control model → `router→ Spec_ProgressiveDisclosure.md`
- Agent conversation behavior, proactivity, and authorship → `router→ Spec_Agent.md`
- Canvas surface, zoom/pan, and direct manipulation → `router→ Spec_Canvas.md`
- Mode bar switching logic → `router→ Spec_ModeBar.md`
- Object types, parameters, and defaults → `router→ Spec_ObjectModel.md`

---

## 2. Panel Layout

The three panels sit side by side in a single row, filling the window below the mode bar.

```
┌──────────────────────────────────────────────────────────────────────┐
│  Mode Bar                                                           │
├─────────────┬──────────────────┬─────────────────────────────────────┤
│             │                  │                                     │
│   Agent     │    Elements      │            Canvas                   │
│   (left)    │    (center)      │            (right)                  │
│             │                  │                                     │
│             │                  │                                     │
│             │                  │                                     │
│             │                  │                                     │
│             │                  │                                     │
└─────────────┴──────────────────┴─────────────────────────────────────┘
```

### Panel order
Left to right: Agent → Elements → Canvas. This order never changes. There is no drag-to-reorder, no preference to swap panels.

### Why this order
The workflow moves left to right. You start with intent (Agent), which produces structure (Elements), which appears as visual output (Canvas). The Agent panel is narrow because conversation is vertical. The Canvas panel is wide because design is spatial. The Elements panel sits between them because it is the bridge — it reflects both what the Agent has done and what the Canvas shows.

---

## 3. Panel Sizing

### Default widths

| Panel | Default width | Minimum width | Maximum width |
|-------|--------------|---------------|---------------|
| Agent | 280pt | 240pt | 400pt |
| Elements | 300pt | 260pt | 480pt |
| Canvas | Remaining space | 600pt | No maximum |

The Canvas panel always fills whatever space the other two panels do not occupy. It has no explicit maximum — it grows with the window.

### Resize handles
A vertical drag handle sits between adjacent panels — one between Agent and Elements, one between Elements and Canvas. Handles are 1pt wide, system separator color, with a 12pt invisible hit target on each side.

Dragging a handle resizes the two panels on either side of it. The third panel is not affected unless the resize would push a panel below its minimum width — in that case, the drag is constrained.

### Window resize behavior
When the overall window is resized, the Canvas absorbs the change. Agent and Elements widths remain fixed until the Canvas reaches its minimum (600pt). Below that point, all three panels share the reduction proportionally, each clamping at its minimum.

If the window is too narrow to fit all three panels at their minimums (total: 1100pt), the Agent panel collapses first. See §4.

---

## 4. Panel Collapse

Panels can be collapsed to give more space to the remaining panels. Collapse is not the same as hiding — a collapsed panel shows a thin rail with a button to re-expand.

### Collapse rules

| Panel | Can collapse? | Collapse trigger | Rail width |
|-------|--------------|------------------|------------|
| Agent | Yes | Button in Agent header, keyboard shortcut (Cmd+1), or automatic when window < 1100pt | 36pt |
| Elements | Yes | Button in Elements header, keyboard shortcut (Cmd+2) | 36pt |
| Canvas | No | Never collapses | — |

The Canvas never collapses. It is always visible. If both the Agent and Elements panels are collapsed, the Canvas fills the entire window below the mode bar.

### Collapsed rail
A collapsed panel shows a vertical rail with:
- The panel name rotated 90° (reading bottom to top)
- A chevron button (▶ for Agent, ◀ for Elements) to re-expand
- Clicking anywhere on the rail re-expands the panel

### Collapse animation
- Collapse: panel width animates to 36pt over 200ms, ease-in-out. Content fades out during the first 100ms.
- Expand: panel width animates from 36pt to its previous width over 200ms, ease-in-out. Content fades in during the last 100ms.

### Keyboard shortcuts

| Shortcut | Action |
|----------|--------|
| Cmd + 1 | Toggle Agent panel collapse |
| Cmd + 2 | Toggle Elements panel collapse |
| Cmd + 0 | Reset all panels to default widths |

---

## 5. The Agent Panel

The Agent panel is the left column. It contains the conversational AI collaborator. Its internal layout has three zones stacked vertically.

router→ Spec_Agent.md — Agent behavior, input modes, proactivity, authorship distinction

### 5.1 Header

```
┌─────────────────────────┐
│ ✦ Agent          [mode] │
└─────────────────────────┘
```

- `✦` marker and the word "Agent" left-aligned
- A mode indicator right-aligned, showing the Agent's current activity: Thinking, Drawing, Listening, or nothing (idle)
- The collapse button (chevron) sits at the far right of the header row

### 5.2 Conversation area

The middle zone, filling all available vertical space between header and input bar. Scrollable. Three message types appear here:

| Message type | Alignment | Visual treatment |
|-------------|-----------|-----------------|
| User message | Right | Plain background, standard text color |
| Agent response | Left | Subtle tinted background, `✦` before text |
| Agent suggestion | Left | Dashed border, Accept button + dismiss `×` button |

Messages are ordered chronologically, newest at the bottom. The conversation area auto-scrolls to the newest message when one appears. If the user has scrolled up to review history, auto-scroll pauses until they scroll back to the bottom.

### 5.3 Input bar

```
┌─────────────────────────────────┐
│ let's talk...              [🎙] │
└─────────────────────────────────┘
```

- Pinned to the bottom of the Agent panel
- A text field with placeholder text: `let's talk...`
- A microphone button to the right, activating voice input
- Pressing Return sends the message. Shift+Return inserts a newline.
- The input bar grows vertically (up to 4 lines) as the user types a longer message, then scrolls internally

### 5.4 Empty state

When no conversation has occurred yet (session start), the conversation area shows a single centered prompt from the Agent:

```
     ✦ What are you working on today?
```

This is both the empty state and the first message. It sets the tone — the Agent speaks first, inviting collaboration. The input bar is focused and ready for typing.

---

## 6. The Elements Panel

The Elements panel is the center column. It shows the structural hierarchy of the current view — every object on the canvas as a named row, organized by nesting.

router→ Spec_ProgressiveDisclosure.md — `>>>` expansion, three-level control model, parameter controls

### 6.1 Header

```
┌──────────────────────────────────┐
│ Elements              [+] [☰/▤] │
└──────────────────────────────────┘
```

- "Elements" label left-aligned
- A `+` button to create a new object (opens the New Object sheet — see §7)
- A view toggle (list/grid) right-aligned — list view is default and the only view in v1. Grid view is reserved for future use. The toggle is visible but grid is disabled with a "Coming soon" tooltip.
- The collapse button (chevron) sits at the far right

### 6.2 Object rows

Each object in the current view appears as a row. Rows are indented to reflect nesting depth.

```
┌──────────────────────────────────┐
│ ◻ Hero Section              >>> │  ← top-level Component (Shape)
│   ◻ Hero Image              >>> │  ← nested child
│   ◻ Hero Title              >>> │  ← nested child
│   ◻ CTA Button              >>> │  ← nested child
│ ◻ Content Section           >>> │  ← another top-level Component
└──────────────────────────────────┘
```

Each row shows:
- An icon representing the object type and subtype (distinct icons for Screen, Shape, Information, Widget)
- The object name
- `>>>` flush right, indicating expandable depth

Indentation is 16pt per nesting level. Maximum visible indentation is 5 levels (80pt) — deeper nesting still works but does not indent further visually.

### 6.3 Row selection

Tapping a row in the Elements panel selects that object. Selection is mutual — see §8 for how selection synchronizes with the Canvas.

The selected row shows:
- A highlight background (system selection color at low opacity)
- The corresponding object on the Canvas shows its selection border and size badges

### 6.4 Row expansion

Tapping `>>>` on a row expands it to show the object's parameter groups (Structure, Content, Behavior). This is the `>>>` progressive disclosure pattern. Full expansion behavior — including multi-expand, animation timing, the three-level control model, and the filled dot indicator — is defined in `Spec_ProgressiveDisclosure.md`. This spec does not duplicate those rules.

What this spec establishes: expansion happens inline within the Elements panel. Expanded content pushes rows below it downward. The panel scrolls vertically when content exceeds the visible area.

### 6.5 Row reordering

Rows can be reordered via long-press + drag. Reordering changes the visual stacking order on the Canvas (top of list = front of stack). Dragging a row into or out of another object's indentation changes nesting.

Drag feedback: a faint insertion line appears between rows to show where the object will land. If the drag position would nest the object inside another, the insertion line indents to show the new parent.

### 6.6 Empty state

When no objects exist in the current view, the Elements panel shows:

```
         Nothing here yet.
     
     Tap + to add a Screen or Component,
     or describe what you're building
     to the Agent.
```

Centered vertically and horizontally. Muted text color. The `+` in the message is styled as an inline reference to the header button (not a separate tappable element).

---

## 7. The Parameter Picker

The Parameter Picker is an overlay that opens when `>>>` is tapped on an **object's own row** (not on a parameter row within an already-expanded object). It shows all available parameters for the object's type and subtype as toggleable options.

router→ Spec_ObjectModel.md — available parameters by subtype (§6, Parameter Picker table)
router→ Spec_Canvas.md — original parameter picker definition (§6)

### 7.1 Appearance

```
┌─────────────────────────────────┐
│  Parameters                     │
│  ───────────────────────────── │
│  Size                  [toggle] │
│  Color                 [toggle] │
│  Text                  [toggle] │
│  Image                 [toggle] │
│  Icon                  [toggle] │
│  Shadow                [toggle] │
│  Border                [toggle] │
│  Interaction           [toggle] │
│  Animation             [toggle] │
│  Accessibility         [toggle] │
│                                 │
│                        [  Done] │
└─────────────────────────────────┘
```

The overlay appears anchored to the object row, floating above the Elements panel content. It dims the area behind it slightly. It does not cover the Canvas — work remains visible.

### 7.2 Toggle behavior

- Each toggle corresponds to a parameter defined in the object model
- Parameters already visible in the Elements panel appear with their toggle on
- Toggling a parameter on adds it as a row in the expanded object view
- Toggling a parameter off removes it from the visible rows — but its value is preserved silently. If the user re-toggles it later, the previous value reappears
- Only parameters valid for the object's subtype are shown. A Shape does not see the Interaction toggle. An Information component does not see the Shape toggle. The availability table in `Spec_ObjectModel.md` §6 is authoritative.

### 7.3 Dismissal

- Tapping **Done** closes the overlay and applies all toggle changes
- Tapping outside the overlay closes it (same as Done — changes are applied immediately as toggles are flipped, not batched)
- Pressing Escape closes the overlay

### 7.4 Relationship to `>>>` expansion

The Parameter Picker and `>>>` row expansion are two different interactions on the same row:

- **First tap on `>>>` for a collapsed object:** opens the Parameter Picker (the user chooses which parameters to work with)
- **After the Parameter Picker has been used at least once:** tapping `>>>` expands/collapses the object row to show its parameters inline (the standard progressive disclosure behavior)
- **Re-opening the Parameter Picker:** a dedicated button (gear icon or "Edit parameters" label) appears at the bottom of the expanded parameter list, allowing the user to return to the picker at any time

This means the very first interaction with a new object's `>>>` is intentionally different — it asks "what do you want to work with?" before showing controls. After that initial setup, `>>>` works as a simple expand/collapse toggle.

---

## 8. Selection Synchronization

Selection is always mutual between the Elements panel and the Canvas. They are two views of the same selection state.

### Elements → Canvas
Tapping a row in the Elements panel:
- Highlights that row
- Shows the selection border and size badges on the corresponding Canvas object
- If the object is off-screen on the Canvas, the Canvas pans smoothly to center it

### Canvas → Elements
Clicking or tapping an object on the Canvas:
- Shows the selection border and size badges on the Canvas
- Highlights the corresponding row in the Elements panel
- If the row is off-screen in the Elements panel, the panel scrolls to reveal it
- If the object's parent rows are collapsed, they expand automatically to reveal the selected child

### Multi-select
Multi-select (Shift+click or marquee drag on Canvas) highlights multiple rows in the Elements panel. The Elements panel does not support multi-select directly — multi-select is initiated from the Canvas only.

### Deselection
- Clicking empty canvas space deselects everything in both panels
- Pressing Escape deselects everything in both panels
- Selecting a different object replaces the previous selection (unless Shift is held)

---

## 9. Panels in Different Modes

The mode bar changes which panels are visible and how they behave. Modes do not destroy panel state — switching modes and switching back restores the previous expand/collapse and scroll positions.

### 9.1 Agent mode (✦)

All three panels visible at their current widths. The Agent panel's input bar is focused. This is the default mode at session start.

### 9.2 Elements mode (☰)

All three panels visible. The Elements panel is the primary focus. Functionally identical to Agent mode in terms of layout, but the mode bar highlights the Elements icon to signal the user is working structurally. The Agent panel remains visible and responsive.

### 9.3 Settings mode (⚙)

The Elements panel's content is replaced with project and object settings (project name, platform, export options, object-level overrides). The panel header reads "Settings" instead of "Elements". The Agent and Canvas panels remain visible and functional. Returning to Elements or Agent mode restores the Elements panel content.

### 9.4 Code mode (</>)

The Elements panel's content is replaced with a read-only code view of the selected object (SwiftUI output in v1). The panel header reads "Code". The Agent and Canvas panels remain visible. The code view updates live as the user selects different objects on the Canvas.

### 9.5 Preview mode (👁)

All panels except the Canvas are hidden. The Canvas fills the entire window below the mode bar. All canvas chrome is removed — no selection borders, no size badges, no floating buttons. The work is shown at its declared size, centered.

- Pressing Escape or clicking the Preview mode icon in the mode bar exits Preview mode
- All panel widths, expand/collapse states, and scroll positions are restored on exit
- Preview mode does not affect the underlying data — no parameters change

router→ Spec_PreviewMode.md — interaction playback, animation, device frame options

---

## 10. Panel Behavior on iOS

On iPad, the three-panel layout works the same as on macOS, with these adjustments:

- Drag handles are replaced by a settings option to set panel widths (three presets: Default, Wide Canvas, Wide Elements)
- The Agent panel collapses by default in portrait orientation and expands in landscape
- In the compact size class (iPhone or iPad split-screen), only one panel is visible at a time. A bottom tab bar switches between Agent, Elements, and Canvas. Selection sync still works — selecting in Elements and switching to Canvas shows the selected object.

### iPhone layout

On iPhone, the three panels become three tabs in a tab bar at the bottom of the screen. Swipe left/right navigates between them. The Canvas is the default view. The mode bar is hidden — mode switching is not available on iPhone in v1.

---

## 11. What This Spec Does Not Cover

- The `>>>` pattern, three-level control model, and per-parameter controls → `router→ Spec_ProgressiveDisclosure.md`
- Agent behavior, suggestions, and input modes → `router→ Spec_Agent.md`
- Canvas zoom, pan, direct manipulation, and gesture drawing → `router→ Spec_Canvas.md`
- Mode bar switching behavior and icon states → `router→ Spec_ModeBar.md`
- Preview mode interaction playback → `router→ Spec_PreviewMode.md`
- Object types, parameter definitions, and defaults → `router→ Spec_ObjectModel.md`
