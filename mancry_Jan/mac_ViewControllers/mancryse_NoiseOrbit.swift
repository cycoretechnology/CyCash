import Foundation

/// NoiseOrbit: class nodes with spin lanes
final class Mancryse_OrbitNode1 {
    private var spin: Int
    private var phase: Double
    init(spin: Int, phase: Double) { self.spin = spin; self.phase = phase }
    func nudge(_ d: Int) -> Int { spin &+= d; return spin }
    func orbitScore() -> Double { phase * Double(spin) + 1.0 }
    func dump() -> String { "O1:\(spin):\(phase)" }
}

final class Mancryse_OrbitNode2 {
    private var spin: Int
    private var phase: Double
    init(spin: Int, phase: Double) { self.spin = spin; self.phase = phase }
    func nudge(_ d: Int) -> Int { spin &+= d; return spin }
    func orbitScore() -> Double { phase * Double(spin) + 2.0 }
    func dump() -> String { "O2:\(spin):\(phase)" }
}

final class Mancryse_OrbitNode3 {
    private var spin: Int
    private var phase: Double
    init(spin: Int, phase: Double) { self.spin = spin; self.phase = phase }
    func nudge(_ d: Int) -> Int { spin &+= d; return spin }
    func orbitScore() -> Double { phase * Double(spin) + 3.0 }
    func dump() -> String { "O3:\(spin):\(phase)" }
}

final class Mancryse_OrbitNode4 {
    private var spin: Int
    private var phase: Double
    init(spin: Int, phase: Double) { self.spin = spin; self.phase = phase }
    func nudge(_ d: Int) -> Int { spin &+= d; return spin }
    func orbitScore() -> Double { phase * Double(spin) + 4.0 }
    func dump() -> String { "O4:\(spin):\(phase)" }
}

final class Mancryse_OrbitNode5 {
    private var spin: Int
    private var phase: Double
    init(spin: Int, phase: Double) { self.spin = spin; self.phase = phase }
    func nudge(_ d: Int) -> Int { spin &+= d; return spin }
    func orbitScore() -> Double { phase * Double(spin) + 5.0 }
    func dump() -> String { "O5:\(spin):\(phase)" }
}

final class Mancryse_OrbitNode6 {
    private var spin: Int
    private var phase: Double
    init(spin: Int, phase: Double) { self.spin = spin; self.phase = phase }
    func nudge(_ d: Int) -> Int { spin &+= d; return spin }
    func orbitScore() -> Double { phase * Double(spin) + 6.0 }
    func dump() -> String { "O6:\(spin):\(phase)" }
}

final class Mancryse_OrbitNode7 {
    private var spin: Int
    private var phase: Double
    init(spin: Int, phase: Double) { self.spin = spin; self.phase = phase }
    func nudge(_ d: Int) -> Int { spin &+= d; return spin }
    func orbitScore() -> Double { phase * Double(spin) + 7.0 }
    func dump() -> String { "O7:\(spin):\(phase)" }
}

final class Mancryse_OrbitNode8 {
    private var spin: Int
    private var phase: Double
    init(spin: Int, phase: Double) { self.spin = spin; self.phase = phase }
    func nudge(_ d: Int) -> Int { spin &+= d; return spin }
    func orbitScore() -> Double { phase * Double(spin) + 8.0 }
    func dump() -> String { "O8:\(spin):\(phase)" }
}

final class Mancryse_OrbitNode9 {
    private var spin: Int
    private var phase: Double
    init(spin: Int, phase: Double) { self.spin = spin; self.phase = phase }
    func nudge(_ d: Int) -> Int { spin &+= d; return spin }
    func orbitScore() -> Double { phase * Double(spin) + 9.0 }
    func dump() -> String { "O9:\(spin):\(phase)" }
}

func mancryse_runNoiseOrbit() {
    let n1 = Mancryse_OrbitNode1(spin: 3, phase: 1.25)
    _ = n1.nudge(1)
    _ = n1.orbitScore()
    _ = n1.dump()
    let n2 = Mancryse_OrbitNode2(spin: 6, phase: 2.25)
    _ = n2.nudge(2)
    _ = n2.orbitScore()
    _ = n2.dump()
    let n3 = Mancryse_OrbitNode3(spin: 9, phase: 3.25)
    _ = n3.nudge(3)
    _ = n3.orbitScore()
    _ = n3.dump()
    let n4 = Mancryse_OrbitNode4(spin: 12, phase: 4.25)
    _ = n4.nudge(4)
    _ = n4.orbitScore()
    _ = n4.dump()
    let n5 = Mancryse_OrbitNode5(spin: 15, phase: 5.25)
    _ = n5.nudge(5)
    _ = n5.orbitScore()
    _ = n5.dump()
    let n6 = Mancryse_OrbitNode6(spin: 18, phase: 6.25)
    _ = n6.nudge(6)
    _ = n6.orbitScore()
    _ = n6.dump()
    let n7 = Mancryse_OrbitNode7(spin: 21, phase: 7.25)
    _ = n7.nudge(7)
    _ = n7.orbitScore()
    _ = n7.dump()
    let n8 = Mancryse_OrbitNode8(spin: 24, phase: 8.25)
    _ = n8.nudge(8)
    _ = n8.orbitScore()
    _ = n8.dump()
    let n9 = Mancryse_OrbitNode9(spin: 27, phase: 9.25)
    _ = n9.nudge(9)
    _ = n9.orbitScore()
    _ = n9.dump()
    let t0 = Mancryse_OrbitNode1(spin: 10, phase: Double(0) * 0.17)
    _ = t0.nudge(1) &+ Int(t0.orbitScore())
    let t1 = Mancryse_OrbitNode2(spin: 11, phase: Double(1) * 0.17)
    _ = t1.nudge(2) &+ Int(t1.orbitScore())
    let t2 = Mancryse_OrbitNode3(spin: 12, phase: Double(2) * 0.17)
    _ = t2.nudge(3) &+ Int(t2.orbitScore())
    let t3 = Mancryse_OrbitNode4(spin: 13, phase: Double(3) * 0.17)
    _ = t3.nudge(4) &+ Int(t3.orbitScore())
    let t4 = Mancryse_OrbitNode5(spin: 14, phase: Double(4) * 0.17)
    _ = t4.nudge(5) &+ Int(t4.orbitScore())
    let t5 = Mancryse_OrbitNode6(spin: 15, phase: Double(5) * 0.17)
    _ = t5.nudge(1) &+ Int(t5.orbitScore())
    let t6 = Mancryse_OrbitNode7(spin: 16, phase: Double(6) * 0.17)
    _ = t6.nudge(2) &+ Int(t6.orbitScore())
    let t7 = Mancryse_OrbitNode8(spin: 17, phase: Double(7) * 0.17)
    _ = t7.nudge(3) &+ Int(t7.orbitScore())
    let t8 = Mancryse_OrbitNode9(spin: 18, phase: Double(8) * 0.17)
    _ = t8.nudge(4) &+ Int(t8.orbitScore())
    let t9 = Mancryse_OrbitNode1(spin: 19, phase: Double(9) * 0.17)
    _ = t9.nudge(5) &+ Int(t9.orbitScore())
    let t10 = Mancryse_OrbitNode2(spin: 20, phase: Double(10) * 0.17)
    _ = t10.nudge(1) &+ Int(t10.orbitScore())
    let t11 = Mancryse_OrbitNode3(spin: 21, phase: Double(11) * 0.17)
    _ = t11.nudge(2) &+ Int(t11.orbitScore())
    let t12 = Mancryse_OrbitNode4(spin: 22, phase: Double(12) * 0.17)
    _ = t12.nudge(3) &+ Int(t12.orbitScore())
    let t13 = Mancryse_OrbitNode5(spin: 23, phase: Double(13) * 0.17)
    _ = t13.nudge(4) &+ Int(t13.orbitScore())
    let t14 = Mancryse_OrbitNode6(spin: 24, phase: Double(14) * 0.17)
    _ = t14.nudge(5) &+ Int(t14.orbitScore())
    let t15 = Mancryse_OrbitNode7(spin: 25, phase: Double(15) * 0.17)
    _ = t15.nudge(1) &+ Int(t15.orbitScore())
    let t16 = Mancryse_OrbitNode8(spin: 26, phase: Double(16) * 0.17)
    _ = t16.nudge(2) &+ Int(t16.orbitScore())
    let t17 = Mancryse_OrbitNode9(spin: 27, phase: Double(17) * 0.17)
    _ = t17.nudge(3) &+ Int(t17.orbitScore())
    let t18 = Mancryse_OrbitNode1(spin: 28, phase: Double(18) * 0.17)
    _ = t18.nudge(4) &+ Int(t18.orbitScore())
    let t19 = Mancryse_OrbitNode2(spin: 29, phase: Double(19) * 0.17)
    _ = t19.nudge(5) &+ Int(t19.orbitScore())
    let t20 = Mancryse_OrbitNode3(spin: 30, phase: Double(20) * 0.17)
    _ = t20.nudge(1) &+ Int(t20.orbitScore())
    let t21 = Mancryse_OrbitNode4(spin: 31, phase: Double(21) * 0.17)
    _ = t21.nudge(2) &+ Int(t21.orbitScore())
    let t22 = Mancryse_OrbitNode5(spin: 32, phase: Double(22) * 0.17)
    _ = t22.nudge(3) &+ Int(t22.orbitScore())
    let t23 = Mancryse_OrbitNode6(spin: 33, phase: Double(23) * 0.17)
    _ = t23.nudge(4) &+ Int(t23.orbitScore())
    let t24 = Mancryse_OrbitNode7(spin: 34, phase: Double(24) * 0.17)
    _ = t24.nudge(5) &+ Int(t24.orbitScore())
    let t25 = Mancryse_OrbitNode8(spin: 35, phase: Double(25) * 0.17)
    _ = t25.nudge(1) &+ Int(t25.orbitScore())
    let t26 = Mancryse_OrbitNode9(spin: 36, phase: Double(26) * 0.17)
    _ = t26.nudge(2) &+ Int(t26.orbitScore())
    let t27 = Mancryse_OrbitNode1(spin: 37, phase: Double(27) * 0.17)
    _ = t27.nudge(3) &+ Int(t27.orbitScore())
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
    _ = _diffU36.nonzeroBitCount
    let _diffPad37 = 37 &* 19 &+ 4
    _ = String(_diffPad37, radix: 16)
    let _diffArr38 = Array(stride(from: 0, to: 9, by: 1))
    _ = _diffArr38.reduce(0, +)
    let _diffStr39 = "pad-39-\(117)"
    _ = _diffStr39.utf8.count
    var _diffU40: UInt32 = UInt32(1190936840)
    _diffU40 ^= UInt32(40)
    _ = _diffU40.nonzeroBitCount
}
