import SwiftUI

// MARK: - ElementsPanelView
// Center panel. Content and tab label swap based on the active mode.
// Source of truth: Spec_Panels.md §9, Spec_ModeBar.md §5

public struct ElementsPanelView: View {
    let state: AppState

    public init(state: AppState) {
        self.state = state
    }

    public var body: some View {
        VStack(spacing: 0) {
            // ── Tab header — label changes with mode (§9.3, §9.4) ──────────
            PanelTabView(
                style: .elements,
                labelOverride: tabLabel,
                trailingAccessory: AnyView(addButton)
            )

            // ── Content — swaps instantly on mode change (§12.1) ──────────
            centerContent
        }
        .background(Color.surfaceElements)
        .frame(maxHeight: .infinity)
    }

    // MARK: - Mode-driven content

    /// The center content area — Elements, Settings, or Code view.
    /// Spec_Panels.md §9.2–9.4
    @ViewBuilder
    private var centerContent: some View {
        switch state.activeMode {
        case .agent, .elements:
            // Standard Elements hierarchy / empty state
            ElementsEmptyStateView()

        case .settings:
            // Project and object settings — Spec_ModeBar.md §5.3
            SettingsPanelContentView()

        case .code:
            // Read-only code view — Spec_ModeBar.md §5.4
            CodePanelContentView()

        case .preview:
            // This panel is fully hidden in Preview mode (PanelLayoutView handles it).
            // Fallback in case it ever renders directly.
            Color.surfaceElements.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    /// Tab label — "Elements" in normal modes, "Settings" or "Code" when swapped.
    /// Spec_Panels.md §9.3, §9.4
    private var tabLabel: String? {
        switch state.activeMode {
        case .settings: return "Settings"
        case .code:     return "Code"
        default:        return nil  // use PanelTabView default ("Elements")
        }
    }

    // + button — shown in Elements/Agent mode only (not in Settings/Code)
    private var addButton: some View {
        Button {
            // No-op until object creation is implemented
        } label: {
            Image(systemName: "plus.circle")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(showAddButton ? .textMuted : .clear)
        }
        .buttonStyle(.plain)
        .disabled(!showAddButton)
    }

    private var showAddButton: Bool {
        state.activeMode == .agent || state.activeMode == .elements
    }
}
