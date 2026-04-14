import SwiftUI

// MARK: - CollapsedRailView
// A 36pt-wide rail shown when a panel is collapsed.
// Source of truth: Spec_Panels.md §4

struct CollapsedRailView: View {
    let panelName: String
    /// True for the Agent panel (chevron points right to re-expand).
    /// False for the Elements panel (chevron points left).
    let expandsRight: Bool
    let background: Color
    let onExpand: () -> Void

    var body: some View {
        Button(action: onExpand) {
            ZStack {
                background

                VStack(spacing: Spacing.sm) {
                    // Chevron indicating expand direction
                    Image(systemName: expandsRight ? "chevron.right" : "chevron.left")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textMuted)

                    // Panel name rotated 90° — reads bottom to top
                    Text(panelName)
                        .font(.uiLabel)
                        .foregroundColor(.textMuted)
                        .rotationEffect(.degrees(-90))
                        .fixedSize()
                }
            }
            .frame(width: PanelWidth.Agent.rail)
            .frame(maxHeight: .infinity)
        }
        .buttonStyle(.plain)
    }
}
