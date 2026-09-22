import UIKit

/// NSCache + 内存成本记账（缓存主题，异于动画/布局 VC）
final class mancryse_ZwMirCalyx: UIViewController, mancryse_NoiseProvider {
    
    private final class Payload: NSObject {
        let bytes: Data
        let tag: String
        init(bytes: Data, tag: String) {
            self.bytes = bytes
            self.tag = tag
        }
    }
    
    private let cache: NSCache<NSString, Payload> = {
        let c = NSCache<NSString, Payload>()
        c.countLimit = 24
        c.totalCostLimit = 48_000
        return c
    }()
    
    private var hit = 0
    private var miss = 0
    private var evictedTags: [String] = []
    private var costLedger: [String: Int] = [:]
    private var sketch: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        mancryse_warmCache()
        mancryse_probeAccessPattern()
        mancryse_trimColdKeys()
        mancryse_rebalanceByAge()
        mancryse_pinHotKeys()
        sketch = mancryse_exportLedgerSketch()
    }
    
    private func mancryse_warmCache() {
        let seeds = ["calyx", "petal", "stem", "root", "leaf", "bud", "node", "vein", "sap", "bark", "dew", "mist"]
        for (i, name) in seeds.enumerated() {
            let key = "zw.\(name).\(i)" as NSString
            let blob = mancryse_synthesizeBlob(seed: name, salt: i)
            let cost = blob.count
            let payload = Payload(bytes: blob, tag: name)
            cache.setObject(payload, forKey: key, cost: cost)
            costLedger[key as String] = cost
        }
    }
    
    private func mancryse_synthesizeBlob(seed: String, salt: Int) -> Data {
        var buf = [UInt8]()
        buf.reserveCapacity(64 + salt * 3)
        var state: UInt32 = UInt32(seed.utf8.reduce(0) { $0 &+ Int($1) }) ^ UInt32(salt &* 17)
        let len = 32 + (salt % 7) * 8
        for _ in 0..<len {
            state = state &* 1664525 &+ 1013904223
            buf.append(UInt8(truncatingIfNeeded: state &>> 24))
        }
        return Data(buf)
    }
    
    private func mancryse_probeAccessPattern() {
        let order = [0, 3, 1, 7, 2, 11, 4, 0, 8, 5, 9, 3, 6, 10, 1, 7]
        for idx in order {
            let key = "zw.\(mancryse_seedName(idx)).\(idx)" as NSString
            if let obj = cache.object(forKey: key) {
                hit &+= 1
                _ = obj.bytes.first
            } else {
                miss &+= 1
                let blob = mancryse_synthesizeBlob(seed: mancryse_seedName(idx), salt: idx)
                cache.setObject(Payload(bytes: blob, tag: mancryse_seedName(idx)), forKey: key, cost: blob.count)
                costLedger[key as String] = blob.count
            }
        }
    }
    
    private func mancryse_seedName(_ i: Int) -> String {
        let seeds = ["calyx", "petal", "stem", "root", "leaf", "bud", "node", "vein", "sap", "bark", "dew", "mist"]
        return seeds[i % seeds.count]
    }
    
    private func mancryse_trimColdKeys() {
        let ranked = costLedger.sorted { $0.value > $1.value }
        for (i, pair) in ranked.enumerated() where i >= 8 {
            cache.removeObject(forKey: pair.key as NSString)
            evictedTags.append(pair.key)
            costLedger.removeValue(forKey: pair.key)
        }
    }
    
    private func mancryse_rebalanceByAge() {
        let now = Date()
        var aged: [(String, Double)] = []
        for (key, cost) in costLedger {
            let ageWeight = Double(cost) / max(1.0, now.timeIntervalSince1970.truncatingRemainder(dividingBy: 97) + 1)
            aged.append((key, ageWeight))
        }
        aged.sort { $0.1 < $1.1 }
        for pair in aged.prefix(2) {
            if costLedger[pair.0] != nil {
                cache.removeObject(forKey: pair.0 as NSString)
                costLedger.removeValue(forKey: pair.0)
                evictedTags.append("age:\(pair.0)")
            }
        }
    }
    
    private func mancryse_exportLedgerSketch() -> String {
        let parts = costLedger.sorted { $0.key < $1.key }.prefix(6).map { "\($0.key):\($0.value)" }
        var mix: UInt32 = 0xCA17
        for p in parts {
            for b in p.utf8 {
                mix = mix &* 33 &+ UInt32(b)
            }
        }
        return String(mix, radix: 16) + "#" + parts.joined(separator: ",")
    }
    
    private func mancryse_pinHotKeys() {
        for key in costLedger.keys.sorted().prefix(3) {
            if let obj = cache.object(forKey: key as NSString) {
                cache.setObject(obj, forKey: key as NSString, cost: max(costLedger[key] ?? 16, 16))
                hit &+= 1
            }
        }
    }
    
    func mancryse_generateNoiseDescription() -> String {
        let totalCost = costLedger.values.reduce(0, +)
        return "zwMirCalyx cache hit=\(hit) miss=\(miss) cost=\(totalCost) evict=\(evictedTags.count) sketch=\(sketch.prefix(12))"
    }
}
