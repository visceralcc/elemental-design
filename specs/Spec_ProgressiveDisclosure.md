# Elemental Design — Progressive Disclosure Specification

**How complexity is revealed in the Elements panel — the >>> pattern and three-level control model**

Version 0.1 | April 2026 | Charlie Denison

---

## Version History
| Version | Date | Changes |
|---------|------|---------|
| 0.1 | Apr 2026 | Initial draft. Row expansion, multi-expand, three-level control model, control types per parameter. |

---

## 1. Overview

Progressive disclosure is Elemental Design's core interaction principle. Every parameter exists and has a sensible default — but no parameter is visible unless the user has chosen to look at it. The Elements panel is the interface through which this happens.

**Design principle: Defaults are decisions, not placeholders.** When a user creates a Component and never touches the Elements panel, Elemental Design has still made real choices — size, spacing, color, corner radius. Those choices are intentional and correct for the subtype. The `>>>` indicator is not an invitation to fix something broken. It is an invitation to go further if you want to.

### Scope boundary — what this spec does NOT cover
- What parameters exist and their default values → `router→ Spec_ObjectModel.md`
- Canvas handles and viewport-adjacent controls (future) → `router→ Spec_Canvas.md`
- How the Agent modifies parameters through conversation → `router→ Spec_Agent.md`

---

## 2. The Elements Panel Row

Every object in the current view is represented as a row in the Elements panel. A row has two parts:

### Collapsed state (default)
```
[Subtype icon]  Component Name          >>>
```
- Shows the object name and subtype icon
- `>>>` appears flush right on every row that has expandable parameters
- No parameter values are shown
- This is the state of every row when an object is first created

### Expanded state
```
[Subtype icon]  Component Name          ^^^

  Structure
  ─────────────────────────────────────
  Size                                >>>
  Padding                             >>>
  Corner Radius                       >>>

  Content
  ─────────────────────────────────────
  Color                               >>>
  Text                                >>>

  Behavior
  ─────────────────────────────────────
  Interaction                         >>>
  State                               >>>
```
- `>>>` becomes `^^^` on the parent row to indicate it is open
- Parameters appear grouped under Structure, Content, Behavior
- Only parameters relevant to this object's subtype and state are shown
- Each parameter row is itself collapsed — showing the parameter name and `>>>` only
- Parameters with non-default values show a subtle indicator (a filled dot before the name)

---

## 3. Expansion Behavior

### Multiple rows open simultaneously
Any number of rows can be expanded at once. There is no accordion behavior — expanding one row does not collapse another. The user builds up their view of the structure as needed.

### Expansion is per-session
Expanded/collapsed state is not persisted. Every session starts with all rows collapsed. This is intentional — it enforces the habit of starting from the default, not from a previously cluttered state.

### Tapping behavior
| Action | Result |
|--------|--------|
| Tap `>>>` on a collapsed row | Expands the row inline |
| Tap `^^^` on an expanded row | Collapses the row |
| Tap a parameter `>>>` inside an expanded row | Expands that parameter's controls inline |
| Tap elsewhere in the panel | No effect on expansion state |

### Animation
- Expansion: content slides down and fades in, 200ms, ease-out
- Collapse: content slides up and fades out, 150ms, ease-in
- No bounce. No spring. Purposeful and quiet.

---

## 4. Parameter Row Expansion

When a parameter `>>>` is tapped, controls appear inline below the parameter name. The control type depends on the parameter.

```
  Size                                ^^^
  ┌─────────────────────────────────────┐
  │  Auto                               │  ← Level 1: auto pill (active)
  │  ───────────────────────────────    │
  │  W  [━━━━━●──────────] 200          │  ← Level 2: slider + readout
  │  H  [━━━━━━━━●────────] 320         │
  │  ───────────────────────────────    │
  │  W  [ 200 pt ]  H  [ 320 pt ]       │  ← Level 3: exact value fields
  └─────────────────────────────────────┘
```

All three levels are visible simultaneously once the parameter is expanded. They are not tabs or steps — they are a single coherent control surface showing the full range of precision available.

---

## 5. The Three-Level Control Model

Every numeric parameter in Elemental Design uses the same three-level model. The levels represent increasing precision, not increasing complexity. A user can interact at any level — they are not required to move through them in order.

### Level 1 — Auto
A pill or toggle showing the current automatic value. When active, Elemental Design is managing this parameter based on context (content size, parent constraints, subtype defaults).

- Tapping **Auto** when it is active does nothing — the value is already managed
- If the user adjusts a slider or types an exact value, Auto deactivates automatically
- An **Auto** button remains visible so the user can return to automatic management at any time
- Auto is the default for all parameters at creation

### Level 2 — Slider
A continuous slider representing the parameter's practical range. Not the full mathematical range — a considered range for typical use.

| Parameter | Slider range |
|-----------|-------------|
| Width / Height | 0 – 800pt |
| Padding (any side) | 0 – 64pt |
| Spacing | 0 – 64pt |
| Corner Radius | 0 – 60pt |
| Opacity | 0 – 100% |
| Font Size | 8 – 72pt |
| Border Width | 0 – 16pt |
| Shadow Radius | 0 – 40pt |

The slider shows a live numeric readout to its right. The readout updates as the slider moves. The canvas updates in real time.

### Level 3 — Exact Value
A text input field showing the current value in points (or the appropriate unit). The user can tap and type any value, including values outside the slider's range.

- Accepts numeric input only
- Pressing Return or Tab commits the value
- Values outside the slider range are accepted and valid — the slider thumb moves to the nearest boundary to indicate the value is out of the visual range
- Invalid input (non-numeric, negative where not allowed) reverts to the previous value with a brief shake animation

### Level summary

| Level | Control | When to use |
|-------|---------|-------------|
| 1 — Auto | Pill / toggle | Let Surface decide |
| 2 — Slider | Continuous slider + readout | Fast, approximate adjustment |
| 3 — Exact | Text input field | Precise, intentional values |

---

## 6. Non-Numeric Control Types

Not all parameters use the three-level model. Other parameter types have their own controls, also revealed inline via `>>>`.

| Parameter type | Control |
|---------------|---------|
| Color | Swatch grid of contextual palette + custom picker |
| Text content | Inline text field, expands to multiline |
| Text style role | Segmented picker: Display / Title / Body / Label / Mono |
| Image | Drop target + file picker button |
| Icon | Searchable icon grid |
| Interaction target | Object picker — shows a list of valid targets in the project |
| Animation | Preset pills (None, Fade, Slide, Scale) + duration slider |
| State | Segmented picker of available states + Add State button |
| Boolean (Clip, etc.) | Toggle |
| Platform | Segmented picker: iOS / macOS / Web |

---

## 7. The Filled Dot Indicator

When a parameter has been set to a non-default value — either by the user or the Agent — a small filled dot appears before the parameter name in the collapsed row.

```
  • Size                              >>>    ← non-default value
    Padding                           >>>    ← default value
  • Color                             >>>    ← non-default value
```

This gives the user a quick scan of what has been customized on this object without expanding anything. AI-authored values use a `✦` marker instead of a dot, consistent with Elemental Design's authorship distinction convention.

router→ Spec_Agent.md — AI/human authorship distinction, ✦ marker rules

---

## 8. States in the Elements Panel

States appear as a nested expandable section within a Component row, accessible via the State parameter under Behavior.

```
[Widget icon]  Button                  ^^^

  Behavior
  ─────────────────────────────────────
  State                               ^^^
  ┌─────────────────────────────────────┐
  │  ● Default   Hover   Pressed        │  ← state picker
  │                          + Add State│
  └─────────────────────────────────────┘
```

- The active state is shown with a filled circle
- Switching states in the panel switches the canvas view
- Parameters shown below always reflect the active state
- A `+` Add State button allows naming and creating a new custom state

---

## 9. What This Spec Does Not Cover

- Viewport-adjacent size handles on the canvas (future v2 feature) → `router→ Spec_Canvas.md`
- Voice or text input as an alternative to panel interaction → `router→ Spec_Agent.md`
- How parameters map to generated Swift code → `router→ Spec_CodeLayer.md`
- Token values behind the slider ranges and defaults → `router→ Spec_DesignSystem.md`
