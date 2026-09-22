//
//  Mancry_EmailCardView.swift
//  mancry_Jan
//
//  Created by mac_liuh on 2026/1/26.
//

import UIKit
import SnapKit

/// 邮箱输入卡片视图
class Mancry_EmailCardView: UIView {
    
    // MARK: - UI
    
    /// 标题标签
    private let mancry_titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(hex: "#2C2F20")
        label.text = "E-Mail"
        return label
    }()
    
    /// 输入框
    private lazy var mancry_textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.textColor = UIColor(hex: "#2C2F20")
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 20
        textField.clipsToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 40))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.delegate = self
        return textField
    }()
    
    /// 占位提示
    private let mancry_placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#B9B9B9")
        label.text = "Enter your E-mail"
        return label
    }()
    
    // MARK: - Properties
    
    /// 邮箱值
    var mancry_emailValue: String {
        get { mancry_textField.text ?? "" }
        set {
            mancry_textField.text = newValue
            mancry_placeholderLabel.isHidden = !newValue.isEmpty
        }
    }
    
    /// 占位符
    var mancry_placeholder: String? {
        get { mancry_placeholderLabel.text }
        set { mancry_placeholderLabel.text = newValue ?? "Enter your E-mail" }
    }
    
    // MARK: - Callbacks
    
    /// 文本变化回调
    var onTextChanged: ((String) -> Void)?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 12
        clipsToBounds = true
        
        addSubview(mancry_titleLabel)
        addSubview(mancry_textField)
        mancry_textField.addSubview(mancry_placeholderLabel)
        
        mancry_titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        mancry_textField.snp.makeConstraints { make in
            make.top.equalTo(mancry_titleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        mancry_placeholderLabel.snp.makeConstraints { make in
            make.left.equalTo(mancry_textField.snp.left).offset(12)
            make.centerY.equalTo(mancry_textField)
        }
    }
}

// MARK: - UITextFieldDelegate

extension Mancry_EmailCardView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString? ?? "" as NSString).replacingCharacters(in: range, with: string)
        // 输入时同步控制占位显示
        mancry_placeholderLabel.isHidden = !newText.isEmpty
        onTextChanged?(newText)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? ""
        mancry_placeholderLabel.isHidden = !text.isEmpty
        onTextChanged?(text)
    }
}
