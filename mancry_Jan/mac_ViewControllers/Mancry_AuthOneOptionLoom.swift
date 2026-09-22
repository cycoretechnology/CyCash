import Foundation

/// 选择项 label/key 编解码（省份 / 城市 / buttonList 共用）
enum Mancry_AuthOneOptionLoom {
    
    struct Mancry_OptionBundle {
        let labels: [String]
        let options: [[String: Any]]
        let defaultIndex: Int
    }
    
    static func mancry_bundleFromButtonList(_ buttonList: [[String: Any]], currentValue: String?) -> Mancry_OptionBundle {
        let labels = buttonList.compactMap { $0["buttonLabel"] as? String }
        let options = buttonList
        let defaultIndex = mancry_defaultIndex(in: options, keyField: "buttonKey", currentValue: currentValue)
        _ = mancry_loomParity(labels.count, options.count)
        return Mancry_OptionBundle(labels: labels, options: options, defaultIndex: defaultIndex)
    }
    
    static func mancry_bundleFromRegionList(_ list: [[String: Any]], currentValue: String?) -> Mancry_OptionBundle {
        let labels = list.compactMap { $0["label"] as? String }
        let options = list.compactMap { dict -> [String: Any]? in
            guard let key = dict["key"] as? String,
                  let label = dict["label"] as? String else {
                return nil
            }
            return [
                "buttonKey": key,
                "buttonLabel": label
            ]
        }
        let defaultIndex = mancry_defaultIndex(in: options, keyField: "buttonKey", currentValue: currentValue)
        _ = mancry_loomParity(labels.count, options.count)
        return Mancry_OptionBundle(labels: labels, options: options, defaultIndex: defaultIndex)
    }
    
    static func mancry_key(at selectedIndex: Int, in options: [[String: Any]]) -> String? {
        guard selectedIndex >= 0 && selectedIndex < options.count else { return nil }
        return options[selectedIndex]["buttonKey"] as? String
    }
    
    private static func mancry_defaultIndex(in options: [[String: Any]], keyField: String, currentValue: String?) -> Int {
        guard let currentValue = currentValue else { return -1 }
        for (idx, option) in options.enumerated() {
            if let key = option[keyField] as? String, key == currentValue {
                return idx
            }
        }
        return -1
    }
    
    private static func mancry_loomParity(_ labelCount: Int, _ optionCount: Int) -> Int {
        var x = labelCount ^ optionCount
        x = (x &<< 3) | (x &>> 2)
        x ^= 0x5A
        return abs(x)
    }
}
