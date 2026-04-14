import SwiftUI
import CoreText

// MARK: - Font Registration
// Registers custom fonts from the package resource bundle at app startup.
// Call FontRegistrar.registerAll() once from the App entry point.

public enum FontRegistrar {
    private static let fontFileNames: [String] = [
        "Barlow-Light",
        "Barlow-Medium",
        "Barlow-SemiBold",
        "Barlow-Bold",
        "BarlowCondensed-Light",
        "BarlowCondensed-Medium",
        "Volkhov-Regular",
        "Volkhov-BoldItalic",
    ]

    public static func registerAll() {
        let bundle = Bundle.module
        for name in fontFileNames {
            guard let url = bundle.url(forResource: name, withExtension: "ttf") else {
                print("⚠️ Font not found in bundle: \(name).ttf")
                continue
            }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}

// MARK: - PostScript Font Name Constants

private enum FontName {
    static let barlowLight       = "Barlow-Light"
    static let barlowMedium      = "Barlow-Medium"
    static let barlowSemiBold    = "Barlow-SemiBold"
    static let barlowBold        = "Barlow-Bold"
    static let barlowCondLight   = "BarlowCondensed-Light"
    static let barlowCondMedium  = "BarlowCondensed-Medium"
    static let volkhov           = "Volkhov-Regular"
    static let volkhovBoldItalic = "Volkhov-BoldItalic"
}

// MARK: - Font Extensions
// Source of truth: Spec_DesignSystem.md §3

public extension Font {

    // MARK: §3.2 UI Chrome — Barlow

    /// Mode bar labels, panel headers, tab labels — Barlow Medium 16pt
    static let uiLabel = Font.custom(FontName.barlowMedium, size: 16)

    /// Object names in element rows, parameter names — Barlow Bold 16pt
    static let uiBold = Font.custom(FontName.barlowBold, size: 16)

    /// Object type labels, secondary descriptors — Barlow Light 16pt
    static let uiLight = Font.custom(FontName.barlowLight, size: 16)

    /// "Done" button text — Barlow SemiBold 16pt
    static let uiSemiBold = Font.custom(FontName.barlowSemiBold, size: 16)

    // MARK: §3.3 Wordmark — Barlow Condensed

    /// "elemental" wordmark — Barlow Condensed Light 20pt
    static let wordmarkPrimary = Font.custom(FontName.barlowCondLight, size: 20)

    /// "design" wordmark — Barlow Condensed Medium 20pt
    static let wordmarkSecondary = Font.custom(FontName.barlowCondMedium, size: 20)

    // MARK: §3.4 Conversation & Input — Volkhov

    /// Agent's primary question — Volkhov Regular 32pt
    static let agentPrompt = Font.custom(FontName.volkhov, size: 32)

    /// Agent responses, follow-up text — Volkhov Regular 16pt
    static let agentBody = Font.custom(FontName.volkhov, size: 16)

    /// User's typed text in conversation — Volkhov Regular 16pt
    static let userMessage = Font.custom(FontName.volkhov, size: 16)

    /// Input bar placeholder text — Volkhov Regular 16pt
    static let inputPlaceholder = Font.custom(FontName.volkhov, size: 16)

    // MARK: Canvas / One-off Sizes

    /// Canvas greeting — Volkhov Bold Italic 64pt
    static let canvasGreeting = Font.custom(FontName.volkhovBoldItalic, size: 64)
}
