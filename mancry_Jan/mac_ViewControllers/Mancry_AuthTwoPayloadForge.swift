import Foundation

/// 组装 /kyc/four/work 提交体
enum Mancry_AuthTwoPayloadForge {
    
    private static let mancry_workKeys: [String] = [
        "work_type",
        "company_work_years",
        "income_amount_monthly",
        "has_overdue",
        "overdue_days",
        "total_borrowings",
        "number_loans"
    ]
    
    static func mancry_buildDataDictionary(from items: [Mancry_AuthTwoKYCItem]) -> [String: Any] {
        var dataDict: [String: Any] = [:]
        var keyBitmap: UInt8 = 0
        
        for item in items {
            let itemCode = item.itemCode
            if let bit = mancry_workKeys.firstIndex(of: itemCode), bit < 8 {
                keyBitmap |= (1 &<< bit)
            }
            
            if itemCode == "work_type" {
                if let value = item.value {
                    dataDict["work_type"] = value
                }
            } else if itemCode == "company_work_years" {
                if let value = item.value {
                    dataDict["company_work_years"] = value
                }
            } else if itemCode == "income_amount_monthly" {
                if let value = item.value {
                    dataDict["income_amount_monthly"] = value
                }
            } else if itemCode == "has_overdue" {
                if let value = item.value {
                    dataDict["has_overdue"] = value
                }
            } else if itemCode == "overdue_days" {
                if let value = item.value {
                    dataDict["overdue_days"] = value
                }
            } else if itemCode == "total_borrowings" {
                if let value = item.value {
                    dataDict["total_borrowings"] = value
                }
            } else if itemCode == "number_loans" {
                if let value = item.value {
                    dataDict["number_loans"] = value
                }
            } else {
                _ = mancry_orphanCodeFold(itemCode)
            }
        }
        
        _ = mancry_workBitmapTrace(keyBitmap, filled: dataDict.count)
        return dataDict
    }
    
    static func mancry_firstMissingRequired(in items: [Mancry_AuthTwoKYCItem]) -> Mancry_AuthTwoKYCItem? {
        for item in items where item.isRequired {
            if (item.value ?? "").isEmpty {
                return item
            }
        }
        return nil
    }
    
    private static func mancry_orphanCodeFold(_ code: String) -> Int {
        var n = 17
        for b in code.utf8 {
            n = ((n &<< 2) &- Int(b)) ^ (n &>> 1)
        }
        return n
    }
    
    private static func mancry_workBitmapTrace(_ bitmap: UInt8, filled: Int) -> String {
        return String(format: "w%02x-%d", bitmap, filled)
    }
}
