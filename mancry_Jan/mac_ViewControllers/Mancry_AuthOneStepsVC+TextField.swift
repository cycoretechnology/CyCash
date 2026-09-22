import UIKit

// MARK: - UITextFieldDelegate

extension Mancry_AuthOneStepsVC {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let index = textField.tag
        guard index >= 0 && index < mancry_items.count else { return true }
        
        let item = mancry_items[index]
        let currentText = textField.text ?? ""
        let maxLength = item.mancry_inputMaxLength()
        
        if maxLength == Int.max {
            return true
        }
        
        let newLength = currentText.count + string.count - range.length
        if newLength > maxLength {
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let index = textField.tag
        guard index >= 0 && index < mancry_items.count else { return }
        
        if let text = textField.text, !text.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.mancry_jumpToNextItem(from: index)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let index = textField.tag
        guard index >= 0 && index < mancry_items.count else { return true }
        
        textField.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.mancry_jumpToNextItem(from: index)
        }
        
        return true
    }
}
