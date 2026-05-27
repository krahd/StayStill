# StayStill (iOS)

Last updated: 2026-05-27 19:18 GMT-3

## Project purpose

Fullscreen iOS image viewer that counter-rotates the displayed image to appear stable in the real world.

## Current state

- `PhotoSource` loads and caches the current image, tracks image versions, and resets zoom when a new image is loaded.
- `ContentView` opens the overlay on tap, hides the rotation toggle, and exposes only image loading controls.
- `ImageStabilizedViewer` starts each image at a cover fit that fills the screen while preserving aspect ratio, then supports pinch zoom and counter-rotation.
- `MotionStabilizer` publishes yaw-based counter-rotation only.
- `README.md` carries the usage summary and `as is` disclaimer.
- `LICENSE.md` carries the MIT licence text.
- The Xcode project is `StayStill/StayStill.xcodeproj`.

## Architecture overview

Data flow:

- `PhotoSource` feeds the current image into `ContentView`.
- `ContentView` passes image and motion state into `ImageStabilizedViewer`.
- `MotionStabilizer` publishes counter-rotation derived from device yaw.

### Current architecture (inline SVG)

<svg xmlns="http://www.w3.org/2000/svg" width="980" height="330" viewBox="0 0 980 330">
  <title>StayStill current architecture</title>
  <desc>Current file-level data flow for the app.</desc>
  <defs>
    <marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse">
      <path d="M 0 0 L 10 5 L 0 10 z" fill="#333"/>
    </marker>
  </defs>

  <rect x="20" y="20" width="280" height="120" fill="#f3f3f3" stroke="#333"/>
  <text x="35" y="55" font-family="monospace" font-size="14">PhotoSource.swift</text>
  <text x="35" y="82" font-family="monospace" font-size="12">• current image cache</text>
  <text x="35" y="102" font-family="monospace" font-size="12">• imageVersion</text>
  <text x="35" y="122" font-family="monospace" font-size="12">• resets zoom on load</text>

  <rect x="350" y="20" width="260" height="120" fill="#f3f3f3" stroke="#333"/>
  <text x="365" y="55" font-family="monospace" font-size="14">ContentView.swift</text>
  <text x="365" y="82" font-family="monospace" font-size="12">• tap to open overlay</text>
  <text x="365" y="102" font-family="monospace" font-size="12">• load new image</text>
  <text x="365" y="122" font-family="monospace" font-size="12">• rotation toggle hidden</text>

  <rect x="670" y="20" width="290" height="120" fill="#f3f3f3" stroke="#333"/>
  <text x="685" y="55" font-family="monospace" font-size="14">MotionStabilizer.swift</text>
  <text x="685" y="82" font-family="monospace" font-size="12">• CoreMotion yaw</text>
  <text x="685" y="102" font-family="monospace" font-size="12">• publishes degrees</text>
  <text x="685" y="122" font-family="monospace" font-size="12">• rotation only</text>

  <rect x="350" y="180" width="260" height="120" fill="#f3f3f3" stroke="#333"/>
  <text x="365" y="215" font-family="monospace" font-size="14">ImageStabilizedViewer.swift</text>
  <text x="365" y="242" font-family="monospace" font-size="12">• cover-fit frame</text>
  <text x="365" y="262" font-family="monospace" font-size="12">• pinch zoom</text>
  <text x="365" y="282" font-family="monospace" font-size="12">• counter-rotation</text>

  <rect x="670" y="180" width="290" height="120" fill="#f3f3f3" stroke="#333"/>
  <text x="685" y="215" font-family="monospace" font-size="14">README / LICENSE / STATUS</text>
  <text x="685" y="242" font-family="monospace" font-size="12">• usage + disclaimer</text>
  <text x="685" y="262" font-family="monospace" font-size="12">• MIT licence</text>
  <text x="685" y="282" font-family="monospace" font-size="12">• current repo state</text>

  <line x1="300" y1="80" x2="350" y2="80" stroke="#333" stroke-width="2" marker-end="url(#arrow)"/>
  <line x1="670" y1="80" x2="610" y2="80" stroke="#333" stroke-width="2" marker-end="url(#arrow)"/>
  <line x1="480" y1="140" x2="480" y2="180" stroke="#333" stroke-width="2" marker-end="url(#arrow)"/>
</svg>

<p><em>Diagram: current file-level data flow for the app. Boxes are tracked files, arrows show the main runtime flow.</em></p>

## Current notes

- The simulator does not exercise live device motion.
- Yaw compensation may still need hardware tuning.

Last updated: 2026-05-27 19:18 GMT-3
