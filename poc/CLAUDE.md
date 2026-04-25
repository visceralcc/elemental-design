# Elemental Design — Web POC · Claude Entry Point

You are working on the **Elemental Design Web POC** — a standalone interactive demo that proves how Elemental Design's component model works. This is NOT the native SwiftUI app. This is a shareable web prototype.

Read this file first. It tells you how this POC is organized and what to read before making changes.

---

## What This POC Is

A single-file HTML/CSS/JS demo that simulates the Elemental Design tool experience. It shows how components compose together inside a container, with built-in margins, padding, and spacing — all driven by each component's subtype defaults.

**The POC proves two things:**
1. **For users** — Elemental Design is useful because components arrive ready to use, with intelligent defaults
2. **For builders** — the code has everything built in; every value comes from the object model, not manual configuration

---

## What This POC Is Not

- Not the native SwiftUI app (that lives in `../ElementalDesign/`)
- Not a full implementation of the Elemental Design tool
- Not a React/React Native project — it's vanilla HTML/CSS/JS, zero dependencies
- Not a throwaway sketch — it should feel polished and representative of the real product's quality

---

## Before You Change Anything

1. **Read `TECH_SPEC.md`** — it defines the architecture, token system, and component data model
2. **Read `BUILD_STATUS.md`** — it tells you what exists, what works, and what's next
3. **Check the parent project specs** when touching component behavior — the POC mirrors the real object model

router→ ../specs/Spec_ObjectModel.md — the authoritative source for component types, subtypes, parameters, and defaults
router→ ../specs/Spec_DesignSystem.md — the authoritative source for color tokens, typography, and spacing
router→ ../specs/Spec_ProgressiveDisclosure.md — the >>> pattern and three-level control model

---

## File Structure

```
poc/
├── CLAUDE.md            ← you are here
├── BUILD_STATUS.md      ← current state, what works, what's next
├── TECH_SPEC.md         ← architecture, data model, token system, rendering
├── DESIGN_INTENT.md     ← what this demo should communicate and how
└── elemental-poc.html   ← the actual demo (single file, zero dependencies)
```

---

## Tech Stack

- **Language:** HTML, CSS, vanilla JavaScript
- **Dependencies:** None (Google Fonts loaded via CDN for Barlow + Vollkorn)
- **Image:** Single Unsplash image loaded via URL
- **Target:** Any modern browser, mobile-responsive
- **Hosting:** Static file — open directly or serve from any web server

---

## Relationship to the Main Project

This POC draws its component model, token values, and interaction patterns from the main Elemental Design specs in `../specs/`. When the main specs change, the POC should be updated to match. The POC is a proof of the spec, not an independent invention.

| POC concept | Authoritative spec |
|-------------|-------------------|
| Component subtypes and defaults | `Spec_ObjectModel.md` §3, §8 |
| Parameter groups (Structure, Content, Behavior) | `Spec_ObjectModel.md` §7 |
| Color tokens | `Spec_DesignSystem.md` §2 |
| Typography | `Spec_DesignSystem.md` §3 |
| Spacing values | `Spec_DesignSystem.md` §4 |
| Progressive disclosure (>>>) | `Spec_ProgressiveDisclosure.md` §2–5 |
| Panel layout | `Spec_Panels.md` §2–6 |

---

## Rules for Working in This POC

1. **Single file.** The demo is one `.html` file. Do not split into multiple files unless there's a clear reason.
2. **No build tools.** No npm, no bundler, no framework. If someone double-clicks the file, it works.
3. **Match the real tokens.** Every color, font, spacing value, and corner radius should come from `Spec_DesignSystem.md`. Don't eyeball it.
4. **Match the real defaults.** Component padding, spacing, sizing behavior should come from `Spec_ObjectModel.md` §8. The POC proves the spec works — it can't prove that if it uses different values.
5. **Mobile-friendly.** The layout should adapt for narrow screens. Elements panel stacks above canvas on mobile.
