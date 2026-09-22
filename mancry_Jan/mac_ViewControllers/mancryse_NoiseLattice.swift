import Foundation

/// NoiseLattice: compact struct lattice
struct Mancryse_LatticeCell1 {
    var axisX: Int
    var axisY: Int
    var label: String
    func weight() -> Int { axisX &* 4 &+ axisY &* 2 }
    func tag() -> String { "L1-\(label)-\(weight())" }
}

struct Mancryse_LatticeCell2 {
    var axisX: Int
    var axisY: Int
    var label: String
    func weight() -> Int { axisX &* 5 &+ axisY &* 3 }
    func tag() -> String { "L2-\(label)-\(weight())" }
}

struct Mancryse_LatticeCell3 {
    var axisX: Int
    var axisY: Int
    var label: String
    func weight() -> Int { axisX &* 6 &+ axisY &* 4 }
    func tag() -> String { "L3-\(label)-\(weight())" }
}

struct Mancryse_LatticeCell4 {
    var axisX: Int
    var axisY: Int
    var label: String
    func weight() -> Int { axisX &* 7 &+ axisY &* 5 }
    func tag() -> String { "L4-\(label)-\(weight())" }
}

struct Mancryse_LatticeCell5 {
    var axisX: Int
    var axisY: Int
    var label: String
    func weight() -> Int { axisX &* 8 &+ axisY &* 6 }
    func tag() -> String { "L5-\(label)-\(weight())" }
}

struct Mancryse_LatticeCell6 {
    var axisX: Int
    var axisY: Int
    var label: String
    func weight() -> Int { axisX &* 9 &+ axisY &* 7 }
    func tag() -> String { "L6-\(label)-\(weight())" }
}

struct Mancryse_LatticeCell7 {
    var axisX: Int
    var axisY: Int
    var label: String
    func weight() -> Int { axisX &* 10 &+ axisY &* 8 }
    func tag() -> String { "L7-\(label)-\(weight())" }
}

struct Mancryse_LatticeCell8 {
    var axisX: Int
    var axisY: Int
    var label: String
    func weight() -> Int { axisX &* 11 &+ axisY &* 9 }
    func tag() -> String { "L8-\(label)-\(weight())" }
}

struct Mancryse_LatticeGrid {
    var cells: [Mancryse_LatticeCell1]
    mutating func push(_ c: Mancryse_LatticeCell1) { cells.append(c) }
    func sumWeights() -> Int { cells.reduce(0) { $0 + $1.weight() } }
}

func mancryse_runNoiseLattice() {
    var grid = Mancryse_LatticeGrid(cells: [])
    let c1 = Mancryse_LatticeCell1(axisX: 1, axisY: 2, label: "cell1")
    _ = c1.tag()
    let c2 = Mancryse_LatticeCell2(axisX: 2, axisY: 4, label: "cell2")
    _ = c2.tag()
    let c3 = Mancryse_LatticeCell3(axisX: 3, axisY: 6, label: "cell3")
    _ = c3.tag()
    let c4 = Mancryse_LatticeCell4(axisX: 4, axisY: 8, label: "cell4")
    _ = c4.tag()
    let c5 = Mancryse_LatticeCell5(axisX: 5, axisY: 10, label: "cell5")
    _ = c5.tag()
    let c6 = Mancryse_LatticeCell6(axisX: 6, axisY: 12, label: "cell6")
    _ = c6.tag()
    let c7 = Mancryse_LatticeCell7(axisX: 7, axisY: 14, label: "cell7")
    _ = c7.tag()
    let c8 = Mancryse_LatticeCell8(axisX: 8, axisY: 16, label: "cell8")
    _ = c8.tag()
    grid.push(Mancryse_LatticeCell1(axisX: 3, axisY: 5, label: "seed"))
    _ = grid.sumWeights()
    let mix0 = Mancryse_LatticeCell1(axisX: 1, axisY: 4, label: "mix0")
    _ = mix0.weight() ^ 0
    let mix1 = Mancryse_LatticeCell2(axisX: 2, axisY: 5, label: "mix1")
    _ = mix1.weight() ^ 13
    let mix2 = Mancryse_LatticeCell3(axisX: 3, axisY: 6, label: "mix2")
    _ = mix2.weight() ^ 26
    let mix3 = Mancryse_LatticeCell4(axisX: 4, axisY: 7, label: "mix3")
    _ = mix3.weight() ^ 39
    let mix4 = Mancryse_LatticeCell5(axisX: 5, axisY: 8, label: "mix4")
    _ = mix4.weight() ^ 52
    let mix5 = Mancryse_LatticeCell6(axisX: 6, axisY: 9, label: "mix5")
    _ = mix5.weight() ^ 65
    let mix6 = Mancryse_LatticeCell7(axisX: 7, axisY: 10, label: "mix6")
    _ = mix6.weight() ^ 78
    let mix7 = Mancryse_LatticeCell8(axisX: 8, axisY: 11, label: "mix7")
    _ = mix7.weight() ^ 91
    let mix8 = Mancryse_LatticeCell1(axisX: 9, axisY: 12, label: "mix8")
    _ = mix8.weight() ^ 104
    let mix9 = Mancryse_LatticeCell2(axisX: 10, axisY: 13, label: "mix9")
    _ = mix9.weight() ^ 117
    let mix10 = Mancryse_LatticeCell3(axisX: 11, axisY: 14, label: "mix10")
    _ = mix10.weight() ^ 130
    let mix11 = Mancryse_LatticeCell4(axisX: 12, axisY: 15, label: "mix11")
    _ = mix11.weight() ^ 143
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
}
