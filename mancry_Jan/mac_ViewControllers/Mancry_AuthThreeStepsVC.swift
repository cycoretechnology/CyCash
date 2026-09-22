
import UIKit
import Contacts
import ContactsUI
import SnapKit

/// 第三步认证：紧急联系人
class Mancry_AuthThreeStepsVC: Mac_BaseViewController {
    
    // MARK: - UI
    
    /// 顶部进度条背景
    private let mancry_progressBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    /// 进度图片（75%）
    private let mancry_progressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "jdt_75")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// 滚动视图
    private lazy var mancry_scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(hex: "#EDF1D8")
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    /// 内容容器
    private let mancry_contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        return view
    }()
    
    /// 联系人01卡片
    private lazy var mancry_contact01Card: Mancry_ContactCardView = {
        let card = Mancry_ContactCardView()
        card.mancry_title = "Contact 01"
        return card
    }()
    
    /// 联系人02卡片
    private lazy var mancry_contact02Card: Mancry_ContactCardView = {
        let card = Mancry_ContactCardView()
        card.mancry_title = "Contact 02"
        return card
    }()
    
    /// 联系人03卡片
    private lazy var mancry_contact03Card: Mancry_ContactCardView = {
        let card = Mancry_ContactCardView()
        card.mancry_title = "Contact 03"
        return card
    }()
    
    /// 邮箱输入卡片
    private lazy var mancry_emailCard: Mancry_EmailCardView = {
        let card = Mancry_EmailCardView()
        return card
    }()
    
    /// 底部继续按钮
    private lazy var mancry_continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(hex: "#CEDF00")
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(mancry_continueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data
    
    /// KYC 配置项模型
    struct MancryKYCItem {
        let isRequired: Bool
        let itemType: Int
        let itemCode: String
        let itemName: String
        let itemSort: Int
        let regularExpression: String
        let buttonList: [[String: Any]]
        
        // 用户输入 / 选择结果
        var value: String?  // 存储 key（选择项）或输入文本（输入项）
        var displayText: String?  // 存储显示的文本（选择项显示 label，输入项显示 value）
    }
    
    /// 联系人数据结构
    struct MancryContactData {
        var relationItem: MancryKYCItem?  // Relationship
        var nameItem: MancryKYCItem?      // Name
        var phoneItem: MancryKYCItem?     // Phone number
    }
    
    private var mancry_allItems: [MancryKYCItem] = []
    private var mancry_contact01: MancryContactData = MancryContactData()
    private var mancry_contact02: MancryContactData = MancryContactData()
    private var mancry_contact03: MancryContactData = MancryContactData()
    private var mancry_emailItem: MancryKYCItem?
    
    /// 底部选择器
    private var mancry_customSelectPopup: Mancry_customselectPopupView?
    
    /// 当前正在编辑的联系人卡片（用于通讯录选择）
    private weak var mancry_currentEditingCard: Mancry_ContactCardView?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: "#EDF1D8")
        self.mac_publiccustomnavView(title: "Emergency Contact")
        setupUI()
        mancry_getthreeStepinitData()
    }
    
    override func mancry_backbtnAction() {
        let cameraPopView = Mancry_PopView(type: .cameraPermission)
        cameraPopView.configure(
            topImageName: "flbeql_tk_xj",
            title: "Confirm to return?",
            description: "Do you want to pause the authentication and return to the homepage?",
            leftButtonTitle: "Confirm",
            rightButtonTitle: "Cancel"
        )
        cameraPopView.onLeftButtonTapped = {
            self.navigationController?.popToRootViewController(animated: true)
        }
      
        cameraPopView.show()
        
    }
    // MARK: - UI Setup
    
    private func setupUI() {
        // 顶部进度区域
        view.addSubview(mancry_progressBgView)
        mancry_progressBgView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(55)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(24)
        }
        
        mancry_progressBgView.addSubview(mancry_progressImageView)
        mancry_progressImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 滚动视图
        view.addSubview(mancry_scrollView)
        mancry_scrollView.snp.makeConstraints { make in
            make.top.equalTo(mancry_progressBgView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-80)
        }
        
        mancry_scrollView.addSubview(mancry_contentView)
        mancry_contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        // 联系人卡片
        mancry_contentView.addSubview(mancry_contact01Card)
        mancry_contact01Card.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        mancry_contentView.addSubview(mancry_contact02Card)
        mancry_contact02Card.snp.makeConstraints { make in
            make.top.equalTo(mancry_contact01Card.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        mancry_contentView.addSubview(mancry_contact03Card)
        mancry_contact03Card.snp.makeConstraints { make in
            make.top.equalTo(mancry_contact02Card.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        // 邮箱卡片
        mancry_contentView.addSubview(mancry_emailCard)
        mancry_emailCard.snp.makeConstraints { make in
            make.top.equalTo(mancry_contact03Card.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        // 底部按钮
        view.addSubview(mancry_continueButton)
        mancry_continueButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(50)
        }
        
        // 设置联系人卡片的回调
        setupContactCardCallbacks()
    }
    
    /// 设置联系人卡片的回调
    private func setupContactCardCallbacks() {
        // Contact 01
        mancry_contact01Card.onRelationTap = { [weak self] in
            self?.mancry_showRelationPicker(for: .contact01)
        }
        mancry_contact01Card.onContactTap = { [weak self] in
            self?.mancry_currentEditingCard = self?.mancry_contact01Card
            self?.mancry_showContactPicker()
        }
        mancry_contact01Card.onNameTextChanged = { [weak self] text in
            self?.mancry_contact01.nameItem?.value = text
            self?.mancry_contact01.nameItem?.displayText = text
        }
        mancry_contact01Card.onPhoneTextChanged = { [weak self] text in
            self?.mancry_contact01.phoneItem?.value = text
            self?.mancry_contact01.phoneItem?.displayText = text
        }
        
        // Contact 02
        mancry_contact02Card.onRelationTap = { [weak self] in
            self?.mancry_showRelationPicker(for: .contact02)
        }
        mancry_contact02Card.onContactTap = { [weak self] in
            self?.mancry_currentEditingCard = self?.mancry_contact02Card
            self?.mancry_showContactPicker()
        }
        mancry_contact02Card.onNameTextChanged = { [weak self] text in
            self?.mancry_contact02.nameItem?.value = text
            self?.mancry_contact02.nameItem?.displayText = text
        }
        mancry_contact02Card.onPhoneTextChanged = { [weak self] text in
            self?.mancry_contact02.phoneItem?.value = text
            self?.mancry_contact02.phoneItem?.displayText = text
        }
        
        // Contact 03
        mancry_contact03Card.onRelationTap = { [weak self] in
            self?.mancry_showRelationPicker(for: .contact03)
        }
        mancry_contact03Card.onContactTap = { [weak self] in
            self?.mancry_currentEditingCard = self?.mancry_contact03Card
            self?.mancry_showContactPicker()
        }
        mancry_contact03Card.onNameTextChanged = { [weak self] text in
            self?.mancry_contact03.nameItem?.value = text
            self?.mancry_contact03.nameItem?.displayText = text
        }
        mancry_contact03Card.onPhoneTextChanged = { [weak self] text in
            self?.mancry_contact03.phoneItem?.value = text
            self?.mancry_contact03.phoneItem?.displayText = text
        }
        
        // Email
        mancry_emailCard.onTextChanged = { [weak self] text in
            self?.mancry_emailItem?.value = text
            self?.mancry_emailItem?.displayText = text
        }
    }
    
    // MARK: - Network
    
    func mancry_getthreeStepinitData() {
        let requestData: [String: Any] = [
            "": ""
        ]
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: requestData, isSign: false)
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else { return }
        
        self.mac_PopLoadingView()
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/kyc/four/search-iterm",
            httpBody: postData,
            successCallBack: { [weak self] result in
                guard let self = self else { return }
                self.mac_hiddenLoadingView()
                
                let code = result["resultCode"] as? Int ?? -1
                if code == 200,
                   let data = result["data"] as? [String: Any],
                   let list = data["kycItemList"] as? [[String: Any]] {
                    
                    // 排序
                    let sorted = list.sorted { (lhs, rhs) -> Bool in
                        let l = lhs["itemSort"] as? Int ?? 0
                        let r = rhs["itemSort"] as? Int ?? 0
                        return l < r
                    }
                    
                    // 映射为本地模型
                    self.mancry_allItems = sorted.map { dict in
                        let isRequired = (dict["isRequired"] as? Int ?? 0) == 1
                        let itemType = dict["itemType"] as? Int ?? 0
                        let itemCode = dict["itemCode"] as? String ?? ""
                        let itemName = dict["itemName"] as? String ?? ""
                        let itemSort = dict["itemSort"] as? Int ?? 0
                        let regularExpression = dict["regularExpression"] as? String ?? ""
                        let buttonList = dict["buttonList"] as? [[String: Any]] ?? []
                        return MancryKYCItem(
                            isRequired: isRequired,
                            itemType: itemType,
                            itemCode: itemCode,
                            itemName: itemName,
                            itemSort: itemSort,
                            regularExpression: regularExpression,
                            buttonList: buttonList,
                            value: nil
                        )
                    }
                    
                    // 分组数据
                    self.mancry_groupItems()
                    
                    // 更新UI
                    self.mancry_updateUI()
                } else {
//                    let message = result["resultMsg"] as? String ?? "Network error"
//                    self.mac_centerToastViewwithMsg(msg: message)
                }
            },
            failureCallBack: { [weak self] _ in
                self?.mac_hiddenLoadingView()
//                self?.mac_centerToastViewwithMsg(msg: "Network error")
            }
        )
    }
    
    /// 将数据分组为三个联系人和邮箱
    private func mancry_groupItems() {
        for item in mancry_allItems {
            if item.itemCode.hasPrefix("first_") {
                if item.itemCode == "first_relation" {
                    mancry_contact01.relationItem = item
                } else if item.itemCode == "first_name" {
                    mancry_contact01.nameItem = item
                } else if item.itemCode == "first_phone" {
                    mancry_contact01.phoneItem = item
                }
            } else if item.itemCode.hasPrefix("second_") {
                if item.itemCode == "second_relation" {
                    mancry_contact02.relationItem = item
                } else if item.itemCode == "second_name" {
                    mancry_contact02.nameItem = item
                } else if item.itemCode == "second_phone" {
                    mancry_contact02.phoneItem = item
                }
            } else if item.itemCode.hasPrefix("third_") {
                if item.itemCode == "third_relation" {
                    mancry_contact03.relationItem = item
                } else if item.itemCode == "third_name" {
                    mancry_contact03.nameItem = item
                } else if item.itemCode == "third_phone" {
                    mancry_contact03.phoneItem = item
                }
            } else if item.itemCode == "email" {
                mancry_emailItem = item
            }
        }
    }
    
    /// 更新UI显示
    private func mancry_updateUI() {
        // Contact 01
        if let relation = mancry_contact01.relationItem {
            mancry_contact01Card.mancry_relationOptions = relation.buttonList
            mancry_contact01Card.mancry_relationValue = relation.value
            mancry_contact01Card.mancry_relationDisplayText = relation.displayText
        }
        if let name = mancry_contact01.nameItem {
            mancry_contact01Card.mancry_nameValue = name.value ?? ""
            mancry_contact01Card.mancry_namePlaceholder = name.itemName
        }
        if let phone = mancry_contact01.phoneItem {
            mancry_contact01Card.mancry_phoneValue = phone.value ?? ""
            mancry_contact01Card.mancry_phonePlaceholder = phone.itemName
        }
        
        // Contact 02
        if let relation = mancry_contact02.relationItem {
            mancry_contact02Card.mancry_relationOptions = relation.buttonList
            mancry_contact02Card.mancry_relationValue = relation.value
            mancry_contact02Card.mancry_relationDisplayText = relation.displayText
        }
        if let name = mancry_contact02.nameItem {
            mancry_contact02Card.mancry_nameValue = name.value ?? ""
            mancry_contact02Card.mancry_namePlaceholder = name.itemName
        }
        if let phone = mancry_contact02.phoneItem {
            mancry_contact02Card.mancry_phoneValue = phone.value ?? ""
            mancry_contact02Card.mancry_phonePlaceholder = phone.itemName
        }
        
        // Contact 03
        if let relation = mancry_contact03.relationItem {
            mancry_contact03Card.mancry_relationOptions = relation.buttonList
            mancry_contact03Card.mancry_relationValue = relation.value
            mancry_contact03Card.mancry_relationDisplayText = relation.displayText
        }
        if let name = mancry_contact03.nameItem {
            mancry_contact03Card.mancry_nameValue = name.value ?? ""
            mancry_contact03Card.mancry_namePlaceholder = name.itemName
        }
        if let phone = mancry_contact03.phoneItem {
            mancry_contact03Card.mancry_phoneValue = phone.value ?? ""
            mancry_contact03Card.mancry_phonePlaceholder = phone.itemName
        }
        
        // Email
        if let email = mancry_emailItem {
            mancry_emailCard.mancry_emailValue = email.value ?? ""
            mancry_emailCard.mancry_placeholder = email.itemName
        }
    }
    
    // MARK: - Actions
    
    /// 显示关系选择器
    private func mancry_showRelationPicker(for contact: ContactType) {
        let relationItem: MancryKYCItem?
        let contactData: MancryContactData
        
        switch contact {
        case .contact01:
            relationItem = mancry_contact01.relationItem
            contactData = mancry_contact01
        case .contact02:
            relationItem = mancry_contact02.relationItem
            contactData = mancry_contact02
        case .contact03:
            relationItem = mancry_contact03.relationItem
            contactData = mancry_contact03
        }
        
        guard let item = relationItem else { return }
        
        // 移除旧的选择器
        mancry_customSelectPopup?.removeFromSuperview()
        
        let picker = Mancry_customselectPopupView()
        self.mancry_customSelectPopup = picker
        
        // 转换为字符串数组（显示 buttonLabel）
        let dataList = item.buttonList.compactMap { dict -> String? in
            return dict["buttonLabel"] as? String
        }
        
        // 找到当前选中项的索引
        var defaultIndex = -1
        if let currentValue = item.value {
            for (idx, option) in item.buttonList.enumerated() {
                if let key = option["buttonKey"] as? String, key == currentValue {
                    defaultIndex = idx
                    break
                }
            }
        }
        
        // 配置弹窗
        picker.configure(title: item.itemName, data: dataList, defaultIndex: defaultIndex)
        
        // 设置确认回调
        picker.onConfirm = { [weak self] selectedIndex, selectedLabel in
            guard let self = self else { return }
            // 根据选中的索引找到对应的 key
            if selectedIndex >= 0 && selectedIndex < item.buttonList.count {
                let selectedDict = item.buttonList[selectedIndex]
                let key = selectedDict["buttonKey"] as? String ?? ""
                
                // 更新数据
                switch contact {
                case .contact01:
                    self.mancry_contact01.relationItem?.value = key
                    self.mancry_contact01.relationItem?.displayText = selectedLabel
                    self.mancry_contact01Card.mancry_relationValue = key
                    self.mancry_contact01Card.mancry_relationDisplayText = selectedLabel
                case .contact02:
                    self.mancry_contact02.relationItem?.value = key
                    self.mancry_contact02.relationItem?.displayText = selectedLabel
                    self.mancry_contact02Card.mancry_relationValue = key
                    self.mancry_contact02Card.mancry_relationDisplayText = selectedLabel
                case .contact03:
                    self.mancry_contact03.relationItem?.value = key
                    self.mancry_contact03.relationItem?.displayText = selectedLabel
                    self.mancry_contact03Card.mancry_relationValue = key
                    self.mancry_contact03Card.mancry_relationDisplayText = selectedLabel
                }
            }
            
            // 清理引用
            self.mancry_customSelectPopup = nil
        }
        
        // 设置取消回调
        picker.onCancel = { [weak self] in
            self?.mancry_customSelectPopup = nil
        }
        
        // 显示弹窗
        picker.show(in: view)
    }
    
    /// 显示通讯录选择器
    private func mancry_showContactPicker() {

                DispatchQueue.main.async {
                    let picker = CNContactPickerViewController()
                    picker.delegate = self
                    // 强制走 “选择某个属性(电话号码)” 的回调：didSelect contactProperty
                    picker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
                    picker.predicateForSelectionOfContact = NSPredicate(value: false)
                    picker.predicateForSelectionOfProperty = NSPredicate(value: true)
                    self.present(picker, animated: true)
                }

    }
    
    /// 提交数据
    @objc private func mancry_continueButtonTapped() {
        view.endEditing(true)
        
        // 校验必填项
        if !mancry_validateData() {
            return
        }
        
        mancry_submitContactInfo()
    }
    
    /// 校验数据
    private func mancry_validateData() -> Bool {
        // 校验三个联系人（提示精确到第几个联系人）
        let contacts: [(suffix: String, contact: MancryContactData)] = [
            ("01", mancry_contact01),
            ("02", mancry_contact02),
            ("03", mancry_contact03)
        ]
        
        for (suffix, contact) in contacts {
            // 校验关系
            if let relation = contact.relationItem, relation.isRequired {
                if (relation.value ?? "").isEmpty {
                    mac_centerToastViewwithMsg(msg: "Please choose Relationship \(suffix)")
                    return false
                }
            }
            
            // 校验姓名
            if let name = contact.nameItem, name.isRequired {
                let value = name.value ?? ""
                if value.isEmpty {
                    mac_centerToastViewwithMsg(msg: "Please choose Name \(suffix)")
                    return false
                }
                // 正则校验
                if !name.regularExpression.isEmpty {
                    let regex = try? NSRegularExpression(pattern: name.regularExpression, options: [])
                    let range = NSRange(location: 0, length: value.count)
                    if let regex = regex, regex.firstMatch(in: value, options: [], range: range) == nil {
                        mac_centerToastViewwithMsg(msg: "Name \(suffix) format is invalid")
                        return false
                    }
                }
            }
            
            // 校验电话
            if let phone = contact.phoneItem, phone.isRequired {
                let value = phone.value ?? ""
                if value.isEmpty {
                    mac_centerToastViewwithMsg(msg: "Please choose Phone number \(suffix)")
                    return false
                }
                // 正则校验
                if !phone.regularExpression.isEmpty {
                    let regex = try? NSRegularExpression(pattern: phone.regularExpression, options: [])
                    let range = NSRange(location: 0, length: value.count)
                    if let regex = regex, regex.firstMatch(in: value, options: [], range: range) == nil {
                        mac_centerToastViewwithMsg(msg: "Phone number \(suffix) format is invalid")
                        return false
                    }
                }
            }
        }
        
        // 校验邮箱
        if let email = mancry_emailItem, email.isRequired {
            let value = email.value ?? ""
            if value.isEmpty {
                mac_centerToastViewwithMsg(msg: "Please enter E-Mail")
                return false
            }
            // 正则校验
            if !email.regularExpression.isEmpty {
                let regex = try? NSRegularExpression(pattern: email.regularExpression, options: [])
                let range = NSRange(location: 0, length: value.count)
                if let regex = regex, regex.firstMatch(in: value, options: [], range: range) == nil {
                    mac_centerToastViewwithMsg(msg: "Invalid email format")
                    return false
                }
            }
        }
        
        return true
    }
    
    /// 提交联系人信息
    private func mancry_submitContactInfo() {
        // 构建 data 对象
        var dataDict: [String: Any] = [:]
        
        // Contact 01
        if let relation = mancry_contact01.relationItem?.value {
            dataDict["first_relation"] = relation
        }
        if let name = mancry_contact01.nameItem?.value {
            dataDict["first_name"] = name
        }
        if let phone = mancry_contact01.phoneItem?.value {
            dataDict["first_phone"] = phone
        }
        
        // Contact 02
        if let relation = mancry_contact02.relationItem?.value {
            dataDict["second_relation"] = relation
        }
        if let name = mancry_contact02.nameItem?.value {
            dataDict["second_name"] = name
        }
        if let phone = mancry_contact02.phoneItem?.value {
            dataDict["second_phone"] = phone
        }
        
        // Contact 03
        if let relation = mancry_contact03.relationItem?.value {
            dataDict["third_relation"] = relation
        }
        if let name = mancry_contact03.nameItem?.value {
            dataDict["third_name"] = name
        }
        if let phone = mancry_contact03.phoneItem?.value {
            dataDict["third_phone"] = phone
        }
        
        // Email
        if let email = mancry_emailItem?.value {
            dataDict["email"] = email
        }
        print("dic---\(dataDict)")
        // 使用 mancry_publicRequestBody 构建请求参数（会自动添加公共参数和签名）
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: dataDict, isSign: false)
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else {
            mac_centerToastViewwithMsg(msg: "Failed to prepare request data")
            return
        }
        
        // 显示加载提示
        self.mac_PopLoadingView()
        
        // 调用接口
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/kyc/four/contact",
            httpBody: postData,
            successCallBack: { [weak self] result in
                guard let self = self else { return }
                self.mac_hiddenLoadingView()
                
                let code = result["resultCode"] as? Int ?? -1
                if code == 200 {
                    // 提交成功，跳转到下一步
                    let vc = Mancry_AuthFourStepsVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    // 提交失败，显示错误信息
                    let message = result["resultMsg"] as? String ?? "Submit failed"
                    self.mac_centerToastViewwithMsg(msg: message)
                }
            },
            failureCallBack: { [weak self] error in
                self?.mac_hiddenLoadingView()
                self?.mac_centerToastViewwithMsg(msg: "Network error")
            }
        )
    }
    
    // MARK: - Contact Type
    
    enum ContactType {
        case contact01
        case contact02
        case contact03
    }
}

// MARK: - CNContactPickerDelegate

extension Mancry_AuthThreeStepsVC: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        guard let editingCard = mancry_currentEditingCard else { return }

        let contact = contactProperty.contact

        
        let (nameRegex, phoneRegex) = mancry_validationRegex(for: editingCard)

        
        let formatted = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
        let name = !formatted.isEmpty
        ? formatted
        : [contact.givenName, contact.familyName].compactMap { $0.isEmpty ? nil : $0 }.joined(separator: " ")
        if name.isEmpty {
            mac_centerToastViewwithMsg(msg: "You can not leave your name section empty")
            return
        }
        if let nameRegex, !nameRegex.isEmpty, !mancry_matchRegex(name, pattern: nameRegex) {
            mac_centerToastViewwithMsg(msg: "Selected contact name format is invalid")
            return
        }

        // 2) 获取/校验用户点选的电话号码
        guard let phoneNumberValue = contactProperty.value as? CNPhoneNumber else {
            mac_centerToastViewwithMsg(msg: "Please choose a phone number")
            return
        }
        let phoneNumber = phoneNumberValue.stringValue
        let cleanedPhone = mancry_cleanPhone(phoneNumber)
        if cleanedPhone.isEmpty {
            mac_centerToastViewwithMsg(msg: "Selected phone number is empty")
            return
        }
        // 通讯录取号规则：去特殊字符、去国号前缀后，须为 9 开头的 10 位手机号
        guard mancry_isValidContactMobile(cleanedPhone) else {
            mac_centerToastViewwithMsg(msg: "Please enter the correct mobile number")
            return
        }
        if let phoneRegex, !phoneRegex.isEmpty, !mancry_matchRegex(cleanedPhone, pattern: phoneRegex) {
            mac_centerToastViewwithMsg(msg: "Selected phone number format is invalid")
            return
        }

        // 3) 去重：如果该手机号已被其他联系人提交过，则提示并拦截
        if mancry_isDuplicatePhone(cleanedPhone, currentCard: editingCard) {
            mac_centerToastViewwithMsg(msg: "The contact has been submitted, please enter another contact")
            return
        }

        // 4) 通过校验后再回填 UI
        editingCard.mancry_nameValue = name
        editingCard.mancry_phoneValue = cleanedPhone

        // 5) 更新数据模型
        if editingCard == mancry_contact01Card {
            mancry_contact01.nameItem?.value = name
            mancry_contact01.nameItem?.displayText = name
            mancry_contact01.phoneItem?.value = cleanedPhone
            mancry_contact01.phoneItem?.displayText = cleanedPhone
        } else if editingCard == mancry_contact02Card {
            mancry_contact02.nameItem?.value = name
            mancry_contact02.nameItem?.displayText = name
            mancry_contact02.phoneItem?.value = cleanedPhone
            mancry_contact02.phoneItem?.displayText = cleanedPhone
        } else if editingCard == mancry_contact03Card {
            mancry_contact03.nameItem?.value = name
            mancry_contact03.nameItem?.displayText = name
            mancry_contact03.phoneItem?.value = cleanedPhone
            mancry_contact03.phoneItem?.displayText = cleanedPhone
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        // 用户取消选择
    }
}

// MARK: - Contact picker validation helpers

private extension Mancry_AuthThreeStepsVC {
    func mancry_validationRegex(for card: Mancry_ContactCardView) -> (name: String?, phone: String?) {
        if card === mancry_contact01Card {
            return (mancry_contact01.nameItem?.regularExpression, mancry_contact01.phoneItem?.regularExpression)
        } else if card === mancry_contact02Card {
            return (mancry_contact02.nameItem?.regularExpression, mancry_contact02.phoneItem?.regularExpression)
        } else if card === mancry_contact03Card {
            return (mancry_contact03.nameItem?.regularExpression, mancry_contact03.phoneItem?.regularExpression)
        }
        return (nil, nil)
    }

    func mancry_matchRegex(_ text: String, pattern: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return false }
        let range = NSRange(location: 0, length: text.count)
        return regex.firstMatch(in: text, options: [], range: range) != nil
    }

    /// 去除特殊字符，去掉国号前缀（630 / 63 / 0），得到本地号码
    func mancry_cleanPhone(_ number: String) -> String {
        var digitsOnly = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        // 优先去菲律宾国码，再去掉前导 0
        if digitsOnly.hasPrefix("6309") && digitsOnly.count >= 13 {
            digitsOnly = String(digitsOnly.dropFirst(3)) // 630 -> 09... then strip 0 below
        } else if digitsOnly.hasPrefix("639") && digitsOnly.count >= 12 {
            digitsOnly = String(digitsOnly.dropFirst(2)) // 63
        }
        while digitsOnly.hasPrefix("0") {
            digitsOnly = String(digitsOnly.dropFirst())
        }
        return digitsOnly
    }
    
    /// 9 开头的 10 位手机号
    func mancry_isValidContactMobile(_ phone: String) -> Bool {
        guard phone.count == 10, phone.hasPrefix("9") else { return false }
        return phone.allSatisfy { $0.isNumber }
    }

    func mancry_isDuplicatePhone(_ cleanedPhone: String, currentCard: Mancry_ContactCardView) -> Bool {
        guard !cleanedPhone.isEmpty else { return false }
        let phones: [(card: Mancry_ContactCardView, phone: String)] = [
            (mancry_contact01Card, mancry_contact01.phoneItem?.value ?? ""),
            (mancry_contact02Card, mancry_contact02.phoneItem?.value ?? ""),
            (mancry_contact03Card, mancry_contact03.phoneItem?.value ?? "")
        ]

        for item in phones {
            guard item.card !== currentCard else { continue }
            if item.phone == cleanedPhone {
                return true
            }
        }
        return false
    }
}
