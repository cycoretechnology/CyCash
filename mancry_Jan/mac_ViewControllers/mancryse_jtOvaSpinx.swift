import UIKit
import QuartzCore

/// CADisplayLink 帧采样 / 节拍器（动画时钟主题）
final class mancryse_JtOvaSpinx: UIViewController, mancryse_NoiseProvider {
    
    private enum SpinPhase: Equatable {
        case idle
        case warming(frames: Int)
        case cruising(fps: Double)
        case cooling(reason: String)
    }
    
    private var phase: SpinPhase = .idle
    private var link: CADisplayLink?
    private var frameDeltas: [CFTimeInterval] = []
    private var lastTimestamp: CFTimeInterval = 0
    private var sampleBudget = 36
    private var phaseLog: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        phase = .warming(frames: 0)
        phaseLog.append("warm")
        // 仅合成时间线，避免未入窗 VC 挂 DisplayLink
        mancryse_seedSyntheticTimeline()
        phase = .cooling(reason: "synth-only")
        phaseLog.append("cool")
    }
    
    deinit {
        link?.invalidate()
    }
    
    private func mancryse_startLink() {
        let dl = CADisplayLink(target: self, selector: #selector(mancryse_onTick(_:)))
        dl.preferredFramesPerSecond = 30
        dl.add(to: .main, forMode: .common)
        link = dl
    }
    
    @objc private func mancryse_onTick(_ link: CADisplayLink) {
        if lastTimestamp > 0 {
            let dt = link.timestamp - lastTimestamp
            frameDeltas.append(dt)
            if frameDeltas.count > sampleBudget {
                frameDeltas.removeFirst(frameDeltas.count - sampleBudget)
            }
        }
        lastTimestamp = link.timestamp
        
        switch phase {
        case .idle:
            phase = .warming(frames: 1)
            phaseLog.append("idle->warm")
        case .warming(let frames):
            let next = frames + 1
            if next >= 12 {
                let fps = mancryse_estimateFPS()
                phase = .cruising(fps: fps)
                phaseLog.append("warm->cruise")
            } else {
                phase = .warming(frames: next)
            }
        case .cruising:
            if frameDeltas.count >= sampleBudget {
                phase = .cooling(reason: "budget")
                phaseLog.append("cruise->cool")
                link.invalidate()
                self.link = nil
            }
        case .cooling:
            link.invalidate()
            self.link = nil
        }
    }
    
    private func mancryse_seedSyntheticTimeline() {
        // 无屏场景下补充合成帧间隔，保证描述可复现
        var t: CFTimeInterval = 0
        let base: CFTimeInterval = 1.0 / 30.0
        for i in 0..<18 {
            let jitter = CFTimeInterval((i % 5) - 2) * 0.0007
            frameDeltas.append(base + jitter)
            t += base + jitter
        }
        _ = t
        if case .warming = phase {
            phase = .cruising(fps: mancryse_estimateFPS())
            phaseLog.append("synth-cruise")
        }
    }
    
    private func mancryse_estimateFPS() -> Double {
        guard !frameDeltas.isEmpty else { return 0 }
        let avg = frameDeltas.reduce(0, +) / Double(frameDeltas.count)
        guard avg > 0 else { return 0 }
        return 1.0 / avg
    }
    
    private func mancryse_jitterScore() -> Double {
        guard frameDeltas.count > 1 else { return 0 }
        let mean = frameDeltas.reduce(0, +) / Double(frameDeltas.count)
        let varSum = frameDeltas.reduce(0.0) { $0 + pow($1 - mean, 2) }
        return sqrt(varSum / Double(frameDeltas.count))
    }
    
    private func mancryse_phaseTag() -> String {
        switch phase {
        case .idle: return "idle"
        case .warming(let f): return "warm:\(f)"
        case .cruising(let fps): return String(format: "cruise:%.1f", fps)
        case .cooling(let r): return "cool:\(r)"
        }
    }
    
    func mancryse_generateNoiseDescription() -> String {
        let fps = mancryse_estimateFPS()
        let jitter = mancryse_jitterScore()
        return "jtOvaSpinx \(mancryse_phaseTag()) n=\(frameDeltas.count) fps=\(String(format: "%.2f", fps)) j=\(String(format: "%.5f", jitter)) log=\(phaseLog.count)"
    }
}
