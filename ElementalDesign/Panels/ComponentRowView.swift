import SwiftUI

// MARK: - ComponentRowView
// Element row button for a Component in the Elements panel.
// Source of truth: Spec_Panels.md §6.2, Spec_ProgressiveDisclosure.md §2
// Figma: node 10:577 (Component_Main_Button)

struct ComponentRowView: View {
    let typeName: String        // Subtype label e.g. "Component", "Shape", "Widget"
    let objectName: String      // The object's display name
    var isActive: Bool = false  // true = blue gradient (selected / parameter picker open)
    var isExpanded: Bool = false // true = >>> becomes ^^^
    let onExpand: () -> Void

    var body: some View {
        HStack(spacing: Spacing.xs) {
            // ── Left: type label + object name ──────────────────────────
            VStack(alignment: .leading, spacing: 0) {
                Text(typeName)
                    .font(.uiLight)         // Barlow Light 16pt
                    .foregroundColor(.textPrimary)
                Text(objectName)
                    .font(.uiBold)          // Barlow Bold 16pt
                    .foregroundColor(.textPrimary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // ── Right: >>> / ^^^ pill button ─────────────────────────────
            OptionsArrowsPill(isExpanded: isExpanded, action: onExpand)
        }
        .padding(Spacing.md)    // 10pt all sides
        .background(
            isActive
                ? LinearGradient.brandBlueGradient   // #0095FF → #0449B8
                : LinearGradient.brandCyanGradient    // #00C3FF → #006B99
        )
        .clipShape(RoundedRectangle(cornerRadius: Radius.button))   // 4pt
    }
}

// MARK: - OptionsArrowsPill
// The >>> pill button. Shows 3 right-pointing triangles (active: cyan fill).
// Figma: node 4:486 passive / 4:488 hover (ButtonOptionsArrows)

private struct OptionsArrowsPill: View {
    let isExpanded: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 0.8) {
                ForEach(0..<3, id: \.self) { _ in
                    if isExpanded {
                        UpTriangle()
                            .fill(Color.textPrimary)
                            .frame(width: 6.6, height: 7.4)
                    } else {
                        RightTriangle()
                            .fill(Color.textPrimary)
                            .frame(width: 6.6, height: 7.4)
                    }
                }
            }
            .frame(width: 38, height: 19)
            .background(Color.brandCyanHighlight)   // #01D4F9
            .clipShape(RoundedRectangle(cornerRadius: 7))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Triangle Shapes

private struct RightTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

private struct UpTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Spacing.sm) {
        ComponentRowView(
            typeName: "Component",
            objectName: "Hero Section",
            isActive: true,
            isExpanded: false,
            onExpand: {}
        )
        ComponentRowView(
            typeName: "Widget",
            objectName: "CTA Button",
            isActive: false,
            isExpanded: false,
            onExpand: {}
        )
        ComponentRowView(
            typeName: "Shape",
            objectName: "Card Container",
            isActive: false,
            isExpanded: true,
            onExpand: {}
        )
    }
    .padding(Spacing.lg)
    .background(Color.surfaceElements)
}
