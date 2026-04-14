import SwiftUI

// MARK: - CanvasEmptyStateView
// Shown on the canvas before any objects exist.
// Source of truth: Handoff Phase 4 — "Hello!" Volkhov Bold Italic 64pt centered.

struct CanvasEmptyStateView: View {
    var body: some View {
        Text("Hello!")
            .font(.canvasGreeting)          // Volkhov Bold Italic 64pt
            .foregroundColor(.textPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
