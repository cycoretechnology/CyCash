import UIKit

// MARK: - Bottom Picker & Navigation

extension Mancry_AuthOneStepsVC {
    
    func mancry_showBottomPicker(for item: Mancry_AuthOneKYCItem, at index: Int) {
        mancry_bottomPicker?.dismiss()
        mancry_bottomPicker = nil
        
        let bundle = Mancry_AuthOneOptionLoom.mancry_bundleFromButtonList(item.buttonList, currentValue: item.value)
        
        let picker = Mancry_customselectPopupView()
        mancry_bottomPicker = picker
        
        picker.configure(title: item.itemName, data: bundle.labels, defaultIndex: bundle.defaultIndex)
        
        picker.onConfirm = { [weak self] selectedIndex, selectedLabel in
            guard let self = self else { return }
            
            if let key = Mancry_AuthOneOptionLoom.mancry_key(at: selectedIndex, in: bundle.options) {
                self.mancry_items[index].value = key
                self.mancry_items[index].displayText = selectedLabel
                
                self.mancry_tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    self?.mancry_jumpToNextItem(from: index)
                }
            }
            
            self.mancry_bottomPicker = nil
        }
        
        picker.onCancel = { [weak self] in
            self?.mancry_bottomPicker = nil
        }
        
        picker.show(in: view)
    }
    
    func mancry_clearCitySelection() {
        for (idx, item) in mancry_items.enumerated() {
            if item.itemSort == 20 {
                mancry_items[idx].value = nil
                mancry_items[idx].displayText = nil
                mancry_tableView.reloadRows(at: [IndexPath(row: idx, section: 0)], with: .none)
                break
            }
        }
    }
    
    func mancry_jumpToNextItem(from currentIndex: Int) {
        let nextIndex = currentIndex + 1
        
        for index in nextIndex..<mancry_items.count {
            let item = mancry_items[index]
            
            if let value = item.value, !value.isEmpty {
                continue
            }
            
            let indexPath = IndexPath(row: index, section: 0)
            mancry_tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                guard let self = self else { return }
                
                if item.itemType == 1 {
                    if let cell = self.mancry_tableView.cellForRow(at: indexPath) as? SelectTableViewCell {
                        cell.mancry_textField.becomeFirstResponder()
                    }
                } else {
                    if let cell = self.mancry_tableView.cellForRow(at: indexPath) as? SelectTableViewCell {
                        cell.mancry_selectOverlayButton.tag = index
                        cell.mancry_selectOverlayButton.sendActions(for: .touchUpInside)
                    }
                }
            }
            
            return
        }
    }
}
