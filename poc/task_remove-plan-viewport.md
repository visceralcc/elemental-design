# Task: Remove Plan and Viewport Panels

**POC Version:** v0.2.1 → v0.2.2
**File:** `poc/elemental-poc.html`

---

## What to do

Remove the **Plan** and **Viewport** panels entirely from the POC. These are placeholder-only panels that will be designed later. Removing them now cleans up the mode bar and panel layout.

After this change, the POC has **4 panels** in this fixed order:

```
Agent | Elements | Code | Component
```

And **3 mode pills** in the mode bar (Component has no pill — it's always open):

```
[Agent] [Elements] [Code]
```

---

## Specific changes

### 1. HTML — Mode bar pills
- Remove the `<div class="mode-pill" data-panel="plan">` pill and its SVG entirely
- Remove the `<div class="mode-pill" data-panel="viewport">` pill and its SVG entirely
- Keep the Agent, Elements, and Code pills exactly as they are

### 2. HTML — Panel containers
- Remove the entire `<!-- Plan -->` panel div (`<div class="panel panel-plan" id="panelPlan">` and everything inside it)
- Remove the entire `<!-- Viewport -->` panel div (`<div class="panel panel-viewport" id="panelViewport">` and everything inside it)
- Keep Agent, Elements, Code, and Component panels exactly as they are

### 3. CSS — Remove dead rules
- Remove `.panel-plan` width/min-width rule
- Remove `.panel-viewport` width/min-width rule
- Remove `.panel-plan .panel-body` background rule
- Remove `.panel-viewport .panel-body` background rule
- Remove `.panel-tab-plan` tab styling
- Remove `.panel-tab-viewport` tab styling
- Remove `--surface-viewport` CSS variable (no longer used)
- Keep `.panel-placeholder-text` class — it's not used anymore after this change, but it's harmless. Remove it if you want to be thorough.

### 4. JavaScript — State and constants
- Update `PANEL_ORDER` array: remove `'plan'` and `'viewport'`. New value:
  ```js
  const PANEL_ORDER = ['agent', 'elements', 'code', 'component'];
  ```
- Update `PANEL_ELEMENTS` map: remove `plan` and `viewport` entries. New value:
  ```js
  const PANEL_ELEMENTS = {
    agent: 'panelAgent',
    elements: 'panelElements',
    code: 'panelCode',
    component: 'panelComponent'
  };
  ```
- Update `state.panels` default: remove `plan` and `viewport`. New value:
  ```js
  panels: {
    agent: false,
    elements: true,
    code: false,
    component: true
  }
  ```

### 5. Comments
- Update the `<!-- Panels -->` comment from `Agent | Plan | Elements | Code | Component | Viewport` to `Agent | Elements | Code | Component`

---

## What NOT to change

- Do not touch any panel content, styling, or behavior for Agent, Elements, Code, or Component
- Do not change the toggle logic — it still works the same way (independent toggles, at least one must remain open, Component always open)
- Do not change mobile responsive behavior
- Do not change any component data, canvas rendering, or Elements panel behavior

---

## Verification

After the change:
1. The mode bar shows 3 pills (Agent, Elements, Code) + the wordmark
2. Default layout shows Elements + Component (same as before)
3. Clicking Agent pill opens the Agent panel to the left of Elements
4. Clicking Code pill opens the Code panel between Elements and Component
5. All three pills toggle independently — any combination works
6. The "at least one panel open" rule still works
7. No console errors
8. Mobile layout still works (panels stack vertically)

---

## Files to read first

- `poc/CLAUDE.md` — POC rules
- `poc/elemental-poc.html` — the file you're editing (single file, everything is here)
