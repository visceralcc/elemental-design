import SwiftUI

// MARK: - ModeBarView
// Source of truth: Spec_ModeBar.md §2, Spec_DesignSystem.md §3.3

public struct ModeBarView: View {
    @Bindable var state: AppState

    public init(state: AppState) {
        self.state = state
    }

    // macOS: 44pt  |  iOS: 48pt — Spec_ModeBar.md §2
    private var barHeight: CGFloat {
        #if os(macOS)
        return ModeBarHeight.macOS
        #else
        return ModeBarHeight.iOS
        #endif
    }

    public var body: some View {
        HStack(spacing: 0) {
            // ── Left: five mode pills ──────────────────────────────────────
            HStack(spacing: Spacing.sm) {
                ForEach(AppMode.allCases) { mode in
                    ModePillButton(
                        mode: mode,
                        isActive: state.activeMode == mode
                    ) {
                        // Mode switch is instant — Spec_DesignSystem.md §12.1
                        state.activeMode = mode
                    }
                }
            }
            .padding(.leading, Spacing.lg)

            // ── Center: empty tab strip placeholder ───────────────────────
            // Tabs are populated when objects exist (Phase 2 spec §7).
            // Reserved space so the wordmark stays pinned to the right.
            Spacer()

            // ── Right: wordmark ───────────────────────────────────────────
            // "elemental design" — Spec_DesignSystem.md §3.3
            WordmarkView()
                .padding(.trailing, Spacing.lg)
        }
        .frame(height: barHeight)
        .background(Color.surfaceTopBar)
        // Keyboard shortcuts for panel collapse are wired here so they are
        // always active regardless of which view has focus.
        .background(panelShortcuts)
    }

    /// Panel collapse shortcuts — Spec_Panels.md §4
    @ViewBuilder
    private var panelShortcuts: some View {
        Group {
            // Cmd+1 — toggle Agent panel
            Button("") { state.toggleAgent() }
                .keyboardShortcut("1", modifiers: .command)
                .hidden()
            // Cmd+2 — toggle Elements panel
            Button("") { state.toggleElements() }
                .keyboardShortcut("2", modifiers: .command)
                .hidden()
            // Cmd+0 — reset all panels to default widths
            Button("") { state.resetPanels() }
                .keyboardShortcut("0", modifiers: .command)
                .hidden()
        }
    }
}

// MARK: - WordmarkView
// "elemental" (Barlow Condensed Light, text-accent) + "design" (Barlow Condensed Medium, white)
// Spec_DesignSystem.md §3.3

private struct WordmarkView: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("elemental")
                .font(.wordmarkPrimary)
                .foregroundColor(.textAccent)
            Text(" design")
                .font(.wordmarkSecondary)
                .foregroundColor(.textPrimary)
        }
    }
}
