import SwiftUI
import ElementalDesign

@main
struct ElementalDesignApp: App {
    init() {
        FontRegistrar.registerAll()
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 1280, height: 800)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
    }
}
