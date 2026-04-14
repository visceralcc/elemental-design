import SwiftUI

// MARK: - ElementsEmptyStateView
// Shown in the Elements panel when no objects exist in the current view.
// Source of truth: Spec_Panels.md §6.6

struct ElementsEmptyStateView: View {
    var body: some View {
        VStack(spacing: Spacing.sm) {
            Text("Nothing here yet.")
                .font(.uiBold)
                .foregroundColor(.textMuted)

            Text("Tap + to add a Screen or Component,\nor describe what you're building\nto the Agent.")
                .font(.uiLight)
                .foregroundColor(.textMuted)
                .multilineTextAlignment(.center)
        }
        .padding(Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
