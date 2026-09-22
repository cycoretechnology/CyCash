import Foundation

/// AuthOne KYC 表单项（从 AuthOneStepsVC 拆出，保持二进制独立编译单元）
struct Mancry_AuthOneKYCItem {
    let isRequired: Bool
    let itemType: Int
    let itemCode: String
    let itemName: String
    let itemSort: Int
    let regularExpression: String
    let buttonList: [[String: Any]]
    
    var value: String?
    var displayText: String?
    
    var mancry_isInputField: Bool {
        return itemType == 1
    }
    
    var mancry_hasFilledValue: Bool {
        guard let value = value else { return false }
        return !value.isEmpty
    }
    
    func mancry_requiredHintMessage() -> String {
        if itemType != 1 {
            return "Please choose \(itemName)"
        }
        return "Please enter \(itemName)"
    }
    
    func mancry_inputMaxLength() -> Int {
        if itemCode == "address" {
            return 128
        }
        if itemCode == "child_count" {
            return 3
        }
        return Int.max
    }
}

extension Mancry_AuthOneStepsVC {
    typealias MancryKYCItem = Mancry_AuthOneKYCItem
}
