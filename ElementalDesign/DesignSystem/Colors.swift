import SwiftUI

// MARK: - Elemental Design Color Tokens
// Source of truth: Spec_DesignSystem.md §2

public extension Color {

    // MARK: §2.1 Brand Colors

    /// Primary interactive color — element rows, action buttons, "elemental" wordmark
    static let brandCyan = Color(hex: "#00C3FF")
    /// Gradient endpoint for standard interactive elements
    static let brandCyanDeep = Color(hex: "#006B99")
    /// Active/selected state — component row when Parameter Picker is open
    static let brandBlue = Color(hex: "#0095FF")
    /// Gradient endpoint for active/selected elements
    static let brandBlueDeep = Color(hex: "#0449B8")
    /// Hover/focus state gradient start for parameter rows
    static let brandCyanHover = Color(hex: "#00DDFF")
    /// Hover/focus state gradient endpoint for parameter rows
    static let brandCyanHoverDeep = Color(hex: "#0187C1")
    /// Wordmark accent, highlights
    static let brandCyanBright = Color(hex: "#01BEF9")
    /// >>> indicator highlight when hovered/active, "Done" button text
    static let brandCyanHighlight = Color(hex: "#01D4F9")
    /// Mode bar active pill fill
    static let brandCyanPill = Color(hex: "#00B2F3")

    // MARK: §2.2 Surface Colors

    /// Top bar / mode bar background
    static let surfaceTopBar = Color(hex: "#4B4B4B")
    /// Agent panel background
    static let surfaceAgent = Color(hex: "#1F1F1F")
    /// Elements panel background
    static let surfaceElements = Color(hex: "#373737")
    /// Canvas gradient start (top)
    static let surfaceCanvasLight = Color(hex: "#2C2C2C")
    /// Canvas gradient end (bottom)
    static let surfaceCanvasDark = Color(hex: "#161616")
    /// Agent tab gradient start
    static let surfaceTabAgentStart = Color(hex: "#000000")
    /// Agent tab gradient end
    static let surfaceTabAgentEnd = Color(hex: "#1F1F1F")
    /// Elements tab gradient start
    static let surfaceTabElementsStart = Color(hex: "#282828")
    /// Elements tab gradient end
    static let surfaceTabElementsEnd = Color(hex: "#3B3B3B")
    /// Canvas/object tab gradient start
    static let surfaceTabCanvasStart = Color(hex: "#1C1C1C")
    /// Canvas/object tab gradient end
    static let surfaceTabCanvasEnd = Color(hex: "#2A2A2A")
    /// Parameter Picker background overlay — rgba(255,255,255,0.09)
    static let surfacePickerOverlay = Color.white.opacity(0.09)

    // MARK: §2.3 Gray Scale

    /// Gray button gradient start (Parameter Picker toggles)
    static let grayButtonLight = Color(hex: "#9A9A9A")
    /// Gray button gradient end
    static let grayButtonDark = Color(hex: "#515151")
    /// Mode bar inactive pill fill
    static let grayModeInactive = Color(hex: "#848484")
    /// Input bar border, dividers
    static let grayBorder = Color(hex: "#888888")
    /// Default component placeholder fill on canvas
    static let grayPlaceholder = Color(hex: "#D9D9D9")
    /// "Done" button background
    static let grayDoneBg = Color(hex: "#EAEAEA")

    // MARK: §2.4 Text Colors

    /// All primary text — labels, names, conversation
    static let textPrimary = Color(hex: "#FFFFFF")
    /// "elemental" in wordmark, accent labels
    static let textAccent = Color(hex: "#01BEF9")
    /// "Done" button text
    static let textDone = Color(hex: "#00B2F3")
    /// Inactive mode bar labels, placeholder text, secondary info
    static let textMuted = Color.white.opacity(0.5)
}

// MARK: - Hex Initializer

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Gradient Shorthands

public extension LinearGradient {
    /// Standard interactive element gradient — left to right, cyan → cyan-deep
    static let brandCyanGradient = LinearGradient(
        colors: [.brandCyan, .brandCyanDeep],
        startPoint: .leading,
        endPoint: .trailing
    )

    /// Hover state gradient — left to right, hover-cyan → hover-cyan-deep
    static let brandCyanHoverGradient = LinearGradient(
        colors: [.brandCyanHover, .brandCyanHoverDeep],
        startPoint: .leading,
        endPoint: .trailing
    )

    /// Active/selected element gradient — left to right, blue → blue-deep
    static let brandBlueGradient = LinearGradient(
        colors: [.brandBlue, .brandBlueDeep],
        startPoint: .leading,
        endPoint: .trailing
    )

    /// Parameter Picker toggle gradient — left to right, gray-light → gray-dark
    static let grayButtonGradient = LinearGradient(
        colors: [.grayButtonLight, .grayButtonDark],
        startPoint: .leading,
        endPoint: .trailing
    )

    /// Canvas background gradient — top to bottom, canvas-light → canvas-dark
    static let canvasGradient = LinearGradient(
        colors: [.surfaceCanvasLight, .surfaceCanvasDark],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Agent tab gradient — bottom to top (tab rises from panel below)
    static let agentTabGradient = LinearGradient(
        colors: [.surfaceTabAgentStart, .surfaceTabAgentEnd],
        startPoint: .bottom,
        endPoint: .top
    )

    /// Elements tab gradient — bottom to top
    static let elementsTabGradient = LinearGradient(
        colors: [.surfaceTabElementsStart, .surfaceTabElementsEnd],
        startPoint: .bottom,
        endPoint: .top
    )

    /// Canvas/object tab gradient — bottom to top
    static let canvasTabGradient = LinearGradient(
        colors: [.surfaceTabCanvasStart, .surfaceTabCanvasEnd],
        startPoint: .bottom,
        endPoint: .top
    )
}
