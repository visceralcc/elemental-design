import XCTest
@testable import ElementalDesign

final class ObjectModelTests: XCTestCase {

    // MARK: - Component Creation & Defaults

    func testShapeDefaults() {
        let shape = Component(name: "Card", subtype: .shape)

        XCTAssertEqual(shape.subtype, .shape)
        XCTAssertEqual(shape.parameters.structure.size.width, .fixed(200))
        XCTAssertEqual(shape.parameters.structure.size.height, .fixed(200))
        XCTAssertEqual(shape.parameters.structure.padding.top, 16)
        XCTAssertEqual(shape.parameters.structure.padding.leading, 16)
        XCTAssertEqual(shape.parameters.structure.padding.bottom, 16)
        XCTAssertEqual(shape.parameters.structure.padding.trailing, 16)
        XCTAssertEqual(shape.parameters.structure.cornerRadius, 12)
        XCTAssertTrue(shape.parameters.structure.clip)
        XCTAssertTrue(shape.parameters.structure.scalesWithContent)
        XCTAssertEqual(shape.parameters.content.color.fill, .solid(.systemBackground))
        XCTAssertEqual(shape.parameters.content.opacity, 1.0)
        XCTAssertNil(shape.parameters.content.text)
        XCTAssertNil(shape.parameters.behavior.interaction)
    }

    func testInformationDefaults() {
        let info = Component(name: "Title", subtype: .information)

        XCTAssertEqual(info.parameters.structure.size.width, .hugContent)
        XCTAssertEqual(info.parameters.structure.size.height, .hugContent)
        XCTAssertEqual(info.parameters.structure.padding.top, 0)
        XCTAssertEqual(info.parameters.structure.cornerRadius, 0)
        XCTAssertFalse(info.parameters.structure.clip)
        XCTAssertEqual(info.parameters.content.color.fill, .none)
        XCTAssertNotNil(info.parameters.content.text)
        XCTAssertEqual(info.parameters.content.text?.styleRole, .body)
        XCTAssertNil(info.parameters.behavior.interaction)
    }

    func testWidgetDefaults() {
        let widget = Component(name: "Submit", subtype: .widget)

        XCTAssertEqual(widget.parameters.structure.size.width, .hugContent)
        XCTAssertEqual(widget.parameters.structure.padding.top, 8)
        XCTAssertEqual(widget.parameters.structure.padding.leading, 12)
        XCTAssertEqual(widget.parameters.structure.cornerRadius, 8)
        XCTAssertTrue(widget.parameters.structure.clip)
        XCTAssertEqual(widget.parameters.content.color.fill, .solid(.systemAccent))
        XCTAssertNotNil(widget.parameters.behavior.interaction)
        XCTAssertEqual(widget.parameters.behavior.interaction?.action, .tap)
        XCTAssertNil(widget.parameters.behavior.interaction?.targetID)
    }

    // MARK: - Screen Creation & Platform Defaults

    func testScreenDefaultsiOS() {
        let screen = Screen(name: "Home", platform: .iOS)

        XCTAssertEqual(screen.platform, .iOS)
        XCTAssertEqual(screen.parameters.structure.size.width, .fixed(390))
        XCTAssertEqual(screen.parameters.structure.size.height, .fixed(844))
        XCTAssertTrue(screen.parameters.structure.clip)
    }

    func testScreenDefaultsMacOS() {
        let screen = Screen(name: "Dashboard", platform: .macOS)

        XCTAssertEqual(screen.parameters.structure.size.width, .fixed(1280))
        XCTAssertEqual(screen.parameters.structure.size.height, .fixed(800))
    }

    func testScreenDefaultsWeb() {
        let screen = Screen(name: "Landing", platform: .web)

        XCTAssertEqual(screen.parameters.structure.size.width, .fixed(1440))
        XCTAssertEqual(screen.parameters.structure.size.height, .fixed(900))
    }

    // MARK: - States

    func testComponentAlwaysHasDefaultState() {
        let component = Component(name: "Box", subtype: .shape)

        XCTAssertFalse(component.states.isEmpty)
        XCTAssertEqual(component.states[0].name, "Default")
        XCTAssertTrue(component.states[0].isBuiltIn)
        XCTAssertEqual(component.activeState.name, "Default")
    }

    func testCustomStateCanBeAdded() {
        var button = Component(name: "Toggle", subtype: .widget)
        let selectedState = ComponentState(
            id: UUID(),
            name: "Selected",
            isBuiltIn: false,
            parameters: ParameterGroup.defaults(for: .widget)
        )
        button.states.append(selectedState)

        XCTAssertEqual(button.states.count, 2)
        XCTAssertEqual(button.states[1].name, "Selected")
        XCTAssertFalse(button.states[1].isBuiltIn)
    }

    func testBuiltInStateApplicability() {
        // Hover applies to Widget and Shape, not Information
        XCTAssertTrue(BuiltInState.hover.applicableSubtypes.contains(.widget))
        XCTAssertTrue(BuiltInState.hover.applicableSubtypes.contains(.shape))
        XCTAssertFalse(BuiltInState.hover.applicableSubtypes.contains(.information))

        // Pressed only applies to Widget
        XCTAssertTrue(BuiltInState.pressed.applicableSubtypes.contains(.widget))
        XCTAssertFalse(BuiltInState.pressed.applicableSubtypes.contains(.shape))

        // Empty only applies to Information
        XCTAssertTrue(BuiltInState.empty.applicableSubtypes.contains(.information))
        XCTAssertFalse(BuiltInState.empty.applicableSubtypes.contains(.widget))

        // Default applies to all
        XCTAssertEqual(BuiltInState.default.applicableSubtypes.count, 3)
    }

    // MARK: - Nesting

    func testScreenCanContainComponents() {
        let label = Component(name: "Label", subtype: .information)
        let screen = Screen(
            name: "Home",
            platform: .iOS,
            children: [.component(label)]
        )

        XCTAssertEqual(screen.children.count, 1)
        XCTAssertEqual(screen.children[0].name, "Label")
    }

    func testComponentsNestWithoutDepthLimit() {
        // Build the tree from Spec_ObjectModel §4:
        // Screen > Shape(card) > Information(title) + Information(body) + Widget(button) > Information(label)
        let buttonLabel = Component(name: "Button Label", subtype: .information)
        let button = Component(
            name: "CTA Button",
            subtype: .widget,
            children: [.component(buttonLabel)]
        )
        let title = Component(name: "Title", subtype: .information)
        let body = Component(name: "Body Text", subtype: .information)
        let card = Component(
            name: "Card",
            subtype: .shape,
            children: [
                .component(title),
                .component(body),
                .component(button)
            ]
        )
        let screen = Screen(
            name: "Home",
            platform: .iOS,
            children: [.component(card)]
        )

        // Verify nesting structure
        XCTAssertEqual(screen.children.count, 1)
        let cardChild = screen.children[0]
        XCTAssertEqual(cardChild.children.count, 3)
        XCTAssertEqual(cardChild.children[2].children.count, 1) // button has label child
    }

    // MARK: - Relationships

    func testSpatialRelationship() {
        let parentID = UUID()
        let childID = UUID()
        let rel = Relationship(
            kind: .contains,
            sourceID: parentID,
            targetID: childID,
            isSpatial: true
        )

        XCTAssertEqual(rel.kind, .contains)
        XCTAssertTrue(rel.isSpatial)
    }

    func testExplicitRelationship() {
        let buttonID = UUID()
        let modalID = UUID()
        let rel = Relationship(
            kind: .triggers,
            sourceID: buttonID,
            targetID: modalID,
            isSpatial: false
        )

        XCTAssertEqual(rel.kind, .triggers)
        XCTAssertFalse(rel.isSpatial)
    }

    func testAllRelationshipKinds() {
        // Verify all four kinds from the spec exist
        let kinds: [RelationshipKind] = [.contains, .triggers, .sharesState, .follows]
        XCTAssertEqual(kinds.count, 4)
    }

    // MARK: - TextParameter

    func testTextParameterDefaults() {
        let text = TextParameter()

        XCTAssertEqual(text.content, "")
        XCTAssertEqual(text.styleRole, .body)
        XCTAssertEqual(text.truncation, .tail)
        XCTAssertNil(text.maxLines)
    }

    func testTextParameterCustomValues() {
        let text = TextParameter(
            content: "Hello World",
            styleRole: .title,
            truncation: .wrap,
            maxLines: 2
        )

        XCTAssertEqual(text.content, "Hello World")
        XCTAssertEqual(text.styleRole, .title)
        XCTAssertEqual(text.truncation, .wrap)
        XCTAssertEqual(text.maxLines, 2)
    }

    func testAllTextStyleRoles() {
        let roles = TextStyleRole.allCases
        XCTAssertEqual(roles.count, 5)
        XCTAssertTrue(roles.contains(.display))
        XCTAssertTrue(roles.contains(.title))
        XCTAssertTrue(roles.contains(.body))
        XCTAssertTrue(roles.contains(.label))
        XCTAssertTrue(roles.contains(.mono))
    }

    // MARK: - ImageParameter

    func testImageParameterDefaults() {
        let image = ImageParameter()

        XCTAssertEqual(image.source, "")
        XCTAssertEqual(image.fitMode, .fill)
    }

    func testImageParameterCustomValues() {
        let image = ImageParameter(source: "hero-photo.jpg", fitMode: .fit)

        XCTAssertEqual(image.source, "hero-photo.jpg")
        XCTAssertEqual(image.fitMode, .fit)
    }

    func testAllImageFitModes() {
        let modes = ImageFitMode.allCases
        XCTAssertEqual(modes.count, 4)
    }

    // MARK: - IconParameter

    func testIconParameterDefaults() {
        let icon = IconParameter()

        XCTAssertEqual(icon.name, "")
        XCTAssertEqual(icon.size, 24)
    }

    func testIconParameterCustomValues() {
        let icon = IconParameter(name: "star.fill", size: 32)

        XCTAssertEqual(icon.name, "star.fill")
        XCTAssertEqual(icon.size, 32)
    }

    // MARK: - ShadowParameter

    func testShadowParameterDefaults() {
        let shadow = ShadowParameter()

        XCTAssertEqual(shadow.radius, 4)
        XCTAssertEqual(shadow.offsetX, 0)
        XCTAssertEqual(shadow.offsetY, 2)
        XCTAssertFalse(shadow.isInner)
        XCTAssertEqual(shadow.color.alpha, 0.25)
    }

    func testInnerShadow() {
        let shadow = ShadowParameter(radius: 8, offsetX: 0, offsetY: 0, isInner: true)

        XCTAssertTrue(shadow.isInner)
        XCTAssertEqual(shadow.radius, 8)
    }

    // MARK: - BorderParameter

    func testBorderParameterDefaults() {
        let border = BorderParameter()

        XCTAssertEqual(border.width, 1)
        XCTAssertEqual(border.position, .inside)
        XCTAssertEqual(border.color, .black)
    }

    func testAllBorderPositions() {
        let positions = BorderPosition.allCases
        XCTAssertEqual(positions.count, 3)
        XCTAssertTrue(positions.contains(.inside))
        XCTAssertTrue(positions.contains(.center))
        XCTAssertTrue(positions.contains(.outside))
    }

    // MARK: - AnimationParameter

    func testAnimationParameterDefaults() {
        let anim = AnimationParameter.default

        XCTAssertEqual(anim.preset, .none)
        XCTAssertEqual(anim.durationSeconds, 0.3)
    }

    func testAllAnimationPresets() {
        let presets = AnimationPreset.allCases
        XCTAssertEqual(presets.count, 4)
        XCTAssertTrue(presets.contains(.none))
        XCTAssertTrue(presets.contains(.fade))
        XCTAssertTrue(presets.contains(.slide))
        XCTAssertTrue(presets.contains(.scale))
    }

    // MARK: - AccessibilityParameter

    func testAccessibilityParameterDefaults() {
        let a11y = AccessibilityParameter()

        XCTAssertEqual(a11y.label, "")
        XCTAssertEqual(a11y.hint, "")
        XCTAssertTrue(a11y.traits.isEmpty)
    }

    func testAccessibilityWithTraits() {
        let a11y = AccessibilityParameter(
            label: "Submit order",
            hint: "Double-tap to place your order",
            traits: [.button]
        )

        XCTAssertEqual(a11y.label, "Submit order")
        XCTAssertEqual(a11y.traits, [.button])
    }

    // MARK: - ElementalEdgeInsets & PaddingUnit

    func testEdgeInsetsDefaultUnit() {
        let insets = ElementalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        XCTAssertEqual(insets.unit, .pt)
    }

    func testEdgeInsetsRelativeUnit() {
        let insets = ElementalEdgeInsets(top: 0.1, leading: 0.1, bottom: 0.1, trailing: 0.1, unit: .relative)

        XCTAssertEqual(insets.unit, .relative)
    }

    // MARK: - ScalesWithContent

    func testShapeScalesWithContentDefaultTrue() {
        let shape = Component(name: "Box", subtype: .shape)
        XCTAssertTrue(shape.parameters.structure.scalesWithContent)
    }

    func testScreenScalesWithContentDefaultFalse() {
        let screen = Screen(name: "Home", platform: .iOS)
        XCTAssertFalse(screen.parameters.structure.scalesWithContent)
    }

    // MARK: - ColorParameter

    func testColorFillNone() {
        let info = Component(name: "Label", subtype: .information)
        XCTAssertEqual(info.parameters.content.color.fill, .none)
    }

    func testColorFillSolid() {
        let shape = Component(name: "Card", subtype: .shape)
        XCTAssertEqual(shape.parameters.content.color.fill, .solid(.systemBackground))
    }

    func testColorFillGradient() {
        let gradient = GradientDefinition(
            stops: [
                .init(color: .white, position: 0),
                .init(color: .black, position: 1)
            ],
            angleDegrees: 90,
            type: .linear
        )
        let color = ColorParameter(fill: .gradient(gradient))

        if case .gradient(let g) = color.fill {
            XCTAssertEqual(g.stops.count, 2)
            XCTAssertEqual(g.type, .linear)
        } else {
            XCTFail("Expected gradient fill")
        }
    }

    // MARK: - InteractionParameter

    func testInteractionActions() {
        let actions = InteractionAction.allCases
        XCTAssertEqual(actions.count, 4)
        XCTAssertTrue(actions.contains(.tap))
        XCTAssertTrue(actions.contains(.press))
        XCTAssertTrue(actions.contains(.swipe))
        XCTAssertTrue(actions.contains(.drag))
    }

    func testWidgetInteractionHasNoTargetByDefault() {
        let widget = Component(name: "Button", subtype: .widget)
        XCTAssertEqual(widget.parameters.behavior.interaction?.action, .tap)
        XCTAssertNil(widget.parameters.behavior.interaction?.targetID)
    }

    // MARK: - Codable Round-Trip

    func testComponentCodableRoundTrip() throws {
        let original = Component(name: "Hero Card", subtype: .shape)

        let encoder = JSONEncoder()
        let data = try encoder.encode(original)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Component.self, from: data)

        XCTAssertEqual(original, decoded)
    }

    func testScreenCodableRoundTrip() throws {
        let button = Component(name: "CTA", subtype: .widget)
        let screen = Screen(
            name: "Home",
            platform: .iOS,
            children: [.component(button)]
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(screen)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Screen.self, from: data)

        XCTAssertEqual(screen, decoded)
    }

    func testParameterGroupWithAllContentTypes() throws {
        // Create a component and set every optional content parameter
        var component = Component(name: "Rich Card", subtype: .shape)
        component.parameters.content.text = TextParameter(content: "Hello", styleRole: .title)
        component.parameters.content.image = ImageParameter(source: "bg.png", fitMode: .fit)
        component.parameters.content.icon = IconParameter(name: "star.fill", size: 20)
        component.parameters.content.shadow = ShadowParameter(radius: 10, offsetX: 2, offsetY: 4, isInner: false)
        component.parameters.content.border = BorderParameter(color: .systemAccent, width: 2, position: .outside)

        // Round-trip through JSON
        let data = try JSONEncoder().encode(component)
        let decoded = try JSONDecoder().decode(Component.self, from: data)

        XCTAssertEqual(decoded.parameters.content.text?.content, "Hello")
        XCTAssertEqual(decoded.parameters.content.text?.styleRole, .title)
        XCTAssertEqual(decoded.parameters.content.image?.source, "bg.png")
        XCTAssertEqual(decoded.parameters.content.image?.fitMode, .fit)
        XCTAssertEqual(decoded.parameters.content.icon?.name, "star.fill")
        XCTAssertEqual(decoded.parameters.content.shadow?.radius, 10)
        XCTAssertFalse(decoded.parameters.content.shadow!.isInner)
        XCTAssertEqual(decoded.parameters.content.border?.width, 2)
        XCTAssertEqual(decoded.parameters.content.border?.position, .outside)
    }

    func testAnimationParameterCodableRoundTrip() throws {
        let anim = AnimationParameter(preset: .slide, durationSeconds: 0.5)

        let data = try JSONEncoder().encode(anim)
        let decoded = try JSONDecoder().decode(AnimationParameter.self, from: data)

        XCTAssertEqual(anim, decoded)
    }

    func testAccessibilityParameterCodableRoundTrip() throws {
        let a11y = AccessibilityParameter(
            label: "Play video",
            hint: "Plays the selected video",
            traits: [.button, .image]
        )

        let data = try JSONEncoder().encode(a11y)
        let decoded = try JSONDecoder().decode(AccessibilityParameter.self, from: data)

        XCTAssertEqual(a11y, decoded)
    }
}
