import SwiftUI

// MARK: - SettingsPanelContentView
// Shown in the center panel when Settings mode is active.
// Source of truth: Spec_ModeBar.md §5.3, Spec_Panels.md §9.3

struct SettingsPanelContentView: View {
    @State private var projectName: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xxl) {

                // ── Project settings ──────────────────────────────────────
                // Shown when no object is selected (always the case in the shell).
                // Spec_ModeBar.md §5.3

                settingsSection("Project") {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        fieldLabel("Name")
                        TextField("Untitled Project", text: $projectName)
                            .font(.uiLabel)
                            .foregroundColor(.textPrimary)
                            .padding(Spacing.md)
                            .background(Color.white.opacity(0.06))
                            .clipShape(RoundedRectangle(cornerRadius: Radius.button))
                    }

                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        fieldLabel("Default Platform")
                        // Segmented picker — iOS / macOS / Web (Spec_ModeBar.md §5.3)
                        PlatformPickerView()
                    }

                    // Export format — disabled in v1
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        fieldLabel("Export Format")
                        Text("Coming soon")
                            .font(.uiLight)
                            .foregroundColor(.textMuted)
                    }
                }
            }
            .padding(.horizontal, PanelMargins.Elements.leading)
            .padding(.top, PanelMargins.Elements.top)
            .padding(.bottom, Spacing.xxl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Helpers

    private func settingsSection<Content: View>(
        _ title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            Text(title)
                .font(.uiBold)
                .foregroundColor(.textPrimary)

            content()
        }
    }

    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .font(.uiLight)
            .foregroundColor(.textMuted)
    }
}

// MARK: - PlatformPickerView
// iOS / macOS / Web segmented control. Spec_ModeBar.md §5.3.

private struct PlatformPickerView: View {
    @State private var selected: Int = 0
    private let options = ["iOS", "macOS", "Web"]

    var body: some View {
        HStack(spacing: Spacing.xs) {
            ForEach(options.indices, id: \.self) { i in
                Button {
                    selected = i
                } label: {
                    Text(options[i])
                        .font(.uiLabel)
                        .foregroundColor(selected == i ? .textPrimary : .textMuted)
                        .padding(.vertical, Spacing.sm)
                        .frame(maxWidth: .infinity)
                        .background(
                            selected == i
                                ? LinearGradient.grayButtonGradient
                                : LinearGradient(colors: [.clear], startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: Radius.button))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(Spacing.xs)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: Radius.button))
    }
}
