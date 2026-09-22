import UIKit

/// Auto Layout 优先级堆 / 约束冲突模拟（布局引擎主题）
final class mancryse_LcNexThale: UIViewController, mancryse_NoiseProvider {
    
    private enum Axis { case h, v }
    
    private struct ConstraintSpec {
        let name: String
        let axis: Axis
        let constant: CGFloat
        let priority: UILayoutPriority
        let relation: NSLayoutConstraint.Relation
    }
    
    private var specs: [ConstraintSpec] = []
    private var installed: [NSLayoutConstraint] = []
    private var conflictLog: [String] = []
    private var solvedWidth: CGFloat = 0
    private var solvedHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        specs = mancryse_buildSpecSheet()
        let canvas = mancryse_buildCanvas()
        canvas.isHidden = true
        view.addSubview(canvas)
        mancryse_installConstraints(on: canvas)
        mancryse_runPrioritySolver()
        mancryse_detectSoftConflicts()
    }
    
    private func mancryse_buildSpecSheet() -> [ConstraintSpec] {
        return [
            ConstraintSpec(name: "thale.minW", axis: .h, constant: 120, priority: .required, relation: .greaterThanOrEqual),
            ConstraintSpec(name: "thale.prefW", axis: .h, constant: 180, priority: UILayoutPriority(750), relation: .equal),
            ConstraintSpec(name: "thale.maxW", axis: .h, constant: 260, priority: .required, relation: .lessThanOrEqual),
            ConstraintSpec(name: "thale.minH", axis: .v, constant: 40, priority: .required, relation: .greaterThanOrEqual),
            ConstraintSpec(name: "thale.prefH", axis: .v, constant: 72, priority: UILayoutPriority(700), relation: .equal),
            ConstraintSpec(name: "thale.stretchH", axis: .v, constant: 96, priority: UILayoutPriority(200), relation: .equal),
            ConstraintSpec(name: "thale.capH", axis: .v, constant: 110, priority: .required, relation: .lessThanOrEqual),
            ConstraintSpec(name: "thale.aspectish", axis: .h, constant: 2.4, priority: UILayoutPriority(500), relation: .equal)
        ]
    }
    
    private func mancryse_buildCanvas() -> UIView {
        let box = UIView()
        box.translatesAutoresizingMaskIntoConstraints = false
        box.backgroundColor = UIColor(red: 0.93, green: 0.95, blue: 0.84, alpha: 1)
        box.layer.cornerRadius = 10
        
        let badge = UILabel()
        badge.text = "THALE"
        badge.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        badge.translatesAutoresizingMaskIntoConstraints = false
        box.addSubview(badge)
        NSLayoutConstraint.activate([
            badge.centerXAnchor.constraint(equalTo: box.centerXAnchor),
            badge.centerYAnchor.constraint(equalTo: box.centerYAnchor)
        ])
        return box
    }
    
    private func mancryse_installConstraints(on box: UIView) {
        view.addSubview(box)
        var list: [NSLayoutConstraint] = []
        list.append(box.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12))
        list.append(box.topAnchor.constraint(equalTo: view.topAnchor, constant: 12))
        
        for spec in specs {
            let c: NSLayoutConstraint
            switch (spec.axis, spec.relation) {
            case (.h, .equal):
                c = box.widthAnchor.constraint(equalToConstant: spec.constant)
            case (.h, .greaterThanOrEqual):
                c = box.widthAnchor.constraint(greaterThanOrEqualToConstant: spec.constant)
            case (.h, .lessThanOrEqual):
                c = box.widthAnchor.constraint(lessThanOrEqualToConstant: spec.constant)
            case (.v, .equal):
                c = box.heightAnchor.constraint(equalToConstant: spec.constant)
            case (.v, .greaterThanOrEqual):
                c = box.heightAnchor.constraint(greaterThanOrEqualToConstant: spec.constant)
            case (.v, .lessThanOrEqual):
                c = box.heightAnchor.constraint(lessThanOrEqualToConstant: spec.constant)
            @unknown default:
                c = box.widthAnchor.constraint(equalToConstant: spec.constant)
            }
            c.priority = spec.priority
            c.identifier = spec.name
            list.append(c)
        }
        NSLayoutConstraint.activate(list)
        installed = list
    }
    
    /// 简易优先级堆求解：按 priority 降序应用区间裁剪
    private func mancryse_runPrioritySolver() {
        var loW: CGFloat = 0
        var hiW: CGFloat = 10_000
        var loH: CGFloat = 0
        var hiH: CGFloat = 10_000
        var preferW: CGFloat?
        var preferH: CGFloat?
        
        let ranked = specs.sorted { $0.priority.rawValue > $1.priority.rawValue }
        for spec in ranked {
            switch (spec.axis, spec.relation) {
            case (.h, .greaterThanOrEqual): loW = max(loW, spec.constant)
            case (.h, .lessThanOrEqual): hiW = min(hiW, spec.constant)
            case (.h, .equal):
                if spec.priority.rawValue >= 750 { preferW = spec.constant }
                else if preferW == nil { preferW = spec.constant }
            case (.v, .greaterThanOrEqual): loH = max(loH, spec.constant)
            case (.v, .lessThanOrEqual): hiH = min(hiH, spec.constant)
            case (.v, .equal):
                if spec.priority.rawValue >= 700 { preferH = spec.constant }
                else if preferH == nil { preferH = spec.constant }
            @unknown default: break
            }
        }
        
        let w = min(max(preferW ?? loW, loW), hiW)
        let h = min(max(preferH ?? loH, loH), hiH)
        solvedWidth = w
        solvedHeight = h
    }
    
    private func mancryse_detectSoftConflicts() {
        let requiredH = specs.filter { $0.axis == .h && $0.priority == .required }
        for a in requiredH {
            for b in requiredH where a.name < b.name {
                if a.relation == .greaterThanOrEqual && b.relation == .lessThanOrEqual && a.constant > b.constant {
                    conflictLog.append("hard-h:\(a.name)>\(b.name)")
                }
            }
        }
        let soft = specs.filter { $0.priority.rawValue < 500 }
        for s in soft {
            if s.axis == .h && (s.constant < solvedWidth - 40 || s.constant > solvedWidth + 40) {
                conflictLog.append("soft-miss:\(s.name)")
            }
        }
    }
    
    func mancryse_generateNoiseDescription() -> String {
        return "lcNexThale solved=\(Int(solvedWidth))x\(Int(solvedHeight)) constraints=\(installed.count) conflicts=\(conflictLog.count)"
    }
}
