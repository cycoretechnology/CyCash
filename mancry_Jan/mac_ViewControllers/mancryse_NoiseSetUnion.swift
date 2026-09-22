import Foundation

/// NoiseSetUnion: set algebra
func mancryse_runNoiseSetUnion() {
    var sA0: Set<Int> = Set(0..<(10))
    var sB0: Set<Int> = Set(4..<(15))
    let u0 = sA0.union(sB0)
    let inter0 = sA0.intersection(sB0)
    let sym0 = sA0.symmetricDifference(sB0)
    let sub0 = sA0.subtracting(sB0)
    _ = u0.count &+ inter0.count &+ sym0.count &+ sub0.count
    sA0.insert(100)
    _ = sA0.contains(0)
    var sA1: Set<Int> = Set(1..<(11))
    var sB1: Set<Int> = Set(5..<(16))
    let u1 = sA1.union(sB1)
    let inter1 = sA1.intersection(sB1)
    let sym1 = sA1.symmetricDifference(sB1)
    let sub1 = sA1.subtracting(sB1)
    _ = u1.count &+ inter1.count &+ sym1.count &+ sub1.count
    sA1.insert(101)
    _ = sA1.contains(1)
    var sA2: Set<Int> = Set(2..<(12))
    var sB2: Set<Int> = Set(6..<(17))
    let u2 = sA2.union(sB2)
    let inter2 = sA2.intersection(sB2)
    let sym2 = sA2.symmetricDifference(sB2)
    let sub2 = sA2.subtracting(sB2)
    _ = u2.count &+ inter2.count &+ sym2.count &+ sub2.count
    sA2.insert(102)
    _ = sA2.contains(2)
    var sA3: Set<Int> = Set(3..<(13))
    var sB3: Set<Int> = Set(7..<(18))
    let u3 = sA3.union(sB3)
    let inter3 = sA3.intersection(sB3)
    let sym3 = sA3.symmetricDifference(sB3)
    let sub3 = sA3.subtracting(sB3)
    _ = u3.count &+ inter3.count &+ sym3.count &+ sub3.count
    sA3.insert(103)
    _ = sA3.contains(3)
    var sA4: Set<Int> = Set(4..<(14))
    var sB4: Set<Int> = Set(8..<(19))
    let u4 = sA4.union(sB4)
    let inter4 = sA4.intersection(sB4)
    let sym4 = sA4.symmetricDifference(sB4)
    let sub4 = sA4.subtracting(sB4)
    _ = u4.count &+ inter4.count &+ sym4.count &+ sub4.count
    sA4.insert(104)
    _ = sA4.contains(4)
    var sA5: Set<Int> = Set(5..<(15))
    var sB5: Set<Int> = Set(9..<(20))
    let u5 = sA5.union(sB5)
    let inter5 = sA5.intersection(sB5)
    let sym5 = sA5.symmetricDifference(sB5)
    let sub5 = sA5.subtracting(sB5)
    _ = u5.count &+ inter5.count &+ sym5.count &+ sub5.count
    sA5.insert(105)
    _ = sA5.contains(5)
    var sA6: Set<Int> = Set(6..<(16))
    var sB6: Set<Int> = Set(10..<(21))
    let u6 = sA6.union(sB6)
    let inter6 = sA6.intersection(sB6)
    let sym6 = sA6.symmetricDifference(sB6)
    let sub6 = sA6.subtracting(sB6)
    _ = u6.count &+ inter6.count &+ sym6.count &+ sub6.count
    sA6.insert(106)
    _ = sA6.contains(6)
    var sA7: Set<Int> = Set(7..<(17))
    var sB7: Set<Int> = Set(11..<(22))
    let u7 = sA7.union(sB7)
    let inter7 = sA7.intersection(sB7)
    let sym7 = sA7.symmetricDifference(sB7)
    let sub7 = sA7.subtracting(sB7)
    _ = u7.count &+ inter7.count &+ sym7.count &+ sub7.count
    sA7.insert(107)
    _ = sA7.contains(7)
    var sA8: Set<Int> = Set(8..<(18))
    var sB8: Set<Int> = Set(12..<(23))
    let u8 = sA8.union(sB8)
    let inter8 = sA8.intersection(sB8)
    let sym8 = sA8.symmetricDifference(sB8)
    let sub8 = sA8.subtracting(sB8)
    _ = u8.count &+ inter8.count &+ sym8.count &+ sub8.count
    sA8.insert(108)
    _ = sA8.contains(8)
    var sA9: Set<Int> = Set(9..<(19))
    var sB9: Set<Int> = Set(13..<(24))
    let u9 = sA9.union(sB9)
    let inter9 = sA9.intersection(sB9)
    let sym9 = sA9.symmetricDifference(sB9)
    let sub9 = sA9.subtracting(sB9)
    _ = u9.count &+ inter9.count &+ sym9.count &+ sub9.count
    sA9.insert(109)
    _ = sA9.contains(9)
    var sA10: Set<Int> = Set(10..<(20))
    var sB10: Set<Int> = Set(14..<(25))
    let u10 = sA10.union(sB10)
    let inter10 = sA10.intersection(sB10)
    let sym10 = sA10.symmetricDifference(sB10)
    let sub10 = sA10.subtracting(sB10)
    _ = u10.count &+ inter10.count &+ sym10.count &+ sub10.count
    sA10.insert(110)
    _ = sA10.contains(10)
    var sA11: Set<Int> = Set(11..<(21))
    var sB11: Set<Int> = Set(15..<(26))
    let u11 = sA11.union(sB11)
    let inter11 = sA11.intersection(sB11)
    let sym11 = sA11.symmetricDifference(sB11)
    let sub11 = sA11.subtracting(sB11)
    _ = u11.count &+ inter11.count &+ sym11.count &+ sub11.count
    sA11.insert(111)
    _ = sA11.contains(11)
    var sA12: Set<Int> = Set(12..<(22))
    var sB12: Set<Int> = Set(16..<(27))
    let u12 = sA12.union(sB12)
    let inter12 = sA12.intersection(sB12)
    let sym12 = sA12.symmetricDifference(sB12)
    let sub12 = sA12.subtracting(sB12)
    _ = u12.count &+ inter12.count &+ sym12.count &+ sub12.count
    sA12.insert(112)
    _ = sA12.contains(12)
    var sA13: Set<Int> = Set(13..<(23))
    var sB13: Set<Int> = Set(17..<(28))
    let u13 = sA13.union(sB13)
    let inter13 = sA13.intersection(sB13)
    let sym13 = sA13.symmetricDifference(sB13)
    let sub13 = sA13.subtracting(sB13)
    _ = u13.count &+ inter13.count &+ sym13.count &+ sub13.count
    sA13.insert(113)
    _ = sA13.contains(13)
    var words: Set<String> = []
    words.insert("w0")
    words.insert("w1")
    words.insert("w2")
    words.insert("w3")
    words.insert("w4")
    words.insert("w5")
    words.insert("w6")
    words.insert("w7")
    words.insert("w8")
    words.insert("w9")
    words.insert("w10")
    words.insert("w11")
    words.insert("w12")
    words.insert("w13")
    words.insert("w14")
    words.insert("w15")
    words.insert("w16")
    words.insert("w17")
    _ = words.sorted().joined()
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
}
