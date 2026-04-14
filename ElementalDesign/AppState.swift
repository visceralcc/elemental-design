import SwiftUI

// MARK: - AppMode
// Source of truth: Spec_ModeBar.md §3

public enum AppMode: Int, CaseIterable, Identifiable {
    case agent    = 1
    case elements = 2
    case settings = 3
    case code     = 4
    case preview  = 5

    public var id: Int { rawValue }

    public var label: String {
        switch self {
        case .agent:    return "Agent"
        case .elements: return "Elements"
        case .settings: return "Settings"
        case .code:     return "Code"
        case .preview:  return "Preview"
        }
    }

    // SF Symbols chosen as stand-ins for the bespoke icon set described in
    // Spec_DesignSystem.md §9 — filled variant for active, outlined for inactive.
    public var symbolName: String {
        switch self {
        case .agent:    return "sparkle"
        case .elements: return "line.3.horizontal"
        case .settings: return "gearshape"
        case .code:     return "chevron.left.forwardslash.chevron.right"
        case .preview:  return "eye"
        }
    }

    public var activeSymbolName: String {
        switch self {
        case .agent:    return "sparkle"
        case .elements: return "line.3.horizontal"
        case .settings: return "gearshape.fill"
        case .code:     return "chevron.left.forwardslash.chevron.right"
        case .preview:  return "eye.fill"
        }
    }

    // Cmd+Shift+1…5 — Spec_ModeBar.md §3
    public var keyEquivalent: KeyEquivalent {
        KeyEquivalent(Character(String(rawValue)))
    }
}

// MARK: - AppState

/// Shared observable state for the Elemental Design session.
/// Injected at the root and read by all panels and the mode bar.
@Observable
public final class AppState {
    /// Currently active mode. Starts in Agent mode (§5.1).
    public var activeMode: AppMode = .agent

    /// Width of Agent panel in points (may be 36 when collapsed).
    public var agentWidth: CGFloat = PanelWidth.Agent.default
    /// Width of Elements panel in points (may be 36 when collapsed).
    public var elementsWidth: CGFloat = PanelWidth.Elements.default

    /// Whether the Agent panel is collapsed to its rail.
    public var agentCollapsed: Bool = false
    /// Whether the Elements panel is collapsed to its rail.
    public var elementsCollapsed: Bool = false

    public init() {}

    // MARK: Panel Helpers

    public func toggleAgent() {
        withAnimation(.easeInOut(duration: AnimationDuration.panelCollapse)) {
            agentCollapsed.toggle()
        }
    }

    public func toggleElements() {
        withAnimation(.easeInOut(duration: AnimationDuration.panelCollapse)) {
            elementsCollapsed.toggle()
        }
    }

    public func resetPanels() {
        withAnimation(.easeInOut(duration: AnimationDuration.panelCollapse)) {
            agentCollapsed    = false
            elementsCollapsed = false
            agentWidth        = PanelWidth.Agent.default
            elementsWidth     = PanelWidth.Elements.default
        }
    }
}
