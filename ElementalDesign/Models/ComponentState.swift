import Foundation

// MARK: - ComponentState

/// A named state for a Component — each state holds parameter overrides on top of Default.
///
/// Every Component has at least the Default state. Additional built-in states
/// (Hover, Pressed, Focused, etc.) are available based on subtype.
/// Users may also declare custom states with plain-language names.
///
/// See Spec_ObjectModel §6 — States.
struct ComponentState: Identifiable, Codable, Equatable, Sendable {
    var id: UUID
    var name: String
    var isBuiltIn: Bool
    var parameters: ParameterGroup

    /// Creates the mandatory Default state for a given subtype.
    static func defaultState(for subtype: ComponentSubtype) -> ComponentState {
        ComponentState(
            id: UUID(),
            name: "Default",
            isBuiltIn: true,
            parameters: ParameterGroup.defaults(for: subtype)
        )
    }
}

// MARK: - Built-in State Names

/// The built-in state names and which subtypes they apply to.
/// See Spec_ObjectModel §6 — Built-in states table.
enum BuiltInState: String, CaseIterable, Sendable {
    case `default` = "Default"
    case hover = "Hover"
    case pressed = "Pressed"
    case focused = "Focused"
    case disabled = "Disabled"
    case loading = "Loading"
    case empty = "Empty"
    case error = "Error"

    /// The subtypes this built-in state applies to.
    var applicableSubtypes: Set<ComponentSubtype> {
        switch self {
        case .default:    return [.shape, .information, .widget]
        case .hover:      return [.widget, .shape]
        case .pressed:    return [.widget]
        case .focused:    return [.widget]
        case .disabled:   return [.widget]
        case .loading:    return [.widget, .information]
        case .empty:      return [.information]
        case .error:      return [.widget, .information]
        }
    }
}
