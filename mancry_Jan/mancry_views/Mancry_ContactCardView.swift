

import UIKit
import SnapKit

/// 联系人卡片视图
class Mancry_ContactCardView: UIView {
    
    // MARK: - UI
    
    /// 标题标签
    private let mancry_titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(hex: "#2C2F20")
        label.textAlignment = .center
        return label
    }()
    
    /// 关系选择字段
    private lazy var mancry_relationField: Mancry_ContactFieldView = {
        let field = Mancry_ContactFieldView()
        field.mancry_title = "Relationship"
        field.mancry_isSelectable = true
        field.mancry_useTitleLabelForValue = true
        field.mancry_showTitlePlaceholder = true  // 在标题行显示占位符
        field.mancry_onTap = { [weak self] in
            self?.onRelationTap?()
        }
        return field
    }()
    
    /// 姓名+电话组合选择视图（整块点击，右侧一个占位+箭头）
    private lazy var mancry_namePhoneField: Mancry_NamePhoneCombinedView = {
        let view = Mancry_NamePhoneCombinedView()
        view.onTap = { [weak self] in self?.onContactTap?() }
        return view
    }()
    
    // MARK: - Properties
    
    /// 标题
    var mancry_title: String? {
        get { mancry_titleLabel.text }
        set { mancry_titleLabel.text = newValue }
    }
    
    /// 关系选项列表
    var mancry_relationOptions: [[String: Any]] = [] {
        didSet {
            // 可以在这里处理选项列表
        }
    }
    
    /// 关系值（key）
    var mancry_relationValue: String? {
        didSet {
            // 根据 value 找到对应的 displayText
            if let value = mancry_relationValue {
                for option in mancry_relationOptions {
                    if let key = option["buttonKey"] as? String, key == value {
                        if let label = option["buttonLabel"] as? String {
                            mancry_relationField.mancry_value = label
                            return
                        }
                    }
                }
            }
            mancry_relationField.mancry_value = nil
        }
    }
    
    /// 关系显示文本
    var mancry_relationDisplayText: String? {
        didSet {
            mancry_relationField.mancry_value = mancry_relationDisplayText
        }
    }
    
    /// 姓名的值
    var mancry_nameValue: String {
        get { mancry_namePhoneField.nameValue }
        set { mancry_namePhoneField.nameValue = newValue }
    }
    
    /// 姓名的占位符
    var mancry_namePlaceholder: String? {
        get { mancry_namePhoneField.placeholderText }
        set { mancry_namePhoneField.placeholderText = newValue ?? "Please choose" }
    }
    
    /// 电话的值
    var mancry_phoneValue: String {
        get { mancry_namePhoneField.phoneValue }
        set { mancry_namePhoneField.phoneValue = newValue }
    }
    
    /// 电话的占位符
    var mancry_phonePlaceholder: String? {
        get { mancry_namePhoneField.placeholderText }
        set { mancry_namePhoneField.placeholderText = newValue ?? "Please choose" }
    }
    
    // MARK: - Callbacks
    
    /// 关系点击回调
    var onRelationTap: (() -> Void)?
    
    /// 选择通讯录回调（Name / Phone 共用一个事件）
    var onContactTap: (() -> Void)?
    
    /// 姓名文本变化回调
    var onNameTextChanged: ((String) -> Void)?
    
    /// 电话文本变化回调
    var onPhoneTextChanged: ((String) -> Void)?
    
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
        addSubview(mancry_relationField)
        addSubview(mancry_namePhoneField)
        
        // 标题居中
        mancry_titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        // Relationship 字段
        mancry_relationField.snp.makeConstraints { make in
            make.top.equalTo(mancry_titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        // Name+Phone 组合视图
        mancry_namePhoneField.snp.makeConstraints { make in
            make.top.equalTo(mancry_relationField.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(72)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}

// MARK: - Name + Phone 组合视图

private class Mancry_NamePhoneCombinedView: UIView {
    
    var nameValue: String = "" {
        didSet { updatePlaceholderAndValues() }
    }
    
    var phoneValue: String = "" {
        didSet { updatePlaceholderAndValues() }
    }
    
    var placeholderText: String = "Please choose" {
        didSet { placeholderLabel.text = placeholderText }
    }
    
    var onTap: (() -> Void)?
    
    private let nameTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(hex: "#777C61")
        label.text = "Name"
        return label
    }()
    
    private let phoneTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(hex: "#777C61")
        label.text = "Phone number"
        return label
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#B9B9B9")
        label.text = "Please choose"
        label.textAlignment = .right
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbysw_order_jt")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var overlayButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        let leftStack = UIStackView(arrangedSubviews: [nameTitleLabel, phoneTitleLabel])
        leftStack.axis = .vertical
        leftStack.spacing = 20
        leftStack.alignment = .leading
        
        let rightStack = UIStackView(arrangedSubviews: [placeholderLabel, arrowImageView])
        rightStack.axis = .horizontal
        rightStack.spacing = 6
        rightStack.alignment = .center
        
        addSubview(leftStack)
        addSubview(rightStack)
        addSubview(overlayButton)
        
        leftStack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        rightStack.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
        }
        
        overlayButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        updatePlaceholderAndValues()
    }
    
    private func updatePlaceholderAndValues() {
        // 左侧标题直接显示值；为空时显示默认标题
        if nameValue.isEmpty {
            nameTitleLabel.text = "Name"
            nameTitleLabel.textColor = UIColor(hex: "#777C61")
        } else {
            nameTitleLabel.text = nameValue
            nameTitleLabel.textColor = UIColor(hex: "#2C2F20")
        }

        if phoneValue.isEmpty {
            phoneTitleLabel.text = "Phone number"
            phoneTitleLabel.textColor = UIColor(hex: "#777C61")
        } else {
            phoneTitleLabel.text = phoneValue
            phoneTitleLabel.textColor = UIColor(hex: "#2C2F20")
        }

        let hasAny = !nameValue.isEmpty || !phoneValue.isEmpty
        placeholderLabel.isHidden = hasAny
    }
    
    @objc private func handleTap() {
        onTap?()
    }
}

/// 联系人字段视图（单个输入/选择字段）
class Mancry_ContactFieldView: UIView {
    
    // MARK: - UI
    
    /// 标题标签（左侧）
    private let mancry_titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(hex: "#777C61")
        return label
    }()
    
    /// 值显示标签（右侧，箭头左侧）
    private let mancry_valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#2C2F20")
        label.textAlignment = .right
        return label
    }()
    
    /// 占位提示（右侧，箭头左侧）
    private let mancry_placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#B9B9B9")
        label.text = "Please choose"
        label.textAlignment = .right
        return label
    }()
    
    /// 右侧箭头图标（选择项使用）
    private let mancry_arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbysw_order_jt")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    /// 分隔线（字段之间的分隔线）
    private let mancry_separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        return view
    }()
    
    /// 输入框（用于输入，但默认隐藏，只显示值）
    private lazy var mancry_textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.textColor = UIColor(hex: "#2C2F20")
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.isHidden = true
        textField.delegate = self
        return textField
    }()
    
    /// 覆盖按钮（选择项点击）
    private lazy var mancry_selectOverlayButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(mancry_fieldTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    /// 标题
    var mancry_title: String? {
        get { mancry_titleLabel.text }
        set {
            mancry_rawTitle = newValue
            // 如果当前没有值，才显示标题；有值时由 value 决定（mancry_useTitleLabelForValue=true）
            if !(hasDisplayValue) {
                mancry_titleLabel.text = newValue
            }
        }
    }

    /// 原始标题（用于 value 清空时恢复显示）
    private var mancry_rawTitle: String?

    /// 是否使用左侧 titleLabel 显示 value（选中后左侧显示 value；未选中显示标题）
    var mancry_useTitleLabelForValue: Bool = false {
        didSet {
            updateValuePresentation()
        }
    }

    /// 当前是否有可显示的 value
    private var hasDisplayValue: Bool {
        return !((mancry_textField.text ?? mancry_valueLabel.text ?? "").isEmpty)
    }
    
    /// 值
    var mancry_value: String? {
        get { mancry_textField.text ?? mancry_valueLabel.text }
        set {
            mancry_textField.text = newValue
            let hasValue = !(newValue ?? "").isEmpty
            mancry_valueLabel.text = hasValue ? newValue : nil
            updateValuePresentation()
        }
    }
    
    /// 占位符
    var mancry_placeholder: String? {
        get { mancry_placeholderLabel.text }
        set { mancry_placeholderLabel.text = newValue ?? "Please choose" }
    }
    
    /// 是否可点击选择（显示箭头）
    var mancry_isSelectable: Bool = false {
        didSet {
            mancry_arrowImageView.isHidden = !mancry_isSelectable
            updateInteractionState()
        }
    }
    
    /// 是否允许输入（即使可点击选择，也允许手动输入）
    var mancry_allowInput: Bool = false {
        didSet {
            updateInteractionState()
        }
    }
    
    /// 是否在标题行显示占位符（Relationship 显示，Name/Phone 不显示）
    var mancry_showTitlePlaceholder: Bool = true {
        didSet {
            updatePlaceholderVisibility()
        }
    }

    /// 值/占位是否靠左显示（默认靠右；Name/Phone 需要靠左）
    var mancry_valueOnLeft: Bool = false {
        didSet {
            updateValueLayout()
        }
    }
    
    /// 是否显示分隔线（Relationship 显示，Name/Phone 不显示）
    var mancry_showSeparator: Bool = true {
        didSet {
            mancry_separatorLine.isHidden = !mancry_showSeparator
        }
    }
    
    /// 更新占位符显示状态
    private func updatePlaceholderVisibility() {
        let hasValue = hasDisplayValue
        if mancry_showTitlePlaceholder {
            mancry_placeholderLabel.isHidden = hasValue
        } else {
            mancry_placeholderLabel.isHidden = true
        }
    }

    /// 更新 value 的呈现方式（左侧 titleLabel 或右侧 valueLabel）
    private func updateValuePresentation() {
        let hasValue = hasDisplayValue

        if mancry_useTitleLabelForValue {
            // 左侧显示 value（有值），没值时显示原始标题
            if hasValue {
                mancry_titleLabel.text = mancry_valueLabel.text ?? mancry_textField.text
                mancry_titleLabel.textColor = UIColor(hex: "#2C2F20")
            } else {
                mancry_titleLabel.text = mancry_rawTitle
                mancry_titleLabel.textColor = UIColor(hex: "#777C61")
            }
            // 右侧不再显示 valueLabel，仅保留 placeholder（无值显示，有值隐藏）
            mancry_valueLabel.isHidden = true
        } else {
            // 默认：左侧显示标题，右侧显示 value
            mancry_titleLabel.text = mancry_rawTitle
            mancry_titleLabel.textColor = UIColor(hex: "#2C2F20")
            mancry_valueLabel.isHidden = !hasValue
        }

        updatePlaceholderVisibility()
    }

    /// 更新值/占位布局（左/右）
    private func updateValueLayout() {
        // 使用 titleLabel 显示 value 时：右侧仅保留 placeholder + 箭头（placeholder 永远在右侧）
        if mancry_useTitleLabelForValue {
            mancry_valueLabel.textAlignment = .right
            mancry_placeholderLabel.textAlignment = .right
            mancry_valueLabel.snp.remakeConstraints { make in
                make.right.equalTo(mancry_arrowImageView.snp.left).offset(-8)
                make.centerY.equalToSuperview()
                make.left.greaterThanOrEqualTo(mancry_titleLabel.snp.right).offset(8)
            }
            mancry_placeholderLabel.snp.remakeConstraints { make in
                make.right.equalTo(mancry_arrowImageView.snp.left).offset(-8)
                make.centerY.equalToSuperview()
                make.left.greaterThanOrEqualTo(mancry_titleLabel.snp.right).offset(8)
            }
            return
        }

        let alignment: NSTextAlignment = mancry_valueOnLeft ? .left : .right
        mancry_valueLabel.textAlignment = alignment
        mancry_placeholderLabel.textAlignment = alignment

        if mancry_valueOnLeft {
            mancry_valueLabel.snp.remakeConstraints { make in
                make.left.equalTo(mancry_titleLabel.snp.right).offset(8)
                make.centerY.equalToSuperview()
                make.right.lessThanOrEqualTo(mancry_arrowImageView.snp.left).offset(-8)
            }
            mancry_placeholderLabel.snp.remakeConstraints { make in
                make.left.equalTo(mancry_titleLabel.snp.right).offset(8)
                make.centerY.equalToSuperview()
                make.right.lessThanOrEqualTo(mancry_arrowImageView.snp.left).offset(-8)
            }
        } else {
            mancry_valueLabel.snp.remakeConstraints { make in
                make.right.equalTo(mancry_arrowImageView.snp.left).offset(-8)
                make.centerY.equalToSuperview()
                make.left.greaterThanOrEqualTo(mancry_titleLabel.snp.right).offset(8)
            }
            mancry_placeholderLabel.snp.remakeConstraints { make in
                make.right.equalTo(mancry_arrowImageView.snp.left).offset(-8)
                make.centerY.equalToSuperview()
                make.left.greaterThanOrEqualTo(mancry_titleLabel.snp.right).offset(8)
            }
        }
    }
    
    /// 更新交互状态
    private func updateInteractionState() {
        if mancry_isSelectable {
            mancry_arrowImageView.isHidden = false
            if mancry_allowInput {
                // 允许输入，点击整个区域触发选择或输入
                mancry_textField.isUserInteractionEnabled = true
                mancry_selectOverlayButton.isHidden = false
            } else {
                // 不允许输入，只能点击选择
                mancry_textField.isUserInteractionEnabled = false
                mancry_selectOverlayButton.isHidden = false
            }
        } else {
            mancry_arrowImageView.isHidden = true
            mancry_textField.isUserInteractionEnabled = true
            mancry_selectOverlayButton.isHidden = true
        }
    }
    
    @objc private func mancry_arrowTapped() {
        // 点击箭头时，触发选择回调（如通讯录选择）
        mancry_onTap?()
    }
    
    // MARK: - Callbacks
    
    /// 点击回调
    var mancry_onTap: (() -> Void)?
    
    /// 文本变化回调
    var mancry_onTextChanged: ((String) -> Void)?
    
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
        
        // 标题标签（左侧）
        addSubview(mancry_titleLabel)
        
        // 值标签（右侧，箭头左侧）
        addSubview(mancry_valueLabel)
        
        // 占位符标签（右侧，箭头左侧）
        addSubview(mancry_placeholderLabel)
        
        // 箭头图标（右侧）
        addSubview(mancry_arrowImageView)
        
        // 分隔线（字段之间的分隔线，在底部）
        addSubview(mancry_separatorLine)
        
        // 输入框（隐藏，用于输入功能）
        addSubview(mancry_textField)
        
        // 覆盖按钮（用于点击）
        addSubview(mancry_selectOverlayButton)
        
        // 标题标签布局（左侧）
        mancry_titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        // 箭头图标（右侧）
        mancry_arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        // 值标签（右侧，箭头左侧）
        mancry_valueLabel.snp.makeConstraints { make in
            make.right.equalTo(mancry_arrowImageView.snp.left).offset(-8)
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(mancry_titleLabel.snp.right).offset(8)
        }
        
        // 占位符标签（右侧，箭头左侧）
        mancry_placeholderLabel.snp.makeConstraints { make in
            make.right.equalTo(mancry_arrowImageView.snp.left).offset(-8)
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(mancry_titleLabel.snp.right).offset(8)
        }
        
        // 分隔线（底部）
        mancry_separatorLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        // 输入框（隐藏，用于输入）
        mancry_textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 覆盖按钮（用于点击整个区域）
        mancry_selectOverlayButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 初始化时调用一次，确保状态正确
        updateInteractionState()
        updateValuePresentation()
        updateValueLayout()
        
        // 初始状态：值标签隐藏，占位符显示
        mancry_valueLabel.isHidden = true
        
        // 初始化分隔线显示状态
        mancry_separatorLine.isHidden = !mancry_showSeparator
    }
    
    // MARK: - Actions
    
    @objc private func mancry_fieldTapped() {
        // 点击整个区域时触发选择回调（如通讯录选择）
        mancry_onTap?()
    }
}

// MARK: - UITextFieldDelegate

extension Mancry_ContactFieldView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString? ?? "" as NSString).replacingCharacters(in: range, with: string)
        // 更新值显示
        mancry_value = newText.isEmpty ? nil : newText
        mancry_onTextChanged?(newText)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? ""
        mancry_value = text.isEmpty ? nil : text
        mancry_textField.isHidden = true
        mancry_onTextChanged?(text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
