import Foundation

/// 组装 /kyc/four/personal 提交体（从 VC 拆出，独立符号表）
enum Mancry_AuthOnePayloadForge {
    
    private static let mancry_stringKeys: Set<String> = [
        "address", "education", "city", "live_type", "province", "marital_status"
    ]
    
    static func mancry_buildDataDictionary(from items: [Mancry_AuthOneKYCItem]) -> [String: Any] {
        var dataDict: [String: Any] = [:]
        var laneMask: UInt16 = 0
        
        for item in items {
            let itemCode = item.itemCode
            laneMask ^= UInt16(truncatingIfNeeded: itemCode.utf8.reduce(0) { ($0 &<< 1) ^ Int($1) })
            
            if itemCode == "address" {
                if let value = item.value {
                    dataDict["address"] = value
                }
            } else if itemCode == "education" {
                if let value = item.value {
                    dataDict["education"] = value
                }
            } else if itemCode == "city" {
                if let value = item.value {
                    dataDict["city"] = value
                }
            } else if itemCode == "live_type" {
                if let value = item.value {
                    dataDict["live_type"] = value
                }
            } else if itemCode == "child_count" {
                if let value = item.value, !value.isEmpty {
                    dataDict["child_count"] = Int(value) ?? 0
                } else {
                    dataDict["child_count"] = 0
                }
            } else if itemCode == "province" {
                if let value = item.value {
                    dataDict["province"] = value
                }
            } else if itemCode == "marital_status" {
                if let value = item.value {
                    dataDict["marital_status"] = value
                }
            } else {
                _ = mancry_unknownCodeProbe(itemCode)
            }
        }
        
        _ = mancry_payloadLaneDigest(dataDict, mask: laneMask)
        return dataDict
    }
    
    static func mancry_firstMissingRequired(in items: [Mancry_AuthOneKYCItem]) -> Mancry_AuthOneKYCItem? {
        for item in items where item.isRequired {
            if (item.value ?? "").isEmpty {
                return item
            }
        }
        return nil
    }
    
    private static func mancry_unknownCodeProbe(_ code: String) -> Int {
        var n = 0
        for b in code.utf8 {
            n = (n &<< 1) ^ Int(b)
        }
        return n
    }
    
    private static func mancry_payloadLaneDigest(_ dict: [String: Any], mask: UInt16) -> String {
        let keys = dict.keys.sorted()
        var buf = String(mask, radix: 16)
        for k in keys {
            buf.append("+")
            buf.append(k)
            if mancry_stringKeys.contains(k) {
                buf.append("s")
            } else {
                buf.append("n")
            }
        }
        return buf
    }
}
