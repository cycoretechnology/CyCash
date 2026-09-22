//
//  SelectTableViewCell.swift
//  mancry_Jan
//
//  Created by mac_liuh on 2026/1/26.
//

import UIKit

class SelectTableViewCell: UITableViewCell {
    
    // 标题标签
    let mancry_titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(hex: "#2C2F20")
        return label
    }()
    
    // 输入框
    let mancry_textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.textColor = UIColor(hex: "#2C2F20")
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 20
        textField.clipsToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 40))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    // 右侧箭头图标（选择项使用）
    let mancry_arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbysw_order_jt")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    // 覆盖按钮（选择项点击）
    let mancry_selectOverlayButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        return button
    }()
    
    // 占位提示
    let mancry_placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#B9B9B9")
        label.text = "Please choose"
        return label
    }()
    
    private var mancry_item: Mancry_AuthOneStepsVC.MancryKYCItem?
    private var mancry_itemTwo: Mancry_AuthTwoStepsVC.MancryKYCItem?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        contentView.addSubview(mancry_titleLabel)
        contentView.addSubview(mancry_textField)
        contentView.addSubview(mancry_arrowImageView)
        contentView.addSubview(mancry_selectOverlayButton)
        mancry_textField.addSubview(mancry_placeholderLabel)
        
        mancry_titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        mancry_textField.snp.makeConstraints { make in
            make.top.equalTo(mancry_titleLabel.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        mancry_arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(mancry_textField)
            make.right.equalTo(mancry_textField).offset(-12)
            make.width.height.equalTo(16)
        }
        
        mancry_selectOverlayButton.snp.makeConstraints { make in
            make.edges.equalTo(mancry_textField)
        }
        
        mancry_placeholderLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with item: Mancry_AuthOneStepsVC.MancryKYCItem) {
        self.mancry_item = item
        self.mancry_itemTwo = nil
        mancry_titleLabel.text = item.itemName
        
        // 显示文本：选择项显示 displayText，输入项显示 value
        let displayText = item.itemType == 1 ? item.value : item.displayText
        mancry_textField.text = displayText
        
        let isInput = item.itemType == 1
        mancry_textField.isUserInteractionEnabled = isInput
        mancry_arrowImageView.isHidden = isInput
        mancry_selectOverlayButton.isHidden = isInput
        
        if isInput {
            // 输入项
            if item.itemCode == "address" {
                mancry_placeholderLabel.text = "Please enter"
            } else if item.itemCode == "child_count" {
                mancry_placeholderLabel.text = "Please enter"
                mancry_textField.keyboardType = .numberPad
            } else {
                mancry_placeholderLabel.text = "Please enter"
            }
        } else {
            // 选择项
            mancry_placeholderLabel.text = "Please choose"
        }
        
        // 有值时隐藏 placeholder
        mancry_placeholderLabel.isHidden = !(displayText ?? "").isEmpty
    }
    
    // 重载方法：支持 Mancry_AuthTwoStepsVC 的数据模型
    func configure(with item: Mancry_AuthTwoStepsVC.MancryKYCItem) {
        self.mancry_itemTwo = item
        self.mancry_item = nil
        mancry_titleLabel.text = item.itemName
        
        // 显示文本：选择项显示 displayText
        let displayText = item.displayText
        mancry_textField.text = displayText
        
        // 所有项都是选择项
        mancry_textField.isUserInteractionEnabled = false
        mancry_arrowImageView.isHidden = false
        mancry_selectOverlayButton.isHidden = false
        
        // 选择项
        mancry_placeholderLabel.text = "Please choose"
        
        // 有值时隐藏 placeholder
        mancry_placeholderLabel.isHidden = !(displayText ?? "").isEmpty
    }
}
