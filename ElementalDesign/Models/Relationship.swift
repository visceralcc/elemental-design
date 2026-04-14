import Foundation

// MARK: - Relationship

/// A connection between two objects in the project.
///
/// Relationships are either spatial (inferred from canvas positioning)
/// or explicit (declared by the user or Agent through the Elements panel).
struct Relationship: Codable, Equatable, Sendable {
    /// The kind of relationship.
    var kind: RelationshipKind

    /// The ID of the source object.
    var sourceID: UUID

    /// The ID of the target object.
    var targetID: UUID

    /// `true` when inferred from canvas position, `false` when explicitly declared.
    var isSpatial: Bool
}
