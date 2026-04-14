import SwiftUI

// MARK: - ResizeHandleView
// 1pt visual separator, 24pt total hit target (12pt each side).
// Source of truth: Spec_Panels.md §3

struct ResizeHandleView: View {
    /// Fired once when a drag gesture begins (before the first onDragChanged).
    let onDragStarted: () -> Void
    /// Fired continuously during drag with `translation.width` from the drag-start point.
    let onDragChanged: (CGFloat) -> Void
    /// Fired when the drag gesture ends.
    let onDragEnded: () -> Void

    @State private var isHovering = false
    @State private var hasDragStarted = false

    var body: some View {
        ZStack {
            // Wide invisible hit target — 12pt each side of the 1pt visual line
            Color.clear
                .frame(width: ComponentSize.resizeHitTarget * 2)
                .contentShape(Rectangle())

            // 1pt visual divider, brightens on hover
            Color.grayBorder
                .opacity(isHovering ? 0.6 : 0.25)
                .frame(width: ComponentSize.resizeHandleWidth)
                .animation(.easeInOut(duration: 0.15), value: isHovering)
        }
        .onContinuousHover { phase in
            switch phase {
            case .active:
                isHovering = true
                #if os(macOS)
                NSCursor.resizeLeftRight.push()
                #endif
            case .ended:
                isHovering = false
                #if os(macOS)
                NSCursor.pop()
                #endif
            }
        }
        .gesture(
            DragGesture(minimumDistance: 1, coordinateSpace: .global)
                .onChanged { value in
                    if !hasDragStarted {
                        hasDragStarted = true
                        onDragStarted()
                    }
                    onDragChanged(value.translation.width)
                }
                .onEnded { _ in
                    hasDragStarted = false
                    onDragEnded()
                }
        )
    }
}
