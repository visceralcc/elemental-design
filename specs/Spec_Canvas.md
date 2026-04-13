# Elemental Design — Canvas Specification

**The canvas surface, navigation, selection, object placement, and the parameter picker**

Version 0.2 | April 2026 | Charlie Denison

---

## Version History
| Version | Date | Changes |
|---------|------|---------|
| 0.1 | Apr 2026 | Initial draft. Canvas surface, zoom/pan, selection, object placement, parameter picker, preview mode, gesture drawing. |
| 0.2 | Apr 2026 | Renamed product to Elemental Design throughout. |

---

## 1. Overview

The Canvas is the primary workspace in Elemental Design. It is where objects are placed, arranged, selected, and previewed. It is the largest panel — occupying the right portion of the three-panel layout — and it is always visible regardless of which mode is active.

**Design principle: The canvas shows the work, not the tool.** There are no rulers, no grids, no guides, no toolbar overlays by default. The only chrome that appears on the canvas is directly attached to a selected object. Everything else is out of the way.

### Scope boundary — what this spec does NOT cover
- The Elements panel and `>>>` expansion behavior → `router→ Spec_ProgressiveDisclosure.md`
- Agent interpretation of canvas gestures → `router→ Spec_Agent.md`
- Preview mode interaction and animation playback → `router→ Spec_PreviewMode.md`
- The mode bar and tab system → `router→ Spec_ModeBar.md`

---

## 2. The Canvas Surface

The canvas is a large bounded workspace. It is not infinite — it has defined extents — but the working area is large enough that it does not feel constrained during normal use.

### Why bounded
Elemental Design is not a general illustration tool. Every object on the canvas is either a Screen (a specific device size) or a Component (a specific element). The bounded canvas reinforces that the work has a frame of reference — a real screen or a real component — rather than an abstract infinite space.

### Working area
The default working area is 8000 × 8000 points. This gives room to explore multiple variations of a Screen or Component side by side without feeling hemmed in. The boundary is visible as a subtle edge — not a hard wall, but a clear signal that you are approaching the edge of the workspace.

### Background
The canvas background is a dark neutral — not pure black, not a grid. No dots, no lines. Just surface.

### Screens on the canvas
A Screen object appears as a bounded frame on the canvas with its platform dimensions:

| Platform | Default dimensions |
|----------|--------------------|
| iOS (iPhone) | 390 × 844 pt |
| iOS (iPad) | 820 × 1180 pt |
| macOS | 1280 × 800 pt |
| Web | 1440 × 900 pt |

The Screen frame has a label above it showing the Screen name. Multiple Screens can exist on the canvas simultaneously, arranged by the user.

### Components on the canvas
A Component not nested inside a Screen appears directly on the canvas as a standalone element. This is the primary working mode when designing a reusable component in isolation.

---

## 3. Navigation — Zoom and Pan

### Zoom
| Input | Action |
|-------|--------|
| Scroll wheel / trackpad pinch | Zoom toward cursor position |
| Cmd + `+` / Cmd + `-` | Zoom in / out in steps |
| Cmd + `0` | Fit all objects in view |
| Cmd + `1` | Zoom to 100% |
| Cmd + `2` | Zoom to selected object, fitted |

Zoom range: 5% minimum, 400% maximum.

### Pan
| Input | Action |
|-------|--------|
| Two-finger drag (trackpad) | Pan freely |
| Space + drag (mouse) | Pan freely |
| Middle mouse button drag | Pan freely |

No scroll bars. No minimap in v1.

---

## 4. Selection

### Single selection
Clicking or tapping any object on the canvas selects it. The selected object shows:
- A selection border (1pt, system accent color) around its bounds
- Size badges floating outside its bounds — X dimension below, Y dimension to the right
- The object's row highlights in the Elements panel

### Multi-select
| Input | Action |
|-------|--------|
| Shift + click | Add object to selection |
| Drag on empty canvas | Marquee select — selects all objects whose bounds intersect the drag rectangle |
| Cmd + A | Select all objects on the current canvas view |
| Escape | Deselect all |

Multi-select shows a combined bounding box around all selected objects. Size badges reflect the combined bounds.

### Selection through nesting
Clicking a nested child selects the child directly. Clicking the parent selects the parent. There is no "click through" — the topmost object at the click point is selected first. Clicking the same spot again while the parent is selected selects the child beneath it (progressive drill-down).

### Selection and the Elements panel
Selection is always synchronized between canvas and Elements panel. Selecting on the canvas highlights the row in the Elements panel and vice versa. The Elements panel scrolls to reveal the selected row automatically.

---

## 5. Object Placement

Objects are placed on the canvas in two ways: via the Agent, or via the `+` button.

### 5.1 Via the Agent
The Agent creates and places objects in response to text, voice, or gesture input. The Agent determines size, position, and nesting based on context. Placed objects appear on the canvas and in the Elements panel simultaneously.

router→ Spec_Agent.md — how the Agent creates and positions objects

### 5.2 Via the + Button
A `+` button in a circle appears in two locations:

**On the canvas** — floating at the top-right edge of the canvas panel. Always visible. Creates a new top-level Screen or Component.

**In the Elements panel** — adjacent to the Elements panel header. Creates a new object and adds it to the current view's hierarchy.

Tapping either `+` button opens the **New Object sheet** — a compact overlay with two choices:

```
┌─────────────────────────┐
│  What are you creating? │
│                         │
│  [  Screen  ]           │
│  [  Component  ]        │
└─────────────────────────┘
```

Selecting Component immediately asks for a subtype:

```
┌─────────────────────────┐
│  Component type         │
│                         │
│  [  Shape  ]            │
│  [  Information  ]      │
│  [  Widget  ]           │
└─────────────────────────┘
```

The object is placed on the canvas at a default size with Elemental Design's default parameters for that subtype. It is selected immediately after placement.

---

## 6. The Parameter Picker

Once an object exists on the canvas and is selected, its row in the Elements panel shows `>>>`. Tapping `>>>` on the **object's own row** (not a parameter row) opens the **Parameter Picker** — an overlay showing the available parameters for this object type, presented as toggleable options.

```
┌─────────────────────────┐
│  Size          [toggle] │
│  Color         [toggle] │
│  Text          [toggle] │
│  Image         [toggle] │
│  Shape         [toggle] │
│  Action        [toggle] │
│                         │
│              [  Done  ] │
└─────────────────────────┘
```

### Behavior
- Parameters already added to the Elements list appear with their toggle active
- The user toggles the parameters they want to work with
- Tapping **Done** adds the selected parameters as rows in the Elements panel beneath the object
- Parameters that are toggled off are removed from the Elements panel (but their values are not deleted — they persist silently at their last value)
- The Parameter Picker can be reopened at any time to add or remove parameters

### Available parameters by subtype

| Parameter | Shape | Information | Widget |
|-----------|-------|-------------|--------|
| Size | ✓ | ✓ | ✓ |
| Color | ✓ | ✓ | ✓ |
| Text | — | ✓ | ✓ |
| Image | ✓ | ✓ | — |
| Shape | ✓ | — | ✓ |
| Action | — | — | ✓ |

### Why additive, not automatic
Elemental Design does not pre-load every parameter for every object. The user selects which parameters they want to work with. This is a stronger form of progressive disclosure — parameters are not just hidden, they are absent until chosen. A Shape with only Color added is genuinely simpler than one with every parameter visible. The Elements panel reflects exactly what the user cares about, nothing more.

---

## 7. Direct Manipulation

### Moving objects
Drag a selected object to reposition it on the canvas. If the object is nested, dragging it outside its parent's bounds offers to remove it from the parent (a brief confirmation appears — "Remove from [Parent Name]?").

### Resizing objects
Selected objects show size badges — X dimension below the object, Y dimension to the right. Dragging a size badge resizes the object on that axis. This updates the Size parameter in the Elements panel in real time.

Corner handles are not shown by default. They appear on hover when the cursor is near a corner of the selected object. Dragging a corner handle resizes both axes simultaneously.

### Nudging
Arrow keys nudge the selected object by 1pt. Shift + arrow keys nudge by 10pt.

---

## 8. Preview Mode

Preview mode is activated via the eye icon in the mode bar. It hides all canvas chrome — selection borders, size badges, panel overlays — and shows only the object or Screen at its defined size, centered in the canvas panel.

In Preview mode:
- Interactions are live — tapping a Widget triggers its declared action
- Animations play — state transitions animate as declared
- The Agent panel and Elements panel are hidden (the full window is the canvas)
- Pressing Escape or clicking the eye icon returns to the working canvas

Preview mode is per-view — it previews the currently active tab (Screen or Component).

router→ Spec_PreviewMode.md — interaction playback, animation, device frame options

---

## 9. Canvas Gesture Drawing

Canvas gesture drawing is a distinct input mode activated by a dedicated button in the canvas toolbar (a pencil icon, visible at the bottom edge of the canvas panel).

When active:
- The cursor becomes a freehand drawing tool
- The user sketches on the canvas — rough shapes, layout ideas, annotations
- The sketch appears as a lightweight ink layer above all canvas objects
- On lift (mouse up / finger up / stylus up), the gesture capture is complete
- The ink layer is sent to the Agent as an image, alongside any text in the Agent input bar
- The Agent processes the sketch and responds — creating objects, adjusting layout, or asking a clarifying question
- The ink layer disappears after the Agent has responded

### V1 behavior
In v1, canvas gestures are interpreted by the Agent as intent only. The sketch is communication — it is never stored as a canvas object.

### Future — Sketch to Object Conversion (Not in V1)
In a future version, the Agent will offer to convert a recognized sketch directly into a canvas object. A drawn rectangle becomes a Shape component. Drawn text becomes an Information component. The Agent surfaces this as a suggestion: "This looks like a card — want me to create it?"

This feature depends on basic Shape and Information components being fully implemented first.

router→ Spec_Agent.md — Agent interpretation of canvas gestures, napkin mode vs. convert mode

---

## 10. What This Spec Does Not Cover

- Parameter controls and the three-level tuning model → `router→ Spec_ProgressiveDisclosure.md`
- Agent creation and placement of objects → `router→ Spec_Agent.md`
- Preview mode interaction and animation playback → `router→ Spec_PreviewMode.md`
- Tab system and multi-view navigation → `router→ Spec_ModeBar.md`
