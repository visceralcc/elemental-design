import Foundation

// MARK: - ParameterGroup

/// The three parameter groups every object carries: Structure, Content, Behavior.
/// Groups are the same for all object types — what differs is which parameters
/// appear within each group, based on type and subtype.
struct ParameterGroup: Codable, Equatable, Sendable {
    var structure: StructureParameters
    var content: ContentParameters
    var behavior: BehaviorParameters

    /// Returns a ParameterGroup populated with intelligent defaults for the given subtype.
    /// See Spec_ObjectModel §8 — Parameter Defaults by Subtype.
    static func defaults(for subtype: ComponentSubtype) -> ParameterGroup {
        switch subtype {
        case .shape:
            return ParameterGroup(
                structure: StructureParameters(
                    size: SizeParameter(width: .fixed(200), height: .fixed(200)),
                    position: PositionParameter(x: 0, y: 0),
                    padding: ElementalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
                    spacing: 0,
                    alignment: .center,
                    cornerRadius: 12,
                    clip: true,
                    scalesWithContent: true
                ),
                content: ContentParameters(
                    color: ColorParameter(fill: .solid(.systemBackground)),
                    opacity: 1.0,
                    text: nil,
                    image: nil,
                    icon: nil,
                    shadow: nil,
                    border: nil
                ),
                behavior: BehaviorParameters(
                    interaction: nil,
                    animation: AnimationParameter.default,
                    accessibility: AccessibilityParameter(),
                    activeStateName: "Default"
                )
            )

        case .information:
            return ParameterGroup(
                structure: StructureParameters(
                    size: SizeParameter(width: .hugContent, height: .hugContent),
                    position: PositionParameter(x: 0, y: 0),
                    padding: ElementalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
                    spacing: 0,
                    alignment: .leading,
                    cornerRadius: 0,
                    clip: false,
                    scalesWithContent: true
                ),
                content: ContentParameters(
                    color: ColorParameter(fill: .none),
                    opacity: 1.0,
                    text: TextParameter(),
                    image: nil,
                    icon: nil,
                    shadow: nil,
                    border: nil
                ),
                behavior: BehaviorParameters(
                    interaction: nil,
                    animation: AnimationParameter.default,
                    accessibility: AccessibilityParameter(),
                    activeStateName: "Default"
                )
            )

        case .widget:
            return ParameterGroup(
                structure: StructureParameters(
                    size: SizeParameter(width: .hugContent, height: .hugContent),
                    position: PositionParameter(x: 0, y: 0),
                    padding: ElementalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12),
                    spacing: 0,
                    alignment: .center,
                    cornerRadius: 8,
                    clip: true,
                    scalesWithContent: true
                ),
                content: ContentParameters(
                    color: ColorParameter(fill: .solid(.systemAccent)),
                    opacity: 1.0,
                    text: nil,
                    image: nil,
                    icon: nil,
                    shadow: nil,
                    border: nil
                ),
                behavior: BehaviorParameters(
                    interaction: InteractionParameter(action: .tap, targetID: nil),
                    animation: AnimationParameter.default,
                    accessibility: AccessibilityParameter(),
                    activeStateName: "Default"
                )
            )
        }
    }

    /// Returns a ParameterGroup with Screen defaults for a given platform.
    static func screenDefaults(for platform: Platform) -> ParameterGroup {
        let size: SizeParameter
        switch platform {
        case .iOS:
            size = SizeParameter(width: .fixed(390), height: .fixed(844))
        case .macOS:
            size = SizeParameter(width: .fixed(1280), height: .fixed(800))
        case .web:
            size = SizeParameter(width: .fixed(1440), height: .fixed(900))
        }

        return ParameterGroup(
            structure: StructureParameters(
                size: size,
                position: PositionParameter(x: 0, y: 0),
                padding: ElementalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
                spacing: 0,
                alignment: .leading,
                cornerRadius: 0,
                clip: true,
                scalesWithContent: false
            ),
            content: ContentParameters(
                color: ColorParameter(fill: .solid(.systemBackground)),
                opacity: 1.0,
                text: nil,
                image: nil,
                icon: nil,
                shadow: nil,
                border: nil
            ),
            behavior: BehaviorParameters(
                interaction: nil,
                animation: AnimationParameter.default,
                accessibility: AccessibilityParameter(),
                activeStateName: "Default"
            )
        )
    }
}

// MARK: - Structure Parameters

/// Parameters that define an object's size and layout relationships.
/// See Spec_ObjectModel §7 — Structure.
struct StructureParameters: Codable, Equatable, Sendable {
    /// Width and height — explicit or inferred from content.
    var size: SizeParameter

    /// X/Y position on the canvas. Relative to parent if nested, absolute if root.
    var position: PositionParameter

    /// Internal spacing between the object's edge and its children.
    var padding: ElementalEdgeInsets

    /// Space between direct children (points). Only meaningful for Components with children.
    var spacing: CGFloat

    /// How children align on the cross axis. Only meaningful for Components with children.
    var alignment: ElementalAlignment

    /// Rounding of corners (points). Applies to Shape and Widget.
    /// Slider range: 0–60pt per Spec_ProgressiveDisclosure §5.
    var cornerRadius: CGFloat

    /// Whether children are clipped to bounds. Applies to Shape.
    var clip: Bool

    /// Whether the object should scale its size to fit its content.
    /// Default: `true`. When `false`, size is fixed regardless of content changes.
    var scalesWithContent: Bool
}

// MARK: - SizeParameter

/// Width and height, each either explicitly set or inferred from content.
struct SizeParameter: Codable, Equatable, Sendable {
    var width: SizeDimension
    var height: SizeDimension
}

/// A single dimension that is either a fixed point value or hugs its content.
enum SizeDimension: Codable, Equatable, Sendable {
    /// A fixed size in points. Slider range: 0–800pt per Spec_ProgressiveDisclosure §5.
    case fixed(CGFloat)

    /// Size inferred from content — the object wraps to fit its children or text.
    case hugContent
}

// MARK: - PositionParameter

/// X/Y position on the canvas in points.
/// Relative to parent if nested, absolute if root-level.
struct PositionParameter: Codable, Equatable, Sendable {
    var x: CGFloat
    var y: CGFloat
}

// MARK: - ElementalEdgeInsets

/// Internal spacing between an object's edge and its children, per side.
/// Slider range per side: 0–64pt per Spec_ProgressiveDisclosure §5.
struct ElementalEdgeInsets: Codable, Equatable, Sendable {
    var top: CGFloat
    var leading: CGFloat
    var bottom: CGFloat
    var trailing: CGFloat

    /// The unit system for padding values.
    var unit: PaddingUnit

    init(
        top: CGFloat = 0,
        leading: CGFloat = 0,
        bottom: CGFloat = 0,
        trailing: CGFloat = 0,
        unit: PaddingUnit = .pt
    ) {
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
        self.unit = unit
    }
}

/// The unit system for padding values.
enum PaddingUnit: String, Codable, Sendable {
    /// Points — absolute values.
    case pt

    /// Relative — proportional to the parent's size.
    case relative
}

// MARK: - ElementalAlignment

/// Cross-axis alignment for children within a parent.
enum ElementalAlignment: String, Codable, CaseIterable, Sendable {
    case leading
    case center
    case trailing
}

// MARK: - Content Parameters

/// Parameters that define what an object contains or communicates.
/// See Spec_ObjectModel §7 — Content.
struct ContentParameters: Codable, Equatable, Sendable {
    /// Fill color. Supports solid, gradient, and dynamic values.
    var color: ColorParameter

    /// Overall transparency. Range: 0.0 (invisible) to 1.0 (fully opaque).
    var opacity: Double

    /// Text content, style role, and truncation behavior.
    /// Applies to: Information, Widget.
    var text: TextParameter?

    /// Image source and fit mode.
    /// Applies to: Information, Shape.
    var image: ImageParameter?

    /// Icon asset and size.
    /// Applies to: Information, Widget.
    var icon: IconParameter?

    /// Drop shadow or inner shadow.
    /// Applies to: All.
    var shadow: ShadowParameter?

    /// Stroke color, width, and position.
    /// Applies to: All.
    var border: BorderParameter?
}

// MARK: - ColorParameter

/// Fill color for an object.
struct ColorParameter: Codable, Equatable, Sendable {
    var fill: ColorFill
}

/// The fill value for a color parameter.
enum ColorFill: Codable, Equatable, Sendable {
    /// No fill — transparent.
    case none

    /// A single solid color.
    case solid(ElementalColor)

    /// A gradient between two or more colors.
    case gradient(GradientDefinition)

    /// A dynamic/semantic color that adapts to context (light/dark mode).
    case dynamic(String)
}

/// A simple RGBA color representation. Not tied to any UI framework.
struct ElementalColor: Codable, Equatable, Sendable {
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double

    init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    // Semantic colors — resolved at render time by the design system.
    static let systemBackground = ElementalColor(red: 0.15, green: 0.15, blue: 0.15)
    static let systemAccent = ElementalColor(red: 0.0, green: 0.48, blue: 1.0)
    static let white = ElementalColor(red: 1, green: 1, blue: 1)
    static let black = ElementalColor(red: 0, green: 0, blue: 0)
    static let clear = ElementalColor(red: 0, green: 0, blue: 0, alpha: 0)
}

/// A gradient defined by color stops, angle, and type.
struct GradientDefinition: Codable, Equatable, Sendable {
    var stops: [GradientStop]
    var angleDegrees: Double
    var type: GradientType

    struct GradientStop: Codable, Equatable, Sendable {
        var color: ElementalColor
        var position: Double // 0.0 to 1.0
    }

    enum GradientType: String, Codable, Sendable {
        case linear
        case radial
    }
}

// MARK: - TextParameter

/// Text content, style role, and truncation behavior.
/// Applies to Information and Widget subtypes.
/// Control: Inline text field (expands to multiline) for content,
/// segmented picker for style role per Spec_ProgressiveDisclosure §6.
struct TextParameter: Codable, Equatable, Sendable {
    /// The text content string.
    var content: String

    /// The typographic role that determines size and weight.
    /// Control: Segmented picker — Display / Title / Body / Label / Mono.
    var styleRole: TextStyleRole

    /// How text behaves when it exceeds available space.
    var truncation: TextTruncation

    /// Maximum number of lines. `nil` means unlimited.
    var maxLines: Int?

    init(
        content: String = "",
        styleRole: TextStyleRole = .body,
        truncation: TextTruncation = .tail,
        maxLines: Int? = nil
    ) {
        self.content = content
        self.styleRole = styleRole
        self.truncation = truncation
        self.maxLines = maxLines
    }
}

/// Typographic style role — determines size, weight, and spacing.
/// Matches the segmented picker in Spec_ProgressiveDisclosure §6.
enum TextStyleRole: String, Codable, CaseIterable, Sendable {
    case display
    case title
    case body
    case label
    case mono
}

/// How text is truncated when it overflows.
enum TextTruncation: String, Codable, CaseIterable, Sendable {
    /// Truncate at the end with an ellipsis.
    case tail

    /// Truncate at the beginning with an ellipsis.
    case head

    /// Truncate in the middle with an ellipsis.
    case middle

    /// Wrap to the next line (no truncation).
    case wrap
}

// MARK: - ImageParameter

/// Image source and fit mode.
/// Applies to Information and Shape subtypes.
/// Control: Drop target + file picker button per Spec_ProgressiveDisclosure §6.
struct ImageParameter: Codable, Equatable, Sendable {
    /// The image source — a file path, asset name, or URL string.
    var source: String

    /// How the image fits within the object's bounds.
    var fitMode: ImageFitMode

    init(
        source: String = "",
        fitMode: ImageFitMode = .fill
    ) {
        self.source = source
        self.fitMode = fitMode
    }
}

/// How an image fits within its container.
enum ImageFitMode: String, Codable, CaseIterable, Sendable {
    /// Scale to fill the bounds, cropping if necessary.
    case fill

    /// Scale to fit entirely within the bounds, letterboxing if necessary.
    case fit

    /// Stretch to fill the bounds exactly, ignoring aspect ratio.
    case stretch

    /// Display at original size, cropping if larger than bounds.
    case original
}

// MARK: - IconParameter

/// An icon asset and its display size.
/// Applies to Information and Widget subtypes.
/// Control: Searchable icon grid per Spec_ProgressiveDisclosure §6.
struct IconParameter: Codable, Equatable, Sendable {
    /// The icon identifier — an SF Symbol name or custom asset name.
    var name: String

    /// The display size of the icon in points.
    var size: CGFloat

    init(
        name: String = "",
        size: CGFloat = 24
    ) {
        self.name = name
        self.size = size
    }
}

// MARK: - ShadowParameter

/// Drop shadow or inner shadow definition.
/// Applies to all object types.
/// Shadow radius slider range: 0–40pt per Spec_ProgressiveDisclosure §5.
struct ShadowParameter: Codable, Equatable, Sendable {
    /// The shadow color.
    var color: ElementalColor

    /// Blur radius in points. Slider range: 0–40pt.
    var radius: CGFloat

    /// Horizontal offset in points.
    var offsetX: CGFloat

    /// Vertical offset in points.
    var offsetY: CGFloat

    /// Whether this is an inner shadow (inset) rather than a drop shadow.
    var isInner: Bool

    init(
        color: ElementalColor = ElementalColor(red: 0, green: 0, blue: 0, alpha: 0.25),
        radius: CGFloat = 4,
        offsetX: CGFloat = 0,
        offsetY: CGFloat = 2,
        isInner: Bool = false
    ) {
        self.color = color
        self.radius = radius
        self.offsetX = offsetX
        self.offsetY = offsetY
        self.isInner = isInner
    }
}

// MARK: - BorderParameter

/// Stroke color, width, and position for an object's edge.
/// Applies to all object types.
/// Border width slider range: 0–16pt per Spec_ProgressiveDisclosure §5.
struct BorderParameter: Codable, Equatable, Sendable {
    /// The stroke color.
    var color: ElementalColor

    /// The stroke width in points. Slider range: 0–16pt.
    var width: CGFloat

    /// Where the border sits relative to the object's edge.
    var position: BorderPosition

    init(
        color: ElementalColor = ElementalColor.black,
        width: CGFloat = 1,
        position: BorderPosition = .inside
    ) {
        self.color = color
        self.width = width
        self.position = position
    }
}

/// Where a border sits relative to the object's edge.
enum BorderPosition: String, Codable, CaseIterable, Sendable {
    case inside
    case center
    case outside
}

// MARK: - Behavior Parameters

/// Parameters that define how an object responds and changes.
/// See Spec_ObjectModel §7 — Behavior.
struct BehaviorParameters: Codable, Equatable, Sendable {
    /// Tap, press, swipe, drag actions and their targets.
    /// Applies to: Widget only.
    var interaction: InteractionParameter?

    /// Transition into and out of a state.
    /// Applies to: All.
    var animation: AnimationParameter

    /// Accessibility label, hint, and trait declarations.
    /// Applies to: All.
    var accessibility: AccessibilityParameter

    /// The name of the currently active state on the canvas.
    /// Applies to: All. Default is always "Default".
    var activeStateName: String
}

// MARK: - InteractionParameter

/// An interaction action and its target.
/// Applies to Widget subtypes.
/// Control: Object picker for target per Spec_ProgressiveDisclosure §6.
struct InteractionParameter: Codable, Equatable, Sendable {
    /// The type of user action that triggers this interaction.
    var action: InteractionAction

    /// The ID of the target object this action affects. `nil` means no target assigned.
    var targetID: UUID?
}

/// The type of user action on a Widget.
enum InteractionAction: String, Codable, CaseIterable, Sendable {
    case tap
    case press
    case swipe
    case drag
}

// MARK: - AnimationParameter

/// Transition animation when entering or leaving a state.
/// Control: Preset pills (None, Fade, Slide, Scale) + duration slider
/// per Spec_ProgressiveDisclosure §6.
struct AnimationParameter: Codable, Equatable, Sendable {
    /// The animation preset.
    var preset: AnimationPreset

    /// Duration in seconds.
    var durationSeconds: Double

    init(
        preset: AnimationPreset = .none,
        durationSeconds: Double = 0.3
    ) {
        self.preset = preset
        self.durationSeconds = durationSeconds
    }

    /// The default animation — no animation.
    static let `default` = AnimationParameter(preset: .none, durationSeconds: 0.3)
}

/// Animation preset options from Spec_ProgressiveDisclosure §6.
enum AnimationPreset: String, Codable, CaseIterable, Sendable {
    case none
    case fade
    case slide
    case scale
}

// MARK: - AccessibilityParameter

/// Accessibility declarations — label, hint, and traits.
/// Applies to all object types per Spec_ObjectModel §7.
struct AccessibilityParameter: Codable, Equatable, Sendable {
    /// The accessibility label read by VoiceOver.
    var label: String

    /// Additional context or usage hint.
    var hint: String

    /// The accessibility traits that describe the element's role.
    var traits: [AccessibilityTrait]

    init(
        label: String = "",
        hint: String = "",
        traits: [AccessibilityTrait] = []
    ) {
        self.label = label
        self.hint = hint
        self.traits = traits
    }
}

/// Accessibility traits that describe an element's behavior to assistive technologies.
enum AccessibilityTrait: String, Codable, CaseIterable, Sendable {
    case button
    case link
    case header
    case image
    case staticText
    case adjustable
    case searchField
    case selected
    case disabled
}
