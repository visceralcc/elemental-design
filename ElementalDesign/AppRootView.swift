import SwiftUI

/// Root view of Elemental Design.
/// Mode bar pinned at the top; three-panel layout fills the remaining space.
public struct AppRootView: View {
    @State private var state = AppState()

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            // Mode bar — always visible (hidden only in Preview mode, Phase 5)
            ModeBarView(state: state)

            // Three-panel layout — Agent | Elements | Canvas
            PanelLayoutView(state: state)
        }
        .frame(minWidth: 1100, minHeight: 600)
        .preferredColorScheme(.dark)
    }
}
