import SwiftUI

// MARK: - CanvasPanelView
// Right panel. Dark gradient background. Always visible — never collapses.
// Source of truth: Spec_Canvas.md §2, Spec_DesignSystem.md §8

public struct CanvasPanelView: View {
    let state: AppState

    public init(state: AppState) {
        self.state = state
    }

    public var body: some View {
        VStack(spacing: 0) {
            // ── Tab header (Phase 3) ───────────────────────────────────────
            PanelTabView(
                style: .canvas,
                trailingAccessory: AnyView(addButton)
            )

            // ── Canvas surface — dark gradient, top to bottom ──────────────
            // Spec_Canvas.md §2, Spec_DesignSystem.md §2.2
            ZStack {
                LinearGradient.canvasGradient

                // Empty state greeting before any objects exist
                CanvasEmptyStateView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxHeight: .infinity)
    }

    private var addButton: some View {
        Button {
            // No-op until object creation is implemented
        } label: {
            Image(systemName: "plus.circle")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.textMuted)
        }
        .buttonStyle(.plain)
    }
}
