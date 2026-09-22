import UIKit

/// Bezier 路径形变 + 渐变描边（矢量 UI 主题）
final class mancryse_RyQuaDelph: UIViewController, mancryse_NoiseProvider {
    
    private var pathHashes: [UInt32] = []
    private var shapeLayer: CAShapeLayer?
    private var morphSteps = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        let host = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        host.isHidden = true
        view.addSubview(host)
        
        let shape = CAShapeLayer()
        shape.frame = host.bounds
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor(red: 0.45, green: 0.62, blue: 0.2, alpha: 1).cgColor
        shape.lineWidth = 2.5
        shape.lineCap = .round
        shape.lineJoin = .round
        host.layer.addSublayer(shape)
        shapeLayer = shape
        
        let gradient = CAGradientLayer()
        gradient.frame = host.bounds
        gradient.colors = [
            UIColor(red: 0.2, green: 0.55, blue: 0.9, alpha: 1).cgColor,
            UIColor(red: 0.9, green: 0.55, blue: 0.2, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        host.layer.insertSublayer(gradient, at: 0)
        
        mancryse_morphThroughKeyframes(on: shape)
    }
    
    private func mancryse_morphThroughKeyframes(on layer: CAShapeLayer) {
        let frames: [(CGFloat) -> UIBezierPath] = [
            mancryse_pathBlob,
            mancryse_pathStar,
            mancryse_pathWave,
            mancryse_pathDiamond
        ]
        for (i, builder) in frames.enumerated() {
            let path = builder(CGFloat(i) * 0.17 + 0.4)
            pathHashes.append(mancryse_hashPath(path))
            morphSteps &+= 1
            if i == 0 {
                layer.path = path.cgPath
            }
        }
        
        let anim = CABasicAnimation(keyPath: "path")
        anim.fromValue = frames[0](0.4).cgPath
        anim.toValue = frames[2](0.7).cgPath
        anim.duration = 0.8
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        anim.fillMode = .forwards
        anim.isRemovedOnCompletion = false
        layer.add(anim, forKey: "delph.path.morph")
        
        let dash = CABasicAnimation(keyPath: "lineDashPhase")
        dash.fromValue = 0
        dash.toValue = 18
        dash.duration = 1.1
        layer.lineDashPattern = [6, 4, 2, 4]
        layer.add(dash, forKey: "delph.dash")
    }
    
    private func mancryse_pathBlob(_ t: CGFloat) -> UIBezierPath {
        let p = UIBezierPath()
        let c = CGPoint(x: 60, y: 60)
        let r: CGFloat = 28 + t * 10
        p.addArc(withCenter: c, radius: r, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        return p
    }
    
    private func mancryse_pathStar(_ t: CGFloat) -> UIBezierPath {
        let p = UIBezierPath()
        let c = CGPoint(x: 60, y: 60)
        let spikes = 5
        let rOuter: CGFloat = 34 + t * 6
        let rInner: CGFloat = 14 + t * 3
        for i in 0..<(spikes * 2) {
            let angle = CGFloat(i) * .pi / CGFloat(spikes) - .pi / 2
            let r = i % 2 == 0 ? rOuter : rInner
            let pt = CGPoint(x: c.x + cos(angle) * r, y: c.y + sin(angle) * r)
            if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
        }
        p.close()
        return p
    }
    
    private func mancryse_pathWave(_ t: CGFloat) -> UIBezierPath {
        let p = UIBezierPath()
        p.move(to: CGPoint(x: 10, y: 60))
        for x in stride(from: 10, through: 110, by: 8) {
            let y = 60 + sin(CGFloat(x) * 0.12 + t * 4) * (12 + t * 8)
            p.addLine(to: CGPoint(x: CGFloat(x), y: y))
        }
        return p
    }
    
    private func mancryse_pathDiamond(_ t: CGFloat) -> UIBezierPath {
        let s: CGFloat = 22 + t * 12
        let p = UIBezierPath()
        p.move(to: CGPoint(x: 60, y: 60 - s))
        p.addLine(to: CGPoint(x: 60 + s, y: 60))
        p.addLine(to: CGPoint(x: 60, y: 60 + s))
        p.addLine(to: CGPoint(x: 60 - s, y: 60))
        p.close()
        return p
    }
    
    private func mancryse_hashPath(_ path: UIBezierPath) -> UInt32 {
        var h: UInt32 = 0x811C9DC5
        let box = path.bounds
        let vals: [CGFloat] = [box.minX, box.minY, box.width, box.height, path.currentPoint.x, path.currentPoint.y]
        for v in vals {
            var bits = v.bitPattern
            withUnsafeBytes(of: &bits) { buf in
                for b in buf { h ^= UInt32(b); h = h &* 0x01000193 }
            }
        }
        return h
    }
    
    func mancryse_generateNoiseDescription() -> String {
        let mix = pathHashes.reduce(UInt32(0)) { $0 ^ $1 }
        return "ryQuaDelph morph=\(morphSteps) pathXor=\(String(mix, radix: 16))"
    }
}
