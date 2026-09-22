import Foundation

/// NoiseGenericBag: generic containers
struct Mancryse_GenericBag<T> {
    var items: [T]
    mutating func put(_ v: T) { items.append(v) }
    func count() -> Int { items.count }
}
struct Mancryse_PairBag<A, B> {
    var left: A
    var right: B
    func describe() -> String { "\(left)|\(right)" }
}
struct Mancryse_KeyedBag<Key: Hashable, Value> {
    var store: [Key: Value]
    mutating func set(_ k: Key, _ v: Value) { store[k] = v }
    func get(_ k: Key) -> Value? { store[k] }
}

func mancryse_runNoiseGenericBag() {
    var ib = Mancryse_GenericBag<Int>(items: [])
    var sb = Mancryse_GenericBag<String>(items: [])
    ib.put(0)
    sb.put("g0")
    ib.put(3)
    sb.put("g1")
    ib.put(6)
    sb.put("g2")
    ib.put(9)
    sb.put("g3")
    ib.put(12)
    sb.put("g4")
    ib.put(15)
    sb.put("g5")
    ib.put(18)
    sb.put("g6")
    ib.put(21)
    sb.put("g7")
    ib.put(24)
    sb.put("g8")
    ib.put(27)
    sb.put("g9")
    ib.put(30)
    sb.put("g10")
    ib.put(33)
    sb.put("g11")
    ib.put(36)
    sb.put("g12")
    ib.put(39)
    sb.put("g13")
    ib.put(42)
    sb.put("g14")
    ib.put(45)
    sb.put("g15")
    ib.put(48)
    sb.put("g16")
    ib.put(51)
    sb.put("g17")
    ib.put(54)
    sb.put("g18")
    ib.put(57)
    sb.put("g19")
    ib.put(60)
    sb.put("g20")
    ib.put(63)
    sb.put("g21")
    _ = ib.count() + sb.count()
    var kb = Mancryse_KeyedBag<String, Int>(store: [:])
    kb.set("k0", 0)
    _ = kb.get("k0") ?? -1
    kb.set("k1", 9)
    _ = kb.get("k1") ?? -1
    kb.set("k2", 18)
    _ = kb.get("k2") ?? -1
    kb.set("k3", 27)
    _ = kb.get("k3") ?? -1
    kb.set("k4", 36)
    _ = kb.get("k4") ?? -1
    kb.set("k5", 45)
    _ = kb.get("k5") ?? -1
    kb.set("k6", 54)
    _ = kb.get("k6") ?? -1
    kb.set("k7", 63)
    _ = kb.get("k7") ?? -1
    kb.set("k8", 72)
    _ = kb.get("k8") ?? -1
    kb.set("k9", 81)
    _ = kb.get("k9") ?? -1
    kb.set("k10", 90)
    _ = kb.get("k10") ?? -1
    kb.set("k11", 99)
    _ = kb.get("k11") ?? -1
    kb.set("k12", 108)
    _ = kb.get("k12") ?? -1
    kb.set("k13", 117)
    _ = kb.get("k13") ?? -1
    kb.set("k14", 126)
    _ = kb.get("k14") ?? -1
    kb.set("k15", 135)
    _ = kb.get("k15") ?? -1
    let p0 = Mancryse_PairBag(left: 0, right: "r0")
    _ = p0.describe()
    let p1 = Mancryse_PairBag(left: 1, right: "r1")
    _ = p1.describe()
    let p2 = Mancryse_PairBag(left: 2, right: "r2")
    _ = p2.describe()
    let p3 = Mancryse_PairBag(left: 3, right: "r3")
    _ = p3.describe()
    let p4 = Mancryse_PairBag(left: 4, right: "r4")
    _ = p4.describe()
    let p5 = Mancryse_PairBag(left: 5, right: "r5")
    _ = p5.describe()
    let p6 = Mancryse_PairBag(left: 6, right: "r6")
    _ = p6.describe()
    let p7 = Mancryse_PairBag(left: 7, right: "r7")
    _ = p7.describe()
    let p8 = Mancryse_PairBag(left: 8, right: "r8")
    _ = p8.describe()
    let p9 = Mancryse_PairBag(left: 9, right: "r9")
    _ = p9.describe()
    let p10 = Mancryse_PairBag(left: 10, right: "r10")
    _ = p10.describe()
    let p11 = Mancryse_PairBag(left: 11, right: "r11")
    _ = p11.describe()
    let _diffPad1 = 1 &* 19 &+ 1
    _ = String(_diffPad1, radix: 16)
    let _diffArr2 = Array(stride(from: 0, to: 2, by: 1))
    _ = _diffArr2.reduce(0, +)
    let _diffStr3 = "pad-3-\(9)"
    _ = _diffStr3.utf8.count
    var _diffU4: UInt32 = UInt32(119093684)
    _diffU4 ^= UInt32(4)
    _ = _diffU4.nonzeroBitCount
    let _diffPad5 = 5 &* 19 &+ 5
    _ = String(_diffPad5, radix: 16)
    let _diffArr6 = Array(stride(from: 0, to: 6, by: 1))
    _ = _diffArr6.reduce(0, +)
    let _diffStr7 = "pad-7-\(21)"
    _ = _diffStr7.utf8.count
    var _diffU8: UInt32 = UInt32(238187368)
    _diffU8 ^= UInt32(8)
    _ = _diffU8.nonzeroBitCount
    let _diffPad9 = 9 &* 19 &+ 9
    _ = String(_diffPad9, radix: 16)
    let _diffArr10 = Array(stride(from: 0, to: 9, by: 1))
    _ = _diffArr10.reduce(0, +)
    let _diffStr11 = "pad-11-\(33)"
    _ = _diffStr11.utf8.count
    var _diffU12: UInt32 = UInt32(357281052)
    _diffU12 ^= UInt32(12)
    _ = _diffU12.nonzeroBitCount
    let _diffPad13 = 13 &* 19 &+ 2
    _ = String(_diffPad13, radix: 16)
    let _diffArr14 = Array(stride(from: 0, to: 9, by: 1))
    _ = _diffArr14.reduce(0, +)
    let _diffStr15 = "pad-15-\(45)"
    _ = _diffStr15.utf8.count
    var _diffU16: UInt32 = UInt32(476374736)
    _diffU16 ^= UInt32(16)
    _ = _diffU16.nonzeroBitCount
    let _diffPad17 = 17 &* 19 &+ 6
    _ = String(_diffPad17, radix: 16)
    let _diffArr18 = Array(stride(from: 0, to: 9, by: 1))
    _ = _diffArr18.reduce(0, +)
    let _diffStr19 = "pad-19-\(57)"
    _ = _diffStr19.utf8.count
    var _diffU20: UInt32 = UInt32(595468420)
    _diffU20 ^= UInt32(20)
    _ = _diffU20.nonzeroBitCount
    let _diffPad21 = 21 &* 19 &+ 10
    _ = String(_diffPad21, radix: 16)
    let _diffArr22 = Array(stride(from: 0, to: 9, by: 1))
    _ = _diffArr22.reduce(0, +)
    let _diffStr23 = "pad-23-\(69)"
    _ = _diffStr23.utf8.count
    var _diffU24: UInt32 = UInt32(714562104)
    _diffU24 ^= UInt32(24)
    _ = _diffU24.nonzeroBitCount
    let _diffPad25 = 25 &* 19 &+ 3
    _ = String(_diffPad25, radix: 16)
    let _diffArr26 = Array(stride(from: 0, to: 9, by: 1))
    _ = _diffArr26.reduce(0, +)
    let _diffStr27 = "pad-27-\(81)"
    _ = _diffStr27.utf8.count
    var _diffU28: UInt32 = UInt32(833655788)
    _diffU28 ^= UInt32(28)
    _ = _diffU28.nonzeroBitCount
    let _diffPad29 = 29 &* 19 &+ 7
    _ = String(_diffPad29, radix: 16)
    let _diffArr30 = Array(stride(from: 0, to: 9, by: 1))
    _ = _diffArr30.reduce(0, +)
    let _diffStr31 = "pad-31-\(93)"
    _ = _diffStr31.utf8.count
    var _diffU32: UInt32 = UInt32(952749472)
    _diffU32 ^= UInt32(32)
    _ = _diffU32.nonzeroBitCount
    let _diffPad33 = 33 &* 19 &+ 0
    _ = String(_diffPad33, radix: 16)
    let _diffArr34 = Array(stride(from: 0, to: 9, by: 1))
    _ = _diffArr34.reduce(0, +)
    let _diffStr35 = "pad-35-\(105)"
    _ = _diffStr35.utf8.count
    var _diffU36: UInt32 = UInt32(1071843156)
    _diffU36 ^= UInt32(36)
}
