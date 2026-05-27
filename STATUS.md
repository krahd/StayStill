# StayStill (iOS)


Last updated: 2026-05-27 16:40 GMT-0300

## Project purpose

Fullscreen image viewer that counter-rotates and optionally counter-translates the displayed image to appear stable in the real world.

## Current implementation state

- SwiftUI app scaffold + core views implemented in `StayStill/`.
- Motion stabilisation is implemented behind `#if os(iOS)` guards and is wired to UI toggles.
- Photos are selected using PhotosUI and cycled via double-tap.
- Overlay settings screen is always accessible by tapping the image; background tap closes it.
- Red debug rectangle is removed from the image viewer.
- iPad status bar (date/time/wifi/battery) is hidden for immersive fullscreen.
- Xcode project exists in `StayStill/StayStill.xcodeproj`.

## Active focus

- Ensure overlay and fullscreen behaviour are correct on iPad/iOS.
- Make builds verifiably compile and run for the configured iOS Simulator environment.

## Architecture overview

Data flow:

- `ContentView` hosts:
  - photo selection (`PhotoPickerView`/PhotosUI)
  - `ImageStabilizedViewer` for display
  - `SettingsView` for toggles
- `MotionStabilizer` publishes motion-derived offsets/angles.
- `PhotoSource` stores selected images and manages cycling.


### Architecture diagram (inline SVG)

<svg xmlns="http://www.w3.org/2000/svg" width="980" height="360" viewBox="0 0 980 360">
  <title>StayStill architecture</title>
  <desc>SwiftUI view hierarchy and data flow.</desc>
  <rect x="20" y="20" width="300" height="130" fill="#f3f3f3" stroke="#333"/>
  <text x="35" y="55" font-family="monospace" font-size="14">ContentView.swift</text>
  <text x="35" y="80" font-family="monospace" font-size="12">• fullscreen layout</text>
  <text x="35" y="100" font-family="monospace" font-size="12">• tap gestures</text>
  <text x="35" y="120" font-family="monospace" font-size="12">• presents Settings/About</text>

  <rect x="350" y="20" width="300" height="130" fill="#f3f3f3" stroke="#333"/>
  <text x="365" y="55" font-family="monospace" font-size="14">PhotoSource.swift</text>
  <text x="365" y="80" font-family="monospace" font-size="12">• selected [UIImage]</text>
  <text x="365" y="100" font-family="monospace" font-size="12">• current index</text>
  <text x="365" y="120" font-family="monospace" font-size="12">• next() cycling</text>

  <rect x="680" y="20" width="280" height="130" fill="#f3f3f3" stroke="#333"/>
  <text x="695" y="55" font-family="monospace" font-size="14">MotionStabilizer.swift</text>
  <text x="695" y="80" font-family="monospace" font-size="12">• CMMotionManager</text>
  <text x="695" y="100" font-family="monospace" font-size="12">• publishes offsets</text>
  <text x="695" y="120" font-family="monospace" font-size="12">• rotation/translation</text>

  <rect x="20" y="180" width="420" height="160" fill="#f3f3f3" stroke="#333"/>
  <text x="35" y="215" font-family="monospace" font-size="14">ImageStabilizedViewer.swift</text>
  <text x="35" y="240" font-family="monospace" font-size="12">• zoom/pan for 2-finger gestures</text>
  <text x="35" y="260" font-family="monospace" font-size="12">• applies counter-transform(s)</text>
  <text x="35" y="280" font-family="monospace" font-size="12">• iOS-only implementation</text>

  <rect x="470" y="180" width="470" height="160" fill="#f3f3f3" stroke="#333"/>
  <text x="485" y="215" font-family="monospace" font-size="14">Settings/About Overlay</text>
  <text x="485" y="240" font-family="monospace" font-size="12">• toggles: rotation + translation</text>
  <text x="485" y="260" font-family="monospace" font-size="12">• about text required</text>
  <text x="485" y="280" font-family="monospace" font-size="12">• hooks into MotionStabilizer</text>

  <line x1="320" y1="85" x2="350" y2="85" stroke="#333"/>
  <line x1="500" y1="150" x2="540" y2="180" stroke="#333"/>
  <line x1="680" y1="85" x2="680" y2="260" stroke="#333"/>
</svg>

<p><em>Diagram: SwiftUI view hierarchy and data flow. Boxes are files, arrows are data/prop flow. If you use a screen reader, skip the SVG and refer to the text sections below for architecture details.</em></p>

## Known issues, risks, and limitations

- iOS simulator runtime availability affects `xcodebuild` verification in this environment.
- Motion compensation axis mapping and translation mapping may require tuning for the intended “stable in the real world” effect.
- Translation compensation is not visually effective with IMU-only (accelerometer/gyroscope) data; robust translation requires visual tracking or ARKit (not implemented).

## Verification

- Build succeeded for iPad Pro 11-inch (M5) simulator (arm64, iOS 26.5).
- Overlay settings, fullscreen, and debug UI fixes verified by build.

Last updated: 2026-05-27 16:40 GMT-0300
