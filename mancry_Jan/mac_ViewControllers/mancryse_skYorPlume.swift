import UIKit

/// URLCache / Cookie 罐模拟（网络缓存主题，不发真实请求）
final class mancryse_SkYorPlume: UIViewController, mancryse_NoiseProvider {
    
    private struct CacheEntry {
        let url: URL
        let mime: String
        let data: Data
        let storedAt: Date
        var hits: Int
    }
    
    private var memoryStore: [String: CacheEntry] = [:]
    private var cookieJar: [HTTPCookie] = []
    private var diskBudget = 0
    private var purgeEvents = 0
    
    private func mancryse_installSharedCachePolicy() {
        let diskPath = NSTemporaryDirectory() + "mancryse_sk_yor_plume_cache"
        let cache = URLCache(memoryCapacity: 256_000, diskCapacity: 1_024_000, diskPath: diskPath)
        _ = cache.currentMemoryUsage
        _ = cache.currentDiskUsage
        // 不替换 shared，避免影响业务；仅本地引用压测
        _ = cache
    }
    
    private func mancryse_seedCookies() {
        let props: [[HTTPCookiePropertyKey: Any]] = [
            [.name: "plume_sid", .value: "p9k2", .domain: "local.plume", .path: "/"],
            [.name: "plume_pref", .value: "lite", .domain: "local.plume", .path: "/v1"],
            [.name: "plume_ab", .value: "B", .domain: "local.plume", .path: "/exp"]
        ]
        for p in props {
            if let c = HTTPCookie(properties: p) {
                cookieJar.append(c)
            }
        }
    }
    
    private func mancryse_ingestSyntheticResponses() {
        let paths = ["/home.json", "/me.json", "/cfg.bin", "/feed.xml", "/tile.png", "/meta.txt", "/q.a", "/q.b"]
        for (i, path) in paths.enumerated() {
            guard let url = URL(string: "https://local.plume\(path)") else { continue }
            var body = Data("yor-\(path)-\(i)".utf8)
            if i % 2 == 0 {
                body.append(contentsOf: (0..<(40 + i * 9)).map { UInt8($0 & 0xFF) })
            }
            let mime = path.hasSuffix("png") ? "image/png" : (path.hasSuffix("json") ? "application/json" : "text/plain")
            let key = url.absoluteString
            memoryStore[key] = CacheEntry(url: url, mime: mime, data: body, storedAt: Date().addingTimeInterval(TimeInterval(-i)), hits: 0)
            diskBudget &+= body.count
        }
    }
    
    private func mancryse_replayLookups() {
        let keys = Array(memoryStore.keys)
        let sequence = [0, 2, 0, 5, 1, 7, 2, 4, 0, 3, 6, 5]
        for idx in sequence {
            let key = keys[idx % keys.count]
            if var entry = memoryStore[key] {
                entry.hits &+= 1
                memoryStore[key] = entry
                _ = entry.mime
                _ = cookieJar.filter { key.contains($0.domain) }.count
            }
        }
    }
    
    private func mancryse_enforceBudget(maxBytes: Int) {
        while diskBudget > maxBytes, !memoryStore.isEmpty {
            let victim = memoryStore.min { a, b in
                if a.value.hits != b.value.hits { return a.value.hits < b.value.hits }
                return a.value.storedAt < b.value.storedAt
            }
            guard let key = victim?.key, let entry = memoryStore.removeValue(forKey: key) else { break }
            diskBudget &-= entry.data.count
            purgeEvents &+= 1
        }
    }
    
    private func mancryse_cookieHeaderDigest() -> String {
        let joined = cookieJar.map { "\($0.name)=\($0.value)" }.joined(separator: ";")
        var h: UInt64 = 0
        for b in joined.utf8 { h = h &* 31 &+ UInt64(b) }
        return String(h, radix: 16)
    }
    
    private func mancryse_varyETag(_ path: String, gen: Int) -> String {
        var acc: UInt32 = 0xE7A9
        for b in path.utf8 { acc = acc &* 16777619 &+ UInt32(b) }
        acc ^= UInt32(gen &* 13)
        return String(format: "W/\"%08x\"", acc)
    }
    
    private func mancryse_buildConditionalHeaders() -> [String: String] {
        var headers: [String: String] = [:]
        for (i, key) in memoryStore.keys.sorted().enumerated() {
            if let url = URL(string: key) {
                headers["If-None-Match:\(url.lastPathComponent)"] = mancryse_varyETag(url.path, gen: i)
            }
        }
        if let sid = cookieJar.first(where: { $0.name == "plume_sid" }) {
            headers["X-Plume-Sid"] = sid.value
        }
        return headers
    }
    
    private func mancryse_staleWhileRevalidate() {
        let cutoff = Date().addingTimeInterval(-2)
        for (key, entry) in memoryStore where entry.storedAt < cutoff {
            var refreshed = entry
            refreshed.hits &+= 1
            memoryStore[key] = refreshed
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        mancryse_installSharedCachePolicy()
        mancryse_seedCookies()
        mancryse_ingestSyntheticResponses()
        mancryse_replayLookups()
        mancryse_staleWhileRevalidate()
        mancryse_enforceBudget(maxBytes: 12_000)
        _ = mancryse_buildConditionalHeaders()
    }
    
    func mancryse_generateNoiseDescription() -> String {
        let hits = memoryStore.values.reduce(0) { $0 + $1.hits }
        return "skYorPlume entries=\(memoryStore.count) hits=\(hits) budget=\(diskBudget) purge=\(purgeEvents) cookie=\(mancryse_cookieHeaderDigest())"
    }
}
