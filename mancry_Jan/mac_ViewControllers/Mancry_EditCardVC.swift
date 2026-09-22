

import UIKit
import SnapKit

class Mancry_EditCardVC: Mac_BaseViewController {

    // MARK: - Models
    struct FieldConfig {
        let itemCode: String
        let itemName: String
        let itemType: Int // 1=text, 3=select, 4=api_select
        let itemSort: Int
        let buttonList: [(label: String, key: String)]?
        let placeholder: String
        let isRequired: Int
        let regularExpression: String
        let frontPrompts: [String]
        let rearPrompts: [String]
    }
    
    // MARK: - Properties
    var nestType = "" // "add" or "edit"
    var mancry_recordId = ""
    var mancry_isSelect = "0" // 默认选中
    
    // Prefill data for edit mode
    var prefillAccountType: String?
    var prefillBankName: String?
    var prefillAccountNo: String?
    
    private var fieldConfigs: [FieldConfig] = []
    private var fieldValues: [String: String] = [:]
    private var walletList: [(name: String, id: String)] = []
    private var bankList: [(name: String, id: String)] = []
    private var selectedAccountType: String?
    
    // MARK: - UI Components
    private lazy var mancry_tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SelectTableViewCell.self, forCellReuseIdentifier: "SelectTableViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    private lazy var mancry_submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(nestType == "edit" ? "Submit" : "Submit", for: .normal)
        button.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(hex: "#CADC00")
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(mancry_submitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mac_publiccustomnavView(title: "Change bank account")
        mancry_setupUI()
        mancry_setupConstraints()
        mancry_requestKycInit()
    }
    
    // MARK: - Setup
    private func mancry_setupUI() {
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        view.addSubview(mancry_tableView)
        view.addSubview(mancry_submitButton)
    }
    
    private func mancry_setupConstraints() {
        mancry_submitButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(56)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        
        mancry_tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(54)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(mancry_submitButton.snp.top).offset(-16)
        }
    }
    
    // MARK: - Network Requests
    private func mancry_requestKycInit() {
        let dataPayload: [String: Any] = ["kycId": "pay_account"]
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: dataPayload,isSign: false)
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else { return }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/payAccountInfo/payAccountItemList",
            httpBody: postData,
            successCallBack: { [weak self] result in
                guard let self = self else { return }
                self.mancry_handleKycInitResponse(result)
            },
            failureCallBack: { [weak self] error in
                self?.mac_centerToastViewwithMsg(msg: "Failed to load form, please try again")
            }
        )
    }
    
    private func mancry_handleKycInitResponse(_ result: [String: Any]) {
        guard let resultCode = result["resultCode"] as? Int, resultCode == 200,
              let data = result["data"] as? [String: Any],
              let kycItemList = data["payAccountInfoItemDtoList"] as? [[String: Any]] else {
            mac_centerToastViewwithMsg(msg: "Invalid form data")
            return
        }
        
        // Parse field configs
        fieldConfigs.removeAll()
        for itemDict in kycItemList {
            if let itemCode = itemDict["itemCode"] as? String,
               let itemName = itemDict["itemName"] as? String,
               let itemType = itemDict["itemType"] as? Int,
               let itemSort = itemDict["itemSort"] as? Int {
                
                let isRequired = itemDict["isRequired"] as? Int ?? 0
                let regularExpression = itemDict["regularExpression"] as? String ?? ""
                let frontPrompts = itemDict["frontPrompts"] as? [String] ?? []
                let rearPrompts = itemDict["rearPrompts"] as? [String] ?? []
                
                // Parse buttonList
                var buttonList: [(label: String, key: String)]? = nil
                if let buttonListArray = itemDict["buttonList"] as? [[String: Any]], !buttonListArray.isEmpty {
                    let buttons = buttonListArray.compactMap { buttonDict -> (label: String, key: String, sort: Int)? in
                        guard let label = buttonDict["buttonLabel"] as? String,
                              let key = buttonDict["buttonKey"] as? String,
                              let sort = buttonDict["buttonSort"] as? Int else {
                            return nil
                        }
                        return (label: label, key: key, sort: sort)
                    }
                    buttonList = buttons.sorted { $0.sort < $1.sort }.map { ($0.label, $0.key) }
                }
                
                let placeholder = frontPrompts.first ?? (itemType == 3 || itemType == 4 ? "Please choose" : "Please enter")
                
                let config = FieldConfig(
                    itemCode: itemCode,
                    itemName: itemName,
                    itemType: itemType,
                    itemSort: itemSort,
                    buttonList: buttonList,
                    placeholder: placeholder,
                    isRequired: isRequired,
                    regularExpression: regularExpression,
                    frontPrompts: frontPrompts,
                    rearPrompts: rearPrompts
                )
                fieldConfigs.append(config)
            }
        }
        
        // Sort by itemSort
        fieldConfigs.sort { $0.itemSort < $1.itemSort }
        
        // Reload table
        DispatchQueue.main.async { [weak self] in
            self?.mancry_tableView.reloadData()
            self?.mancry_applyPrefillDataIfNeeded()
            self?.mancry_requestUserInfo()
        }
    }
    
    private func mancry_requestUserInfo() {
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: [:])
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else { return }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/user/info",
            httpBody: postData,
            successCallBack: { [weak self] result in
                guard let self = self else { return }
                self.mancry_handleUserInfoResponse(result)
            },
            failureCallBack: { _ in }
        )
    }
    
    private func mancry_handleUserInfoResponse(_ result: [String: Any]) {
        guard let resultCode = result["resultCode"] as? Int, resultCode == 200,
              let data = result["data"] as? [String: Any],
              let name = data["name"] as? String else {
            return
        }
        
        // Fill account_name field
        if let nameIndex = fieldConfigs.firstIndex(where: { $0.itemCode == "account_name" }) {
            fieldValues["account_name"] = name
            DispatchQueue.main.async { [weak self] in
                self?.mancry_tableView.reloadRows(at: [IndexPath(row: nameIndex, section: 0)], with: .none)
            }
        }
    }
    
    private func mancry_requestWalletList(completion: @escaping () -> Void) {
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: [:])
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else { return }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/sys/wallet",
            httpBody: postData,
            successCallBack: { [weak self] result in
                guard let self = self else { return }
                self.mancry_handleWalletResponse(result, completion: completion)
            },
            failureCallBack: { [weak self] error in
                self?.mac_centerToastViewwithMsg(msg: "Failed to load wallet list")
            }
        )
    }
    
    private func mancry_handleWalletResponse(_ result: [String: Any], completion: @escaping () -> Void) {
        guard let resultCode = result["resultCode"] as? Int, resultCode == 200,
              let data = result["data"] as? [String: Any] else {
            mac_centerToastViewwithMsg(msg: "Failed to load wallet list")
            return
        }
        
        walletList.removeAll()
        
        var walletListArray: [[String: Any]] = []
        if let wallets = data["walletList"] as? [[String: Any]] {
            walletListArray = wallets
        } else if let wallets = data["list"] as? [[String: Any]] {
            walletListArray = wallets
        }
        
        let wallets = walletListArray.compactMap { dict -> (name: String, id: String, sort: Int)? in
            let label = (dict["label"] as? String) ?? (dict["name"] as? String)
            let key = (dict["key"] as? String) ?? (dict["id"] as? String)
            guard let label = label, let key = key else { return nil }
            let sort = dict["sort"] as? Int ?? 0
            return (name: label, id: key, sort: sort)
        }
        
        walletList = wallets.sorted { $0.sort < $1.sort }.map { ($0.name, $0.id) }
        completion()
    }
    
    private func mancry_requestBankList(completion: @escaping () -> Void) {
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: [:])
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else { return }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/sys/bank",
            httpBody: postData,
            successCallBack: { [weak self] result in
                guard let self = self else { return }
                self.mancry_handleBankResponse(result, completion: completion)
            },
            failureCallBack: { [weak self] error in
                self?.mac_centerToastViewwithMsg(msg: "Failed to load bank list")
            }
        )
    }
    
    private func mancry_handleBankResponse(_ result: [String: Any], completion: @escaping () -> Void) {
        guard let resultCode = result["resultCode"] as? Int, resultCode == 200,
              let data = result["data"] as? [String: Any] else {
            mac_centerToastViewwithMsg(msg: "Failed to load bank list")
            return
        }
        
        bankList.removeAll()
        
        var bankListArray: [[String: Any]] = []
        if let banks = data["bankList"] as? [[String: Any]] {
            bankListArray = banks
        } else if let banks = data["list"] as? [[String: Any]] {
            bankListArray = banks
        }
        
        let banks = bankListArray.compactMap { dict -> (name: String, id: String, sort: Int)? in
            let label = (dict["label"] as? String) ?? (dict["name"] as? String)
            let key = (dict["key"] as? String) ?? (dict["id"] as? String)
            guard let label = label, let key = key else { return nil }
            let sort = dict["sort"] as? Int ?? 0
            return (name: label, id: key, sort: sort)
        }
        
        bankList = banks.sorted { $0.sort < $1.sort }.map { ($0.name, $0.id) }
        completion()
    }
    
    // MARK: - Actions
    @objc private func mancry_submitButtonTapped() {
        guard mancry_validateInputs() else { return }
        
        if nestType == "add" {
            mancry_submitAdd()
        } else {
            mancry_submitEdit()
        }
    }
    
    private func mancry_validateInputs() -> Bool {
        for config in fieldConfigs {
            if config.isRequired == 1 {
                let value = fieldValues[config.itemCode] ?? ""
                if value.trimmingCharacters(in: .whitespaces).isEmpty {
                    let message = config.rearPrompts.first ?? "Please \(config.itemType == 1 ? "enter" : "select") \(config.itemName)"
                    mac_centerToastViewwithMsg(msg: message)
                    return false
                }
                
                // Validate regex
                if !config.regularExpression.isEmpty && !value.isEmpty {
                    let regex = try? NSRegularExpression(pattern: config.regularExpression)
                    let range = NSRange(location: 0, length: value.utf16.count)
                    if let regex = regex, regex.firstMatch(in: value, options: [], range: range) == nil {
                        let message = config.rearPrompts.first ?? "Invalid format for \(config.itemName.lowercased())"
                        mac_centerToastViewwithMsg(msg: message)
                        return false
                    }
                }
            }
        }
        return true
    }
    
    private func mancry_submitAdd() {
        let itemListArr: [[String: Any]] = fieldConfigs.compactMap { config in
            guard let value = fieldValues[config.itemCode] else { return nil }
            return [
                "itemCode": config.itemCode,
                "itemValueType": 1,
                "itemValue": value
            ]
        }
        
        let dataPayload: [String: Any] = [
            "defaultFlag": mancry_isSelect,
            "kycCommitItemList": itemListArr
        ]
        
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: dataPayload)
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else { return }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/payAccountInfo/save",
            httpBody: postData,
            successCallBack: { [weak self] result in
                guard let self = self else { return }
                self.mancry_handleSubmitResponse(result)
            },
            failureCallBack: { [weak self] error in
                self?.mac_centerToastViewwithMsg(msg: "Submit failed, please try again")
            }
        )
    }
    
    private func mancry_submitEdit() {
        let itemListArr: [[String: Any]] = fieldConfigs.compactMap { config in
            guard let value = fieldValues[config.itemCode] else { return nil }
            return [
                "itemCode": config.itemCode,
                "itemValue": value
            ]
        }
        
        let dataPayload: [String: Any] = [
            "defaultFlag": mancry_isSelect,
            "kycCommitItemList": itemListArr,
            "recordId": mancry_recordId
        ]
        print("\(dataPayload)")
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: dataPayload)
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else { return }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/payAccountInfo/update",
            httpBody: postData,
            successCallBack: { [weak self] result in
                guard let self = self else { return }
                self.mancry_handleSubmitResponse(result)
            },
            failureCallBack: { [weak self] error in
                self?.mac_centerToastViewwithMsg(msg: "Submit failed, please try again")
            }
        )
    }
    
    private func mancry_handleSubmitResponse(_ result: [String: Any]) {
        guard let resultCode = result["resultCode"] as? Int else { return }
        
        if resultCode == 200 {
            navigationController?.popViewController(animated: true)
        } else {
            let errorMsg = result["resultMsg"] as? String ?? "Submit failed"
            mac_centerToastViewwithMsg(msg: errorMsg)
        }
    }
    
    private func mancry_applyPrefillDataIfNeeded() {
        // 先设置 account_type
        if let type = prefillAccountType, !type.isEmpty {
            selectedAccountType = type
            fieldValues["account_type"] = type
        }
        
        // 设置 account_no
        if let accountNo = prefillAccountNo, !accountNo.isEmpty {
            fieldValues["account_no"] = accountNo
        }
        
        // 如果有 bankName 需要预填充，先加载对应的列表
        if let bankName = prefillBankName, !bankName.isEmpty, let accountType = selectedAccountType {
            if accountType == "E-wallet" {
                // 加载钱包列表
                mancry_requestWalletList { [weak self] in
                    guard let self = self else { return }
                    // 设置 bank_name
                    self.fieldValues["bank_name"] = bankName
                    self.mancry_tableView.reloadData()
                }
            } else if accountType == "BankTransfer" {
                // 加载银行列表
                mancry_requestBankList { [weak self] in
                    guard let self = self else { return }
                    // 设置 bank_name
                    self.fieldValues["bank_name"] = bankName
                    self.mancry_tableView.reloadData()
                }
            } else {
                mancry_tableView.reloadData()
            }
        } else {
            mancry_tableView.reloadData()
        }
    }
    
    private func mancry_showPicker(options: [String], title: String, completion: @escaping (String) -> Void) {
        let popup = Mancry_customselectPopupView()
        popup.configure(title: title, data: options)
        popup.onConfirm = { index, value in
            completion(value)
        }
        popup.onCancel = {}
        popup.show()
    }
}

// MARK: - UITableViewDelegate & DataSource
extension Mancry_EditCardVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fieldConfigs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectTableViewCell", for: indexPath) as! SelectTableViewCell
        cell.selectionStyle = .none
        let config = fieldConfigs[indexPath.row]
        
        // Configure cell based on field type
        if config.itemType == 1 {
            // Text input
            cell.mancry_titleLabel.text = config.itemName
            cell.mancry_textField.text = fieldValues[config.itemCode]
            cell.mancry_textField.placeholder = "" // 清除 textField 自带的 placeholder
            
            // account_name 字段不可编辑
            if config.itemCode == "account_name" {
                cell.mancry_textField.isUserInteractionEnabled = false
                cell.mancry_textField.textColor = UIColor(hex: "#999999")
            } else {
                cell.mancry_textField.isUserInteractionEnabled = true
                cell.mancry_textField.textColor = UIColor(hex: "#2C2F20")
            }
            
            cell.mancry_arrowImageView.isHidden = true
            cell.mancry_selectOverlayButton.isHidden = true
            
            // 设置自定义 placeholder
            cell.mancry_placeholderLabel.text = "Please enter"
            cell.mancry_placeholderLabel.isHidden = !(fieldValues[config.itemCode] ?? "").isEmpty
            
            // Set keyboard type
            if !config.regularExpression.isEmpty && config.regularExpression.contains("\\d") {
                cell.mancry_textField.keyboardType = .numberPad
            } else {
                cell.mancry_textField.keyboardType = .default
            }
            
            cell.mancry_textField.tag = indexPath.row
            cell.mancry_textField.addTarget(self, action: #selector(mancry_textFieldDidChange(_:)), for: .editingChanged)
            
        } else {
            // Select field
            cell.mancry_titleLabel.text = config.itemName
            cell.mancry_textField.isUserInteractionEnabled = false
            cell.mancry_textField.placeholder = "" // 清除 textField 自带的 placeholder
            cell.mancry_arrowImageView.isHidden = false
            cell.mancry_selectOverlayButton.isHidden = false
            cell.mancry_textField.textColor = UIColor(hex: "#2C2F20")
            
            // 设置自定义 placeholder
            cell.mancry_placeholderLabel.text = "Please choose"
            
            // Display selected value
            if let value = fieldValues[config.itemCode], !value.isEmpty {
                // For select fields, show the label instead of key
                if config.itemType == 3, let buttonList = config.buttonList {
                    if let button = buttonList.first(where: { $0.key == value }) {
                        cell.mancry_textField.text = button.label
                        cell.mancry_placeholderLabel.isHidden = true
                    }
                } else if config.itemType == 4 {
                    // For API select, show the name from list
                    if config.itemCode == "bank_name" {
                        if let wallet = walletList.first(where: { $0.id == value }) {
                            cell.mancry_textField.text = wallet.name
                            cell.mancry_placeholderLabel.isHidden = true
                        } else if let bank = bankList.first(where: { $0.id == value }) {
                            cell.mancry_textField.text = bank.name
                            cell.mancry_placeholderLabel.isHidden = true
                        }
                    }
                }
            } else {
                cell.mancry_textField.text = ""
                cell.mancry_placeholderLabel.isHidden = false
            }
            
            cell.mancry_selectOverlayButton.tag = indexPath.row
            cell.mancry_selectOverlayButton.addTarget(self, action: #selector(mancry_selectFieldTapped(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70
//    }
    
    @objc private func mancry_textFieldDidChange(_ textField: UITextField) {
        let index = textField.tag
        guard index < fieldConfigs.count else { return }
        let config = fieldConfigs[index]
        fieldValues[config.itemCode] = textField.text ?? ""
        
        // 更新 placeholder 显示状态
        if let cell = mancry_tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? SelectTableViewCell {
            cell.mancry_placeholderLabel.isHidden = !(textField.text ?? "").isEmpty
        }
    }
    
    @objc private func mancry_selectFieldTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index < fieldConfigs.count else { return }
        let config = fieldConfigs[index]
        
        view.endEditing(true)
        
        if config.itemType == 3, let buttonList = config.buttonList, !buttonList.isEmpty {
            // Select from buttonList
            let options = buttonList.map { $0.label }
            mancry_showPicker(options: options, title: config.itemName) { [weak self] selectedLabel in
                guard let self = self else { return }
                if let selectedButton = buttonList.first(where: { $0.label == selectedLabel }) {
                    self.selectedAccountType = selectedButton.key
                    self.fieldValues[config.itemCode] = selectedButton.key
                    
                    // Clear bank_name when account_type changes
                    if config.itemCode == "account_type" {
                        if let bankNameIndex = self.fieldConfigs.firstIndex(where: { $0.itemCode == "bank_name" }) {
                            self.fieldValues["bank_name"] = ""
                            self.walletList.removeAll()
                            self.bankList.removeAll()
                            self.mancry_tableView.reloadRows(at: [IndexPath(row: bankNameIndex, section: 0)], with: .none)
                        }
                    }
                    
                    self.mancry_tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
            }
        } else if config.itemType == 4 && config.itemCode == "bank_name" {
            // API select for bank_name
            guard let accountType = selectedAccountType else {
                mac_centerToastViewwithMsg(msg: "Please select account type first")
                return
            }
            
            if accountType == "E-wallet" {
                mancry_requestWalletList { [weak self] in
                    guard let self = self else { return }
                    if !self.walletList.isEmpty {
                        let options = self.walletList.map { $0.name }
                        self.mancry_showPicker(options: options, title: config.itemName) { [weak self] selectedName in
                            guard let self = self else { return }
                            if let selectedWallet = self.walletList.first(where: { $0.name == selectedName }) {
                                self.fieldValues[config.itemCode] = selectedWallet.id
                                self.mancry_tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                            }
                        }
                    } else {
                        self.mac_centerToastViewwithMsg(msg: "No wallet data available")
                    }
                }
            } else if accountType == "BankTransfer" {
                mancry_requestBankList { [weak self] in
                    guard let self = self else { return }
                    if !self.bankList.isEmpty {
                        let options = self.bankList.map { $0.name }
                        self.mancry_showPicker(options: options, title: config.itemName) { [weak self] selectedName in
                            guard let self = self else { return }
                            if let selectedBank = self.bankList.first(where: { $0.name == selectedName }) {
                                self.fieldValues[config.itemCode] = selectedBank.id
                                self.mancry_tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                            }
                        }
                    } else {
                        self.mac_centerToastViewwithMsg(msg: "No bank data available")
                    }
                }
            }
        }
    }
}
