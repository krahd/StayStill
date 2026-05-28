# StayStill (iOS)

Last updated: 2026-05-27 19:29 GMT-3

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

### Current architecture

![Diagram: current file-level data flow for the app. Boxes are tracked files, arrows show the main runtime flow.](docs/status-architecture.svg)


## Current notes

- The simulator does not exercise live device motion.
- Yaw compensation may still need hardware tuning.

## Future Steps

- Evaluate if using the device's camera can provide better rotation compensation.
- Evaluate if using the device's camera can provide panning compensation.

Last updated: 2026-05-27 19:29 GMT-3
