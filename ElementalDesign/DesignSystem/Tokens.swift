import CoreFoundation

// MARK: - Spacing Tokens
// Source of truth: Spec_DesignSystem.md §4

public enum Spacing {
    /// 4pt — Tight internal gaps (icon ↔ label in a button)
    public static let xs: CGFloat  = 4
    /// 8pt — Compact padding, vertical gaps between tightly packed elements
    public static let sm: CGFloat  = 8
    /// 10pt — Standard button padding, element row internal padding
    public static let md: CGFloat  = 10
    /// 16pt — Panel content margins, nesting indentation per level
    public static let lg: CGFloat  = 16
    /// 20pt — Agent prompt text margins
    public static let xl: CGFloat  = 20
    /// 24pt — Vertical gap between major sections
    public static let xxl: CGFloat = 24
}

// MARK: Panel Margins (§4.3)

public enum PanelMargins {
    public enum Agent {
        public static let leading: CGFloat  = 15
        public static let trailing: CGFloat = 10
        public static let top: CGFloat      = 10
    }
    public enum Elements {
        public static let leading: CGFloat  = 10
        public static let trailing: CGFloat = 10
        public static let top: CGFloat      = 8
    }
}

// MARK: Element Row Spacing (§4.4)

public enum RowSpacing {
    /// Vertical gap between element rows
    public static let rowGap: CGFloat           = 10
    /// Parameter Picker vertical gap between toggle buttons
    public static let pickerGap: CGFloat        = 12
    /// Nesting indentation per level
    public static let nestIndent: CGFloat       = 16
}

// MARK: - Corner Radius Tokens
// Source of truth: Spec_DesignSystem.md §5

public enum Radius {
    /// 4pt — Element row buttons, parameter toggle buttons
    public static let button: CGFloat  = 4
    /// 6pt — Parameter Picker overlay background
    public static let overlay: CGFloat = 6
    /// 23pt — Panel tabs (top-left and/or top-right rounded)
    public static let tab: CGFloat     = 23
    /// 29pt — Mode bar pills (fully rounded capsule)
    public static let pill: CGFloat    = 29
    /// 31pt — Agent input bar (fully rounded capsule)
    public static let input: CGFloat   = 31
    /// 45pt — "Done" button (fully rounded capsule)
    public static let done: CGFloat    = 45
}

// MARK: - Panel Sizing Constants
// Source of truth: Spec_Panels.md §3

public enum PanelWidth {
    public enum Agent {
        public static let `default`: CGFloat = 280
        public static let minimum: CGFloat   = 240
        public static let maximum: CGFloat   = 400
        public static let rail: CGFloat      = 36
    }
    public enum Elements {
        public static let `default`: CGFloat = 300
        public static let minimum: CGFloat   = 260
        public static let maximum: CGFloat   = 480
        public static let rail: CGFloat      = 36
    }
    public enum Canvas {
        public static let minimum: CGFloat   = 600
    }
}

// MARK: - Mode Bar Height Constants
// Source of truth: Spec_ModeBar.md §2

public enum ModeBarHeight {
    public static let macOS: CGFloat = 93
    public static let iOS: CGFloat   = 48
}

// MARK: - Component Size Constants
// Source of truth: Spec_DesignSystem.md §6, §7, §8

public enum ComponentSize {
    /// Mode bar pill: 54×29pt
    public static let modePillWidth: CGFloat  = 54
    public static let modePillHeight: CGFloat = 29

    /// Panel tab height: 46pt
    public static let tabHeight: CGFloat      = 46

    /// Agent/Elements panel tab width
    public static let agentTabWidth: CGFloat    = 187
    public static let elementsTabWidth: CGFloat = 187
    /// Canvas tab width
    public static let canvasTabWidth: CGFloat   = 330

    /// Agent input bar collapsed height
    public static let inputBarHeight: CGFloat     = 42
    /// Agent input bar max expanded height
    public static let inputBarMaxHeight: CGFloat  = 208
    /// Mic button size
    public static let micButtonSize: CGFloat      = 26

    /// Resize handle visual width
    public static let resizeHandleWidth: CGFloat  = 1
    /// Resize handle invisible hit target (each side)
    public static let resizeHitTarget: CGFloat    = 12
}

// MARK: - Animation Constants
// Source of truth: Spec_DesignSystem.md §12

public enum AnimationDuration {
    public static let panelCollapse: Double  = 0.200
    public static let rowExpand: Double      = 0.200
    public static let rowCollapse: Double    = 0.150
    public static let pickerOpen: Double     = 0.150
    public static let pickerClose: Double    = 0.100
}
