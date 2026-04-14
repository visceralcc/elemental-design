import SwiftUI

// MARK: - ActionButtonView
// Cyan gradient full-width action button used in the Agent panel empty state.
// Source of truth: Spec_DesignSystem.md §6.5

struct ActionButtonView: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.uiLabel)             // Barlow Medium 16pt
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Spacing.md)        // 10pt all sides
                .background(LinearGradient.brandCyanGradient)
                .clipShape(RoundedRectangle(cornerRadius: Radius.button))  // 4pt
        }
        .buttonStyle(.plain)
        // Width driven by the panel layout (fills available width minus margins)
    }
}
