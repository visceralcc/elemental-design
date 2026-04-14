import SwiftUI

// MARK: - AgentEmptyStateView
// Shown in the Agent panel conversation area before any conversation has occurred.
// Source of truth: Spec_Panels.md §5.4, Spec_DesignSystem.md §6.5
//
// Layout:
//   ✦ (spark mark)
//   "What do you want to build today?" — Volkhov 32pt
//   Four cyan action buttons stacked vertically

struct AgentEmptyStateView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xl) {

            // ── Agent prompt ──────────────────────────────────────────────
            VStack(alignment: .leading, spacing: Spacing.sm) {
                // ✦ spark marker — identifies Agent-authored content (Spec_Agent.md §6)
                Image(systemName: "sparkle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.brandCyanBright)

                Text("What do you want\nto build today?")
                    .font(.agentPrompt)             // Volkhov Regular 32pt
                    .foregroundColor(.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // ── Action buttons ─────────────────────────────────────────────
            // Four quick-start options — Spec_Panels.md §5.4 (implied), Handoff Phase 4
            VStack(spacing: Spacing.sm) {
                ActionButtonView(label: "a Website")  { }
                ActionButtonView(label: "an App")     { }
                ActionButtonView(label: "a Component"){ }
                ActionButtonView(label: "Open...")    { }
            }
        }
        .padding(.leading, PanelMargins.Agent.leading)
        .padding(.trailing, PanelMargins.Agent.trailing)
        .padding(.top, PanelMargins.Agent.top)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
