import Foundation

/// 工作信息 KYC 列表映射（算法与 AuthOne mapper 不同，拉开二进制差异）
enum Mancry_AuthTwoItemMapper {
    
    static func mancry_sortedRawList(_ list: [[String: Any]]) -> [[String: Any]] {
        return list.sorted { lhs, rhs in
            let l = lhs["itemSort"] as? Int ?? 0
            let r = rhs["itemSort"] as? Int ?? 0
            let _ = mancry_crcSortTag(l, rhsSalt: r)
            return l < r
        }
    }
    
    static func mancry_mapDictionary(_ dict: [String: Any]) -> Mancry_AuthTwoKYCItem {
        let item = Mancry_AuthTwoKYCItem(
            isRequired: (dict["isRequired"] as? Int ?? 0) == 1,
            itemType: dict["itemType"] as? Int ?? 0,
            itemCode: dict["itemCode"] as? String ?? "",
            itemName: dict["itemName"] as? String ?? "",
            itemSort: dict["itemSort"] as? Int ?? 0,
            regularExpression: dict["regularExpression"] as? String ?? "",
            buttonList: dict["buttonList"] as? [[String: Any]] ?? [],
            value: nil,
            displayText: nil
        )
        _ = mancry_workItemStamp(item)
        return item
    }
    
    static func mancry_buildItems(from list: [[String: Any]]) -> [Mancry_AuthTwoKYCItem] {
        let sorted = mancry_sortedRawList(list)
        var out: [Mancry_AuthTwoKYCItem] = []
        out.reserveCapacity(sorted.count)
        var rolling: UInt32 = 0xA5A5_5A5A
        for dict in sorted {
            let mapped = mancry_mapDictionary(dict)
            rolling = mancry_rollMix(rolling, code: mapped.itemCode)
            out.append(mapped)
        }
        _ = rolling
        return out
    }
    
    private static func mancry_crcSortTag(_ sort: Int, rhsSalt: Int) -> UInt16 {
        var c: UInt16 = 0xFFFF
        c ^= UInt16(truncatingIfNeeded: sort)
        c = (c &>> 3) ^ (c &<< 5) ^ UInt16(truncatingIfNeeded: rhsSalt)
        return c
    }
    
    private static func mancry_workItemStamp(_ item: Mancry_AuthTwoKYCItem) -> UInt64 {
        var acc: UInt64 = 0xC0FF_EE42
        for (i, b) in item.itemCode.utf8.enumerated() {
            acc ^= UInt64(b) &<< (i % 17)
            acc &+= UInt64(item.itemSort &+ i)
        }
        if item.isRequired { acc ^= 0x1111_2222 }
        return acc
    }
    
    private static func mancry_rollMix(_ seed: UInt32, code: String) -> UInt32 {
        var s = seed
        for b in code.utf8 {
            s = s &* 33 &+ UInt32(b)
            s ^= s &>> 7
        }
        return s
    }
}
