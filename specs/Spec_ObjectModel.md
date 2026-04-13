# Elemental Design — Object Model Specification

**The objects Elemental Design works with, how they relate, and how they are parameterized**

Version 0.2 | April 2026 | Charlie Denison

---

## Version History
| Version | Date | Changes |
|---------|------|---------|
| 0.1 | Apr 2026 | Initial draft. Root types, subtypes, nesting, relationships, states, parameter groups. |
| 0.2 | Apr 2026 | Renamed product to Elemental Design. Renamed SurfaceObject protocol to ElementalObject. |

---

## 1. Overview

The object model defines every thing that can exist in an Elemental Design project — what types of objects exist, how they contain and relate to each other, and how their parameters are organized.

**Design principle: Objects know what they are.** A Component is not a generic container with properties bolted on. It has a type, a subtype, a set of states, and a parameter structure that reflects its purpose. Elemental Design uses this self-knowledge to set intelligent defaults, offer contextually appropriate controls, and generate accurate documentation automatically.

### Scope boundary — what this spec does NOT cover
- How parameters are displayed or edited in the UI → `router→ Spec_ProgressiveDisclosure.md`
- How the Agent creates or modifies objects → `router→ Spec_Agent.md`
- How objects are serialized to `.component.md` files → `router→ Spec_ComponentDocs.md`
- Canvas interaction, drag, resize, zoom → `router→ Spec_Canvas.md`

---

## 2. Root Object Types

Elemental Design has two root object types. Every object in a project is one of these.

| Type | Purpose | Can contain |
|------|---------|-------------|
| **Screen** | A full view — a complete app screen or web page | Components (unlimited nesting) |
| **Component** | A reusable UI element | Other Components (unlimited nesting) |

A project contains one or more Screens. Each Screen contains zero or more Components. Components may contain other Components without depth limit.

There is no generic "group" or "frame" object. Grouping is expressed through nesting — a Component that exists to hold other Components is still a Component, with its own type, subtype, and parameters.

---

## 3. Component Subtypes

Every Component has a subtype declared at creation. The subtype shapes which parameters are available and what defaults Elemental Design applies.

| Subtype | Purpose | Typical examples |
|---------|---------|-----------------|
| **Shape** | A visual or structural element with no semantic content | Containers, cards, dividers, backgrounds, decorative elements |
| **Information** | An element whose primary job is to communicate content | Text blocks, labels, images, icons, data displays |
| **Widget** | An interactive element that accepts user input or triggers actions | Buttons, toggles, sliders, form fields, navigation items |

### Subtype rules
- Subtype is set at creation and does not change.
- Subtype determines the default parameter set Elemental Design applies — a Widget always gets Interaction parameters by default; a Shape does not.
- Subtype is visible in the Elements panel as a label beneath the component name.
- A Component containing only Shapes is still a Shape. Subtype describes the Component itself, not its children.

---

## 4. Nesting

Components nest without depth limit. A Screen is the root of every nesting tree.

```
Screen
└── Component (Shape)          ← a card container
    ├── Component (Information) ← a title
    ├── Component (Information) ← a body text block
    └── Component (Widget)      ← a call-to-action button
        └── Component (Information) ← label inside the button
```

### Nesting rules
- A Screen cannot be nested inside another Screen or Component.
- A Component can be nested inside a Screen or inside any other Component.
- There is no enforced depth limit in v1. Practical limits are a product decision, not a data model constraint.
- Nesting order in the Elements panel reflects visual stacking order on the canvas — top of list = front of stack.

---

## 5. Relationships

Relationships describe how objects are connected. Elemental Design supports two relationship modes.

### 5.1 Spatial (inferred)
When a Component is positioned inside another Component's bounds on the canvas, Elemental Design infers a parent/child relationship automatically. The inner object becomes a child. No explicit action required.

Spatial relationships update automatically when objects are moved. Dragging a child outside its parent's bounds removes the relationship.

### 5.2 Explicit (declared)
A relationship can be declared independently of spatial position. This covers logical connections that don't have a visual expression — a button that triggers a modal, a component that shares state with a sibling, a Screen that follows another in a flow.

Explicit relationships are declared through the Elements panel. They appear in the Element Map view as directed connections.

router→ Spec_ElementMap.md — the Element Map view, relationship visualization, flow declaration

### Relationship kinds

| Kind | Direction | Meaning |
|------|-----------|---------|
| **contains** | parent → child | Spatial nesting. Inferred automatically. |
| **triggers** | source → target | An action on source causes something on target |
| **shares state** | bidirectional | Two components reflect the same state value |
| **follows** | source → target | Screen-level: target screen follows source in a flow |

---

## 6. States

State is a first-class concept in Elemental Design. Every Component has at least one state — **Default** — and may have additional states declared by the user or Agent.

### Built-in states

| State | Applies to | Meaning |
|-------|-----------|---------|
| **Default** | All Components | The resting appearance. Always exists. Cannot be deleted. |
| **Hover** | Widget, Shape | Cursor or pointer is over the component |
| **Pressed** | Widget | Active press or tap in progress |
| **Focused** | Widget | Keyboard or accessibility focus |
| **Disabled** | Widget | Component is present but not interactive |
| **Loading** | Widget, Information | Awaiting data or async action |
| **Empty** | Information | No content to display |
| **Error** | Widget, Information | Something has gone wrong |

### Custom states
Users may declare additional states with plain-language names ("Selected", "Expanded", "Playing"). Custom states have the same parameter structure as built-in states.

### State rules
- Each state is an independent set of parameter overrides on top of Default. Default is always the base.
- Switching states on the canvas switches the canvas view — it does not affect other states.
- States are visible in the Elements panel as a nested row beneath the Component, accessible via `>>>`.
- A Component with only Default defined behaves identically to a stateless component.

router→ Spec_ProgressiveDisclosure.md — how states are revealed and edited in the Elements panel

---

## 7. Parameter Groups

Every object has parameters organized into three groups. Groups are the same for all object types — what differs is which parameters appear within each group, based on type and subtype.

### Structure
Parameters that define the object's size and layout relationships.

| Parameter | Applies to | Description |
|-----------|-----------|-------------|
| Size | All | Width and height. Set explicitly or inferred from content. |
| Position | All | X/Y on canvas. Relative to parent if nested, absolute if root. |
| Padding | All | Internal spacing between the object's edge and its children |
| Spacing | Components with children | Space between direct children |
| Alignment | Components with children | How children align on the cross axis |
| Corner Radius | Shape, Widget | Rounding of corners |
| Clip | Shape | Whether children are clipped to bounds |

### Content
Parameters that define what the object contains or communicates.

| Parameter | Applies to | Description |
|-----------|-----------|-------------|
| Color | All | Fill color. Supports solid, gradient, and dynamic values. |
| Opacity | All | Overall transparency |
| Text | Information, Widget | Text content, style role, and truncation behavior |
| Image | Information, Shape | Image source and fit mode |
| Icon | Information, Widget | Icon asset and size |
| Shadow | All | Drop shadow or inner shadow |
| Border | All | Stroke color, width, and position |

### Behavior
Parameters that define how the object responds and changes.

| Parameter | Applies to | Description |
|-----------|-----------|-------------|
| Interaction | Widget | Tap, press, swipe, drag actions and their targets |
| Animation | All | Transition into and out of this state |
| Accessibility | All | Label, hint, trait declarations |
| State | All | Which state is currently active on the canvas |

---

## 8. Parameter Defaults by Subtype

Elemental Design applies intelligent defaults at creation. The user sees a component that already works — no blank slate.

| Parameter | Shape default | Information default | Widget default |
|-----------|--------------|-------------------|---------------|
| Size | 200 × 200 | Hug content | Hug content |
| Padding | 16pt all sides | 0 | 12pt horizontal, 8pt vertical |
| Color | System background | None (transparent) | System accent |
| Corner Radius | 12pt | 0 | 8pt |
| Clip | On | Off | On |
| Interaction | None | None | Tap (no target) |

All defaults are overridable. None are hidden — they are visible in the Elements panel via `>>>`.

---

## 9. The ElementalObject Data Model

```swift
// Root protocol — every object in an Elemental Design project conforms to this
protocol ElementalObject: Identifiable, Codable {
    var id: UUID { get }
    var name: String { get set }
    var children: [any ElementalObject] { get set }
    var relationships: [Relationship] { get set }
    var parameters: ParameterGroup { get set }
}

// Root types
struct Screen: ElementalObject {
    var id: UUID
    var name: String
    var platform: Platform          // .iOS, .macOS, .web
    var children: [any ElementalObject]
    var relationships: [Relationship]
    var parameters: ParameterGroup
}

struct Component: ElementalObject {
    var id: UUID
    var name: String
    var subtype: ComponentSubtype   // .shape, .information, .widget
    var states: [ComponentState]    // always contains .default
    var activeState: ComponentState
    var children: [any ElementalObject]
    var relationships: [Relationship]
    var parameters: ParameterGroup  // parameters for the active state
}

// Enums
enum Platform { case iOS, macOS, web }
enum ComponentSubtype { case shape, information, widget }

// State
struct ComponentState: Identifiable, Codable {
    var id: UUID
    var name: String                // "Default", "Hover", "Pressed", or custom
    var isBuiltIn: Bool
    var parameters: ParameterGroup  // overrides on top of Default
}

// Relationship
struct Relationship: Codable {
    var kind: RelationshipKind
    var sourceID: UUID
    var targetID: UUID
    var isSpatial: Bool             // true = inferred from canvas, false = explicitly declared
}

enum RelationshipKind { case contains, triggers, sharesState, follows }
```

---

## 10. What This Spec Does Not Cover

- How parameters render as controls in the UI → `router→ Spec_ProgressiveDisclosure.md`
- How the Agent creates objects from natural language → `router→ Spec_Agent.md`
- How objects are persisted to disk → `router→ Spec_Persistence.md`
- The Element Map relationship visualization → `router→ Spec_ElementMap.md`
- Canvas interaction model (drag, resize, selection) → `router→ Spec_Canvas.md`
