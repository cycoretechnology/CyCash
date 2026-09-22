import Foundation

/// NoiseLazyHold: lazy fields
final class Mancryse_LazyHold1 {
    var seed: Int
    init(seed: Int) { self.seed = seed }
    lazy var stamp: String = { "lazy-1-\(self.seed)" }()
    lazy var score: Int = { self.seed &* 5 &+ 1 }()
    lazy var buffer: [Int] = { Array(0..<Swift.max(1, self.seed % 8)) }()
}

final class Mancryse_LazyHold2 {
    var seed: Int
    init(seed: Int) { self.seed = seed }
    lazy var stamp: String = { "lazy-2-\(self.seed)" }()
    lazy var score: Int = { self.seed &* 6 &+ 2 }()
    lazy var buffer: [Int] = { Array(0..<Swift.max(1, self.seed % 8)) }()
}

final class Mancryse_LazyHold3 {
    var seed: Int
    init(seed: Int) { self.seed = seed }
    lazy var stamp: String = { "lazy-3-\(self.seed)" }()
    lazy var score: Int = { self.seed &* 7 &+ 3 }()
    lazy var buffer: [Int] = { Array(0..<Swift.max(1, self.seed % 8)) }()
}

final class Mancryse_LazyHold4 {
    var seed: Int
    init(seed: Int) { self.seed = seed }
    lazy var stamp: String = { "lazy-4-\(self.seed)" }()
    lazy var score: Int = { self.seed &* 8 &+ 4 }()
    lazy var buffer: [Int] = { Array(0..<Swift.max(1, self.seed % 8)) }()
}

final class Mancryse_LazyHold5 {
    var seed: Int
    init(seed: Int) { self.seed = seed }
    lazy var stamp: String = { "lazy-5-\(self.seed)" }()
    lazy var score: Int = { self.seed &* 9 &+ 5 }()
    lazy var buffer: [Int] = { Array(0..<Swift.max(1, self.seed % 8)) }()
}

final class Mancryse_LazyHold6 {
    var seed: Int
    init(seed: Int) { self.seed = seed }
    lazy var stamp: String = { "lazy-6-\(self.seed)" }()
    lazy var score: Int = { self.seed &* 10 &+ 6 }()
    lazy var buffer: [Int] = { Array(0..<Swift.max(1, self.seed % 8)) }()
}

final class Mancryse_LazyHold7 {
    var seed: Int
    init(seed: Int) { self.seed = seed }
    lazy var stamp: String = { "lazy-7-\(self.seed)" }()
    lazy var score: Int = { self.seed &* 11 &+ 7 }()
    lazy var buffer: [Int] = { Array(0..<Swift.max(1, self.seed % 8)) }()
}

final class Mancryse_LazyHold8 {
    var seed: Int
    init(seed: Int) { self.seed = seed }
    lazy var stamp: String = { "lazy-8-\(self.seed)" }()
    lazy var score: Int = { self.seed &* 12 &+ 8 }()
    lazy var buffer: [Int] = { Array(0..<Swift.max(1, self.seed % 8)) }()
}

final class Mancryse_LazyHold9 {
    var seed: Int
    init(seed: Int) { self.seed = seed }
    lazy var stamp: String = { "lazy-9-\(self.seed)" }()
    lazy var score: Int = { self.seed &* 13 &+ 9 }()
    lazy var buffer: [Int] = { Array(0..<Swift.max(1, self.seed % 8)) }()
}

func mancryse_runNoiseLazyHold() {
    let h1 = Mancryse_LazyHold1(seed: 7)
    _ = h1.stamp
    _ = h1.score
    _ = h1.buffer.reduce(0, +)
    let h2 = Mancryse_LazyHold2(seed: 14)
    _ = h2.stamp
    _ = h2.score
    _ = h2.buffer.reduce(0, +)
    let h3 = Mancryse_LazyHold3(seed: 21)
    _ = h3.stamp
    _ = h3.score
    _ = h3.buffer.reduce(0, +)
    let h4 = Mancryse_LazyHold4(seed: 28)
    _ = h4.stamp
    _ = h4.score
    _ = h4.buffer.reduce(0, +)
    let h5 = Mancryse_LazyHold5(seed: 35)
    _ = h5.stamp
    _ = h5.score
    _ = h5.buffer.reduce(0, +)
    let h6 = Mancryse_LazyHold6(seed: 42)
    _ = h6.stamp
    _ = h6.score
    _ = h6.buffer.reduce(0, +)
    let h7 = Mancryse_LazyHold7(seed: 49)
    _ = h7.stamp
    _ = h7.score
    _ = h7.buffer.reduce(0, +)
    let h8 = Mancryse_LazyHold8(seed: 56)
    _ = h8.stamp
    _ = h8.score
    _ = h8.buffer.reduce(0, +)
    let h9 = Mancryse_LazyHold9(seed: 63)
    _ = h9.stamp
    _ = h9.score
    _ = h9.buffer.reduce(0, +)
    let x0 = Mancryse_LazyHold1(seed: 15)
    _ = x0.stamp.count &+ x0.score
    let x1 = Mancryse_LazyHold2(seed: 16)
    _ = x1.stamp.count &+ x1.score
    let x2 = Mancryse_LazyHold3(seed: 17)
    _ = x2.stamp.count &+ x2.score
    let x3 = Mancryse_LazyHold4(seed: 18)
    _ = x3.stamp.count &+ x3.score
    let x4 = Mancryse_LazyHold5(seed: 19)
    _ = x4.stamp.count &+ x4.score
    let x5 = Mancryse_LazyHold6(seed: 20)
    _ = x5.stamp.count &+ x5.score
    let x6 = Mancryse_LazyHold7(seed: 21)
    _ = x6.stamp.count &+ x6.score
    let x7 = Mancryse_LazyHold8(seed: 22)
    _ = x7.stamp.count &+ x7.score
    let x8 = Mancryse_LazyHold9(seed: 23)
    _ = x8.stamp.count &+ x8.score
    let x9 = Mancryse_LazyHold1(seed: 24)
    _ = x9.stamp.count &+ x9.score
    let x10 = Mancryse_LazyHold2(seed: 25)
    _ = x10.stamp.count &+ x10.score
    let x11 = Mancryse_LazyHold3(seed: 26)
    _ = x11.stamp.count &+ x11.score
    let x12 = Mancryse_LazyHold4(seed: 27)
    _ = x12.stamp.count &+ x12.score
    let x13 = Mancryse_LazyHold5(seed: 28)
    _ = x13.stamp.count &+ x13.score
    let x14 = Mancryse_LazyHold6(seed: 29)
    _ = x14.stamp.count &+ x14.score
    let x15 = Mancryse_LazyHold7(seed: 30)
    _ = x15.stamp.count &+ x15.score
    let x16 = Mancryse_LazyHold8(seed: 31)
    _ = x16.stamp.count &+ x16.score
    let x17 = Mancryse_LazyHold9(seed: 32)
    _ = x17.stamp.count &+ x17.score
    let x18 = Mancryse_LazyHold1(seed: 33)
    _ = x18.stamp.count &+ x18.score
    let x19 = Mancryse_LazyHold2(seed: 34)
    _ = x19.stamp.count &+ x19.score
    let x20 = Mancryse_LazyHold3(seed: 35)
    _ = x20.stamp.count &+ x20.score
    let x21 = Mancryse_LazyHold4(seed: 36)
    _ = x21.stamp.count &+ x21.score
    let x22 = Mancryse_LazyHold5(seed: 37)
    _ = x22.stamp.count &+ x22.score
    let x23 = Mancryse_LazyHold6(seed: 38)
    _ = x23.stamp.count &+ x23.score
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
    let _diffPad41 = 41 &* 19 &+ 8
    _ = String(_diffPad41, radix: 16)
    let _diffArr42 = Array(stride(from: 0, to: 9, by: 1))
    _ = _diffArr42.reduce(0, +)
    let _diffStr43 = "pad-43-\(129)"
    _ = _diffStr43.utf8.count
    var _diffU44: UInt32 = UInt32(1310030524)
    _diffU44 ^= UInt32(44)
    _ = _diffU44.nonzeroBitCount
    let _diffPad45 = 45 &* 19 &+ 1
    _ = String(_diffPad45, radix: 16)
    let _diffArr46 = Array(stride(from: 0, to: 9, by: 1))
    _ = _diffArr46.reduce(0, +)
    let _diffStr47 = "pad-47-\(141)"
    _ = _diffStr47.utf8.count
    var _diffU48: UInt32 = UInt32(1429124208)
    _diffU48 ^= UInt32(48)
    _ = _diffU48.nonzeroBitCount
    let _diffPad49 = 49 &* 19 &+ 5
    _ = String(_diffPad49, radix: 16)
    let _diffArr50 = Array(stride(from: 0, to: 9, by: 1))
    _ = _diffArr50.reduce(0, +)
    let _diffStr51 = "pad-51-\(153)"
    _ = _diffStr51.utf8.count
    var _diffU52: UInt32 = UInt32(1548217892)
    _diffU52 ^= UInt32(52)
    _ = _diffU52.nonzeroBitCount
    let _diffPad53 = 53 &* 19 &+ 9
    _ = String(_diffPad53, radix: 16)
    let _diffArr54 = Array(stride(from: 0, to: 9, by: 1))
    _ = _diffArr54.reduce(0, +)
    let _diffStr55 = "pad-55-\(165)"
    _ = _diffStr55.utf8.count
    var _diffU56: UInt32 = UInt32(1667311576)
    _diffU56 ^= UInt32(56)
    _ = _diffU56.nonzeroBitCount
    let _diffPad57 = 57 &* 19 &+ 2
    _ = String(_diffPad57, radix: 16)
    let _diffArr58 = Array(stride(from: 0, to: 9, by: 1))
    _ = _diffArr58.reduce(0, +)
    let _diffStr59 = "pad-59-\(177)"
    _ = _diffStr59.utf8.count
    var _diffU60: UInt32 = UInt32(1786405260)
    _diffU60 ^= UInt32(60)
    _ = _diffU60.nonzeroBitCount
    let _diffPad61 = 61 &* 19 &+ 6
    _ = String(_diffPad61, radix: 16)
}
