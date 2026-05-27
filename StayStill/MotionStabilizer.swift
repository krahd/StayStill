import Foundation

#if os(iOS)
import CoreMotion

/// Motion-driven stabilization:
/// - counter-rotation (degrees) to compensate device rotation
///
/// Notes:
/// - Approximate: yaw alignment may require tuning per device.
@MainActor
final class MotionStabilizer: ObservableObject {

    // User toggles
    @Published var rotationEnabled: Bool = true {
        didSet { startIfNeeded() }
    }

    // Outputs used by renderer
    @Published private(set) var counterRotationDegrees: Double = 0

    private let motionManager = CMMotionManager()

    // Rotation baselines
    private var baselineYaw: Double?

    func startIfNeeded() {
        guard rotationEnabled else {
            motionManager.stopDeviceMotionUpdates()
            resetMotionState()
            return
        }

        if motionManager.isDeviceMotionActive == false {
            resetMotionState()
            motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
            motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main) { [weak self] motion, _ in
                guard let self, let motion else { return }

                // Rotation compensation (Z axis only)
                if self.rotationEnabled {
                    let yaw = motion.attitude.yaw
                    if self.baselineYaw == nil { self.baselineYaw = yaw }
                    let dyaw = yaw - (self.baselineYaw ?? yaw)
                    self.counterRotationDegrees = (dyaw * 180.0 / .pi)
                } else {
                    self.counterRotationDegrees = 0
                }
            }
        }
    }

    /// Compatibility for older call sites.
    func start() {
        startIfNeeded()
    }

    /// Reset baselines and motion-derived state.
    private func resetMotionState() {
        baselineYaw = nil
        counterRotationDegrees = 0
    }
}

#else

/// Non-iOS stub so builds on other platforms don’t fail.
@MainActor
final class MotionStabilizer: ObservableObject {
    @Published var rotationEnabled: Bool = true

    @Published private(set) var counterRotationDegrees: Double = 0

    func startIfNeeded() {}
    func start() {}
}

#endif
