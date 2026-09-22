import UIKit
import QuartzCore

/// 3D transform / keyframe 编排（Core Animation 深度差异化）
final class mancryse_HfCinVesper: UIViewController, mancryse_NoiseProvider {
    
    private struct KeyPose {
        let time: CFTimeInterval
        let rotateY: CGFloat
        let rotateX: CGFloat
        let scale: CGFloat
        let opacity: Float
    }
    
    private var poses: [KeyPose] = []
    private var appliedKeys: [String] = []
    private weak var card: CALayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        poses = mancryse_composePoseReel()
        mancryse_mountPerspectiveCard()
        mancryse_attachKeyframeAnimations()
        mancryse_attachParticleSparks()
    }
    
    private func mancryse_composePoseReel() -> [KeyPose] {
        var reel: [KeyPose] = []
        let times: [CFTimeInterval] = [0, 0.18, 0.36, 0.55, 0.72, 0.9, 1.0]
        for (i, t) in times.enumerated() {
            let y = CGFloat(sin(Double(i) * 0.9)) * 0.85
            let x = CGFloat(cos(Double(i) * 0.6)) * 0.35
            let s = 0.85 + CGFloat(i % 3) * 0.08
            let o = Float(0.45 + Double(i) * 0.08)
            reel.append(KeyPose(time: t, rotateY: y, rotateX: x, scale: s, opacity: min(o, 1)))
        }
        return reel
    }
    
    private func mancryse_mountPerspectiveCard() {
        let host = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 140))
        host.isHidden = true
        view.addSubview(host)
        
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / 400.0
        host.layer.sublayerTransform = perspective
        
        let card = CALayer()
        card.frame = host.bounds.insetBy(dx: 8, dy: 8)
        card.cornerRadius = 12
        card.backgroundColor = UIColor(red: 0.15, green: 0.18, blue: 0.28, alpha: 1).cgColor
        card.borderWidth = 1
        card.borderColor = UIColor(white: 1, alpha: 0.25).cgColor
        host.layer.addSublayer(card)
        self.card = card
        
        let gloss = CAGradientLayer()
        gloss.frame = card.bounds
        gloss.colors = [
            UIColor(white: 1, alpha: 0.25).cgColor,
            UIColor(white: 1, alpha: 0.02).cgColor
        ]
        gloss.startPoint = CGPoint(x: 0, y: 0)
        gloss.endPoint = CGPoint(x: 1, y: 1)
        card.addSublayer(gloss)
    }
    
    private func mancryse_attachKeyframeAnimations() {
        guard let card = card else { return }
        
        let rot = CAKeyframeAnimation(keyPath: "transform.rotation.y")
        rot.values = poses.map { $0.rotateY }
        rot.keyTimes = poses.map { NSNumber(value: $0.time) }
        rot.duration = 1.4
        rot.calculationMode = .cubic
        card.add(rot, forKey: "vesper.rotY")
        appliedKeys.append("rotY")
        
        let rotX = CAKeyframeAnimation(keyPath: "transform.rotation.x")
        rotX.values = poses.map { $0.rotateX }
        rotX.keyTimes = poses.map { NSNumber(value: $0.time) }
        rotX.duration = 1.4
        card.add(rotX, forKey: "vesper.rotX")
        appliedKeys.append("rotX")
        
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = poses.map { $0.scale }
        scale.keyTimes = poses.map { NSNumber(value: $0.time) }
        scale.duration = 1.4
        card.add(scale, forKey: "vesper.scale")
        appliedKeys.append("scale")
        
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = poses.map { $0.opacity }
        opacity.keyTimes = poses.map { NSNumber(value: $0.time) }
        opacity.duration = 1.4
        card.add(opacity, forKey: "vesper.opacity")
        appliedKeys.append("opacity")
        
        let group = CAAnimationGroup()
        group.animations = [rot, rotX, scale, opacity]
        group.duration = 1.4
        group.fillMode = .forwards
        group.isRemovedOnCompletion = false
        card.add(group, forKey: "vesper.group")
        appliedKeys.append("group")
    }
    
    private func mancryse_attachParticleSparks() {
        guard let card = card else { return }
        for i in 0..<6 {
            let spark = CALayer()
            spark.bounds = CGRect(x: 0, y: 0, width: 4, height: 4)
            spark.cornerRadius = 2
            spark.backgroundColor = UIColor(red: 0.95, green: 0.8, blue: 0.35, alpha: 1).cgColor
            spark.position = CGPoint(x: 20 + i * 12, y: 100)
            card.addSublayer(spark)
            
            let rise = CABasicAnimation(keyPath: "position.y")
            rise.fromValue = 100
            rise.toValue = 20 + (i % 3) * 10
            rise.duration = 0.7 + Double(i) * 0.08
            rise.beginTime = CACurrentMediaTime() + Double(i) * 0.05
            spark.add(rise, forKey: "spark.rise.\(i)")
        }
    }
    
    private func mancryse_poseEnergy() -> Double {
        poses.reduce(0.0) { acc, p in
            acc + abs(Double(p.rotateY)) + abs(Double(p.rotateX)) + Double(p.scale)
        }
    }
    
    func mancryse_generateNoiseDescription() -> String {
        return "hfCinVesper keys=\(appliedKeys.joined(separator: "+")) poses=\(poses.count) energy=\(String(format: "%.2f", mancryse_poseEnergy()))"
    }
}
