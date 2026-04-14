import SwiftUI

// MARK: - AgentInputBarView
// Persistent text input at the bottom of the Agent panel.
// Source of truth: Spec_DesignSystem.md §7, Spec_Panels.md §5.3

struct AgentInputBarView: View {
    @Binding var text: String
    /// Drives keyboard focus — set to true when Agent mode becomes active.
    var isFocused: FocusState<Bool>.Binding

    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            // ── Placeholder + text field ──────────────────────────────────
            ZStack(alignment: .leading) {
                // Custom placeholder shown when the field is empty
                if text.isEmpty {
                    Text("let's talk...")
                        .font(.inputPlaceholder)    // Volkhov Regular 16pt
                        .foregroundColor(.textMuted)
                        .padding(.leading, 13)
                        .padding(.trailing, 40)
                        .padding(.vertical, 12)
                        .allowsHitTesting(false)
                }

                TextField("", text: $text, axis: .vertical)
                    .font(.userMessage)             // Volkhov Regular 16pt
                    .foregroundColor(.textPrimary)
                    .lineLimit(1...8)               // grows up to ~208pt (≈8 lines)
                    .focused(isFocused)
                    .padding(.leading, 13)
                    .padding(.trailing, 40)         // leave room for mic button
                    .padding(.top, 2)
                    .padding(.bottom, 3)
            }

            // ── Mic button — 26×26pt circle, 1pt white border ─────────────
            // Spec_DesignSystem.md §7, positioned bottom-right inside the bar.
            micButton
                .padding(.trailing, 6)
                .padding(.bottom, 6)
        }
        .frame(minHeight: ComponentSize.inputBarHeight)
        .overlay(
            Capsule()
                .strokeBorder(Color.grayBorder, lineWidth: 1)
        )
        .padding(.horizontal, PanelMargins.Agent.leading)
        .padding(.bottom, Spacing.md)
    }

    private var micButton: some View {
        Button {
            // Voice input — not yet implemented
        } label: {
            ZStack {
                Circle()
                    .strokeBorder(Color.white, lineWidth: 1)
                    .frame(
                        width: ComponentSize.micButtonSize,
                        height: ComponentSize.micButtonSize
                    )
                Image(systemName: "mic")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.textPrimary)
            }
        }
        .buttonStyle(.plain)
    }
}
