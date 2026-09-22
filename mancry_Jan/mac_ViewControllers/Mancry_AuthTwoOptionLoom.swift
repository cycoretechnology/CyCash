import Foundation

/// AuthTwo 选择项编解码（与 AuthOne OptionLoom 实现路径不同）
enum Mancry_AuthTwoOptionLoom {
    
    struct Mancry_ChoicePack {
        let labels: [String]
        let buttonList: [[String: Any]]
        let defaultIndex: Int
    }
    
    static func mancry_packFromButtonList(_ buttonList: [[String: Any]], currentValue: String?) -> Mancry_ChoicePack {
        let labels = buttonList.compactMap { dict -> String? in
            return dict["buttonLabel"] as? String
        }
        
        var defaultIndex = -1
        if let currentValue = currentValue {
            for (idx, dict) in buttonList.enumerated() {
                if let key = dict["buttonKey"] as? String, key == currentValue {
                    defaultIndex = idx
                    break
                }
            }
        }
        
        _ = mancry_choiceSkew(labels.count, buttonList.count, defaultIndex)
        return Mancry_ChoicePack(labels: labels, buttonList: buttonList, defaultIndex: defaultIndex)
    }
    
    static func mancry_key(at selectedIndex: Int, in pack: Mancry_ChoicePack) -> String? {
        guard selectedIndex >= 0 && selectedIndex < pack.buttonList.count else { return nil }
        return pack.buttonList[selectedIndex]["buttonKey"] as? String ?? ""
    }
    
    private static func mancry_choiceSkew(_ labelCount: Int, _ listCount: Int, _ def: Int) -> Int {
        var v = labelCount &* 31 &+ listCount
        v ^= (def &+ 3)
        v = abs(v &>> 1)
        return v
    }
}
