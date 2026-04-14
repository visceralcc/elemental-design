import SwiftUI

// MARK: - PanelLayoutView
// Three-panel horizontal layout: Agent | Elements | Canvas.
// Handles resize drag, collapse animation, and minimum-width clamping.
// Source of truth: Spec_Panels.md §2–4

public struct PanelLayoutView: View {
    @Bindable var state: AppState

    // Stable baseline captured at the moment each drag starts.
    @State private var agentWidthAtDragStart:    CGFloat = PanelWidth.Agent.default
    @State private var elementsWidthAtDragStart: CGFloat = PanelWidth.Elements.default

    public init(state: AppState) {
        self.state = state
    }

    public var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {

                if state.activeMode == .preview {
                    // ── Preview mode: only canvas visible, fills full width ─
                    // Agent + Elements are fully HIDDEN — no rail, no handle.
                    // Spec_ModeBar.md §5.5, Spec_Panels.md §9.5
                    CanvasPanelView(state: state)
                        .frame(maxWidth: .infinity)

                } else {
                    // ── Normal modes: full three-panel layout ──────────────

                    // Agent panel (or collapsed rail)
                    if state.agentCollapsed {
                        CollapsedRailView(
                            panelName: "Agent",
                            expandsRight: true,
                            background: .surfaceAgent,
                            onExpand: { state.toggleAgent() }
                        )
                    } else {
                        AgentPanelView(state: state)
                            .frame(width: state.agentWidth)
                    }

                    // Resize handle: Agent ↔ Elements
                    ResizeHandleView(
                        onDragStarted: {
                            agentWidthAtDragStart    = state.agentWidth
                            elementsWidthAtDragStart = state.elementsWidth
                        },
                        onDragChanged: { delta in
                            resizeAgent(delta: delta, totalWidth: geo.size.width)
                        },
                        onDragEnded: {}
                    )

                    // Elements panel (or collapsed rail)
                    if state.elementsCollapsed {
                        CollapsedRailView(
                            panelName: "Elements",
                            expandsRight: false,
                            background: .surfaceElements,
                            onExpand: { state.toggleElements() }
                        )
                    } else {
                        ElementsPanelView(state: state)
                            .frame(width: state.elementsWidth)
                    }

                    // Resize handle: Elements ↔ Canvas
                    ResizeHandleView(
                        onDragStarted: {
                            agentWidthAtDragStart    = state.agentWidth
                            elementsWidthAtDragStart = state.elementsWidth
                        },
                        onDragChanged: { delta in
                            resizeElements(delta: delta, totalWidth: geo.size.width)
                        },
                        onDragEnded: {}
                    )

                    // Canvas panel — always fills remaining space
                    CanvasPanelView(state: state)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // MARK: - Resize Logic

    /// Adjusts the Agent panel width. Clamps to Agent min/max and ensures
    /// Canvas stays at its minimum (600pt). Spec_Panels.md §3.
    private func resizeAgent(delta: CGFloat, totalWidth: CGFloat) {
        let handleAllowance = ComponentSize.resizeHitTarget * 4  // two handles
        let effectiveElem   = state.elementsCollapsed
            ? PanelWidth.Elements.rail
            : state.elementsWidth

        var newAgent = (agentWidthAtDragStart + delta).clamped(
            to: PanelWidth.Agent.minimum ... PanelWidth.Agent.maximum
        )

        // Enforce Canvas minimum
        let canvas = totalWidth - newAgent - effectiveElem - handleAllowance
        if canvas < PanelWidth.Canvas.minimum {
            newAgent = totalWidth - effectiveElem - PanelWidth.Canvas.minimum - handleAllowance
            newAgent = newAgent.clamped(to: PanelWidth.Agent.minimum ... PanelWidth.Agent.maximum)
        }

        state.agentWidth = newAgent
    }

    /// Adjusts the Elements panel width. Clamps to Elements min/max and ensures
    /// Canvas stays at its minimum (600pt). Spec_Panels.md §3.
    private func resizeElements(delta: CGFloat, totalWidth: CGFloat) {
        let handleAllowance = ComponentSize.resizeHitTarget * 4
        let effectiveAgent  = state.agentCollapsed
            ? PanelWidth.Agent.rail
            : state.agentWidth

        var newElem = (elementsWidthAtDragStart + delta).clamped(
            to: PanelWidth.Elements.minimum ... PanelWidth.Elements.maximum
        )

        // Enforce Canvas minimum
        let canvas = totalWidth - effectiveAgent - newElem - handleAllowance
        if canvas < PanelWidth.Canvas.minimum {
            newElem = totalWidth - effectiveAgent - PanelWidth.Canvas.minimum - handleAllowance
            newElem = newElem.clamped(to: PanelWidth.Elements.minimum ... PanelWidth.Elements.maximum)
        }

        state.elementsWidth = newElem
    }
}

// MARK: - Clamping Helper

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
