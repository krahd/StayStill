import SwiftUI

#if os(iOS)
import UIKit

@MainActor
final class PhotoSource: ObservableObject {
    @Published private(set) var images: [UIImage] = []
    @Published private(set) var selectedIndex: Int = 0
    @Published private(set) var imageVersion: Int = 0

    var hasImages: Bool { !images.isEmpty }

    @Published var lastZoom: CGFloat = 1

    init() {
        loadLastImage()
    }

    func setImages(_ newImages: [UIImage]) {
        images = newImages
        selectedIndex = 0
        imageVersion += 1
        setLastZoom(1)
        if let first = newImages.first {
            saveLastImage(first)
        }
    }

    func setLastZoom(_ zoom: CGFloat) {
        lastZoom = zoom
    }

    func next() {
        guard !images.isEmpty else { return }
        selectedIndex = (selectedIndex + 1) % images.count
    }

    func currentImage() -> UIImage? {
        guard images.indices.contains(selectedIndex) else { return nil }
        return images[selectedIndex]
    }

    // MARK: - Persistence
    private func saveLastImage(_ image: UIImage) {
        guard let data = image.pngData() else { return }
        let url = Self.lastImageURL()
        do {
            try data.write(to: url)
        } catch {
            print("Failed to save last image: \(error)")
        }
    }

    private func loadLastImage() {
        let url = Self.lastImageURL()
        guard FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else { return }
        images = [image]
        selectedIndex = 0
        lastZoom = 1
    }

    private static func lastImageURL() -> URL {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("staystill_last.png")
    }
}
#else
// Non-iOS stub so the project can still compile even if Xcode is mis-targeting platform.
@MainActor
final class PhotoSource: ObservableObject {
    @Published private(set) var images: [Any] = []
    @Published private(set) var selectedIndex: Int = 0
    var hasImages: Bool { false }
    func setImages(_ newImages: [Any]) {}
    func next() {}
    func currentImage() -> Any? { nil }
}
#endif
