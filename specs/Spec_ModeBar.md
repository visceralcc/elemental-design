# Elemental Design — Mode Bar Specification

**The five modes, switching behavior, and what each mode reveals**

Version 0.1 | April 2026 | Charlie Denison

---

## Version History
| Version | Date | Changes |
|---------|------|---------|
| 0.1 | Apr 2026 | Initial draft. Five modes, switching behavior, icon states, keyboard shortcuts, tab system, mode persistence. |

---

## 1. Overview

The mode bar is the horizontal strip across the top of the window. It holds five mode buttons that change how you are *looking at* the work. Modes do not change the work itself — they change which panels are visible and what the center panel shows.

**Design principle: Modes are lenses, not workspaces.** Switching modes does not create a new context or move you to a different place. It adjusts what is visible in the same place. The Canvas always shows the same objects. The Agent always holds the same conversation. The only thing that changes is the center panel's content and, in Preview mode, the visibility of UI chrome. A mode switch should feel like turning your head, not opening a new app.

### Scope boundary — what this spec does NOT cover
- Panel layout, sizing, and collapse behavior → `router→ Spec_Panels.md`
- The `>>>` expansion pattern and parameter controls → `router→ Spec_ProgressiveDisclosure.md`
- Agent behavior, conversation, and input modes → `router→ Spec_Agent.md`
- Canvas interaction, zoom/pan, gesture drawing → `router→ Spec_Canvas.md`
- Preview mode interaction playback and animation → `router→ Spec_PreviewMode.md`

---

## 2. Mode Bar Layout

The mode bar sits at the top of the window, spanning the full width. It is a single row, always visible (except in Preview mode — see §5.5).

```
┌──────────────────────────────────────────────────────────────────────┐
│  [✦]    [☰]    [⚙]    [</>]    [👁]              [Tab1] [Tab2] ... │
│  Agent  Elements Settings Code   Preview                  Tabs      │
└──────────────────────────────────────────────────────────────────────┘
```

### Left side — mode buttons
Five buttons in a fixed row. Each button shows an icon and a text label below it. The active mode button is visually distinct (filled icon, accent-colored underline). Inactive buttons are muted.

### Right side — tabs
The tab strip occupies the right portion of the mode bar. Tabs represent open Screens or Components. See §7.

### Height
The mode bar is 44pt tall on macOS, 48pt on iOS. It does not resize.

---

## 3. The Five Modes

| Mode | Icon | Label | Keyboard shortcut | What it does |
|------|------|-------|--------------------|-------------|
| Agent | ✦ | Agent | Cmd+Shift+1 | Focuses the Agent panel for conversation |
| Elements | ☰ | Elements | Cmd+Shift+2 | Shows the structural hierarchy in the center panel |
| Settings | ⚙ | Settings | Cmd+Shift+3 | Shows project and object settings in the center panel |
| Code | </> | Code | Cmd+Shift+4 | Shows a read-only code view of the selected object in the center panel |
| Preview | 👁 | Preview | Cmd+Shift+5 | Hides all panels and chrome; shows the work full-screen |

---

## 4. Switching Behavior

### How switching works
Clicking a mode button or pressing its keyboard shortcut activates that mode immediately. There is no confirmation, no transition screen, no loading state.

### What persists across mode switches
- Canvas view (zoom level, pan position, selected objects)
- Agent conversation history and input bar contents
- Elements panel expand/collapse state for all rows
- Elements panel scroll position
- Tab selection (which Screen or Component is active)

All of these are restored exactly when switching back to a mode. Switching to Settings and back to Elements does not collapse your expanded rows or lose your scroll position.

### What does not persist
- The first visit to Settings or Code mode in a session starts with the center panel scrolled to the top
- Preview mode always starts centered on the active tab's content

### Active mode indicator
The active mode button shows:
- A filled version of the icon (other buttons show an outlined version)
- An accent-colored underline beneath the button (2pt, system accent color)
- The label text at full opacity (inactive labels are at 50% opacity)

Only one mode is active at a time. Clicking the already-active mode button does nothing.

---

## 5. Mode Details

### 5.1 Agent Mode (✦)

The default mode at session start. All three panels are visible at their current widths.

The Agent panel's input bar receives keyboard focus when entering this mode — the cursor appears in the text field, ready for typing. This is the only mode where entering the mode moves focus to a specific control.

Agent mode is the natural starting point. The Agent's opening prompt ("What are you working on today?") appears in this mode, and the user can begin describing their project immediately.

### 5.2 Elements Mode (☰)

All three panels visible. The center panel shows the Elements hierarchy — the same content as in Agent mode. The distinction is conceptual: Elements mode signals that the user is working structurally, focused on hierarchy, nesting, and parameter editing rather than conversation.

Functionally, Agent mode and Elements mode show the same panel layout. The difference is the mode bar highlight and the implied focus. The Agent panel remains visible and responsive in Elements mode — the user can still type in the Agent input bar.

### 5.3 Settings Mode (⚙)

The center panel's content is replaced with settings. The Agent and Canvas panels remain visible and functional.

The center panel header changes from "Elements" to "Settings". Two sections appear:

**Project settings** (shown when no object is selected):
- Project name (editable text field)
- Default platform (segmented picker: iOS / macOS / Web)
- Export format preferences (future — disabled in v1)

**Object settings** (shown when an object is selected):
- Object name (editable text field)
- Object type and subtype (read-only display)
- Platform override (for Screens — segmented picker)
- Accessibility audit summary (future — placeholder in v1)

If the user selects a different object on the Canvas while in Settings mode, the object settings update to reflect the new selection.

### 5.4 Code Mode (</>)

The center panel's content is replaced with a read-only code view. The Agent and Canvas panels remain visible and functional.

The center panel header changes from "Elements" to "Code". The code view shows the SwiftUI representation of the currently selected object.

- If a single object is selected: shows that object's SwiftUI code
- If multiple objects are selected: shows the code for the first object in the selection
- If no object is selected: shows a message — "Select an object to see its code"
- Code updates live as the user selects different objects on the Canvas
- Syntax highlighting follows Xcode's default color scheme (adapts to light/dark mode)
- A "Copy" button in the panel header copies the visible code to the clipboard

Code view is read-only in v1. The user cannot edit code and have it flow back to the design. This is an explicit v1 boundary — code-to-design sync is a future capability.

### 5.5 Preview Mode (👁)

Preview mode is visually distinct from all other modes. It hides everything except the Canvas and the mode bar.

On entering Preview mode:
- The Agent panel and center panel are hidden (not collapsed — fully hidden, no rail)
- All canvas chrome is removed: no selection borders, no size badges, no floating `+` button, no cursor overlays
- The active tab's content is displayed at its declared size, centered in the full window
- The mode bar remains visible at the top so the user can exit Preview mode

On exiting Preview mode (click the Preview button again, or press Escape):
- All panels are restored to their previous widths and states
- Canvas chrome reappears
- The previously active mode is restored (if the user was in Elements mode before Preview, they return to Elements mode)

In Preview mode, interactions are live — tapping a Widget triggers its declared action, and state transitions animate as declared.

router→ Spec_PreviewMode.md — interaction playback, animation timing, device frame options

---

## 6. Mode Availability

All five modes are always available. No mode is disabled or locked based on project state. Even in an empty project with no objects, every mode is tappable:

| Mode | Empty project behavior |
|------|----------------------|
| Agent | Shows the Agent's opening prompt. Fully functional. |
| Elements | Shows the empty state ("Nothing here yet..."). |
| Settings | Shows project settings only (no object settings without a selection). |
| Code | Shows "Select an object to see its code." |
| Preview | Shows an empty canvas, centered. |

---

## 7. The Tab System

Tabs appear in the right portion of the mode bar. Each tab represents an open Screen or Component that the user is actively working on.

### 7.1 Tab appearance

```
[Home Screen ▾]  [Hero Card ▾]  [+]
```

Each tab shows:
- The object name
- A dropdown indicator (▾) for the tab menu
- A close button (×) on hover

A `+` button at the end of the tab strip creates a new tab (opens the New Object sheet — same as the `+` in the Elements panel header).

### 7.2 Tab behavior

- Clicking a tab switches the Canvas and Elements panel to show that Screen or Component
- The active tab has a distinct background (subtle fill, matching the accent underline style)
- Tabs can be reordered by dragging
- Closing a tab removes it from the strip but does not delete the object — the object still exists in the project
- If all tabs are closed, the Canvas and Elements panel show their empty states
- A maximum of 8 tabs can be open simultaneously. Attempting to open a ninth replaces the least recently used tab.

### 7.3 Tab menu

Clicking the dropdown indicator (▾) on a tab opens a small menu:

- **Rename** — inline rename of the object
- **Duplicate** — creates a copy of the Screen or Component and opens it in a new tab
- **Close** — closes the tab
- **Close Other Tabs** — closes all tabs except this one

### 7.4 Relationship between tabs and the Elements panel

The Elements panel always reflects the active tab. Switching tabs changes which object hierarchy is shown in the Elements panel. Expand/collapse state is preserved per tab — switching away from a tab and back restores the Elements panel exactly as the user left it.

---

## 8. What This Spec Does Not Cover

- Panel layout, sizing, resize handles, and collapse → `router→ Spec_Panels.md`
- The `>>>` pattern and three-level controls → `router→ Spec_ProgressiveDisclosure.md`
- Agent conversation, proactivity, and authorship → `router→ Spec_Agent.md`
- Canvas surface, selection, and gesture drawing → `router→ Spec_Canvas.md`
- Preview mode interaction playback and animation → `router→ Spec_PreviewMode.md`
- Object types, parameters, and defaults → `router→ Spec_ObjectModel.md`
