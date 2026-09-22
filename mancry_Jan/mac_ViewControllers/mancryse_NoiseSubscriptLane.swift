import Foundation

/// SubscriptLane: @dynamicMemberLookup 路由表，不再逐行 board[i]
@dynamicMemberLookup
private final class Mancryse_RouteBook {
    private var slots: [String: Int]
    
    init(_ pairs: [(String, Int)]) {
        var bag: [String: Int] = [:]
        for p in pairs { bag[p.0] = p.1 }
        slots = bag
    }
    
    subscript(dynamicMember name: String) -> Int {
        get { slots[name] ?? -9 }
        set { slots[name] = newValue }
    }
    
    subscript(_ key: String, or fallback: Int) -> Int {
        if let v = slots[key] { return v }
        slots[key] = fallback
        return fallback
    }
    
    func snapshotKeys() -> [String] {
        var out: [String] = []
        for k in slots.keys { out.append(k) }
        out.sort()
        return out
    }
}

private struct Mancryse_RingBuffer {
    private var data: [Int]
    private var head = 0
    private var count = 0
    
    init(capacity: Int) {
        data = Array(repeating: 0, count: max(2, capacity))
    }
    
    mutating func push(_ value: Int) {
        let idx = (head + count) % data.count
        if count == data.count {
            head = (head + 1) % data.count
            data[(head + count - 1) % data.count] = value
        } else {
            data[idx] = value
            count += 1
        }
    }
    
    func peek(_ offset: Int) -> Int? {
        if offset < 0 || offset >= count { return nil }
        return data[(head + offset) % data.count]
    }
    
    func foldXOR() -> Int {
        var x = 0
        var i = 0
        while i < count {
            x ^= peek(i) ?? 0
            i += 1
        }
        return x
    }
}

func mancryse_runNoiseSubscriptLane() {
    var book = Mancryse_RouteBook([
        ("alpha", 3), ("bravo", 8), ("charlie", 1), ("delta", 13), ("echo", 5)
    ])
    book.alpha = book.alpha &+ book.bravo
    book.delta = book[dynamicMember: "echo"] &* 2
    _ = book["foxtrot", or: 21]
    _ = book["golf", or: book.charlie]
    
    var ring = Mancryse_RingBuffer(capacity: 6)
    let keys = book.snapshotKeys()
    var k = 0
    while k < keys.count {
        let name = keys[k]
        let value = book[dynamicMember: name]
        ring.push(value)
        if value > 10 {
            ring.push(value &- 4)
        }
        k += 1
    }
    
    var transcript = ""
    var step = 0
    while let item = ring.peek(step) {
        transcript.append(String(item, radix: 16))
        transcript.append("-")
        step += 1
        if step > 20 { break }
    }
    _ = ring.foldXOR()
    _ = transcript
    _ = mancryse_laneConflictScan(book)
}

private func mancryse_laneConflictScan(_ book: Mancryse_RouteBook) -> Int {
    let names = book.snapshotKeys()
    var clashes = 0
    var i = 0
    while i < names.count {
        var j = i + 1
        while j < names.count {
            let a = book[dynamicMember: names[i]]
            let b = book[dynamicMember: names[j]]
            if a == b || (a ^ b) == 0 {
                clashes += 1
            } else if abs(a - b) < 3 {
                clashes += 2
            }
            j += 1
        }
        i += 1
    }
    return clashes
}
