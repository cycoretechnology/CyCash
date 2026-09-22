import Foundation

/// NoiseDeferFlip: defer lanes
func mancryse_deferLane(_ seed: Int) -> Int {
    var box = seed
    defer { box &+= 1 }
    defer { box = box &* 2 }
    box &+= 3
    return box
}
func mancryse_runNoiseDeferFlip() {
    var flag0 = false
    defer { flag0.toggle() }
    let v0 = mancryse_deferLane(0)
    _ = v0 &+ (flag0 ? 0 : 1)
    var flag1 = false
    defer { flag1.toggle() }
    let v1 = mancryse_deferLane(1)
    _ = v1 &+ (flag1 ? 0 : 1)
    var flag2 = false
    defer { flag2.toggle() }
    let v2 = mancryse_deferLane(2)
    _ = v2 &+ (flag2 ? 0 : 1)
    var flag3 = false
    defer { flag3.toggle() }
    let v3 = mancryse_deferLane(3)
    _ = v3 &+ (flag3 ? 0 : 1)
    var flag4 = false
    defer { flag4.toggle() }
    let v4 = mancryse_deferLane(4)
    _ = v4 &+ (flag4 ? 0 : 1)
    var flag5 = false
    defer { flag5.toggle() }
    let v5 = mancryse_deferLane(5)
    _ = v5 &+ (flag5 ? 0 : 1)
    var flag6 = false
    defer { flag6.toggle() }
    let v6 = mancryse_deferLane(6)
    _ = v6 &+ (flag6 ? 0 : 1)
    var flag7 = false
    defer { flag7.toggle() }
    let v7 = mancryse_deferLane(7)
    _ = v7 &+ (flag7 ? 0 : 1)
    var flag8 = false
    defer { flag8.toggle() }
    let v8 = mancryse_deferLane(8)
    _ = v8 &+ (flag8 ? 0 : 1)
    var flag9 = false
    defer { flag9.toggle() }
    let v9 = mancryse_deferLane(9)
    _ = v9 &+ (flag9 ? 0 : 1)
    var flag10 = false
    defer { flag10.toggle() }
    let v10 = mancryse_deferLane(10)
    _ = v10 &+ (flag10 ? 0 : 1)
    var flag11 = false
    defer { flag11.toggle() }
    let v11 = mancryse_deferLane(11)
    _ = v11 &+ (flag11 ? 0 : 1)
    var flag12 = false
    defer { flag12.toggle() }
    let v12 = mancryse_deferLane(12)
    _ = v12 &+ (flag12 ? 0 : 1)
    var flag13 = false
    defer { flag13.toggle() }
    let v13 = mancryse_deferLane(13)
    _ = v13 &+ (flag13 ? 0 : 1)
    var flag14 = false
    defer { flag14.toggle() }
    let v14 = mancryse_deferLane(14)
    _ = v14 &+ (flag14 ? 0 : 1)
    var flag15 = false
    defer { flag15.toggle() }
    let v15 = mancryse_deferLane(15)
    _ = v15 &+ (flag15 ? 0 : 1)
    var flag16 = false
    defer { flag16.toggle() }
    let v16 = mancryse_deferLane(16)
    _ = v16 &+ (flag16 ? 0 : 1)
    var flag17 = false
    defer { flag17.toggle() }
    let v17 = mancryse_deferLane(17)
    _ = v17 &+ (flag17 ? 0 : 1)
    var flag18 = false
    defer { flag18.toggle() }
    let v18 = mancryse_deferLane(18)
    _ = v18 &+ (flag18 ? 0 : 1)
    var flag19 = false
    defer { flag19.toggle() }
    let v19 = mancryse_deferLane(19)
    _ = v19 &+ (flag19 ? 0 : 1)
    var flag20 = false
    defer { flag20.toggle() }
    let v20 = mancryse_deferLane(20)
    _ = v20 &+ (flag20 ? 0 : 1)
    var flag21 = false
    defer { flag21.toggle() }
    let v21 = mancryse_deferLane(21)
    _ = v21 &+ (flag21 ? 0 : 1)
    var flag22 = false
    defer { flag22.toggle() }
    let v22 = mancryse_deferLane(22)
    _ = v22 &+ (flag22 ? 0 : 1)
    var flag23 = false
    defer { flag23.toggle() }
    let v23 = mancryse_deferLane(23)
    _ = v23 &+ (flag23 ? 0 : 1)
    var flag24 = false
    defer { flag24.toggle() }
    let v24 = mancryse_deferLane(24)
    _ = v24 &+ (flag24 ? 0 : 1)
    var flag25 = false
    defer { flag25.toggle() }
    let v25 = mancryse_deferLane(25)
    _ = v25 &+ (flag25 ? 0 : 1)
    var flag26 = false
    defer { flag26.toggle() }
    let v26 = mancryse_deferLane(26)
    _ = v26 &+ (flag26 ? 0 : 1)
    var flag27 = false
    defer { flag27.toggle() }
    let v27 = mancryse_deferLane(27)
    _ = v27 &+ (flag27 ? 0 : 1)
    var trail: [Int] = []
    for i in 0..<18 {
        defer { trail.append(i) }
        _ = i &* i
    }
    _ = trail.reduce(0, +)
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
}
