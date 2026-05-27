import SwiftUI

#if os(iOS)
import UIKit

/// Fullscreen image viewer with:
/// - two-finger pinch zoom + pan (SwiftUI gestures)
/// - stabilization transforms (counter-rotation + translation offset)
struct ImageStabilizedViewer: View {
    let image: UIImage
    let rotationEnabled: Bool
    let translationEnabled: Bool

    let counterRotationDegrees: Double
    let translationOffset: SIMD2<Float>


    let initialZoom: CGFloat
    let onZoomChanged: (CGFloat) -> Void

    @State private var baseScale: CGFloat = 1
    @State private var gestureScale: CGFloat = 1
    @State private var baseOffset: CGSize = .zero
    @State private var gestureOffset: CGSize = .zero

    var body: some View {
        GeometryReader { geo in
            let available = geo.size
            let screenDiagonal = sqrt(pow(available.width, 2) + pow(available.height, 2))
            let imageDiagonal = sqrt(pow(image.size.width, 2) + pow(image.size.height, 2))
            let scale = screenDiagonal / imageDiagonal

            Image(uiImage: image)
                .resizable()
                .frame(
                    width: image.size.width * scale,
                    height: image.size.height * scale
                )
                .scaleEffect(clampedScale)
                .offset(
                    x: baseOffset.width + gestureOffset.width + (translationEnabled ? CGFloat(translationOffset.x) : 0),
                    y: baseOffset.height + gestureOffset.height + (translationEnabled ? CGFloat(translationOffset.y) : 0)
                )
                .rotationEffect(.degrees(rotationEnabled ? counterRotationDegrees : 0))
                .contentShape(Rectangle())
                .gesture(zoomGesture)
                .simultaneousGesture(panGesture)
                .ignoresSafeArea(edges: .all)
                // Removed debug border
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

    private var panGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                gestureOffset = value.translation
            }
            .onEnded { _ in
                baseOffset = CGSize(
                    width: baseOffset.width + gestureOffset.width,
                    height: baseOffset.height + gestureOffset.height
                )
                gestureOffset = .zero
            }
    }
}

private extension View {
    func translationEffect(_ size: CGSize) -> some View {
        offset(x: size.width, y: size.height)
    }
}

#else
// Non-iOS stub (prevents UIImage compile errors when targeting macOS by mistake).
struct ImageStabilizedViewer: View {
    var body: some View { Color.clear }
}
#endif
