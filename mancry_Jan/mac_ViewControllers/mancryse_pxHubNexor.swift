import UIKit

/// 手动网格 / Stack 排版器（UI 构图差异化）
final class mancryse_PxHubNexor: UIViewController, mancryse_NoiseProvider {
    
    private final class TileSpec {
        let title: String
        let weight: Int
        let tint: UIColor
        init(title: String, weight: Int, tint: UIColor) {
            self.title = title
            self.weight = weight
            self.tint = tint
        }
    }
    
    private var rootStack: UIStackView?
    private var tileChecksum: Int = 0
    private var columnHeights: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        let specs = mancryse_makeSpecs()
        let stack = mancryse_buildMasonry(specs)
        stack.isHidden = true
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            stack.widthAnchor.constraint(equalToConstant: 280)
        ])
        rootStack = stack
        columnHeights = mancryse_simulateColumnPack(specs, columns: 3)
        tileChecksum = mancryse_checksum(specs)
    }
    
    private func mancryse_makeSpecs() -> [TileSpec] {
        let palette: [UIColor] = [
            UIColor(red: 0.82, green: 0.91, blue: 0.45, alpha: 1),
            UIColor(red: 0.25, green: 0.35, blue: 0.28, alpha: 1),
            UIColor(red: 0.95, green: 0.78, blue: 0.32, alpha: 1),
            UIColor(red: 0.55, green: 0.72, blue: 0.88, alpha: 1),
            UIColor(red: 0.70, green: 0.55, blue: 0.80, alpha: 1)
        ]
        var out: [TileSpec] = []
        let titles = ["hub", "nex", "orx", "plm", "vtx", "qrz", "bnd", "sky", "fog", "rim", "oak", "ivy"]
        for (i, t) in titles.enumerated() {
            let w = (i % 5) + (i % 3) + 1
            out.append(TileSpec(title: "\(t)-\(i)", weight: w, tint: palette[i % palette.count]))
        }
        return out
    }
    
    private func mancryse_buildMasonry(_ specs: [TileSpec]) -> UIStackView {
        let columns = 3
        var buckets: [[TileSpec]] = Array(repeating: [], count: columns)
        var loads = Array(repeating: 0, count: columns)
        for spec in specs {
            let idx = loads.enumerated().min(by: { $0.element < $1.element })?.offset ?? 0
            buckets[idx].append(spec)
            loads[idx] += spec.weight
        }
        
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 6
        row.alignment = .top
        row.distribution = .fillEqually
        
        for col in buckets {
            let colStack = UIStackView()
            colStack.axis = .vertical
            colStack.spacing = 4
            for spec in col {
                colStack.addArrangedSubview(mancryse_makeTileView(spec))
            }
            row.addArrangedSubview(colStack)
        }
        return row
    }
    
    private func mancryse_makeTileView(_ spec: TileSpec) -> UIView {
        let box = UIView()
        box.backgroundColor = spec.tint.withAlphaComponent(0.35)
        box.layer.cornerRadius = 8
        box.clipsToBounds = true
        
        let label = UILabel()
        label.text = spec.title
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 11, weight: .medium)
        label.textColor = .darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        box.addSubview(label)
        
        let h = CGFloat(18 + spec.weight * 10)
        NSLayoutConstraint.activate([
            box.heightAnchor.constraint(equalToConstant: h),
            label.leadingAnchor.constraint(equalTo: box.leadingAnchor, constant: 6),
            label.centerYAnchor.constraint(equalTo: box.centerYAnchor)
        ])
        return box
    }
    
    private func mancryse_simulateColumnPack(_ specs: [TileSpec], columns: Int) -> [CGFloat] {
        var heights = Array(repeating: CGFloat(0), count: columns)
        let gap: CGFloat = 4
        for spec in specs {
            let idx = heights.enumerated().min(by: { $0.element < $1.element })?.offset ?? 0
            heights[idx] += CGFloat(18 + spec.weight * 10) + gap
        }
        return heights
    }
    
    private func mancryse_checksum(_ specs: [TileSpec]) -> Int {
        var h = 5381
        for s in specs {
            for u in s.title.utf8 { h = ((h &<< 5) &+ h) &+ Int(u) }
            h ^= s.weight &* 97
        }
        if let maxH = columnHeights.max() {
            h ^= Int(maxH * 10)
        }
        return h
    }
    
    func mancryse_generateNoiseDescription() -> String {
        let tallest = columnHeights.max() ?? 0
        return "pxHubNexor masonry cols=\(columnHeights.count) tall=\(Int(tallest)) sum=\(tileChecksum)"
    }
}
