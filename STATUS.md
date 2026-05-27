# StayStill (iOS)

Last updated: 2026-05-27 18:14 GMT-3

## Project purpose

Fullscreen iOS image viewer that counter-rotates the displayed image to appear stable in the real world.

## Current state

- SwiftUI app scaffold and core views live in `StayStill/`.
- The app uses PhotosUI to load images into `PhotoSource`.
- The viewer supports pinch zoom and counter-rotation only.
- Overlay controls provide rotation toggling, image loading, and close actions.
- Rotation compensation is driven by `MotionStabilizer` via device yaw.
- `README.md` contains the user-facing usage summary and the "as is" disclaimer.
- `LICENSE.md` contains the MIT licence text.
- The Xcode project is `StayStill/StayStill.xcodeproj`.

## Key files

- `StayStill/ContentView.swift`: app shell, overlay, and image picker flow.
- `StayStill/MotionStabilizer.swift`: yaw-based rotation compensation.
- `StayStill/ImageStabilizedViewer.swift`: image display, zoom, and counter-rotation.
- `StayStill/SettingsView.swift`: rotation setting screen.
- `README.md`: usage and disclaimer.
- `LICENSE.md`: licence text.

## Current notes

- The app is configured for iOS simulator and device runs.
- Yaw compensation may still need hardware tuning if the rotation feel changes.
- The simulator does not provide live device motion.

### Current architecture

<svg xmlns="http://www.w3.org/2000/svg" width="980" height="320" viewBox="0 0 980 320">
  <title>StayStill current architecture</title>
  <desc>Current file-level structure of the app.</desc>
  <rect x="20" y="20" width="300" height="120" fill="#f3f3f3" stroke="#333"/>
  <text x="35" y="55" font-family="monospace" font-size="14">ContentView.swift</text>
  <text x="35" y="80" font-family="monospace" font-size="12">• picker</text>
  <text x="35" y="100" font-family="monospace" font-size="12">• overlay controls</text>
  <text x="35" y="120" font-family="monospace" font-size="12">• image selection flow</text>

  <rect x="350" y="20" width="290" height="120" fill="#f3f3f3" stroke="#333"/>
  <text x="365" y="55" font-family="monospace" font-size="14">MotionStabilizer.swift</text>
  <text x="365" y="80" font-family="monospace" font-size="12">• CoreMotion yaw</text>
  <text x="365" y="100" font-family="monospace" font-size="12">• rotation only</text>
  <text x="365" y="120" font-family="monospace" font-size="12">• publishes degrees</text>

  <rect x="670" y="20" width="290" height="120" fill="#f3f3f3" stroke="#333"/>
  <text x="685" y="55" font-family="monospace" font-size="14">ImageStabilizedViewer.swift</text>
  <text x="685" y="80" font-family="monospace" font-size="12">• pinch zoom</text>
  <text x="685" y="100" font-family="monospace" font-size="12">• counter-rotation</text>
  <text x="685" y="120" font-family="monospace" font-size="12">• fullscreen display</text>

  <rect x="20" y="170" width="300" height="120" fill="#f3f3f3" stroke="#333"/>
  <text x="35" y="205" font-family="monospace" font-size="14">SettingsView.swift</text>
  <text x="35" y="230" font-family="monospace" font-size="12">• rotation toggle</text>
  <text x="35" y="250" font-family="monospace" font-size="12">• settings form</text>

  <rect x="350" y="170" width="610" height="120" fill="#f3f3f3" stroke="#333"/>
  <text x="365" y="205" font-family="monospace" font-size="14">README.md + LICENSE.md + STATUS.md</text>
  <text x="365" y="230" font-family="monospace" font-size="12">• usage and disclaimer</text>
  <text x="365" y="250" font-family="monospace" font-size="12">• MIT licence</text>

  <line x1="320" y1="80" x2="350" y2="80" stroke="#333"/>
  <line x1="540" y1="140" x2="540" y2="170" stroke="#333"/>
  <line x1="525" y1="140" x2="170" y2="170" stroke="#333"/>
  <line x1="805" y1="140" x2="670" y2="170" stroke="#333"/>
</svg>

<p><em>Diagram: current file-level architecture. Boxes are tracked files, arrows show the main UI and data flow.</em></p>

## Known limitations

- The simulator does not exercise live device motion.
- Yaw compensation may need hardware tuning.

Last updated: 2026-05-27 18:14 GMT-3
