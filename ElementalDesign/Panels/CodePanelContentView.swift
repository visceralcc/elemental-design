import SwiftUI

// MARK: - CodePanelContentView
// Shown in the center panel when Code mode is active.
// Displays "Select an object to see its code" when nothing is selected.
// Source of truth: Spec_ModeBar.md §5.4, Spec_Panels.md §9.4

struct CodePanelContentView: View {
    var body: some View {
        // Code view is read-only in v1 — no selection means no code to show.
        // Spec_ModeBar.md §5.4: "If no object is selected: shows a message —
        // 'Select an object to see its code'"
        VStack(spacing: Spacing.sm) {
            Image(systemName: "curlybraces")
                .font(.system(size: 32, weight: .light))
                .foregroundColor(.textMuted)

            Text("Select an object to see its code.")
                .font(.uiLight)
                .foregroundColor(.textMuted)
                .multilineTextAlignment(.center)
        }
        .padding(Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
