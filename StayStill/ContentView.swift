import SwiftUI

#if os(iOS)
import PhotosUI

struct ContentView: View {
    @StateObject private var photoSource = PhotoSource()
    @StateObject private var motion = MotionStabilizer()

    @State private var showOverlay = false
    @State private var selection: [PhotosPickerItem] = []

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let uiImage = photoSource.currentImage() {
                ImageStabilizedViewer(
                    image: uiImage,
                    rotationEnabled: motion.rotationEnabled,
                    counterRotationDegrees: motion.counterRotationDegrees,
                    initialZoom: photoSource.lastZoom,
                    onZoomChanged: { z in photoSource.setLastZoom(z) }
                )
                .id(photoSource.imageVersion)
                .contentShape(Rectangle())
                .highPriorityGesture(TapGesture().onEnded { showOverlay = true })
            } else {
                VStack(spacing: 16) {
                    Text("StayStill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                    Text("Pick a photo to start.")
                        .foregroundStyle(.white.opacity(0.8))

                    PhotosPicker(
                        selection: $selection,
                        maxSelectionCount: nil,
                        matching: .images
                    ) {
                        Text("Pick Photos")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }

            // Overlay always accessible
            if showOverlay {
                ZStack {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                        .onTapGesture { showOverlay = false }
                    VStack(spacing: 24) {
                        Text("StayStill")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                        Text("StayStill is an experiment by Tomas Laurenzo (tomas@laurenzo.net)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        PhotosPicker(
                            selection: $selection,
                            maxSelectionCount: nil,
                            matching: .images
                        ) {
                            Label("Load New Image", systemImage: "photo")
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(24)
                    .padding(40)
                    .onTapGesture { }
                }
            }
        }
        .onAppear {
            motion.startIfNeeded()
        }
        .onChange(of: selection) { _, newValue in
            Task { await loadSelectedImages(from: newValue) }
        }
    }

    private func loadSelectedImages(from items: [PhotosPickerItem]) async {
        guard !items.isEmpty else { return }

        var loaded: [UIImage] = []
        loaded.reserveCapacity(items.count)

        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                loaded.append(uiImage)
            }
        }

        await MainActor.run {
            guard !loaded.isEmpty else { return }
            photoSource.setImages(loaded)
            motion.startIfNeeded()
            showOverlay = false
            selection = []
        }
    }
}

#else
// Non-iOS stub so the project can still compile even if Xcode targets macOS by mistake.
struct ContentView: View {
    var body: some View { Text("StayStill is an iOS app.") }
}
#endif
