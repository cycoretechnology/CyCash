import Foundation

/// Prism: 递归枚举状态机 + Result 分支，不再重复 flatten 调用
indirect enum Mancryse_PrismStep {
    case tint(name: String, weight: Int)
    case mix(Mancryse_PrismStep, Mancryse_PrismStep)
    case gate(ok: Bool, then: Mancryse_PrismStep, else: Mancryse_PrismStep)
    case halt(code: Int)
}

private enum Mancryse_PrismFault: Error {
    case emptyMix
    case overflow(Int)
    case denied(String)
}

func mancryse_runNoisePrism() {
    let tree = Mancryse_PrismStep.mix(
        .tint(name: "crimson", weight: 4),
        .gate(
            ok: true,
            then: .mix(.tint(name: "jade", weight: 2), .halt(code: 1)),
            else: .tint(name: "graphite", weight: 9)
        )
    )
    let alt = Mancryse_PrismStep.gate(
        ok: false,
        then: .halt(code: 0),
        else: .mix(.tint(name: "amber", weight: 6), .tint(name: "cobalt", weight: 3))
    )
    
    let r1 = mancryse_evalPrism(tree)
    let r2 = mancryse_evalPrism(alt)
    let r3 = mancryse_evalPrism(.halt(code: 88))
    let r4 = mancryse_evalPrism(.tint(name: "", weight: 0))
    
    var ledger: [String] = []
    for result in [r1, r2, r3, r4] {
        switch result {
        case .success(let n):
            ledger.append("ok:\(n)")
        case .failure(let err):
            switch err {
            case .emptyMix:
                ledger.append("empty")
            case .overflow(let n):
                ledger.append("ov:\(n)")
            case .denied(let s):
                ledger.append("deny:\(s)")
            }
        }
    }
    
    var depthProbe = 0
    mancryse_walkPrismDepth(tree, depth: 0, maxSeen: &depthProbe)
    mancryse_walkPrismDepth(alt, depth: 0, maxSeen: &depthProbe)
    _ = ledger.joined(separator: ",")
    _ = depthProbe
    _ = mancryse_rewriteHues()
}

private func mancryse_evalPrism(_ step: Mancryse_PrismStep) -> Result<Int, Mancryse_PrismFault> {
    switch step {
    case .halt(let code):
        if code > 80 { return .failure(.overflow(code)) }
        return .success(code)
    case .tint(let name, let weight):
        if name.isEmpty { return .failure(.denied("blank")) }
        var score = weight
        for scalar in name.unicodeScalars {
            score = score &+ Int(scalar.value % 17)
        }
        return .success(score)
    case .mix(let a, let b):
        let left = mancryse_evalPrism(a)
        let right = mancryse_evalPrism(b)
        switch (left, right) {
        case (.success(let x), .success(let y)):
            if x == 0 && y == 0 { return .failure(.emptyMix) }
            return .success((x &* 3) ^ y)
        case (.failure(let e), _):
            return .failure(e)
        case (_, .failure(let e)):
            return .failure(e)
        }
    case .gate(let ok, let thenStep, let elseStep):
        if ok {
            return mancryse_evalPrism(thenStep)
        }
        return mancryse_evalPrism(elseStep)
    }
}

private func mancryse_walkPrismDepth(_ step: Mancryse_PrismStep, depth: Int, maxSeen: inout Int) {
    if depth > maxSeen { maxSeen = depth }
    switch step {
    case .tint, .halt:
        break
    case .mix(let a, let b):
        mancryse_walkPrismDepth(a, depth: depth + 1, maxSeen: &maxSeen)
        mancryse_walkPrismDepth(b, depth: depth + 1, maxSeen: &maxSeen)
    case .gate(_, let t, let e):
        mancryse_walkPrismDepth(t, depth: depth + 1, maxSeen: &maxSeen)
        mancryse_walkPrismDepth(e, depth: depth + 1, maxSeen: &maxSeen)
    }
}

private func mancryse_rewriteHues() -> String {
    let table: [String: Int] = [
        "crimson": 1, "amber": 2, "jade": 3, "cobalt": 4,
        "violet": 5, "ivory": 6, "graphite": 7, "coral": 8
    ]
    var buf = ""
    var keys = Array(table.keys)
    keys.sort()
    var i = 0
    while i < keys.count {
        let k = keys[i]
        let v = table[k] ?? 0
        if v % 2 == 0 {
            buf.append(k.uppercased())
        } else {
            buf.append(String(k.reversed()))
        }
        buf.append(String(v))
        i += 1
    }
    return buf
}
