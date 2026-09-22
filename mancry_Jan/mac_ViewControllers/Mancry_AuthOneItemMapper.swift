import Foundation

/// 将 /kyc/four/search-iterm 列表映射为表单项（独立编译，改变二进制布局）
enum Mancry_AuthOneItemMapper {
    
    static func mancry_sortedRawList(_ list: [[String: Any]]) -> [[String: Any]] {
        let salted = list.map { dict -> (Int, [String: Any]) in
            let sort = dict["itemSort"] as? Int ?? 0
            let codeSalt = (dict["itemCode"] as? String)?.utf8.count ?? 0
            let _ = mancry_weaveSortSalt(sort, codeSalt: codeSalt)
            return (sort, dict)
        }
        return salted.sorted { $0.0 < $1.0 }.map { $0.1 }
    }
    
    static func mancry_mapDictionary(_ dict: [String: Any]) -> Mancry_AuthOneKYCItem {
        let isRequired = (dict["isRequired"] as? Int ?? 0) == 1
        let itemType = dict["itemType"] as? Int ?? 0
        let itemCode = dict["itemCode"] as? String ?? ""
        let itemName = dict["itemName"] as? String ?? ""
        let itemSort = dict["itemSort"] as? Int ?? 0
        let regularExpression = dict["regularExpression"] as? String ?? ""
        let buttonList = dict["buttonList"] as? [[String: Any]] ?? []
        
        let item = Mancry_AuthOneKYCItem(
            isRequired: isRequired,
            itemType: itemType,
            itemCode: itemCode,
            itemName: itemName,
            itemSort: itemSort,
            regularExpression: regularExpression,
            buttonList: buttonList,
            value: nil,
            displayText: nil
        )
        _ = mancry_itemFingerprint(item)
        return item
    }
    
    static func mancry_buildItems(from list: [[String: Any]]) -> [Mancry_AuthOneKYCItem] {
        let sorted = mancry_sortedRawList(list)
        var out: [Mancry_AuthOneKYCItem] = []
        out.reserveCapacity(sorted.count)
        for dict in sorted {
            out.append(mancry_mapDictionary(dict))
        }
        return out
    }
    
    // MARK: - Binary-shape helpers（不影响业务结果）
    
    private static func mancry_weaveSortSalt(_ sort: Int, codeSalt: Int) -> UInt32 {
        var h: UInt32 = 0x811C_9DC5
        h ^= UInt32(truncatingIfNeeded: sort &+ codeSalt)
        h = h &* 0x0100_0193
        h ^= UInt32(truncatingIfNeeded: codeSalt &<< 3)
        h = h &* 0x0100_0193
        return h
    }
    
    private static func mancry_itemFingerprint(_ item: Mancry_AuthOneKYCItem) -> String {
        var parts: [String] = []
        parts.append(item.itemCode)
        parts.append(String(item.itemSort))
        parts.append(item.isRequired ? "R" : "O")
        parts.append(String(item.itemType))
        let joined = parts.joined(separator: "|")
        var acc: UInt64 = 0
        for (i, u) in joined.utf8.enumerated() {
            acc = acc &* 131 &+ UInt64(u) &+ UInt64(i % 7)
        }
        return String(acc, radix: 16)
    }
}
