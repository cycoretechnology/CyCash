import Foundation

/// NoiseOptionalGate: optional chains
func mancryse_runNoiseOptionalGate() {
    let a0: String? = (0 % 3 == 0) ? nil : "opt0"
    if let v = a0 { _ = v.uppercased() } else { _ = "nil0" }
    let b0: Int? = (0 % 4 == 0) ? nil : 0
    let c0 = b0.map { $0 &* 5 } ?? 0
    _ = c0
    _ = a0?.count ?? -1
    let a1: String? = (1 % 3 == 0) ? nil : "opt1"
    if let v = a1 { _ = v.uppercased() } else { _ = "nil1" }
    let b1: Int? = (1 % 4 == 0) ? nil : 2
    let c1 = b1.map { $0 &* 5 } ?? 1
    _ = c1
    _ = a1?.count ?? -1
    let a2: String? = (2 % 3 == 0) ? nil : "opt2"
    if let v = a2 { _ = v.uppercased() } else { _ = "nil2" }
    let b2: Int? = (2 % 4 == 0) ? nil : 4
    let c2 = b2.map { $0 &* 5 } ?? 2
    _ = c2
    _ = a2?.count ?? -1
    let a3: String? = (3 % 3 == 0) ? nil : "opt3"
    if let v = a3 { _ = v.uppercased() } else { _ = "nil3" }
    let b3: Int? = (3 % 4 == 0) ? nil : 6
    let c3 = b3.map { $0 &* 5 } ?? 3
    _ = c3
    _ = a3?.count ?? -1
    let a4: String? = (4 % 3 == 0) ? nil : "opt4"
    if let v = a4 { _ = v.uppercased() } else { _ = "nil4" }
    let b4: Int? = (4 % 4 == 0) ? nil : 8
    let c4 = b4.map { $0 &* 5 } ?? 4
    _ = c4
    _ = a4?.count ?? -1
    let a5: String? = (5 % 3 == 0) ? nil : "opt5"
    if let v = a5 { _ = v.uppercased() } else { _ = "nil5" }
    let b5: Int? = (5 % 4 == 0) ? nil : 10
    let c5 = b5.map { $0 &* 5 } ?? 5
    _ = c5
    _ = a5?.count ?? -1
    let a6: String? = (6 % 3 == 0) ? nil : "opt6"
    if let v = a6 { _ = v.uppercased() } else { _ = "nil6" }
    let b6: Int? = (6 % 4 == 0) ? nil : 12
    let c6 = b6.map { $0 &* 5 } ?? 6
    _ = c6
    _ = a6?.count ?? -1
    let a7: String? = (7 % 3 == 0) ? nil : "opt7"
    if let v = a7 { _ = v.uppercased() } else { _ = "nil7" }
    let b7: Int? = (7 % 4 == 0) ? nil : 14
    let c7 = b7.map { $0 &* 5 } ?? 7
    _ = c7
    _ = a7?.count ?? -1
    let a8: String? = (8 % 3 == 0) ? nil : "opt8"
    if let v = a8 { _ = v.uppercased() } else { _ = "nil8" }
    let b8: Int? = (8 % 4 == 0) ? nil : 16
    let c8 = b8.map { $0 &* 5 } ?? 8
    _ = c8
    _ = a8?.count ?? -1
    let a9: String? = (9 % 3 == 0) ? nil : "opt9"
    if let v = a9 { _ = v.uppercased() } else { _ = "nil9" }
    let b9: Int? = (9 % 4 == 0) ? nil : 18
    let c9 = b9.map { $0 &* 5 } ?? 9
    _ = c9
    _ = a9?.count ?? -1
    let a10: String? = (10 % 3 == 0) ? nil : "opt10"
    if let v = a10 { _ = v.uppercased() } else { _ = "nil10" }
    let b10: Int? = (10 % 4 == 0) ? nil : 20
    let c10 = b10.map { $0 &* 5 } ?? 10
    _ = c10
    _ = a10?.count ?? -1
    let a11: String? = (11 % 3 == 0) ? nil : "opt11"
    if let v = a11 { _ = v.uppercased() } else { _ = "nil11" }
    let b11: Int? = (11 % 4 == 0) ? nil : 22
    let c11 = b11.map { $0 &* 5 } ?? 11
    _ = c11
    _ = a11?.count ?? -1
    let a12: String? = (12 % 3 == 0) ? nil : "opt12"
    if let v = a12 { _ = v.uppercased() } else { _ = "nil12" }
    let b12: Int? = (12 % 4 == 0) ? nil : 24
    let c12 = b12.map { $0 &* 5 } ?? 12
    _ = c12
    _ = a12?.count ?? -1
    let a13: String? = (13 % 3 == 0) ? nil : "opt13"
    if let v = a13 { _ = v.uppercased() } else { _ = "nil13" }
    let b13: Int? = (13 % 4 == 0) ? nil : 26
    let c13 = b13.map { $0 &* 5 } ?? 13
    _ = c13
    _ = a13?.count ?? -1
    let a14: String? = (14 % 3 == 0) ? nil : "opt14"
    if let v = a14 { _ = v.uppercased() } else { _ = "nil14" }
    let b14: Int? = (14 % 4 == 0) ? nil : 28
    let c14 = b14.map { $0 &* 5 } ?? 14
    _ = c14
    _ = a14?.count ?? -1
    let a15: String? = (15 % 3 == 0) ? nil : "opt15"
    if let v = a15 { _ = v.uppercased() } else { _ = "nil15" }
    let b15: Int? = (15 % 4 == 0) ? nil : 30
    let c15 = b15.map { $0 &* 5 } ?? 15
    _ = c15
    _ = a15?.count ?? -1
    let a16: String? = (16 % 3 == 0) ? nil : "opt16"
    if let v = a16 { _ = v.uppercased() } else { _ = "nil16" }
    let b16: Int? = (16 % 4 == 0) ? nil : 32
    let c16 = b16.map { $0 &* 5 } ?? 16
    _ = c16
    _ = a16?.count ?? -1
    let a17: String? = (17 % 3 == 0) ? nil : "opt17"
    if let v = a17 { _ = v.uppercased() } else { _ = "nil17" }
    let b17: Int? = (17 % 4 == 0) ? nil : 34
    let c17 = b17.map { $0 &* 5 } ?? 17
    _ = c17
    _ = a17?.count ?? -1
    let a18: String? = (18 % 3 == 0) ? nil : "opt18"
    if let v = a18 { _ = v.uppercased() } else { _ = "nil18" }
    let b18: Int? = (18 % 4 == 0) ? nil : 36
    let c18 = b18.map { $0 &* 5 } ?? 18
    _ = c18
    _ = a18?.count ?? -1
    let a19: String? = (19 % 3 == 0) ? nil : "opt19"
    if let v = a19 { _ = v.uppercased() } else { _ = "nil19" }
    let b19: Int? = (19 % 4 == 0) ? nil : 38
    let c19 = b19.map { $0 &* 5 } ?? 19
    _ = c19
    _ = a19?.count ?? -1
    let a20: String? = (20 % 3 == 0) ? nil : "opt20"
    if let v = a20 { _ = v.uppercased() } else { _ = "nil20" }
    let b20: Int? = (20 % 4 == 0) ? nil : 40
    let c20 = b20.map { $0 &* 5 } ?? 20
    _ = c20
    _ = a20?.count ?? -1
    let a21: String? = (21 % 3 == 0) ? nil : "opt21"
    if let v = a21 { _ = v.uppercased() } else { _ = "nil21" }
    let b21: Int? = (21 % 4 == 0) ? nil : 42
    let c21 = b21.map { $0 &* 5 } ?? 21
    _ = c21
    _ = a21?.count ?? -1
    let a22: String? = (22 % 3 == 0) ? nil : "opt22"
    if let v = a22 { _ = v.uppercased() } else { _ = "nil22" }
    let b22: Int? = (22 % 4 == 0) ? nil : 44
    let c22 = b22.map { $0 &* 5 } ?? 22
    _ = c22
    _ = a22?.count ?? -1
    let a23: String? = (23 % 3 == 0) ? nil : "opt23"
    if let v = a23 { _ = v.uppercased() } else { _ = "nil23" }
    let b23: Int? = (23 % 4 == 0) ? nil : 46
    let c23 = b23.map { $0 &* 5 } ?? 23
    _ = c23
    _ = a23?.count ?? -1
    let a24: String? = (24 % 3 == 0) ? nil : "opt24"
    if let v = a24 { _ = v.uppercased() } else { _ = "nil24" }
    let b24: Int? = (24 % 4 == 0) ? nil : 48
    let c24 = b24.map { $0 &* 5 } ?? 24
    _ = c24
    _ = a24?.count ?? -1
    let a25: String? = (25 % 3 == 0) ? nil : "opt25"
    if let v = a25 { _ = v.uppercased() } else { _ = "nil25" }
    let b25: Int? = (25 % 4 == 0) ? nil : 50
    let c25 = b25.map { $0 &* 5 } ?? 25
    _ = c25
    _ = a25?.count ?? -1
    let a26: String? = (26 % 3 == 0) ? nil : "opt26"
    if let v = a26 { _ = v.uppercased() } else { _ = "nil26" }
    let b26: Int? = (26 % 4 == 0) ? nil : 52
    let c26 = b26.map { $0 &* 5 } ?? 26
    _ = c26
    _ = a26?.count ?? -1
    let a27: String? = (27 % 3 == 0) ? nil : "opt27"
    if let v = a27 { _ = v.uppercased() } else { _ = "nil27" }
    let b27: Int? = (27 % 4 == 0) ? nil : 54
    let c27 = b27.map { $0 &* 5 } ?? 27
    _ = c27
    _ = a27?.count ?? -1
    let a28: String? = (28 % 3 == 0) ? nil : "opt28"
    if let v = a28 { _ = v.uppercased() } else { _ = "nil28" }
    let b28: Int? = (28 % 4 == 0) ? nil : 56
    let c28 = b28.map { $0 &* 5 } ?? 28
    _ = c28
    _ = a28?.count ?? -1
    let a29: String? = (29 % 3 == 0) ? nil : "opt29"
    if let v = a29 { _ = v.uppercased() } else { _ = "nil29" }
    let b29: Int? = (29 % 4 == 0) ? nil : 58
    let c29 = b29.map { $0 &* 5 } ?? 29
    _ = c29
    _ = a29?.count ?? -1
    let a30: String? = (30 % 3 == 0) ? nil : "opt30"
    if let v = a30 { _ = v.uppercased() } else { _ = "nil30" }
    let b30: Int? = (30 % 4 == 0) ? nil : 60
    let c30 = b30.map { $0 &* 5 } ?? 30
    _ = c30
    _ = a30?.count ?? -1
    let a31: String? = (31 % 3 == 0) ? nil : "opt31"
    if let v = a31 { _ = v.uppercased() } else { _ = "nil31" }
    let b31: Int? = (31 % 4 == 0) ? nil : 62
    let c31 = b31.map { $0 &* 5 } ?? 31
    _ = c31
    _ = a31?.count ?? -1
    let nested: [[Int]?] = [Optional([1, 2]), nil, Optional([3, 4, 5])]
    _ = nested.compactMap { $0 }.flatMap { $0 }.reduce(0, +)
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
}
