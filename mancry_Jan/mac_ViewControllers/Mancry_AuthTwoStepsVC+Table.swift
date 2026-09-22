import UIKit

// MARK: - UITableViewDataSource & UITableViewDelegate

extension Mancry_AuthTwoStepsVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mancry_items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = mancry_items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectTableViewCell", for: indexPath) as! SelectTableViewCell
        cell.selectionStyle = .none
        cell.configure(with: item)
        
        cell.mancry_selectOverlayButton.tag = indexPath.row
        cell.mancry_selectOverlayButton.removeTarget(nil, action: nil, for: .allEvents)
        cell.mancry_selectOverlayButton.addTarget(self, action: #selector(mancry_selectButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
    @objc func mancry_selectButtonTapped(_ button: UIButton) {
        view.endEditing(true)
        let index = button.tag
        guard index >= 0 && index < mancry_items.count else { return }
        
        let item = mancry_items[index]
        if !item.buttonList.isEmpty {
            mancry_showBottomPicker(for: item, at: index)
        }
    }
}
