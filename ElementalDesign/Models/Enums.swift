// MARK: - Platform

/// The target platform context for a Screen.
/// Determines default dimensions and platform-specific behaviors.
enum Platform: String, Codable, CaseIterable, Sendable {
    case iOS
    case macOS
    case web
}

// MARK: - ComponentSubtype

/// The subtype of a Component, declared at creation and immutable.
/// Determines which parameters are available and what defaults are applied.
enum ComponentSubtype: String, Codable, CaseIterable, Sendable {
    case shape
    case information
    case widget
}

// MARK: - RelationshipKind

/// The kind of relationship between two objects.
enum RelationshipKind: String, Codable, Sendable {
    case contains
    case triggers
    case sharesState
    case follows
}
