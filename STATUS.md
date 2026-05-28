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

## ARKit Integration

- Using the device's camera can provide better rotation and translation compensation through ARKit world tracking.

Current implementation is explicitly IMU-driven:

- ContentView instantiates MotionStabilizer and passes only counterRotationDegrees and translationOffset into the image viewer.  ￼
- MotionStabilizer uses CoreMotion, with device-motion updates at 60 Hz.  ￼  ￼
- Rotation compensation currently uses yaw delta only.  ￼
- Translation compensation integrates motion.userAcceleration, then maps velocity to a 2D image-plane offset with fixed gain, smoothing, and clamping. The file itself marks this as approximate.  ￼
- Rendering is a 2D SwiftUI transform: scale, 2D offset, and Z-axis rotation.  ￼

So the present system is a 2D perceptual stabiliser, not a true camera-pose/image-reprojection system.

What the camera would improve

Using the camera means using visual odometry / visual-inertial odometry: estimating device/camera pose from camera frames, usually fused with IMU data. Visual odometry estimates camera position and orientation from sequential images; when fused with IMU data it becomes visual-inertial odometry.  ￼

On iOS, the practical route would be ARKit world tracking, not a custom raw-camera tracker. ARKit uses the device camera, CPU/GPU, and motion sensors for AR tracking.  ￼ Commercial VIO systems, including Apple ARKit, are treated in the literature as off-the-shelf 6-DoF ego-motion tracking systems, but their accuracy and consistency remain empirical rather than perfect.  ￼

ARKit could provide:

1. 6-DoF camera pose instead of only yaw plus accelerometer-derived planar drift.
2. Much better translation estimates than double-integrating acceleration.
3. Depth-aware possibilities on LiDAR-capable devices.
4. A more principled compensation model: compute camera-pose delta from a baseline pose, then transform the displayed image accordingly.


Best feasible architecture

The best version is not camera instead of accelerometer, but:

ARKit / VIO pose
- IMU prediction
- display-time smoothing
- optional depth/plane model
→ image transform

For this repo, that means replacing or extending MotionStabilizer with something like ARStabilizer:

ARSession
→ ARFrame.camera.transform
→ baseline camera pose
→ current camera pose
→ relative transform
→ derive:

- roll/yaw/pitch correction
- image-plane translation
- optional perspective warp

Then ImageStabilizedViewer would need to move beyond:

.offset(...)
.rotationEffect(...)

towards either:

1. 2D approximation: keep SwiftUI transforms but drive them from ARKit pose.
2. Better approximation: use projectionEffect / CATransform3D for perspective.
3. Correcter model: render the photo as a textured plane in RealityKit/Metal and update the virtual camera inversely to the physical camera pose.
4. Most correct: reconstruct or assume scene geometry, then reproject. This exceeds the current app’s structure.

Practical conclusion

Camera/VIO can make StayStill substantially better, especially for translation. It cannot make it real-time perfect.

The realistic target is:

perceptually convincing compensation for small rotations and small translations, with graceful degradation.

The current accelerometer translation method is the weakest part. Replacing it with ARKit pose tracking would be the most meaningful technical improvement. Rotation could remain IMU-driven or be fused with ARKit pose; translation should not be based on raw acceleration integration.


Last updated: 2026-05-27 19:29 GMT-3
