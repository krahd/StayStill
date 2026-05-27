import SwiftUI

#if os(iOS)
import UIKit

/// Fullscreen image viewer with:
/// - two-finger pinch zoom (SwiftUI)
/// - stabilization transform (counter-rotation)
struct ImageStabilizedViewer: View {
    let image: UIImage
    let rotationEnabled: Bool

    let counterRotationDegrees: Double

    let initialZoom: CGFloat
    let onZoomChanged: (CGFloat) -> Void

    @State private var baseScale: CGFloat = 1
    @State private var gestureScale: CGFloat = 1

    var body: some View {
        GeometryReader { geo in
            let available = geo.size
            let widthScale = available.width / image.size.width
            let heightScale = available.height / image.size.height
            let scale = max(widthScale, heightScale)

            Image(uiImage: image)
                .resizable()
                .frame(
                    width: image.size.width * scale,
                    height: image.size.height * scale
                )
                .scaleEffect(clampedScale)
                .rotationEffect(.degrees(rotationEnabled ? counterRotationDegrees : 0))
                .contentShape(Rectangle())
                .gesture(zoomGesture)
                .ignoresSafeArea(edges: .all)
        }
        .onAppear {
            if baseScale == 1 {
                baseScale = initialZoom > 0 ? initialZoom : 1
            }
        }
    }

    private var clampedScale: CGFloat {
        let s = baseScale * gestureScale
        return min(max(s, 1), 6)
    }

    private var zoomGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                gestureScale = value
            }
            .onEnded { _ in
                baseScale = clampedScale
                gestureScale = 1
                onZoomChanged(baseScale)
            }
    }
}

#else
// Non-iOS stub (prevents UIImage compile errors when targeting macOS by mistake).
struct ImageStabilizedViewer: View {
    var body: some View { Color.clear }
}
#endif
