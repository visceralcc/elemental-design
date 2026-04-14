import SwiftUI

// MARK: - AgentPanelView
// Left panel. Background #1F1F1F. Conversation UI with input bar pinned to bottom.
// Input bar is focused when Agent mode becomes active — Spec_ModeBar.md §5.1.
// Source of truth: Spec_Panels.md §5, Spec_Agent.md §2

public struct AgentPanelView: View {
    let state: AppState

    @State private var inputText: String = ""
    @FocusState private var inputFocused: Bool

    public init(state: AppState) {
        self.state = state
    }

    public var body: some View {
        VStack(spacing: 0) {
            // ── Tab header (Phase 3) ───────────────────────────────────────
            PanelTabView(style: .agent)

            // ── Conversation area (scrollable) ────────────────────────────
            ScrollView {
                AgentEmptyStateView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // ── Input bar — pinned to bottom ──────────────────────────────
            AgentInputBarView(text: $inputText, isFocused: $inputFocused)
        }
        .background(Color.surfaceAgent)
        .frame(maxHeight: .infinity)
        // Focus the input bar whenever Agent mode is (re-)entered.
        // Spec_ModeBar.md §5.1: "The Agent panel's input bar receives keyboard
        // focus when entering this mode."
        .onChange(of: state.activeMode) { _, newMode in
            if newMode == .agent {
                inputFocused = true
            }
        }
        .onAppear {
            // Focus on initial launch — Agent is the default mode (§5.1)
            if state.activeMode == .agent {
                inputFocused = true
            }
        }
    }
}
