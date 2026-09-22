import Foundation

/// AuthTwo 工作信息 KYC 表单项（独立编译单元）
struct Mancry_AuthTwoKYCItem {
    let isRequired: Bool
    let itemType: Int
    let itemCode: String
    let itemName: String
    let itemSort: Int
    let regularExpression: String
    let buttonList: [[String: Any]]
    
    var value: String?
    var displayText: String?
    
    var mancry_hasChoice: Bool {
        return !(value ?? "").isEmpty
    }
    
    func mancry_chooseHint() -> String {
        return "Please choose \(itemName)"
    }
}

extension Mancry_AuthTwoStepsVC {
    typealias MancryKYCItem = Mancry_AuthTwoKYCItem
}
