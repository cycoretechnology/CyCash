

import UIKit
import SnapKit



class Mancry_HomeWithDrawnVC: Mac_BaseViewController {
    
    // MARK: - Public data
    var mancry_productId: String = ""
    var mancry_orderId: String = ""
    
    // MARK: - Data
    private var mancry_repaymentItems: [[String: Any]] = []
    /// 接口返回的 amountDetailList 全量数据
    private var mancry_amountDetailList: [[String: Any]] = []
    /// 当前选中的金额档位
    private var mancry_selectedAmountDetail: [String: Any]?
    /// 当前选中的期限档位
    private var mancry_selectedTermDetail: [String: Any]?
    /// 贷款详情列表数据（增加 isClickable、highlight 标记）
    private var mancry_loanDetailsData: [(title: String,
                                          value: String,
                                          showInfo: Bool,
                                          tooltipMessage: String,
                                          isClickable: Bool,
                                          highlight: Bool)] = []
    private var mancry_bankAccountNo: String = ""
    
    // MARK: - State
    private var mancry_isRepaymentExpanded: Bool = false
    
    // MARK: - UI Components
    private lazy var mancry_scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(hex: "#EDF1D8")
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var mancry_contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        return view
    }()
    
    // 顶部提示
    private lazy var mancry_infoBanner: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#505D2A")
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var mancry_infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "Take action right now! Once you confirm your pending withdrawal order, we will promptly transfer the funds to your bank account."
        return label
    }()
    
    // 还款计划
    private lazy var mancry_repaymentPlanView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var mancry_repaymentHeaderView: UIView = {
        let view = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(mancry_toggleRepaymentPlan))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var mancry_repaymentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Repayment Plan"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(hex: "#2C2F20")
        return label
    }()
    
    private lazy var mancry_repaymentArrowView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbeql_loan_hkjt")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var mancry_repaymentTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.rowHeight = 80
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(Mancry_RepaymentPlanCell.self, forCellReuseIdentifier: Mancry_RepaymentPlanCell.identifier)
        return tableView
    }()
    
    private var mancry_repaymentTableHeightConstraint: Constraint?
    
    private lazy var mancry_repaymentMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#666666")
        label.numberOfLines = 0
        label.text = "If you repay the first amount due on time, the remaining balance will be automatically reset to zero for you."
        return label
    }()
    
    // 产品卡
    private lazy var mancry_productCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var mancry_productLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var mancry_productTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(hex: "#777C61")
        label.text = "Product Name"
        return label
    }()
    
    private lazy var mancry_statusBadgeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbeql_order_ggyhk(1)")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var mancry_loanDetailsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 40
        tableView.estimatedRowHeight = 40
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(Mancry_LoanDetailCell.self, forCellReuseIdentifier: Mancry_LoanDetailCell.identifier)
        return tableView
    }()
    
    private var mancry_loanDetailsTableHeightConstraint: Constraint?
    
    // 银行卡模块
    private lazy var mancry_bankCardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var mancry_bankIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bankimg")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var mancry_bankCardNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(hex: "#2C2F20")
        label.text = "00000000000"
        return label
    }()
    
    // 底部按钮
    private lazy var mancry_bottomButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        return view
    }()
    
    private lazy var mancry_withdrawButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Withdraw", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        button.backgroundColor = UIColor(hex: "#CADC00")
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(mancry_withdrawButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mac_publiccustomnavView(title: "Loan details")
        mancry_setupUI()
        mancry_setupConstraints()
        mancry_requestProductDetailsData()
    }
    
    // MARK: - UI Setup
    private func mancry_setupUI() {
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        
        view.addSubview(mancry_scrollView)
        mancry_scrollView.addSubview(mancry_contentView)
        
        mancry_contentView.addSubview(mancry_infoBanner)
        mancry_infoBanner.addSubview(mancry_infoLabel)
        
        mancry_contentView.addSubview(mancry_repaymentPlanView)
        mancry_repaymentPlanView.addSubview(mancry_repaymentHeaderView)
        mancry_repaymentHeaderView.addSubview(mancry_repaymentTitleLabel)
        mancry_repaymentHeaderView.addSubview(mancry_repaymentArrowView)
        mancry_repaymentPlanView.addSubview(mancry_repaymentTableView)
        mancry_repaymentPlanView.addSubview(mancry_repaymentMessageLabel)
        
        mancry_contentView.addSubview(mancry_productCardView)
        mancry_productCardView.addSubview(mancry_productLogoImageView)
        mancry_productCardView.addSubview(mancry_productTitleLabel)
        mancry_productCardView.addSubview(mancry_statusBadgeImageView)
        mancry_productCardView.addSubview(mancry_loanDetailsTableView)
        mancry_productCardView.addSubview(mancry_bankCardView)
        
        mancry_bankCardView.addSubview(mancry_bankIconView)
        mancry_bankCardView.addSubview(mancry_bankCardNumberLabel)
        
        view.addSubview(mancry_bottomButtonContainer)
        mancry_bottomButtonContainer.addSubview(mancry_withdrawButton)
    }
    
    private func mancry_setupConstraints() {
        // 底部按钮容器
        mancry_bottomButtonContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        mancry_withdrawButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        // ScrollView
        mancry_scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(mancry_bottomButtonContainer.snp.top)
        }
        
        mancry_contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        mancry_infoBanner.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        mancry_infoLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        mancry_repaymentPlanView.snp.makeConstraints { make in
            make.top.equalTo(mancry_infoBanner.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        mancry_repaymentHeaderView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.equalTo(24)
        }
        
        mancry_repaymentTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        mancry_repaymentArrowView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        mancry_repaymentTableView.snp.makeConstraints { make in
            make.top.equalTo(mancry_repaymentHeaderView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            mancry_repaymentTableHeightConstraint = make.height.equalTo(80).constraint
        }
        
        mancry_repaymentMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(mancry_repaymentTableView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        mancry_productCardView.snp.makeConstraints { make in
            make.top.equalTo(mancry_repaymentPlanView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-24)
        }
        
        mancry_productLogoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(20)
        }
        
        mancry_productTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mancry_productLogoImageView)
            make.left.equalTo(mancry_productLogoImageView.snp.right).offset(8)
        }
        
        mancry_statusBadgeImageView.snp.makeConstraints { make in
            make.centerY.equalTo(mancry_productLogoImageView)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(24)
            make.width.greaterThanOrEqualTo(100)
        }
        
        mancry_loanDetailsTableView.snp.makeConstraints { make in
            make.top.equalTo(mancry_productTitleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            mancry_loanDetailsTableHeightConstraint = make.height.equalTo(40).constraint
        }
        
        mancry_bankCardView.snp.makeConstraints { make in
            make.top.equalTo(mancry_loanDetailsTableView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
        
        mancry_bankIconView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(68)
            make.height.equalTo(48)
        }
        
        mancry_bankCardNumberLabel.snp.makeConstraints { make in
            make.left.equalTo(mancry_bankIconView.snp.right).offset(12)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    // MARK: - Network
    private func mancry_requestProductDetailsData() {
        let bizData: [String: Any] = [
            "productId": mancry_productId,
            "appType": "DC",
            "orderId": mancry_orderId
        ]
        
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: bizData, isSign: false, ["orderId": mancry_orderId], true)
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else { return }
        
        mac_PopLoadingView()
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/order/withdrawn/detail",
            httpBody: postData,
            successCallBack: { [weak self] result in
                guard let self = self else { return }
                self.mac_hiddenLoadingView()
                
                let code = result["resultCode"] as? Int ?? -1
                guard code == 200 else {
                    let msg = result["resultMsg"] as? String ?? "Request failed"
                    self.mac_centerToastViewwithMsg(msg: msg)
                    return
                }
                
                guard let dataDict = result["data"] as? [String: Any] else { return }
                self.mancry_handleWithdrawnData(dataDict)
            },
            failureCallBack: { [weak self] error in
                self?.mac_centerToastViewwithMsg(msg: "Product state request failed")
                print("Product state request error: \(error.localizedDescription)")
            }
        )
    }
    
    private func mancry_tobowithTiXianData(loanAmount: String, loanTerm: String) {
        let mancry_bizData: [String: Any] = [
            "loanAmount": loanAmount,
            "loanTerm": loanTerm,
            "orderId": mancry_orderId
        ]
        
        let mancry_parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: mancry_bizData, isSign: false,["orderId":mancry_orderId],true)
        guard let mancry_postData = try? JSONSerialization.data(withJSONObject: mancry_parametersDic) else { return }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/order/apply/withdrawal",
            httpBody: mancry_postData,
            successCallBack: { [weak self] mancry_result in
                print("提现--\(mancry_result)")
                guard let self = self else { return }
                let code = mancry_result["resultCode"] as? Int ?? -1
                if code == 200 {
                    
                    let popView = Mancry_PopView(type: .thankYou)
                    popView.configure(
                        topImageName: "flbeql_tk_cg",
                        title: "Success!",
                        description: "Withdrawal is successful, the funds will be transferred to your bank account, please check",
                        rightButtonTitle: "Confirm"
                    )
                    popView.onRightButtonTapped = {
                        // Confirm 点击回调
                        self.navigationController?.popViewController(animated: true)
                    }
                    popView.show()
                }
            
            },
            failureCallBack: { [weak self] mancry_error in
                self?.mac_centerToastViewwithMsg(msg: "Product state request failed")
                print("Product state request error: \(mancry_error.localizedDescription)")
                
            }
        )
    }
    
    // MARK: - Data Handling
    private func mancry_handleWithdrawnData(_ data: [String: Any]) {
        // 顶部提示信息
        if let msg = data["message"] as? String, !msg.isEmpty {
            DispatchQueue.main.async {
                self.mancry_repaymentMessageLabel.text = msg
            }
        }
        
        // 产品名 / Logo
        if let productName = data["productName"] as? String {
            DispatchQueue.main.async {
                self.mancry_productTitleLabel.text = productName
            }
        }
        if let productLogo = data["productLogo"] as? String, let url = URL(string: productLogo) {
            DispatchQueue.main.async {
                self.mancry_productLogoImageView.sd_setImage(with: url)
            }
        }
        
        // 银行卡信息
        if let bankCardList = data["bankCardList"] as? [[String: Any]], let firstCard = bankCardList.first {
            let accountNo = firstCard["accountNo"] as? String ?? ""
            self.mancry_bankAccountNo = accountNo
            DispatchQueue.main.async {
                self.mancry_bankCardNumberLabel.text = accountNo
            }
        }
        
        // 还款计划 + 详情：默认选中 amountDetailList 最后一条，且其中 termDetailList 最后一条
        if let amountDetailList = data["amountDetailList"] as? [[String: Any]],
           !amountDetailList.isEmpty {
            mancry_amountDetailList = amountDetailList
            let selectedAmountDetail = amountDetailList.last!
            mancry_selectedAmountDetail = selectedAmountDetail
            
            if let termDetailList = selectedAmountDetail["termDetailList"] as? [[String: Any]],
               !termDetailList.isEmpty {
                mancry_selectedTermDetail = termDetailList.last!
                mancry_updateLoanAndRepaymentFromSelectedTerm()
            }
        }
    }
    
    /// 根据当前选中的金额与期限，更新还款计划和详情列表
    private func mancry_updateLoanAndRepaymentFromSelectedTerm() {
        guard let term = mancry_selectedTermDetail else { return }
        
        // 还款计划
        if let productTermItemList = term["productTermItemList"] as? [[String: Any]] {
            mancry_repaymentItems = productTermItemList
        } else {
            mancry_repaymentItems = []
        }
        
        // 详情列表
        var details: [(title: String,
                       value: String,
                       showInfo: Bool,
                       tooltipMessage: String,
                       isClickable: Bool,
                       highlight: Bool)] = []
        
        let formatAmount: (String?) -> String = { amountStr in
            guard let amountStr = amountStr, !amountStr.isEmpty,
                  let amount = Double(amountStr) else { return "₱ 0" }
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            formatter.maximumFractionDigits = 2
            return "₱ \(formatter.string(from: NSNumber(value: amount)) ?? amountStr)"
        }
        
        // Loan Amount（可切换，右侧高亮）
        var loanAmountRaw: String?
        if let selAmount = mancry_selectedAmountDetail,
           let amt = selAmount["loanAmount"] as? String {
            loanAmountRaw = amt
        } else if let amt = term["loanAmount"] as? String {
            loanAmountRaw = amt
        }
        if let loanAmountRaw = loanAmountRaw {
            details.append((
                title: "Loan Amount",
                value: formatAmount(loanAmountRaw),
                showInfo: false,
                tooltipMessage: "",
                isClickable: true,
                highlight: true
            ))
        }
        
        // Amount received（带说明）
        if let arrivalAmount = term["arrivalAmount"] as? String {
            details.append((
                title: "Amount received",
                value: formatAmount(arrivalAmount),
                showInfo: true,
                tooltipMessage: "The actual amount you receive is calculated by deducting the service fee and GST from the loan amount.",
                isClickable: false,
                highlight: false
            ))
        }
        
        // Service fee（带说明）
        if let feeAmount = term["feeAmount"] as? String {
            details.append((
                title: "Service fee",
                value: formatAmount(feeAmount),
                showInfo: true,
                tooltipMessage: "This is the fee charged by the financial institution for providing loan services.",
                isClickable: false,
                highlight: false
            ))
        }
        
        // Interest（带说明）
        if let taxAmount = term["taxAmount"] as? String {
            details.append((
                title: "Interest",
                value: formatAmount(taxAmount),
                showInfo: true,
                tooltipMessage: "Calculated based on your loan amount, loan term, and the interest rate of the current product.",
                isClickable: false,
                highlight: false
            ))
        }
        
        // Date of application
        if let borrowingDate = term["borrowingDate"] as? String {
            details.append((
                title: "Date of application",
                value: borrowingDate,
                showInfo: false,
                tooltipMessage: "",
                isClickable: false,
                highlight: false
            ))
        }
        
        // Due date
        if let repaymentDate = term["repaymentDate"] as? String {
            details.append((
                title: "Due date",
                value: repaymentDate,
                showInfo: false,
                tooltipMessage: "-",
                isClickable: false,
                highlight: false
            ))
        }
        
        // Loan term（可切换，右侧高亮）
        var termText: String?
        var showTermValue: Int?
        if let termInt = term["showTerm"] as? Int {
            showTermValue = termInt
        } else if let termStr = term["showTerm"] as? String {
            showTermValue = Int(termStr)
        } else if let loanTermInt = term["loanTerm"] as? Int {
            showTermValue = loanTermInt
        } else if let loanTermStr = term["loanTerm"] as? String {
            showTermValue = Int(loanTermStr)
        }
        if let showTermValue = showTermValue {
            let unit = term["productTermUnit"] as? Int ?? 1
            termText = unit == 1 ? "\(showTermValue) Days" : "\(showTermValue) Months"
        }
        if let termText = termText {
            // termDetailList 仅一条时不显示右侧下拉图，且不可点击
            let termList = mancry_selectedAmountDetail?["termDetailList"] as? [[String: Any]] ?? []
            let loanTermClickable = termList.count > 1
            details.append((
                title: "Loan term",
                value: termText,
                showInfo: false,
                tooltipMessage: "",
                isClickable: loanTermClickable,
                highlight: true
            ))
        }
        
        mancry_loanDetailsData = details
        
        DispatchQueue.main.async {
            // 更新还款计划表
            self.mancry_repaymentTableView.reloadData()
            self.mancry_updateRepaymentTableHeight()
            
            // 更新详情表高度
            let rowCount = self.mancry_loanDetailsData.count
            let height = max(CGFloat(rowCount) * 40.0, 40.0)
            self.mancry_loanDetailsTableView.snp.remakeConstraints { make in
                make.top.equalTo(self.mancry_productTitleLabel.snp.bottom).offset(12)
                make.left.right.equalToSuperview().inset(16)
                make.height.equalTo(height)
            }
            
            self.mancry_loanDetailsTableView.reloadData()
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Actions
    @objc private func mancry_toggleRepaymentPlan() {
        guard !mancry_repaymentItems.isEmpty else { return }
        mancry_isRepaymentExpanded.toggle()
        mancry_updateRepaymentTableHeight()
        
        UIView.animate(withDuration: 0.25) {
            self.mancry_repaymentArrowView.transform = self.mancry_isRepaymentExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
            self.view.layoutIfNeeded()
        }
    }
    
    private func mancry_updateRepaymentTableHeight() {
        let count = mancry_repaymentItems.count
        let visibleRows = mancry_isRepaymentExpanded ? count : min(1, count)
        let height = CGFloat(visibleRows) * 80.0
        mancry_repaymentTableHeightConstraint?.update(offset: height)
        mancry_repaymentTableView.reloadData()
    }
    
    @objc private func mancry_withdrawButtonTapped() {
        // 从当前选中的金额档位中获取 Loan Amount，从选中的期限档位中获取 loanTerm 作为入参
        guard let amountDetail = mancry_selectedAmountDetail,
              let loanAmount = amountDetail["loanAmount"] as? String,
              !loanAmount.isEmpty else {
            mac_centerToastViewwithMsg(msg: "Loan amount is invalid")
            return
        }
        var loanTermStr = ""
        if let term = mancry_selectedTermDetail {
            if let val = term["loanTerm"] as? Int {
                loanTermStr = "\(val)"
            } else if let val = term["loanTerm"] as? String {
                loanTermStr = val
            }
        }
        mancry_tobowithTiXianData(loanAmount: loanAmount, loanTerm: loanTermStr)
    }
}

// MARK: - UITableViewDelegate & DataSource
extension Mancry_HomeWithDrawnVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === mancry_repaymentTableView {
            if mancry_repaymentItems.isEmpty { return 0 }
            return mancry_isRepaymentExpanded ? mancry_repaymentItems.count : 1
        } else if tableView === mancry_loanDetailsTableView {
            return mancry_loanDetailsData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === mancry_repaymentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: Mancry_RepaymentPlanCell.identifier, for: indexPath) as! Mancry_RepaymentPlanCell
            let item = mancry_repaymentItems[indexPath.row]
            let dueDate = (item["expirationDate"] as? String) ?? "--"
            let repaymentAmount = (item["repaymentAmount"] as? String) ?? "0"
            let formattedAmount = "₱\(repaymentAmount)"
            cell.configure(dueDate: dueDate, amount: formattedAmount)
            return cell
        } else if tableView === mancry_loanDetailsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: Mancry_LoanDetailCell.identifier, for: indexPath) as! Mancry_LoanDetailCell
            let item = mancry_loanDetailsData[indexPath.row]
            cell.configure(title: item.title,
                           value: item.value,
                           showInfo: item.showInfo,
                           isClickable: item.isClickable,
                           tag: indexPath.row,
                           highlightValue: item.highlight)
            cell.onInfoButtonTapped = { [weak self] tag in
                guard let self = self, tag < self.mancry_loanDetailsData.count else { return }
                let tooltip = self.mancry_loanDetailsData[tag].tooltipMessage
                if !tooltip.isEmpty {
                    self.mac_centerToastViewwithMsg(msg: tooltip)
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === mancry_loanDetailsTableView {
            let item = mancry_loanDetailsData[indexPath.row]
            if item.title == "Loan Amount" && item.isClickable {
                mancry_showAmountSelectionPopup()
            } else if item.title == "Loan term" && item.isClickable {
                mancry_showTermSelectionPopup()
            }
        }
    }
    
    /// 选择 Loan Amount
    private func mancry_showAmountSelectionPopup() {
        guard !mancry_amountDetailList.isEmpty else { return }
        
        let popup = Mancry_customselectPopupView()
        let titles: [String] = mancry_amountDetailList.map { detail in
            let amount = detail["loanAmount"] as? String
            let formatted = amount ?? "0"
            return "₱ \(formatted)"
        }
        popup.configure(title: "Select Loan Amount", data: titles)
        popup.onConfirm = { [weak self] index, _ in
            guard let self = self, index < self.mancry_amountDetailList.count else { return }
            let amountDetail = self.mancry_amountDetailList[index]
            self.mancry_selectedAmountDetail = amountDetail
            
            if let termDetailList = amountDetail["termDetailList"] as? [[String: Any]],
               !termDetailList.isEmpty {
                // 默认选中该金额下的最后一期
                self.mancry_selectedTermDetail = termDetailList.last
            }
            self.mancry_updateLoanAndRepaymentFromSelectedTerm()
        }
        popup.onCancel = {}
        popup.show()
    }
    
    /// 选择 Loan term
    private func mancry_showTermSelectionPopup() {
        guard let amountDetail = mancry_selectedAmountDetail,
              let termDetailList = amountDetail["termDetailList"] as? [[String: Any]],
              termDetailList.count > 1 else { return }
        
        let popup = Mancry_customselectPopupView()
        let titles: [String] = termDetailList.map { term in
            var showTermValue: Int = 0
            if let val = term["showTerm"] as? Int {
                showTermValue = val
            } else if let str = term["showTerm"] as? String {
                showTermValue = Int(str) ?? 0
            } else if let val = term["loanTerm"] as? Int {
                showTermValue = val
            } else if let str = term["loanTerm"] as? String {
                showTermValue = Int(str) ?? 0
            }
            let unit = term["productTermUnit"] as? Int ?? 1
            return unit == 1 ? "\(showTermValue) Days" : "\(showTermValue) Months"
        }
        
        popup.configure(title: "Select the loan tenure", data: titles)
        popup.onConfirm = { [weak self] index, _ in
            guard let self = self, index < termDetailList.count else { return }
            self.mancry_selectedTermDetail = termDetailList[index]
            self.mancry_updateLoanAndRepaymentFromSelectedTerm()
        }
        popup.onCancel = {}
        popup.show()
    }
}
