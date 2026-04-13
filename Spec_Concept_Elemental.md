# Elemental Design — Concept Specification

**What it is, why it exists, and how it thinks**

Version 0.1 | April 2026 | Charlie Denison

---

## Version History
| Version | Date | Changes |
|---------|------|---------|
| 0.1 | Apr 2026 | Initial concept spec. Establishes philosophy, interaction model, object model, and document structure. |

---

## 1. What Elemental Design Is

Elemental Design is a native macOS and iOS design tool for building apps, websites, and components. It is designed for designers, developers, and people who have never used a design tool before.

**Design principle: Intent over configuration.** Elemental Design never asks you to manually construct what it can reasonably infer. You declare what something *is* and what it *does*. Elemental Design handles how it looks and behaves by default, and reveals controls progressively when you want to go further.

Elemental Design is not Figma. It does not use the toolbar-and-panel metaphor. There are no tools to pick up and put down. There are no property inspectors open by default. Complexity is always one tap away — never in your face.

---

## 2. The Three Panels

Elemental Design has three persistent panels:

**Agent** (left) — A conversational collaborator. Always present. Asks plain-language questions to establish context ("What do you want to build today?"). Remains available throughout the session to answer questions, suggest next steps, and respond to what's happening on the canvas. The Agent never takes over the canvas.

**Elements** (center) — The structural hierarchy of the current view. Shows every object in the canvas as a named row. Each row is collapsed by default — it shows the object exists and has a sensible default. The `>>>` indicator signals there is depth available. Tapping a row expands it inline to reveal controls.

**Canvas** (right) — The work itself. Dark, infinite, minimal chrome. Objects are created and manipulated here. Size handles appear as floating badges directly on the canvas, outside the object boundary.

router→ Spec_Panels.md — detailed behavior of each panel, empty states, resize rules

---

## 3. The Mode Bar

Five modes across the top bar. These change how you are *looking at* the work — they do not change the work itself.

| Mode | Icon | Purpose |
|------|------|---------|
| Agent | ✦ | Conversational AI panel active |
| Elements | ☰ | Structure and hierarchy view |
| Settings | ⚙ | Object and project configuration |
| Code | `</>` | Code view of the current object |
| Preview | 👁 | Live preview of the current object or screen |

router→ Spec_ModeBar.md — mode switching behavior, what each mode shows and hides

---

## 4. The Object Model

Elemental Design has two root object types:

**Screen** — a full view in an app or website. Has a platform context (iOS, macOS, web).

**Component** — a reusable UI element. Has a subtype: Shape, Information, or Widget.

Every object has parameters organized into three groups:

- **Structure** — size, position, layout relationships
- **Content** — color, text, image, data
- **Behavior** — interaction, animation, state

Parameters are revealed through the `>>>` progressive disclosure pattern in the Elements panel. No parameter is visible by default unless it has been set by the user or the Agent.

router→ Spec_ObjectModel.md — full object type definitions, subtypes, parameter groups, and the tag system

---

## 5. Progressive Disclosure

The `>>>` indicator is Elemental Design's core interaction pattern. It appears on every element row in the Elements panel and means: *there is more here, when you want it.*

Tapping a row expands it inline. Controls appear. Tapping again collapses it. Nothing is open by default. This is how Elemental Design stays approachable for non-designers and deep enough for experts — the same UI, the same objects, the same tool.

router→ Spec_ProgressiveDisclosure.md — expansion behavior, animation, control types, three-level tuning model

---

## 6. The Agent

The Agent is always present in the left panel. It:

- Asks a plain-language question to start every session
- Responds to what the user selects or changes on the canvas
- Can create, name, and configure objects on behalf of the user
- Always distinguishes AI-generated content visually from user-authored content

The Agent does not replace the canvas. It works alongside it.

router→ Spec_Agent.md — Agent behavior, prompt patterns, AI/human content distinction, voice input

---

## 7. What Elemental Design Is Not

- Not a Figma replacement with a new skin. The interaction model is fundamentally different.
- Not a code editor. The code view reflects the design — it does not drive it (in v1).
- Not a prototyping tool in the traditional sense. Behavior is declared through the tag system, not wired manually.
- Not a cloud-first tool. Elemental Design is native. Files live locally.

---

## 8. Document Structure

This file is the top of the Elemental Design specification tree. Every major system has its own spec file. This document links to those files using the `router→` pattern.

`router→` is a navigation primitive in Elemental Design's documentation system. When an AI agent or developer encounters `router→`, it means: *follow this link if you need depth on this topic.* Each linked file is focused, minimal, and independently readable.

All spec files live in `specs/` at the project root.

| File | Contents |
|------|----------|
| Spec_Concept_Elemental Design.md | This file. Philosophy, model, structure. |
| Spec_Panels.md | Three-panel layout, behavior, empty states |
| Spec_ModeBar.md | Mode switching, what each mode exposes |
| Spec_ObjectModel.md | Object types, subtypes, parameters, tag system |
| Spec_ProgressiveDisclosure.md | `>>>` pattern, controls, three-level tuning |
| Spec_Agent.md | Agent behavior, AI/human distinction, voice |
| Spec_DesignSystem.md | Typography, color, spacing, component tokens |
