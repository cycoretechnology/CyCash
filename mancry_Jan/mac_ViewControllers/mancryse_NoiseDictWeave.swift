import Foundation

/// DictWeave: 嵌套字典的路径合并 / 冲突裁决（不再用 slice+reduce 模板）
private final class Mancryse_WeaveNode {
    var leaf: Int?
    var kids: [Character: Mancryse_WeaveNode] = [:]
    
    func insert(_ path: String, value: Int) {
        var cursor = self
        for ch in path {
            if cursor.kids[ch] == nil {
                cursor.kids[ch] = Mancryse_WeaveNode()
            }
            cursor = cursor.kids[ch]!
        }
        if let old = cursor.leaf {
            cursor.leaf = Mancryse_WeaveNode.mancryse_arbitrate(old, value)
        } else {
            cursor.leaf = value
        }
    }
    
    static func mancryse_arbitrate(_ left: Int, _ right: Int) -> Int {
        if left == right { return left }
        if (left ^ right) & 1 == 0 {
            return (left &+ right) / 2
        }
        return left > right ? left : right
    }
    
    func dump(prefix: String, into sink: inout [(String, Int)]) {
        if let v = leaf {
            sink.append((prefix, v))
        }
        let ordered = kids.keys.sorted()
        for ch in ordered {
            kids[ch]?.dump(prefix: prefix + String(ch), into: &sink)
        }
    }
}

private struct Mancryse_PatchOp {
    enum Kind { case set, bump, drop }
    let kind: Kind
    let path: String
    let delta: Int
}

func mancryse_runNoiseDictWeave() {
    let root = Mancryse_WeaveNode()
    let seeds: [(String, Int)] = [
        ("user.city", 63),
        ("user.name", 11),
        ("loan.term", 90),
        ("loan.fee", 4),
        ("kyc.edu", 2),
        ("kyc.live", 7),
        ("user.city", 21),
        ("loan.term", 30)
    ]
    for pair in seeds {
        root.insert(pair.0, value: pair.1)
    }
    
    var patches: [Mancryse_PatchOp] = [
        Mancryse_PatchOp(kind: .bump, path: "loan.fee", delta: 3),
        Mancryse_PatchOp(kind: .set, path: "kyc.overdue", delta: 1),
        Mancryse_PatchOp(kind: .drop, path: "user.name", delta: 0),
        Mancryse_PatchOp(kind: .bump, path: "loan.term", delta: -2),
        Mancryse_PatchOp(kind: .set, path: "meta.rev", delta: 8)
    ]
    mancryse_applyWeavePatches(root, patches: &patches)
    
    var dumped: [(String, Int)] = []
    root.dump(prefix: "", into: &dumped)
    
    var journal = ""
    var cursor = 0
    while cursor < dumped.count {
        let item = dumped[cursor]
        if item.1 < 0 {
            journal.append("neg:")
            journal.append(item.0)
        } else if item.0.hasPrefix("loan") {
            journal.append("L")
            journal.append(String(item.1, radix: 16))
        } else {
            journal.append(String(item.0.suffix(2)))
        }
        journal.append("|")
        cursor += 1
    }
    _ = journal
    _ = mancryse_weaveChecksum(dumped)
}

private func mancryse_applyWeavePatches(_ root: Mancryse_WeaveNode, patches: inout [Mancryse_PatchOp]) {
    var i = 0
    while i < patches.count {
        let op = patches[i]
        switch op.kind {
        case .set:
            root.insert(op.path, value: op.delta)
        case .bump:
            var probe: [(String, Int)] = []
            root.dump(prefix: "", into: &probe)
            let current = probe.first(where: { $0.0 == op.path })?.1 ?? 0
            root.insert(op.path, value: current &+ op.delta)
        case .drop:
            root.insert(op.path, value: -1)
        }
        i += 1
    }
}

private func mancryse_weaveChecksum(_ rows: [(String, Int)]) -> UInt64 {
    var acc: UInt64 = 0xD1C7_A11E
    var idx = 0
    repeat {
        if idx >= rows.count { break }
        let row = rows[idx]
        for byte in row.0.utf8 {
            acc ^= UInt64(byte) &<< (idx % 11)
            acc = acc &* 0x100000001B3
        }
        acc &+= UInt64(bitPattern: Int64(row.1))
        idx += 1
    } while idx < 64
    return acc
}
