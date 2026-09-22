
import UIKit
import SnapKit

class Mancry_MeOneVC: Mac_BaseViewController {
    
    // MARK: - Properties
    
    // 银行卡列表数据
    private var mancry_bankCardList: [[String: Any]] = []
    
    // TableView
    private lazy var mancry_tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(hex: "#EDF1D8")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(Mancry_BankCardCell.self, forCellReuseIdentifier: "Mancry_BankCardCell")
        tableView.register(Mancry_BankInfoCell.self, forCellReuseIdentifier: "Mancry_BankInfoCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    // Add 按钮
    private lazy var mancry_addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Add", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        button.backgroundColor = UIColor(hex: "#CADC00")
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(mancry_addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        mac_publiccustomnavView(title: "Bank Account")
        mancry_setupUI()
        mancry_setupConstraints()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        mancry_loadBankCardList()
    }
    
    
    
    // MARK: - Setup UI
    
    private func mancry_setupUI() {
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        
        view.addSubview(mancry_tableView)
        view.addSubview(mancry_addButton)
    }
    
    private func mancry_setupConstraints() {
        
        // Add 按钮
        mancry_addButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }
        
        // TableView
        mancry_tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(mancry_addButton.snp.top).offset(-16)
        }
    }
    
    // MARK: - Actions
    
    @objc private func mancry_addButtonTapped() {
        // 检查是否可以添加银行卡
        mancry_checkCanAddBankCard()
    }
    
    // MARK: - Network Requests
    
    /// 加载银行卡列表
    private func mancry_loadBankCardList() {
        self.mancry_bankCardList.removeAll()
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: [:])
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else { return }
        
        self.mac_PopLoadingView()
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/payAccountInfo/list",
            httpBody: postData,
            successCallBack: { [weak self] result in
                self?.mac_hiddenLoadingView()
                let code = result["resultCode"] as? Int ?? -1
                if code == 200 {
                    guard let dataDict = result["data"] as? [String: Any],
                          let bankCardList = dataDict["payAccountInfoList"] as? [[String: Any]] else {
                        return
                    }
                    self?.mancry_bankCardList = bankCardList
                    self?.mancry_tableView.reloadData()
                } else {
                    let message = result["resultMsg"] as? String ?? "Failed to load bank cards"
                    self?.mac_centerToastViewwithMsg(msg: message)
                }
            },
            failureCallBack: { [weak self] error in
                self?.mac_hiddenLoadingView()
                self?.mac_centerToastViewwithMsg(msg: "Network error, please try again")
            }
        )
    }
    
    /// 刷新所有银行卡 cell 的按钮状态
    private func mancry_refreshAllBankCardCells() {
        for i in 0..<mancry_bankCardList.count {
            let indexPath = IndexPath(row: i, section: 0)
            if let cell = mancry_tableView.cellForRow(at: indexPath) as? Mancry_BankCardCell {
                let bankCard = mancry_bankCardList[i]
                cell.mancry_configure(with: bankCard)
            }
        }
    }
    
    /// 更新默认银行卡
    private func mancry_updateDefaultBankCard(accountId: String) {
        let requestData: [String: Any] = [
            "defaultFlag": "1",
            "recordId": accountId
        ]
        
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: requestData, isSign: false)
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else {
            mac_centerToastViewwithMsg(msg: "Request failed")
            return
        }
        
        self.mac_PopLoadingView()
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/payAccountInfo/update",
            httpBody: postData,
            successCallBack: { [weak self] result in
                self?.mac_hiddenLoadingView()
                let code = result["resultCode"] as? Int ?? -1
                if code == 200 {
                    
                    self?.mancry_loadBankCardList()
                } else {
                    let message = result["resultMsg"] as? String ?? "Failed to update default account"
                    self?.mac_centerToastViewwithMsg(msg: message)
                }
            },
            failureCallBack: { [weak self] error in
                self?.mac_hiddenLoadingView()
                self?.mac_centerToastViewwithMsg(msg: "Network error, please try again")
            }
        )
    }
    
    /// 检查是否可以添加银行卡
    private func mancry_checkCanAddBankCard() {
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: [:])
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else { return }
        
        self.mac_PopLoadingView()
        let errorMes = "Please complete KYC verification before adding a payout account."
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/kyc/four/status",
            httpBody: postData,
            successCallBack: { [weak self] result in
                self?.mac_hiddenLoadingView()
                let code = result["resultCode"] as? Int ?? -1
                if code == 200 {
                    guard let data = result["data"] as? [String: Any] else { return }
                    if let dataDict = data as? [String: Any],
                       let history = dataDict["echoMap"] as? [String: Any],
                       let willExecuteStepNumber = history["willExecuteStepNumber"] as? String {
                        let fig_willexNum = Int(willExecuteStepNumber) ?? 0
                        
                        if fig_willexNum == -1{
                            let vc = Mancry_EditCardVC()
                            vc.nestType = "add"
                            self?.navigationController?.pushViewController(vc, animated: true)

                        }else{
                            self?.mac_centerToastViewwithMsg(msg: "You need to finish KYC verification to add a bank account.")
                        }
                        


                }
                } else {
                    let message = result["resultMsg"] as? String ?? errorMes
                    self?.mac_centerToastViewwithMsg(msg: message)
                }
            },
            failureCallBack: { [weak self] error in
                self?.mac_hiddenLoadingView()
                
            }
        )
    }
    
    /// 跳转到添加银行卡页面
    private func mancry_navigateToAddBankCard() {
        // 跳转到添加银行卡页面
        print("Navigate to add bank card page")
        // let addVC = Mancry_AddBankCardVC()
        // navigationController?.pushViewController(addVC, animated: true)
    }
}

// MARK: - UITableView Delegate & DataSource

extension Mancry_MeOneVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mancry_bankCardList.count + 1 // +1 是提示信息cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == mancry_bankCardList.count{
            // 提示信息cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "Mancry_BankInfoCell", for: indexPath) as! Mancry_BankInfoCell
            return cell
        } else {
            // 银行卡cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "Mancry_BankCardCell", for: indexPath) as! Mancry_BankCardCell
            cell.selectionStyle = .none
            if indexPath.row < mancry_bankCardList.count {
                let bankCard = mancry_bankCardList[indexPath.row]
                cell.mancry_configure(with: bankCard)
                cell.mancry_defaultButtonTapped = { [weak self] in
                    guard let self = self else { return }
                    // 检查是否已经是默认账户
                    let isDefault = bankCard["defaultFlag"] as? String
                    if isDefault == "1"{
                        return // 已经是默认账户，不需要更新
                    }
                    
                    // 更新所有银行卡的 isDefault 状态
                    for i in 0..<self.mancry_bankCardList.count {
                        self.mancry_bankCardList[i]["isDefault"] = (i == indexPath.row)
                    }
                    
                    // 刷新所有银行卡 cell 的按钮状态
                    self.mancry_refreshAllBankCardCells()
                    
                    if let accountId = bankCard["recordId"] as? String {
                        self.mancry_updateDefaultBankCard(accountId: accountId)
                    }
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == mancry_bankCardList.count{
            return 100 // 提示信息cell高度
        }
        return 180 // 银行卡cell高度
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < mancry_bankCardList.count {
            let bankCard = mancry_bankCardList[indexPath.row]
            let canEdit = bankCard["editFlag"] as? String
            
            if canEdit == "1" {
                // 可以编辑，跳转到编辑页面
                print("Edit bank card: \(bankCard)")
                
                let vc = Mancry_EditCardVC()
                
                vc.nestType = "edit" // 或 "edit"
                vc.mancry_recordId = bankCard["recordId"] as! String
                vc.mancry_isSelect = bankCard["defaultFlag"] as! String
                
                vc.prefillAccountType = bankCard["accountType"] as? String
                vc.prefillBankName = bankCard["bankCode"] as? String
                vc.prefillAccountNo = bankCard["accountNo"] as? String
    
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
    }
}

// MARK: - Bank Card Cell

class Mancry_BankCardCell: UITableViewCell {
    
    var mancry_defaultButtonTapped: (() -> Void)?
    
    // 容器视图
    private lazy var mancry_containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // 银行卡背景
    private lazy var mancry_backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbebw_bank_bg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.isUserInteractionEnabled = true // 允许接收触摸事件
        return imageView
    }()
    
    // Default 复选框按钮
    private lazy var mancry_defaultButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Default", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.setTitleColor(UIColor(hex: "#CADC00"), for: .normal)
        button.setImage(UIImage(named: "flbsss_qs-fxk-icon-u"), for: .selected)
        button.setImage(UIImage(named: "flbsss_qs-fxk-icon-u(1)"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.isUserInteractionEnabled = true // 确保按钮可以接收触摸事件
        button.addTarget(self, action: #selector(mancry_defaultButtonAction), for: .touchUpInside)
        return button
    }()
    
    // 账户编号
    private lazy var mancry_accountNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(hex: "#CADC00")
        label.textAlignment = .right
        return label
    }()
    
    // 银行卡号
    private lazy var mancry_cardNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    // 账户持有人
    private lazy var mancry_accountHolderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#CADC00")
        return label
    }()
    
    // 编辑图标
    private lazy var mancry_editImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbeql_bank_edit")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        mancry_setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func mancry_setupUI() {
        contentView.addSubview(mancry_containerView)
        mancry_containerView.addSubview(mancry_backgroundImageView)
        mancry_backgroundImageView.addSubview(mancry_defaultButton)
        mancry_backgroundImageView.addSubview(mancry_accountNumberLabel)
        mancry_backgroundImageView.addSubview(mancry_cardNumberLabel)
        mancry_backgroundImageView.addSubview(mancry_accountHolderLabel)
        mancry_backgroundImageView.addSubview(mancry_editImageView)
        
        mancry_containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().offset(0)
            make.top.bottom.equalToSuperview().offset(0)
        }
        
        mancry_backgroundImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        mancry_defaultButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        mancry_accountNumberLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
        }
        
        mancry_cardNumberLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        mancry_accountHolderLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        mancry_editImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.width.height.equalTo(24)
        }
    }
    
    func mancry_configure(with bankCard: [String: Any]) {
        // defaultFlag: "1" 表示默认账户
        let defaultFlag = bankCard["defaultFlag"] as? String ?? "0"
        mancry_defaultButton.isSelected = (defaultFlag == "1")
        
        // accountNumber 使用 bankCode 字段
        let bankCode = bankCard["accountType"] as? String ?? ""
        mancry_accountNumberLabel.text = bankCode
        
        // cardNumber 使用 accountNo 字段，格式化银行卡号（每4位加空格）
        let accountNo = bankCard["accountNo"] as? String ?? ""
        let formattedCardNumber = mancry_formatCardNumber(accountNo)
        mancry_cardNumberLabel.text = formattedCardNumber
        
        // accountHolder 使用 accountName 字段
        let accountName = bankCard["accountName"] as? String ?? ""
        mancry_accountHolderLabel.text = accountName
        
        // editFlag: "1" 表示可以编辑，显示编辑图标
        let editFlag = bankCard["editFlag"] as? String ?? "0"
        mancry_editImageView.isHidden = (editFlag != "1")
    }
    
    /// 格式化银行卡号（每4位加空格）
    private func mancry_formatCardNumber(_ cardNumber: String) -> String {
        let cleaned = cardNumber.replacingOccurrences(of: " ", with: "")
        var formatted = ""
        for (index, char) in cleaned.enumerated() {
            if index > 0 && index % 4 == 0 {
                formatted += " "
            }
            formatted.append(char)
        }
        return formatted
    }
    
    @objc private func mancry_defaultButtonAction() {
        // 点击后，按钮变为选中状态
        mancry_defaultButton.isSelected = true
        // 回调由外部控制，这里只更新按钮状态
        mancry_defaultButtonTapped?()
    }
}

// MARK: - Bank Info Cell

class Mancry_BankInfoCell: UITableViewCell {
    
    // 容器视图
    private lazy var mancry_containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#505D2A")
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    // 提示文字
    private lazy var mancry_infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Multiple receiving accounts are supported. If the default method fails, the system will automatically use your backup account for the transfer."
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        mancry_setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func mancry_setupUI() {
        contentView.addSubview(mancry_containerView)
        mancry_containerView.addSubview(mancry_infoLabel)
        
        mancry_containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        mancry_infoLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}



