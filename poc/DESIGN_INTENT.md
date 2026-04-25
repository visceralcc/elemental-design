# Elemental Design — Web POC · Design Intent

**What this demo should communicate and how it should feel**

Version 0.1 | April 2026

---

## 1. The Core Message

Elemental Design is a tool where **components know what they are**. When you place a Title, it arrives with the right size, weight, and spacing. When you place it inside a Container, the Container already has padding and child spacing. You didn't configure any of that. It just works.

The POC should make someone feel: *"Oh — it already did the right thing. And I can change it if I want."*

---

## 2. What the Demo Should Prove

### To a designer
- You don't start from a blank rectangle and manually set every property
- Components have sensible defaults based on their type (Shape, Information, Widget)
- Composition is additive — you place things, and the layout responds
- You can see exactly what the system decided (padding, spacing, sizing) and override any of it

### To a developer
- Every value has a source — it comes from the subtype defaults in the object model
- The code doesn't require manual layout configuration; the component system handles it
- Parameters are structured (Structure / Content / Behavior) and inspectable
- The same component model that drives the canvas drives the generated code

### To anyone
- This tool is approachable — you don't need to know design or code to understand what's happening
- The >>> pattern means "there's more here when you want it" — complexity is available, never imposed

---

## 3. Visual Principles

### The tool recedes
The POC should feel like the Elemental Design interface — dark, quiet, typographically restrained. The cyan/blue gradient family signals interactivity. The user's composed card should be the brightest, most prominent thing on screen. The tool's chrome (Elements panel, mode bar) should feel like it's there to support, not compete.

### Show the invisible structure
The padding overlays (cyan dashed lines) and spacing indicators (pink lines) are the demo's signature move. They make the invisible visible — the built-in margins and spacing that you normally can't see but that make the difference between a well-composed component and a messy one. These should feel like x-ray vision, not clutter.

### Progressive disclosure works in the demo too
The demo itself uses progressive disclosure. You start with just component rows and an empty canvas. You place one thing. Then another. Complexity builds as you go. The parameter readout only appears when you expand a row. You're never overwhelmed.

---

## 4. Demo Flow (Ideal Walkthrough)

The ideal first experience, whether someone is clicking through themselves or being shown by Charlie:

1. **Land on the page.** See the Elements panel with 6 components, all grayed out. Canvas is empty. The instruction says "Tap the Container to place it first."
2. **Place the Container.** It appears on the canvas — a dark rounded rectangle. Already has padding (visible if overlay is on). Already has the right corner radius.
3. **Place the Image.** It nests inside the container. Spacing appears between it and the container edge. The image fills its bounds and clips to rounded corners.
4. **Place the Title.** It appears below the image with proper spacing. The text is already sized and weighted as a Title — no font picker needed.
5. **Place the rest.** Body text, label, icon row. Each one slots in with correct spacing.
6. **Tap a component.** Selection highlights in both the panel and on canvas. Expand its row to see the built-in parameter values.
7. **Toggle overlays.** See the padding and spacing that make it all work. This is the "aha" moment.
8. **Change the scale.** Watch everything adapt proportionally — the container, the image, the text. `scalesWithContent` in action.

---

## 5. What "Done" Looks Like for v1

The POC is ready to share when:
- [ ] The demo flow above works smoothly with no visual glitches
- [ ] Every token value matches the spec
- [ ] The composed card looks like something a designer would be proud of
- [ ] The padding/spacing overlays communicate the "built-in intelligence" message clearly
- [ ] It works on a phone (Safari, Chrome) and a laptop (any browser)
- [ ] Someone who has never seen Elemental Design can click through it in 30 seconds and understand the concept

---

## 6. Future Demo Scenarios

Beyond the card composition, future POC iterations could demonstrate:

| Scenario | What it proves |
|----------|---------------|
| **Nav bar** | Horizontal layout with Widget components (buttons/icons) |
| **List item** | Compact composition showing how the same subtypes work at small scale |
| **Form field** | Widget subtype with states (Default, Focused, Error) |
| **Side-by-side platforms** | Same component rendered at iOS vs. Web dimensions |
| **Agent conversation** | Simulated Agent panel showing the AI building the card step by step |
| **Code output** | SwiftUI code generated from the current composition |

Each scenario is a separate composition within the same demo, not a separate file. The demo should eventually let you switch between scenarios to see the range of what Elemental Design handles.
