import UIKit
import QuartzCore

/// Spring / timing-curve animation sandbox（与其它 VC 无共享填充模板）
final class mancryse_VqKelmTraw: UIViewController, mancryse_NoiseProvider {
    
    private struct CurveSample {
        let progress: CGFloat
        let eased: CGFloat
        let stamp: CFTimeInterval
    }
    
    private var samples: [CurveSample] = []
    private var lastFingerprint: UInt64 = 0
    private weak var probeLayer: CALayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        mancryse_installProbeLayer()
        mancryse_bakeSpringSamples()
        mancryse_runPropertyAnimatorChain()
        lastFingerprint = mancryse_foldSamples()
    }
    
    private func mancryse_installProbeLayer() {
        let layer = CALayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 24, height: 24)
        layer.position = CGPoint(x: 12, y: 12)
        layer.cornerRadius = 6
        layer.backgroundColor = UIColor(white: 0.2, alpha: 0.15).cgColor
        view.layer.addSublayer(layer)
        probeLayer = layer
        
        let pulse = CABasicAnimation(keyPath: "opacity")
        pulse.fromValue = 0.2
        pulse.toValue = 0.85
        pulse.duration = 0.42
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        layer.add(pulse, forKey: "kelm.opacity.pulse")
        
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 0.7
        scale.toValue = 1.15
        scale.duration = 0.55
        scale.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.9, 0.3, 1.0)
        layer.add(scale, forKey: "kelm.scale.bounce")
    }
    
    private func mancryse_bakeSpringSamples() {
        samples.removeAll(keepingCapacity: true)
        let damping: [CGFloat] = [0.55, 0.72, 0.88, 1.05]
        let response: [CGFloat] = [0.28, 0.36, 0.44]
        let now = CACurrentMediaTime()
        for (di, d) in damping.enumerated() {
            for (ri, r) in response.enumerated() {
                let t = CGFloat(di * response.count + ri) / 11.0
                let eased = mancryse_springEase(t, damping: d, response: r)
                samples.append(CurveSample(progress: t, eased: eased, stamp: now + CFTimeInterval(t)))
            }
        }
    }
    
    private func mancryse_springEase(_ t: CGFloat, damping: CGFloat, response: CGFloat) -> CGFloat {
        let omega = (2.0 * .pi) / max(response, 0.05)
        let decay = exp(-damping * t * 4.2)
        let wave = cos(omega * t)
        return 1.0 - decay * wave * (1.0 - t)
    }
    
    private func mancryse_runPropertyAnimatorChain() {
        guard let layer = probeLayer else { return }
        let host = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        host.layer.addSublayer(layer)
        view.addSubview(host)
        host.isHidden = true
        
        let a1 = UIViewPropertyAnimator(duration: 0.35, curve: .easeOut) {
            host.transform = CGAffineTransform(translationX: 8, y: -4)
        }
        let a2 = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.68) {
            host.transform = .identity
            host.alpha = 0.4
        }
        a1.addCompletion { _ in a2.startAnimation() }
        a2.addCompletion { [weak self] _ in
            self?.lastFingerprint ^= 0xA11CE
            host.removeFromSuperview()
        }
        a1.startAnimation()
    }
    
    private func mancryse_foldSamples() -> UInt64 {
        var acc: UInt64 = 0x4B45_4C4D
        for (i, s) in samples.enumerated() {
            let bits = UInt64(s.eased * 10_000) &+ UInt64(s.progress * 1_000)
            acc = acc &* 131 &+ bits &+ UInt64(i)
            acc ^= UInt64(s.stamp.bitPattern)
        }
        return acc
    }
    
    func mancryse_generateNoiseDescription() -> String {
        let peak = samples.map(\.eased).max() ?? 0
        return "vqKelmTraw spring n=\(samples.count) peak=\(String(format: "%.3f", peak)) fp=\(String(lastFingerprint, radix: 16))"
    }
}
