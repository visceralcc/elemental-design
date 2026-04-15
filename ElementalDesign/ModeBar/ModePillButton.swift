import SwiftUI

// MARK: - ModePillButton
// Source of truth: Spec_DesignSystem.md §6.7, Spec_ModeBar.md §4

struct ModePillButton: View {
    let mode: AppMode
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 3) {
                // Pill — 54×29pt, fully rounded capsule (radius-pill = 29pt)
                ZStack {
                    Capsule()
                        .fill(isActive ? Color.brandCyanPill : Color.grayModeInactive)
                        .frame(width: ComponentSize.modePillWidth, height: ComponentSize.modePillHeight)

                    Image(systemName: isActive ? mode.activeSymbolName : mode.symbolName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }

                // Label — Barlow Medium 16pt at full or 50% opacity
                Text(mode.label)
                    .font(.uiLabel)
                    .foregroundColor(isActive ? .textPrimary : .textMuted)
                    .lineLimit(1)
            }

        }
        .buttonStyle(.plain)
        // Cmd+Shift+[1…5] — Spec_ModeBar.md §3
        .keyboardShortcut(mode.keyEquivalent, modifiers: [.command, .shift])
    }
}
