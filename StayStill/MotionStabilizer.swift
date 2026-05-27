import Foundation
import simd

#if os(iOS)
import CoreMotion

/// Motion-driven stabilization:
/// - counter-rotation (degrees) to compensate device rotation
/// - counter-translation (image-plane offset) to reduce perceived drift
///
/// Notes:
/// - Approximate: axis mapping and gains will require tuning per device.
@MainActor
final class MotionStabilizer: ObservableObject {

    // User toggles
    @Published var rotationEnabled: Bool = true {
        didSet { startIfNeeded() }
    }
    @Published var translationEnabled: Bool = true {
        didSet { startIfNeeded() }
    }

    // Outputs used by renderer
    @Published private(set) var counterRotationDegrees: Double = 0
    @Published private(set) var translationOffset: SIMD2<Float> = .init(0, 0)

    private let motionManager = CMMotionManager()

    // Rotation baselines
    private var baselineYaw: Double?
    private var baselineRoll: Double?

    // Translation integration state (very rough)
    private var lastVelocity: SIMD2<Float> = .init(0, 0)
    private var lastTimestamp: TimeInterval?

    // Filtering gains
    private let translationSmoothing: Float = 0.16
    private let translationGain: Float = 1200
    private let translationClamp: Float = 180

    func startIfNeeded() {
        guard rotationEnabled || translationEnabled else {
            motionManager.stopDeviceMotionUpdates()
            motionManager.stopAccelerometerUpdates()
            resetMotionState()
            return
        }

        if motionManager.isAccelerometerActive == false {
            motionManager.accelerometerUpdateInterval = 1.0 / 60.0
            motionManager.startAccelerometerUpdates()
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

                // Translation compensation (planar offset)
                // NOTE: This still uses IMU-derived acceleration, so it is approximate.
                if self.translationEnabled {
                    let accel = motion.userAcceleration
                    let ax = Float(accel.x)
                    let ay = Float(accel.y)

                    let now = motion.timestamp
                    if let lastT = self.lastTimestamp {
                        let dt = Float(max(0.001, now - lastT))
                        self.lastVelocity += SIMD2<Float>(ax, ay) * dt
                        let target = -self.lastVelocity * self.translationGain
                        self.translationOffset += (target - self.translationOffset) * self.translationSmoothing
                        self.translationOffset = self.clampedTranslationOffset(self.translationOffset)
                    }
                    self.lastTimestamp = now
                } else {
                    self.lastVelocity = .init(0, 0)
                    self.lastTimestamp = nil
                    self.translationOffset = .init(0, 0)
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
        baselineRoll = nil
        lastVelocity = .init(0, 0)
        lastTimestamp = nil
        counterRotationDegrees = 0
        translationOffset = .init(0, 0)
    }

    private func clampedTranslationOffset(_ value: SIMD2<Float>) -> SIMD2<Float> {
        SIMD2<Float>(
            max(-translationClamp, min(translationClamp, value.x)),
            max(-translationClamp, min(translationClamp, value.y))
        )
    }
}

#else

/// Non-iOS stub so builds on other platforms don’t fail.
@MainActor
final class MotionStabilizer: ObservableObject {
    @Published var rotationEnabled: Bool = true
    @Published var translationEnabled: Bool = true

    @Published private(set) var counterRotationDegrees: Double = 0
    @Published private(set) var translationOffset: SIMD2<Float> = .init(0, 0)

    func startIfNeeded() {}
    func start() {}
}

#endif
