import Foundation

// MARK: - ElementalObject Protocol

/// Root protocol — every object in an Elemental Design project conforms to this.
/// See Spec_ObjectModel §9.
protocol ElementalObject: Identifiable, Sendable {
    var id: UUID { get }
    var name: String { get set }
    var children: [AnyElementalObject] { get set }
    var relationships: [Relationship] { get set }
    var parameters: ParameterGroup { get set }
}

// MARK: - Screen

/// A full view — a complete app screen or web page.
/// Has a platform context (iOS, macOS, web) that determines default dimensions.
/// A Screen is the root of every nesting tree and cannot be nested inside anything.
///
/// See Spec_ObjectModel §2 — Root Object Types.
struct Screen: ElementalObject, Codable, Equatable, Sendable {
    var id: UUID
    var name: String
    var platform: Platform
    var children: [AnyElementalObject]
    var relationships: [Relationship]
    var parameters: ParameterGroup

    init(
        id: UUID = UUID(),
        name: String = "Screen",
        platform: Platform = .iOS,
        children: [AnyElementalObject] = [],
        relationships: [Relationship] = [],
        parameters: ParameterGroup? = nil
    ) {
        self.id = id
        self.name = name
        self.platform = platform
        self.children = children
        self.relationships = relationships
        self.parameters = parameters ?? ParameterGroup.screenDefaults(for: platform)
    }
}

// MARK: - Component

/// A reusable UI element. Has a subtype (Shape, Information, Widget) declared at creation.
/// Components may contain other Components without depth limit.
///
/// See Spec_ObjectModel §2–3 — Root Object Types, Component Subtypes.
struct Component: ElementalObject, Codable, Equatable, Sendable {
    var id: UUID
    var name: String
    var subtype: ComponentSubtype
    var states: [ComponentState]
    var activeState: ComponentState
    var children: [AnyElementalObject]
    var relationships: [Relationship]
    var parameters: ParameterGroup

    init(
        id: UUID = UUID(),
        name: String = "Component",
        subtype: ComponentSubtype,
        states: [ComponentState]? = nil,
        activeState: ComponentState? = nil,
        children: [AnyElementalObject] = [],
        relationships: [Relationship] = [],
        parameters: ParameterGroup? = nil
    ) {
        let defaultState = ComponentState.defaultState(for: subtype)
        let resolvedStates = states ?? [defaultState]
        let resolvedActive = activeState ?? resolvedStates[0]

        self.id = id
        self.name = name
        self.subtype = subtype
        self.states = resolvedStates
        self.activeState = resolvedActive
        self.children = children
        self.relationships = relationships
        self.parameters = parameters ?? ParameterGroup.defaults(for: subtype)
    }
}

// MARK: - AnyElementalObject (Type-Erased Wrapper)

/// A type-erased wrapper for ElementalObject that enables heterogeneous collections
/// and Codable conformance for the children array.
///
/// Wraps either a Screen or a Component. In practice, Screen children are always
/// Components (Screens cannot be nested), but the wrapper is uniform for simplicity.
enum AnyElementalObject: Codable, Equatable, Identifiable, Sendable {
    case screen(Screen)
    case component(Component)

    var id: UUID {
        switch self {
        case .screen(let s): return s.id
        case .component(let c): return c.id
        }
    }

    var name: String {
        get {
            switch self {
            case .screen(let s): return s.name
            case .component(let c): return c.name
            }
        }
        set {
            switch self {
            case .screen(var s):
                s.name = newValue
                self = .screen(s)
            case .component(var c):
                c.name = newValue
                self = .component(c)
            }
        }
    }

    var children: [AnyElementalObject] {
        get {
            switch self {
            case .screen(let s): return s.children
            case .component(let c): return c.children
            }
        }
        set {
            switch self {
            case .screen(var s):
                s.children = newValue
                self = .screen(s)
            case .component(var c):
                c.children = newValue
                self = .component(c)
            }
        }
    }

    var parameters: ParameterGroup {
        get {
            switch self {
            case .screen(let s): return s.parameters
            case .component(let c): return c.parameters
            }
        }
        set {
            switch self {
            case .screen(var s):
                s.parameters = newValue
                self = .screen(s)
            case .component(var c):
                c.parameters = newValue
                self = .component(c)
            }
        }
    }
}
