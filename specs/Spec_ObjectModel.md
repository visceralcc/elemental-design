# Elemental Design — Object Model Specification

**The objects Elemental Design works with, how they relate, and how they are parameterized**

Version 0.3 | April 2026 | Charlie Denison

---

## Version History
| Version | Date | Changes |
|---------|------|---------|
| 0.1 | Apr 2026 | Initial draft. Root types, subtypes, nesting, relationships, states, parameter groups. |
| 0.2 | Apr 2026 | Renamed product to Elemental Design. Renamed SurfaceObject protocol to ElementalObject. |
| 0.3 | Apr 2026 | Expanded §7 with full parameter type definitions for Text, Image, Icon, Shadow, Border, Animation, and Accessibility. Added scalesWithContent to Structure. Added PaddingUnit to Padding. Updated §9 data model to match implemented code. |

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
| Size | All | Width and height. Each dimension is either a fixed point value or "hug content" (inferred from children/text). |
| Position | All | X/Y on canvas in points. Relative to parent if nested, absolute if root. |
| Padding | All | Internal spacing between the object's edge and its children. Per-side values (top, leading, bottom, trailing). Supports point and relative units. |
| Spacing | Components with children | Space between direct children (points) |
| Alignment | Components with children | How children align on the cross axis: leading, center, or trailing |
| Corner Radius | Shape, Widget | Rounding of corners (points) |
| Clip | Shape | Whether children are clipped to bounds |
| Scales with Content | All | Whether the object scales its size to fit its content. Default: on. When off, size is fixed regardless of content changes. |

### Content
Parameters that define what the object contains or communicates.

| Parameter | Applies to | Description |
|-----------|-----------|-------------|
| Color | All | Fill color. Supports solid, gradient, dynamic (adapts to light/dark mode), and none (transparent). |
| Opacity | All | Overall transparency. Range: 0% (invisible) to 100% (fully opaque). |
| Text | Information, Widget | See §7.1 — Text. |
| Image | Information, Shape | See §7.2 — Image. |
| Icon | Information, Widget | See §7.3 — Icon. |
| Shadow | All | See §7.4 — Shadow. |
| Border | All | See §7.5 — Border. |

### Behavior
Parameters that define how the object responds and changes.

| Parameter | Applies to | Description |
|-----------|-----------|-------------|
| Interaction | Widget | Tap, press, swipe, or drag action and its target object. Target is optional — a Widget can exist with a declared action but no target assigned yet. |
| Animation | All | See §7.6 — Animation. |
| Accessibility | All | See §7.7 — Accessibility. |
| State | All | Which state is currently active on the canvas. Always "Default" at creation. |

---

### 7.1 Text

Text content, style role, and truncation behavior. Applies to Information and Widget subtypes.

| Property | Values | Default | Description |
|----------|--------|---------|-------------|
| Content | Free text | Empty string | The text content. Control: inline text field, expands to multiline. |
| Style Role | Display, Title, Body, Label, Mono | Body | Determines size, weight, and spacing. Control: segmented picker. |
| Truncation | Tail, Head, Middle, Wrap | Tail | How text behaves when it exceeds available space. |
| Max Lines | Integer or unlimited | Unlimited | Maximum number of visible lines. Unlimited means no limit. |

### 7.2 Image

Image source and fit mode. Applies to Information and Shape subtypes.

| Property | Values | Default | Description |
|----------|--------|---------|-------------|
| Source | File path, asset name, or URL | Empty string | The image to display. Control: drop target + file picker button. |
| Fit Mode | Fill, Fit, Stretch, Original | Fill | How the image fits within the object's bounds. |

**Fit mode definitions:**

| Mode | Behavior |
|------|----------|
| Fill | Scale to fill bounds, cropping if necessary. Preserves aspect ratio. |
| Fit | Scale to fit entirely within bounds, letterboxing if necessary. Preserves aspect ratio. |
| Stretch | Scale to fill bounds exactly. Does not preserve aspect ratio. |
| Original | Display at original pixel size, cropping if larger than bounds. |

### 7.3 Icon

An icon asset and its display size. Applies to Information and Widget subtypes.

| Property | Values | Default | Description |
|----------|--------|---------|-------------|
| Name | SF Symbol name or custom asset name | Empty string | The icon identifier. Control: searchable icon grid. |
| Size | Points | 24pt | The display size of the icon. |

### 7.4 Shadow

Drop shadow or inner shadow. Applies to all object types.

| Property | Values | Default | Description |
|----------|--------|---------|-------------|
| Color | Any color | Black at 25% opacity | The shadow color. |
| Radius | Points (slider: 0–40pt) | 4pt | Blur radius. |
| Offset X | Points | 0 | Horizontal offset. |
| Offset Y | Points | 2pt | Vertical offset. |
| Inner | On / Off | Off | Whether this is an inner shadow (inset) rather than a drop shadow. |

### 7.5 Border

Stroke around an object's edge. Applies to all object types.

| Property | Values | Default | Description |
|----------|--------|---------|-------------|
| Color | Any color | Black | The stroke color. |
| Width | Points (slider: 0–16pt) | 1pt | The stroke width. |
| Position | Inside, Center, Outside | Inside | Where the border sits relative to the object's edge. |

### 7.6 Animation

Transition animation when entering or leaving a state. Applies to all object types.

| Property | Values | Default | Description |
|----------|--------|---------|-------------|
| Preset | None, Fade, Slide, Scale | None | The animation style. Control: preset pills. |
| Duration | Seconds | 0.3s | How long the transition takes. |

### 7.7 Accessibility

Accessibility declarations for assistive technologies. Applies to all object types.

| Property | Values | Default | Description |
|----------|--------|---------|-------------|
| Label | Free text | Empty string | The accessibility label read by VoiceOver. |
| Hint | Free text | Empty string | Additional context or usage hint for the user. |
| Traits | Button, Link, Header, Image, Static Text, Adjustable, Search Field, Selected, Disabled | None | Traits that describe the element's role and behavior. Multiple traits can be combined. |

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
| Scales with Content | On | On | On |
| Interaction | None | None | Tap (no target) |
| Text | None | Empty (Body style) | None |
| Animation | None | None | None |
| Opacity | 100% | 100% | 100% |

All defaults are overridable. None are hidden — they are visible in the Elements panel via `>>>`.

### Screen defaults by platform

| Platform | Width | Height |
|----------|-------|--------|
| iOS (iPhone) | 390pt | 844pt |
| iOS (iPad) | 820pt | 1180pt |
| macOS | 1280pt | 800pt |
| Web | 1440pt | 900pt |

Screens default to clip on, scales-with-content off, and system background fill.

---

## 9. The ElementalObject Data Model

```swift
// Root protocol — every object in an Elemental Design project conforms to this
protocol ElementalObject: Identifiable {
    var id: UUID { get }
    var name: String { get set }
    var children: [AnyElementalObject] { get set }
    var relationships: [Relationship] { get set }
    var parameters: ParameterGroup { get set }
}

// Root types
struct Screen: ElementalObject {
    var id: UUID
    var name: String
    var platform: Platform          // .iOS, .macOS, .web
    var children: [AnyElementalObject]
    var relationships: [Relationship]
    var parameters: ParameterGroup
}

struct Component: ElementalObject {
    var id: UUID
    var name: String
    var subtype: ComponentSubtype   // .shape, .information, .widget
    var states: [ComponentState]    // always contains Default
    var activeState: ComponentState
    var children: [AnyElementalObject]
    var relationships: [Relationship]
    var parameters: ParameterGroup  // parameters for the active state
}

// AnyElementalObject — type-erased wrapper for heterogeneous children arrays
enum AnyElementalObject {
    case screen(Screen)
    case component(Component)
}

// Enums
enum Platform { case iOS, macOS, web }
enum ComponentSubtype { case shape, information, widget }

// State
struct ComponentState {
    var id: UUID
    var name: String                // "Default", "Hover", "Pressed", or custom
    var isBuiltIn: Bool
    var parameters: ParameterGroup  // overrides on top of Default
}

// Relationship
struct Relationship {
    var kind: RelationshipKind
    var sourceID: UUID
    var targetID: UUID
    var isSpatial: Bool             // true = inferred from canvas, false = explicitly declared
}

enum RelationshipKind { case contains, triggers, sharesState, follows }

// ParameterGroup
struct ParameterGroup {
    var structure: StructureParameters
    var content: ContentParameters
    var behavior: BehaviorParameters
}

// Structure
struct StructureParameters {
    var size: SizeParameter         // .fixed(CGFloat) or .hugContent per dimension
    var position: PositionParameter // x, y in points
    var padding: ElementalEdgeInsets // per-side, with unit (.pt or .relative)
    var spacing: CGFloat
    var alignment: ElementalAlignment // .leading, .center, .trailing
    var cornerRadius: CGFloat
    var clip: Bool
    var scalesWithContent: Bool
}

// Content
struct ContentParameters {
    var color: ColorParameter       // fill: .none, .solid, .gradient, .dynamic
    var opacity: Double
    var text: TextParameter?        // §7.1
    var image: ImageParameter?      // §7.2
    var icon: IconParameter?        // §7.3
    var shadow: ShadowParameter?    // §7.4
    var border: BorderParameter?    // §7.5
}

// Behavior
struct BehaviorParameters {
    var interaction: InteractionParameter?  // action + optional targetID
    var animation: AnimationParameter       // §7.6
    var accessibility: AccessibilityParameter // §7.7
    var activeStateName: String
}
```

---

## 10. What This Spec Does Not Cover

- How parameters render as controls in the UI → `router→ Spec_ProgressiveDisclosure.md`
- How the Agent creates objects from natural language → `router→ Spec_Agent.md`
- How objects are persisted to disk → `router→ Spec_Persistence.md`
- The Element Map relationship visualization → `router→ Spec_ElementMap.md`
- Canvas interaction model (drag, resize, selection) → `router→ Spec_Canvas.md`
