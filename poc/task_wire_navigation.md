# Task: Wire Primary Navigation to Tabs and Panels

## What to change

Make the 5 mode bar pills clickable so they control which tab and panel content is visible. Add an Agent panel. Only one pill is active at a time.

## Current state

- 5 mode pills exist in the mode bar but are static (no click behavior)
- Agent + Elements pills are both cyan; Plan, Code, Viewport are gray
- Two tabs exist in the tab row: Elements and Canvas (Component)
- Below the tabs: Elements panel on the left, Canvas area on the right
- No Agent panel exists

## Desired behavior

### Primary navigation (mode pills)

All 5 pills become clickable. Clicking a pill:
1. Sets that pill to **active** (`#00B2F3`) — all others go **inactive** (`#848484`)
2. Shows/hides the appropriate **left-panel tab** and **left-panel content**
3. The **Canvas tab + canvas area** always remains visible on the right — it never hides

### What each pill does

| Pill clicked | Left panel tab shown | Left panel content | Canvas (right side) |
|-------------|---------------------|-------------------|-------------------|
| **Agent** | Agent tab | Agent panel (new — see below) | Stays visible |
| **Elements** | Elements tab | Elements panel (existing content) | Stays visible |
| **Plan** | Plan tab | Empty placeholder: "Plan view coming soon" | Stays visible |
| **Code** | Code tab | Empty placeholder: "Code view coming soon" | Stays visible |
| **Viewport** | Viewport tab | Empty placeholder: "Viewport coming soon" | Stays visible |

### Default state on load
**Elements** pill is active by default (matching current behavior where the Elements panel is visible).

## Tab design for each mode

Each left-panel tab follows the existing tab design pattern (46px tall, icon + title, content-width). Here are the specifics:

### Agent tab
- Background: `#1F1F1F` (the `--surface-agent` color — add this CSS variable if not present; it's not currently in the POC)
- Corner radius: **0 top-left, 23px top-right, 0 bottom** (straight left side, rounded right side)
- Icon: `icon_agent.svg` (23×23px) — the sparkle icon. Embed inline SVG paths:
```svg
<svg class="tab-icon" width="23" height="23" viewBox="0 0 23 23" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
<path d="M21.2287 11.1427C16.162 9.74359 15.1083 8.68892 13.709 3.62296C13.6645 3.46184 13.5182 3.35073 13.3516 3.35073C13.1849 3.35073 13.0386 3.46185 12.9941 3.62296C11.595 8.68971 10.5404 9.74335 5.47441 11.1427C5.3133 11.1871 5.20312 11.3334 5.20312 11.5001C5.20312 11.6668 5.31423 11.8131 5.47441 11.8575C10.5412 13.2566 11.5948 14.3113 12.9941 19.3773C13.0386 19.5384 13.1849 19.6495 13.3516 19.6495C13.5182 19.6495 13.6645 19.5384 13.709 19.3773C15.1081 14.3105 16.1627 13.2569 21.2287 11.8575C21.3898 11.8131 21.5 11.6668 21.5 11.5001C21.5 11.3334 21.3889 11.1871 21.2287 11.1427Z" fill="white"/>
<path d="M5.21668 9.37637C5.26113 9.53749 5.40743 9.6486 5.5741 9.6486C5.74078 9.6486 5.88708 9.53748 5.93152 9.37637C6.57967 7.03006 7.03062 6.57909 9.37691 5.93098C9.53802 5.88654 9.6482 5.74024 9.6482 5.57357C9.6482 5.40689 9.53709 5.26059 9.37691 5.21615C7.0306 4.568 6.57963 4.11798 5.93152 1.77076C5.88708 1.60964 5.74078 1.49854 5.5741 1.49854C5.40743 1.49854 5.26113 1.60965 5.21668 1.77076C4.56853 4.11707 4.11758 4.56804 1.77129 5.21615C1.61018 5.26059 1.5 5.40689 1.5 5.57357C1.5 5.74024 1.61111 5.88654 1.77129 5.93098C4.1176 6.57913 4.56857 7.02915 5.21668 9.37637Z" fill="white"/>
<path d="M9.93258 17.6245C7.96404 17.0809 7.58627 16.7032 7.04286 14.7347C6.99841 14.5736 6.85212 14.4625 6.68544 14.4625C6.51876 14.4625 6.37247 14.5736 6.32802 14.7347C5.78449 16.7033 5.4067 17.0811 3.43829 17.6245C3.27718 17.6689 3.167 17.8152 3.167 17.9819C3.167 18.1486 3.27811 18.2949 3.43829 18.3393C5.40684 18.8828 5.78461 19.2606 6.32802 21.229C6.37247 21.3902 6.51876 21.5013 6.68544 21.5013C6.85212 21.5013 6.99841 21.3901 7.04286 21.229C7.58639 19.2605 7.96418 18.8827 9.93258 18.3393C10.0937 18.2949 10.2039 18.1486 10.2039 17.9819C10.2039 17.8152 10.0928 17.6689 9.93258 17.6245Z" fill="white"/>
</svg>
```
- Title: "Agent"

### Elements tab (already exists)
- Keep as-is: `#373737` background, 23px 23px 0 0 corners, icon_elements + "Elements" title
- The placed count ("0/6 placed") stays on this tab

### Plan tab
- Background: `#373737` (same as Elements — it occupies the same left panel slot)
- Corner radius: 23px 23px 0 0
- Icon: `icon_plan.svg` (14×18px). Embed inline SVG paths:
```svg
<svg class="tab-icon" width="14" height="18" viewBox="0 0 14 18" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
<path fill-rule="evenodd" clip-rule="evenodd" d="M2.36814 2.03562V0.522037L0.533205 2.31809H2.07956C2.23765 2.31809 2.36811 2.19039 2.36811 2.03565L2.36814 2.03562ZM3.12252 0H13.1428C13.6125 0 14 0.375587 14 0.839038V17.1602C14 17.3908 13.9041 17.6011 13.7483 17.7536L13.7475 17.7529C13.5917 17.9054 13.3776 18 13.1428 18H0.857972C0.388301 18 0.000767422 17.6244 0.000767422 17.161L0 3.05713H2.07969C2.65372 3.05713 3.12262 2.59892 3.12262 2.03631L3.12252 0ZM7.91833 3.79616H5.51776V4.77341H7.91915L7.91833 3.79616ZM7.80783 8.5555L6.71809 7.48886L5.62836 8.5555L6.71809 9.62214L7.80783 8.5555ZM7.40186 12.6133C6.80097 12.0251 5.7511 12.4353 5.7511 13.2841C5.7511 14.1291 6.79633 14.5452 7.40186 13.9533C7.77942 13.583 7.77942 12.9821 7.40186 12.6133ZM8.39721 12.9145C7.99815 11.1785 5.4395 11.1665 5.03807 12.9145H3.4848V8.92434H4.9383L6.45089 10.4049C6.59824 10.5491 6.8369 10.5491 6.98425 10.4049L8.49684 8.92434H10.2818C10.4898 8.92434 10.6594 8.75909 10.6594 8.55478V4.28451C10.6594 4.08095 10.4906 3.91495 10.2818 3.91495H8.67256C8.67256 3.58519 8.75851 3.05713 8.295 3.05713L5.14001 3.05788C4.93204 3.05788 4.76245 3.22313 4.76245 3.42745V5.14305C4.76245 5.34661 4.93127 5.51261 5.14001 5.51261H8.29549C8.759 5.51261 8.67305 4.98455 8.67305 4.65479H9.90553V8.18664H8.49807L6.98548 6.7061C6.83813 6.56188 6.59946 6.56188 6.45212 6.7061L4.93952 8.18664L3.10688 8.18589C2.89891 8.18589 2.72932 8.35114 2.72932 8.55545V13.284C2.72932 13.4876 2.89814 13.6536 3.10688 13.6536H5.03775C5.43298 15.373 7.99464 15.415 8.39689 13.6536H10.2816C10.7781 13.6536 10.7781 12.9152 10.2816 12.9152L8.39721 12.9145Z" fill="white"/>
</svg>
```
- Title: "Plan"

### Code tab
- Background: `#373737`
- Corner radius: 23px 23px 0 0
- Icon: `icon_code.svg` (19×15px). Embed inline SVG paths:
```svg
<svg class="tab-icon" width="19" height="15" viewBox="0 0 19 15" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
<path fill-rule="evenodd" clip-rule="evenodd" d="M7.2164 13.9665C7.11613 14.4282 7.41319 14.8825 7.87986 14.9807C8.34652 15.0799 8.80568 14.7861 8.90501 14.3243L11.7837 1.0332C11.884 0.572421 11.5869 0.118128 11.1202 0.0189392C10.6536 -0.0793361 10.1953 0.21456 10.0951 0.675347L7.2164 13.9665ZM5.31321 3.0988C4.97586 2.76504 4.42861 2.76504 4.09126 3.0988L0.25301 6.89627C-0.0843366 7.23003 -0.0843366 7.77054 0.25301 8.1043L4.09126 11.9018C4.42861 12.2355 4.97586 12.2355 5.31321 11.9018C5.65055 11.568 5.65055 11.0275 5.31321 10.6937L2.08508 7.49991L5.31321 4.30687C5.65055 3.97311 5.65055 3.43261 5.31321 3.09884V3.0988ZM13.6868 3.0988C14.0241 2.76504 14.5714 2.76504 14.9087 3.0988L18.747 6.89627C19.0843 7.23003 19.0843 7.77054 18.747 8.1043L14.9087 11.9018C14.5714 12.2355 14.0241 12.2355 13.6868 11.9018C13.3494 11.568 13.3494 11.0275 13.6868 10.6937L16.9149 7.49991L13.6868 4.30687C13.3494 3.97311 13.3494 3.43261 13.6868 3.09884V3.0988Z" fill="white"/>
</svg>
```
- Title: "Code"

### Viewport tab
- Background: `#373737`
- Corner radius: 23px 23px 0 0
- Icon: `icon_viewport.svg` (20×12px) — already embedded in the Canvas tab
- Title: "Viewport"

## Agent panel (new)

When the Agent pill is active, the left panel shows the Agent panel:

- Background: `#1F1F1F`
- Same width as the Elements panel (260px)
- Content for now: a simple placeholder state. Center vertically and horizontally:
  - The sparkle icon (icon_agent.svg) at ~40px, faded to ~25% opacity
  - Below it: "Agent panel coming soon" in Barlow 13px, muted text color

The Agent panel replaces the Elements panel in the left column — they don't show simultaneously. The controls strip (Place All, Padding/Spacing checkboxes, Scale buttons) should **only** show when the Elements pill is active, since those controls are specific to the Elements view.

## Implementation approach

### State management

Add a `mode` property to the `state` object. Values: `'agent'`, `'elements'`, `'plan'`, `'code'`, `'viewport'`. Default: `'elements'`.

```javascript
let state = { selected: null, scale: 1, expanded: {}, mode: 'elements' };
```

Add a `setMode(mode)` function that updates `state.mode` and calls `render()`.

### Making pills clickable

Add `onclick="setMode('agent')"` etc. to each pill div. Add `cursor: pointer` to `.mode-pill`. In the render cycle, update pill classes based on `state.mode`:
- The pill matching the current mode gets class `active`
- All others get class `inactive`

### Tab row rendering

The tab row should be re-rendered based on the current mode. The left tab slot shows the tab for the active mode. The right tab slot (Canvas) always shows.

Make the tab row dynamic — either re-render its innerHTML in the render cycle, or have all 5 left-side tabs in the HTML and show/hide based on mode.

### Left panel content

Similarly, either swap innerHTML or show/hide. The simplest approach: have the Elements panel content (scroll + controls) and placeholder panels all in the HTML, and toggle `display: none` / `display: flex` based on mode.

### What NOT to change

- Don't change the Canvas tab or canvas area — it always stays visible
- Don't change the canvas rendering logic, component data, or interactive features
- Don't change the Elements panel content when it IS visible — all existing functionality (component rows, expand/collapse, params, selection sync, canvas rendering) must keep working
- The tab row dark background strip stays

## Spec references

- `specs/Spec_DesignSystem.md` §2.2 for `surface-agent` color (#1F1F1F)
- `specs/Spec_DesignSystem.md` §8 for tab design
- `specs/Spec_Panels.md` §9 for mode behavior descriptions
- `specs/Spec_Agent.md` §2 for Agent panel layout
