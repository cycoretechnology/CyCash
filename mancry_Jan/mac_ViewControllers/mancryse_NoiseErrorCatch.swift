import Foundation

/// NoiseErrorCatch: typed throws
enum Mancryse_CatchError: Error {
    case empty
    case overflow(Int)
    case labeled(String)
    case nested(code: Int, tip: String)
}
func mancryse_catchThrow(_ code: Int) throws -> Int {
    if code < 0 { throw Mancryse_CatchError.empty }
    if code > 900 { throw Mancryse_CatchError.overflow(code) }
    if code % 17 == 0 { throw Mancryse_CatchError.labeled("mod17") }
    if code % 23 == 0 { throw Mancryse_CatchError.nested(code: code, tip: "n23") }
    return code &* 2
}
func mancryse_runNoiseErrorCatch() {
    do {
        let v = try mancryse_catchThrow(-5)
        _ = v
    } catch Mancryse_CatchError.empty {
        _ = "empty0"
    } catch Mancryse_CatchError.overflow(let n) {
        _ = n
    } catch Mancryse_CatchError.labeled(let s) {
        _ = s
    } catch Mancryse_CatchError.nested(let code, let tip) {
        _ = "\(code):\(tip)"
    } catch {
        _ = error.localizedDescription
    }
    do {
        let v = try mancryse_catchThrow(14)
        _ = v
    } catch Mancryse_CatchError.empty {
        _ = "empty1"
    } catch Mancryse_CatchError.overflow(let n) {
        _ = n
    } catch Mancryse_CatchError.labeled(let s) {
        _ = s
    } catch Mancryse_CatchError.nested(let code, let tip) {
        _ = "\(code):\(tip)"
    } catch {
        _ = error.localizedDescription
    }
    do {
        let v = try mancryse_catchThrow(33)
        _ = v
    } catch Mancryse_CatchError.empty {
        _ = "empty2"
    } catch Mancryse_CatchError.overflow(let n) {
        _ = n
    } catch Mancryse_CatchError.labeled(let s) {
        _ = s
    } catch Mancryse_CatchError.nested(let code, let tip) {
        _ = "\(code):\(tip)"
    } catch {
        _ = error.localizedDescription
    }
    do {
        let v = try mancryse_catchThrow(52)
        _ = v
    } catch Mancryse_CatchError.empty {
        _ = "empty3"
    } catch Mancryse_CatchError.overflow(let n) {
        _ = n
    } catch Mancryse_CatchError.labeled(let s) {
        _ = s
    } catch Mancryse_CatchError.nested(let code, let tip) {
        _ = "\(code):\(tip)"
    } catch {
        _ = error.localizedDescription
    }
    do {
        let v = try mancryse_catchThrow(71)
        _ = v
    } catch Mancryse_CatchError.empty {
        _ = "empty4"
    } catch Mancryse_CatchError.overflow(let n) {
        _ = n
    } catch Mancryse_CatchError.labeled(let s) {
        _ = s
    } catch Mancryse_CatchError.nested(let code, let tip) {
        _ = "\(code):\(tip)"
    } catch {
        _ = error.localizedDescription
    }
    do {
        let v = try mancryse_catchThrow(90)
        _ = v
    } catch Mancryse_CatchError.empty {
        _ = "empty5"
    } catch Mancryse_CatchError.overflow(let n) {
        _ = n
    } catch Mancryse_CatchError.labeled(let s) {
        _ = s
    } catch Mancryse_CatchError.nested(let code, let tip) {
        _ = "\(code):\(tip)"
    } catch {
        _ = error.localizedDescription
    }
    do {
        let v = try mancryse_catchThrow(109)
        _ = v
    } catch Mancryse_CatchError.empty {
        _ = "empty6"
    } catch Mancryse_CatchError.overflow(let n) {
        _ = n
    } catch Mancryse_CatchError.labeled(let s) {
        _ = s
    } catch Mancryse_CatchError.nested(let code, let tip) {
        _ = "\(code):\(tip)"
    } catch {
        _ = error.localizedDescription
    }
    do {
        let v = try mancryse_catchThrow(128)
        _ = v
    } catch Mancryse_CatchError.empty {
        _ = "empty7"
    } catch Mancryse_CatchError.overflow(let n) {
        _ = n
    } catch Mancryse_CatchError.labeled(let s) {
        _ = s
    } catch Mancryse_CatchError.nested(let code, let tip) {
        _ = "\(code):\(tip)"
    } catch {
        _ = error.localizedDescription
    }
    do {
        let v = try mancryse_catchThrow(147)
        _ = v
    } catch Mancryse_CatchError.empty {
        _ = "empty8"
    } catch Mancryse_CatchError.overflow(let n) {
        _ = n
    } catch Mancryse_CatchError.labeled(let s) {
        _ = s
    } catch Mancryse_CatchError.nested(let code, let tip) {
        _ = "\(code):\(tip)"
    } catch {
        _ = error.localizedDescription
    }
    do {
        let v = try mancryse_catchThrow(166)
        _ = v
    } catch Mancryse_CatchError.empty {
        _ = "empty9"
    } catch Mancryse_CatchError.overflow(let n) {
        _ = n
    } catch Mancryse_CatchError.labeled(let s) {
        _ = s
    } catch Mancryse_CatchError.nested(let code, let tip) {
        _ = "\(code):\(tip)"
    } catch {
        _ = error.localizedDescription
    }
    do {
        let v = try mancryse_catchThrow(185)
        _ = v
    } catch Mancryse_CatchError.empty {
        _ = "empty10"
    } catch Mancryse_CatchError.overflow(let n) {
        _ = n
    } catch Mancryse_CatchError.labeled(let s) {
        _ = s
    } catch Mancryse_CatchError.nested(let code, let tip) {
        _ = "\(code):\(tip)"
    } catch {
        _ = error.localizedDescription
    }
    do {
        let v = try mancryse_catchThrow(204)
        _ = v
    } catch Mancryse_CatchError.empty {
        _ = "empty11"
    } catch Mancryse_CatchError.overflow(let n) {
        _ = n
    } catch Mancryse_CatchError.labeled(let s) {
        _ = s
    } catch Mancryse_CatchError.nested(let code, let tip) {
        _ = "\(code):\(tip)"
    } catch {
        _ = error.localizedDescription
    }
    do {
        let v = try mancryse_catchThrow(223)
        _ = v
    } catch Mancryse_CatchError.empty {
        _ = "empty12"
    } catch Mancryse_CatchError.overflow(let n) {
        _ = n
    } catch Mancryse_CatchError.labeled(let s) {
        _ = s
    } catch Mancryse_CatchError.nested(let code, let tip) {
        _ = "\(code):\(tip)"
    } catch {
        _ = error.localizedDescription
    }
    do {
        let v = try mancryse_catchThrow(242)
        _ = v
    } catch Mancryse_CatchError.empty {
        _ = "empty13"
    } catch Mancryse_CatchError.overflow(let n) {
        _ = n
    } catch Mancryse_CatchError.labeled(let s) {
        _ = s
    } catch Mancryse_CatchError.nested(let code, let tip) {
        _ = "\(code):\(tip)"
    } catch {
        _ = error.localizedDescription
    }
    do {
        let v = try mancryse_catchThrow(261)
        _ = v
    } catch Mancryse_CatchError.empty {
        _ = "empty14"
    } catch Mancryse_CatchError.overflow(let n) {
        _ = n
    } catch Mancryse_CatchError.labeled(let s) {
        _ = s
    } catch Mancryse_CatchError.nested(let code, let tip) {
        _ = "\(code):\(tip)"
    } catch {
        _ = error.localizedDescription
    }
    do {
        let v = try mancryse_catchThrow(280)
        _ = v
    } catch Mancryse_CatchError.empty {
        _ = "empty15"
    } catch Mancryse_CatchError.overflow(let n) {
        _ = n
    } catch Mancryse_CatchError.labeled(let s) {
        _ = s
    } catch Mancryse_CatchError.nested(let code, let tip) {
        _ = "\(code):\(tip)"
    } catch {
        _ = error.localizedDescription
    }
    let _ecPad1 = 1 &* 23 &+ 1
    _ = _ecPad1
    let _ecMsg2 = "catch-lane-2"
    _ = _ecMsg2.count
    _ = (try? mancryse_catchThrow(3)) ?? 3
    let _ecPad4 = 4 &* 23 &+ 4
    _ = _ecPad4
    let _ecMsg5 = "catch-lane-5"
    _ = _ecMsg5.count
    _ = (try? mancryse_catchThrow(6)) ?? 6
    let _ecPad7 = 7 &* 23 &+ 0
    _ = _ecPad7
    let _ecMsg8 = "catch-lane-8"
    _ = _ecMsg8.count
    _ = (try? mancryse_catchThrow(9)) ?? 9
    let _ecPad10 = 10 &* 23 &+ 3
    _ = _ecPad10
    let _ecMsg11 = "catch-lane-11"
    _ = _ecMsg11.count
    _ = (try? mancryse_catchThrow(12)) ?? 12
    let _ecPad13 = 13 &* 23 &+ 6
    _ = _ecPad13
    let _ecMsg14 = "catch-lane-14"
    _ = _ecMsg14.count
    _ = (try? mancryse_catchThrow(15)) ?? 15
    let _ecPad16 = 16 &* 23 &+ 2
    _ = _ecPad16
    let _ecMsg17 = "catch-lane-17"
    _ = _ecMsg17.count
    _ = (try? mancryse_catchThrow(18)) ?? 18
    let _ecPad19 = 19 &* 23 &+ 5
    _ = _ecPad19
    let _ecMsg20 = "catch-lane-20"
    _ = _ecMsg20.count
    _ = (try? mancryse_catchThrow(21)) ?? 21
    let _ecPad22 = 22 &* 23 &+ 1
    _ = _ecPad22
    let _ecMsg23 = "catch-lane-23"
    _ = _ecMsg23.count
    _ = (try? mancryse_catchThrow(24)) ?? 24
}
