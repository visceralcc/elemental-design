import SwiftUI

// MARK: - PanelTab Configuration
// Source of truth: Spec_DesignSystem.md §8

enum PanelTabStyle {
    /// Agent panel tab — gradient black→#1F1F1F, top-right corner only rounded
    case agent
    /// Elements panel tab — gradient #282828→#3B3B3B, both top corners rounded
    case elements
    /// Canvas/object tab — gradient #1C1C1C→#2A2A2A, both top corners rounded
    case canvas
}

// MARK: - PanelTabView

struct PanelTabView: View {
    let style: PanelTabStyle
    /// Overrides the default label text. Used when Settings/Code mode changes
    /// the Elements panel header. Spec_Panels.md §9.3–9.4.
    let labelOverride: String?
    /// Optional right-side accessory (e.g., Add button). Pass nil for none.
    let trailingAccessory: AnyView?

    init(style: PanelTabStyle, labelOverride: String? = nil, trailingAccessory: AnyView? = nil) {
        self.style = style
        self.labelOverride = labelOverride
        self.trailingAccessory = trailingAccessory
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab background — gradient flows bottom→top (tab rises from panel below)
            gradientBackground
                .clipShape(tabShape)

            // Tab content row
            HStack(spacing: Spacing.xs) {
                leadingIcon
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.textPrimary)

                Text(label)
                    .font(.uiLabel)
                    .foregroundColor(.textPrimary)

                Spacer()

                if let accessory = trailingAccessory {
                    accessory
                }
            }
            .padding(.horizontal, Spacing.md)
        }
        .frame(height: ComponentSize.tabHeight)
    }

    // MARK: - Subviews

    private var gradientBackground: LinearGradient {
        switch style {
        case .agent:    return .agentTabGradient
        case .elements: return .elementsTabGradient
        case .canvas:   return .canvasTabGradient
        }
    }

    private var label: String {
        if let override = labelOverride { return override }
        switch style {
        case .agent:    return "Agent"
        case .elements: return "Elements"
        case .canvas:   return ""
        }
    }

    private var leadingIcon: Image {
        switch style {
        case .agent:
            // Spark icon — SF Symbol approximation: sparkle
            return Image(systemName: "sparkle")
        case .elements:
            // Gear icon
            return Image(systemName: "gearshape")
        case .canvas:
            // Eye icon
            return Image(systemName: "eye")
        }
    }

    /// Tab shape with selective corner rounding.
    /// Agent: top-right only. Elements + Canvas: both top corners.
    /// Source of truth: Spec_DesignSystem.md §8
    private var tabShape: UnevenRoundedRectangle {
        switch style {
        case .agent:
            return UnevenRoundedRectangle(
                topLeadingRadius: 0,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: Radius.tab
            )
        case .elements, .canvas:
            return UnevenRoundedRectangle(
                topLeadingRadius: Radius.tab,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: Radius.tab
            )
        }
    }
}
