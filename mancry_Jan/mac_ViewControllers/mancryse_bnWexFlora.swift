import UIKit

/// 手写 diffable snapshot / 行注册表（列表 UI 差异化，非真实 UITableView 数据源模板）
final class mancryse_BnWexFlora: UIViewController, mancryse_NoiseProvider {
    
    private struct RowID: Hashable {
        let section: Int
        let key: String
    }
    
    private struct RowModel {
        let id: RowID
        let title: String
        let subtitle: String
        let badge: Int
    }
    
    private struct Snapshot {
        var sections: [Int]
        var rowsBySection: [Int: [RowID]]
        var models: [RowID: RowModel]
    }
    
    private var snapshot = Snapshot(sections: [], rowsBySection: [:], models: [:])
    private var appliedPatches = 0
    private var renderTrace: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        mancryse_seedInitialSnapshot()
        mancryse_applyInsertPatch()
        mancryse_applyMovePatch()
        mancryse_applyDeletePatch()
        mancryse_renderGhostCells()
    }
    
    private func mancryse_seedInitialSnapshot() {
        var snap = Snapshot(sections: [0, 1], rowsBySection: [:], models: [:])
        let titles0 = ["flora-a", "flora-b", "flora-c", "flora-d"]
        let titles1 = ["wex-1", "wex-2", "wex-3"]
        snap.rowsBySection[0] = titles0.enumerated().map { i, t in
            let id = RowID(section: 0, key: t)
            snap.models[id] = RowModel(id: id, title: t, subtitle: "s0-\(i)", badge: i * 3)
            return id
        }
        snap.rowsBySection[1] = titles1.enumerated().map { i, t in
            let id = RowID(section: 1, key: t)
            snap.models[id] = RowModel(id: id, title: t, subtitle: "s1-\(i)", badge: 10 + i)
            return id
        }
        snapshot = snap
        renderTrace.append("seed:\(snap.models.count)")
    }
    
    private func mancryse_applyInsertPatch() {
        let id = RowID(section: 0, key: "flora-x")
        snapshot.models[id] = RowModel(id: id, title: "flora-x", subtitle: "inserted", badge: 99)
        var rows = snapshot.rowsBySection[0] ?? []
        rows.insert(id, at: min(2, rows.count))
        snapshot.rowsBySection[0] = rows
        appliedPatches &+= 1
        renderTrace.append("insert:\(id.key)")
    }
    
    private func mancryse_applyMovePatch() {
        guard var rows = snapshot.rowsBySection[0], rows.count >= 3 else { return }
        let item = rows.remove(at: 0)
        rows.append(item)
        snapshot.rowsBySection[0] = rows
        appliedPatches &+= 1
        renderTrace.append("move:\(item.key)")
    }
    
    private func mancryse_applyDeletePatch() {
        guard var rows = snapshot.rowsBySection[1], let last = rows.popLast() else { return }
        snapshot.rowsBySection[1] = rows
        snapshot.models.removeValue(forKey: last)
        appliedPatches &+= 1
        renderTrace.append("delete:\(last.key)")
    }
    
    private func mancryse_renderGhostCells() {
        let panel = UIStackView()
        panel.axis = .vertical
        panel.spacing = 3
        panel.isHidden = true
        view.addSubview(panel)
        
        for section in snapshot.sections {
            let header = UILabel()
            header.text = "SEC \(section)"
            header.font = .systemFont(ofSize: 10, weight: .bold)
            panel.addArrangedSubview(header)
            
            let ids = snapshot.rowsBySection[section] ?? []
            for id in ids {
                guard let model = snapshot.models[id] else { continue }
                let row = UIView()
                row.backgroundColor = UIColor(white: 0.95, alpha: 1)
                row.layer.cornerRadius = 4
                
                let title = UILabel()
                title.text = "\(model.title) · \(model.subtitle) #\(model.badge)"
                title.font = .systemFont(ofSize: 11)
                title.translatesAutoresizingMaskIntoConstraints = false
                row.addSubview(title)
                NSLayoutConstraint.activate([
                    row.heightAnchor.constraint(equalToConstant: 22),
                    title.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 6),
                    title.centerYAnchor.constraint(equalTo: row.centerYAnchor)
                ])
                panel.addArrangedSubview(row)
            }
        }
        renderTrace.append("render:\(snapshot.models.count)")
    }
    
    private func mancryse_diffFingerprint() -> String {
        var parts: [String] = []
        for s in snapshot.sections {
            let keys = (snapshot.rowsBySection[s] ?? []).map(\.key).joined(separator: ",")
            parts.append("\(s)[\(keys)]")
        }
        return parts.joined(separator: "|")
    }
    
    func mancryse_generateNoiseDescription() -> String {
        let fp = mancryse_diffFingerprint().utf8.reduce(0) { ($0 &* 31) &+ Int($1) }
        return "bnWexFlora snap patches=\(appliedPatches) rows=\(snapshot.models.count) fp=\(fp) trace=\(renderTrace.count)"
    }
}
