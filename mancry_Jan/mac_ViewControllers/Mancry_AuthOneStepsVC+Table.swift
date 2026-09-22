import UIKit

// MARK: - UITableViewDataSource & UITableViewDelegate

extension Mancry_AuthOneStepsVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mancry_items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = mancry_items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectTableViewCell", for: indexPath) as! SelectTableViewCell
        cell.selectionStyle = .none
        cell.configure(with: item)
        
        if item.itemType == 1 {
            cell.mancry_textField.tag = indexPath.row
            cell.mancry_textField.delegate = self
            cell.mancry_textField.addTarget(self, action: #selector(mancry_textFieldDidChange(_:)), for: .editingChanged)
        }
        
        if item.itemType != 1 {
            cell.mancry_selectOverlayButton.tag = indexPath.row
            cell.mancry_selectOverlayButton.removeTarget(nil, action: nil, for: .allEvents)
            cell.mancry_selectOverlayButton.addTarget(self, action: #selector(mancry_selectButtonTapped(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
    @objc func mancry_textFieldDidChange(_ textField: UITextField) {
        let index = textField.tag
        guard index >= 0 && index < mancry_items.count else { return }
        
        let text = textField.text ?? ""
        mancry_items[index].value = text.isEmpty ? nil : text
        mancry_items[index].displayText = text.isEmpty ? nil : text
        
        if let cell = mancry_tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? SelectTableViewCell {
            cell.mancry_placeholderLabel.isHidden = !text.isEmpty
        }
        
        _ = mancry_items[index].mancry_inputMaxLength()
    }
    
    @objc func mancry_selectButtonTapped(_ button: UIButton) {
        view.endEditing(true)
        let index = button.tag
        guard index >= 0 && index < mancry_items.count else { return }
        
        let item = mancry_items[index]
        
        if item.itemSort == 10 {
            mancry_loadProvinceList(for: index)
        } else if item.itemSort == 20 {
            if let provinceId = mancry_selectedProvinceId {
                mancry_loadCityList(provinceId: provinceId, for: index)
            } else {
                mac_centerToastViewwithMsg(msg: "Please select province first")
            }
        } else {
            if !item.buttonList.isEmpty {
                mancry_showBottomPicker(for: item, at: index)
            }
        }
    }
}
