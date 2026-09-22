

import UIKit
import SnapKit
import Contacts
import Toast_Swift

/// 订单详情页（Loan details）
class Mancry_HomeOrderDetailsVC: Mac_BaseViewController {

    
    var mancry_productId = ""
    var mancry_orderId = ""
    var mancry_loanAmount = ""
    var mancry_showTerm = ""
    var isShowLeftBtnStr = ""
    
    let progressView = Mancry_uploadProgressView()
    // MARK: - Public data (由上个页面传入)
    /// 订单详情原始数据，期望包含还款计划列表、产品名称、银行卡等信息
    var mancry_orderDetailData: [String: Any]?
    
    /// 还款计划列表数据（取自 mancry_orderDetailData 中的 productTermItemList 或类似字段）
    private var mancry_repaymentItems: [[String: Any]] = []
    
    /// 贷款详情列表数据（Loan Amount、Date of application 等）
    private var mancry_loanDetailsData: [(title: String, value: String, showInfo: Bool, tooltipMessage: String)] = []
    
    /// 订单状态
    private var mancry_orderStatus: Int = 0
    
    // MARK: - State
    private var mancry_isRepaymentExpanded: Bool = false
    
    /// 还款计划模块的 top 约束（用于动态调整）
    private var mancry_repaymentPlanViewTopConstraint: Constraint?
    
    /// 产品卡片模块的 top 约束（用于动态调整）
    private var mancry_productCardViewTopConstraint: Constraint?
    
    /// 产品卡片模块的 bottom 约束（用于动态调整）
    private var mancry_productCardViewBottomConstraint: Constraint?
    
    /// 银行卡模块的 top 约束（用于动态调整）
    private var mancry_bankCardViewTopConstraint: Constraint?
    
    var fig_bindId = ""
    // MARK: - UI
    private lazy var mancry_scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(hex: "#EDF1D8")
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        // 小屏需能拖动滚动；info 点击靠更大 hit 区域 + window toast，不靠禁掉手势取消
        scrollView.delaysContentTouches = false
        scrollView.canCancelContentTouches = true
        scrollView.keyboardDismissMode = .onDrag
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }()
    
    private lazy var mancry_contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        return view
    }()
    
    /// 底部按钮容器高度约束（隐藏时收为 0，避免小屏被空底栏占位）
    private var mancry_bottomButtonContainerHeightConstraint: Constraint?
    
    /// 顶部提示文案区域
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
        label.text = "Your application is currently under review, and the final loan amount depends on the credit assessment. Maintaining a good credit record can enhance the actual loan amount approved."
        return label
    }()
    
    // MARK: - Repayment Plan
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
        tableView.rowHeight = 60
        tableView.estimatedRowHeight = 60
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
    
    // MARK: - Product / Bank card section
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
    
    private lazy var mancry_statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "flbeql_order_shz")
        return imageView
    }()
    
    /// 贷款详情列表（UIStackView，避免嵌套 UITableView 在可滚动页面里点不到）
    private lazy var mancry_loanDetailsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 0
        stack.isUserInteractionEnabled = true
        return stack
    }()
    
    /// 银行卡区域
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
    
    // MARK: - Bottom Buttons
    /// 底部固定按钮容器
    private lazy var mancry_bottomButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        view.isHidden = true
        return view
    }()
    
    /// Withdraw 按钮（orderStatus = 32 时显示）
    private lazy var mancry_withdrawButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        button.backgroundColor = UIColor(hex: "#CADC00") // 黄色/绿色
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.isHidden = true
        button.addTarget(self, action: #selector(mancry_withdrawButtonTapped), for: .touchUpInside)
        return button
    }()
    
    /// Defer 按钮（orderStatus = 60 时显示）
    private lazy var mancry_deferButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Defer", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        button.backgroundColor = UIColor(hex: "#DFE4C6") // 浅米色
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.isHidden = true
        button.addTarget(self, action: #selector(mancry_deferButtonTapped), for: .touchUpInside)
        return button
    }()
    
    /// Repay 按钮（orderStatus = 60 时显示）
    private lazy var mancry_repayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Repay", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        button.backgroundColor = UIColor(hex: "CADC00") // 黄色/绿色
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.isHidden = true
        button.addTarget(self, action: #selector(mancry_repayButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        mac_publiccustomnavView(title: "Loan details")
        mancry_setupUI()
        mancry_setupConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(goSucceedHomenotification(_:)), name: NSNotification.Name.init(rawValue: "mancry_uploadSucceed"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mancry_getHomeOrderDetailsData()

    }
    
    @objc func goSucceedHomenotification(_ notice:Notification){
//        print("下单成功，触发好评Detail")
        self.progressView.dismiss()

    }
    
    func mancry_getHomeOrderDetailsData(){
        let signData: [String: Any] = [
            "orderId":mancry_orderId,
        ]
        let nosignData: [String: Any] = [
            "orderId":mancry_orderId,
            "appType": "DC",
            "productId":mancry_productId
          ]
        
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: nosignData, isSign: false,signData,true)
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else { return }
        
        mac_PopLoadingView()
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/order/detailV2",
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
                
                // 解析 data
                guard let dataDict = result["data"] as? [String: Any] else { return }
                

                if let productDic = dataDict["product"] as? [String: Any],
                    let productName = productDic["productName"] as? String,let productLogo = productDic["productLogo"] as? String  {
                    DispatchQueue.main.async {
                        self.mancry_productTitleLabel.text = productName
                        self.mancry_productLogoImageView.sd_setImage(with: URL(string: productLogo))
                       
                    }
                }
             
                
                if let productLogo = dataDict["productLogo"] as? String, !productLogo.isEmpty,
                   let url = URL(string: productLogo) {
                    DispatchQueue.main.async {
                        self.mancry_productLogoImageView.sd_setImage(with: url)
                    }
                } else if let orderDetail = dataDict["orderDetail"] as? [String: Any],
                          let productLogo = orderDetail["productLogo"] as? String, !productLogo.isEmpty,
                          let url = URL(string: productLogo) {
                    DispatchQueue.main.async {
                        self.mancry_productLogoImageView.sd_setImage(with: url)
                    }
                }
                
                // 1. 取出 orderStatus
                if let orderDetail = dataDict["orderDetail"] as? [String: Any] {
                    if let orderStatus = orderDetail["orderStatus"] as? Int {
                        self.mancry_orderStatus = orderStatus
                    } else if let orderStatusStr = orderDetail["orderStatus"] as? String,
                              let orderStatus = Int(orderStatusStr) {
                        self.mancry_orderStatus = orderStatus
                    }
                    self.mancry_orderId = orderDetail["orderId"] as? String ?? ""
                    let isShowStr = orderDetail["ifExtension"] as? String ?? ""
                    isShowLeftBtnStr = isShowStr
                    // 根据 orderStatus 设置状态图片
                    DispatchQueue.main.async {
                        self.mancry_updateStatusImage()
                    }
                }
                
                // 1. 取出 productTermItemList 数组作为还款计划的值
                if let orderDetail = dataDict["orderDetail"] as? [String: Any],
                   let productTermItemList = orderDetail["productTermItemList"] as? [[String: Any]] {
                    self.mancry_repaymentItems = productTermItemList
                    DispatchQueue.main.async {
                        self.mancry_repaymentTableView.reloadData()
                        self.mancry_updateRepaymentTableHeight()
                    }
                }
                
                // 2. 取出 accountNo 字段作为银行卡的值
                if let bankCard = dataDict["bankCard"] as? [String: Any],
                   let accountNo = bankCard["accountNo"] as? String {
                    DispatchQueue.main.async {
                        self.mancry_bankCardNumberLabel.text = accountNo
                    }
                }
                if let bankCard = dataDict["bankCard"] as? [String: Any],
                   let bindId = bankCard["bindId"] as? String {
                   fig_bindId = bindId
                }
                
//                 3. 详情列表字段对齐 Suml_orderPeekVC（无 EMI）
                if let orderDetail = dataDict["orderDetail"] as? [String: Any] {
                    var details: [(title: String, value: String, showInfo: Bool, tooltipMessage: String)] = []
                    
                    let formatAmount: (String?) -> String = { amountStr in
                        guard let amountStr = amountStr, !amountStr.isEmpty,
                              let amount = Double(amountStr.replacingOccurrences(of: ",", with: "")) else { return "₱ 0" }
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .decimal
                        formatter.groupingSeparator = ","
                        formatter.maximumFractionDigits = 2
                        return "₱ \(formatter.string(from: NSNumber(value: amount)) ?? amountStr)"
                    }
                    
                    let stringValue: (Any?) -> String = { any in
                        guard let any = any, !(any is NSNull) else { return "" }
                        if let s = any as? String { return s.trimmingCharacters(in: .whitespacesAndNewlines) }
                        if let n = any as? NSNumber { return n.stringValue }
                        if let i = any as? Int { return "\(i)" }
                        if let d = any as? Double { return String(d) }
                        return "\(any)".trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    
                    let loanAmount = stringValue(orderDetail["loanAmount"])
                    if !loanAmount.isEmpty {
                        details.append(("Loan Amount", formatAmount(loanAmount), false, ""))
                        mancry_loanAmount = loanAmount
                    }
                    
                    // Loan duration / Select the loan period
                    let termRaw = stringValue(orderDetail["showTerm"] ?? orderDetail["loanTerm"])
                    var termUnit = (orderDetail["productTermUnit"] as? NSNumber)?.intValue
                        ?? (orderDetail["productTermUnit"] as? Int)
                        ?? 1
                    if termUnit == 0 { termUnit = 1 }
                    if !termRaw.isEmpty {
                        let termText = termUnit == 1 ? "\(termRaw) Days" : "\(termRaw) Months"
                        mancry_showTerm = termRaw
                        let termTitle = self.mancry_orderStatus == 32 ? "Select the loan period" : "Loan duration"
                        details.append((termTitle, termText, false, ""))
                    }
                    
                    let receiptAmount = stringValue(orderDetail["receiptAmount"] ?? orderDetail["arrivalAmount"])
                    if !receiptAmount.isEmpty {
                        details.append((
                            "Amount received",
                            formatAmount(receiptAmount),
                            true,
                            "The actual amount you receive is calculated by deducting the service fee and GST from the loan amount."
                        ))
                    }
                    
                    let interestAmount = stringValue(orderDetail["interestAmount"])
                    if !interestAmount.isEmpty {
                        details.append((
                            "Interest",
                            formatAmount(interestAmount),
                            true,
                            "Calculated based on your loan amount, loan term, and the interest rate of the current product."
                        ))
                    }
                    
                    let feeAmount = stringValue(orderDetail["feeAmount"])
                    if !feeAmount.isEmpty {
                        details.append((
                            "Service fee",
                            formatAmount(feeAmount),
                            true,
                            "This is the fee charged by the financial institution for providing loan services."
                        ))
                    }
                    
//                    let taxAmount = stringValue(orderDetail["taxAmount"])
//                    if !taxAmount.isEmpty {
//                        details.append(("GST", formatAmount(taxAmount), false, ""))
//                    }
                    
                    let applyDate = stringValue(orderDetail["applyDate"] ?? orderDetail["borrowingDate"])
                    if self.mancry_orderStatus == 60 || self.mancry_orderStatus == 61 || self.mancry_orderStatus == 70 {
                        let payoutDate = stringValue(orderDetail["payoutDate"])
                        if !payoutDate.isEmpty {
                            details.append(("Payment date", payoutDate, false, ""))
                        }
                    } else if !applyDate.isEmpty {
                        details.append(("Date of application", applyDate, false, ""))
                    }
                    
                    let dueDate = stringValue(orderDetail["dueDate"] ?? orderDetail["repaymentDate"])
                    if !dueDate.isEmpty {
                        details.append(("Due date", dueDate, false, ""))
                    }
                    
                    if self.mancry_orderStatus == 61 {
                        let penaltyAmount = stringValue(orderDetail["penaltyAmount"])
                        if !penaltyAmount.isEmpty, penaltyAmount != "0" {
                            details.append(("Late charge", formatAmount(penaltyAmount), false, ""))
                        }
                    }
                    
                    if self.mancry_orderStatus == 60 || self.mancry_orderStatus == 61 || self.mancry_orderStatus == 70 {
                        let totalRepayment = stringValue(orderDetail["totalRepaymentAmount"])
                        if !totalRepayment.isEmpty, totalRepayment != "0" {
                            details.append(("Total repayment", formatAmount(totalRepayment), false, ""))
                        }
                        
                        let reductionAmount = stringValue(orderDetail["reductionAmount"]) // 减免金额
                         var isShowreduction = false
                        if reductionAmount == "" || reductionAmount == "0"{
                            isShowreduction = false
                        }else{
                            isShowreduction = true
                        }
                        if isShowreduction == true{
                            details.append(("Amount of deduction", formatAmount(reductionAmount.isEmpty ? "0" : reductionAmount), false, ""))
                        }
                        
                        let alreadyRepaid = stringValue(orderDetail["alreadyRepaymentAmount"]) //已还金额
                        
                        var isShowalreadyRepaid = false
                        if  alreadyRepaid == "" || alreadyRepaid == "0"{
                            isShowalreadyRepaid = false
                        }else{
                            isShowalreadyRepaid = true
                        }
                        
                        if isShowalreadyRepaid == true {
                            details.append(("Amount repaid", formatAmount(alreadyRepaid.isEmpty ? "0" : alreadyRepaid), false, ""))
                        }
                        
                        if self.mancry_orderStatus != 70 {
                            let amountDue = stringValue(orderDetail["shouldRepaymentAmount"])
                            if isShowreduction == true || isShowalreadyRepaid == true {
                                details.append(("Amount Due", formatAmount(amountDue), false, ""))
                            }
                        }
                        
                        let deferFee = stringValue(orderDetail["extensionAmount"] ?? orderDetail["defermentCharge"] ?? orderDetail["deferAmount"])
                        if !deferFee.isEmpty {
                            details.append(("Deferment charge", formatAmount(deferFee), false, ""))
                        }
                        
                        if self.mancry_orderStatus == 70 {
                            let repaymentDate = stringValue(orderDetail["repaymentDate"])
                            if !repaymentDate.isEmpty {
                                details.append(("Repayment date", repaymentDate, false, ""))
                            }
                        }
                    }
                    
                    self.mancry_loanDetailsData = details
                    DispatchQueue.main.async {
                        self.mancry_reloadLoanDetailsStack()
                        self.mancry_updateRepaymentPlanVisibility()
                        self.mancry_updateBottomButtons()
                        self.view.setNeedsLayout()
                        self.view.layoutIfNeeded()
                    }
                }
                
                // 更新 message
                if let message = dataDict["message"] as? String {
                    DispatchQueue.main.async {
                        self.mancry_repaymentMessageLabel.text = message
                    }
                }
            },
            failureCallBack: { [weak self] error in
                self?.mac_hiddenLoadingView()
                self?.mac_centerToastViewwithMsg(msg: "Network error, please try again")
                print("Order list request failed: \(error.localizedDescription)")
            }
        )
    }
    
    
    private func mancry_rightBtnAction(){
        mac_PopLoadingView()
        let signData: [String: Any] = [
            "orderId":mancry_orderId,
        ]
        let nosignData: [String: Any] = [
            "orderId":mancry_orderId,
            "periodNoList": [1]
          ]
        
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: nosignData, isSign: false,signData,true)
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else { return }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/order/repay/connect",
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
                // 解析 data
                guard let dataDict = result["data"] as? [String: Any] else { return }
                let connect = dataDict["connect"] as? String
                let  vc = Mancry_WebViewController()
                vc.mancry_linkUrlStr = connect ?? ""
                vc.mancry_titleStr = "Repayment"
                self.navigationController?.pushViewController(vc, animated: true)

            },
            failureCallBack: { [weak self] error in
                self?.mac_hiddenLoadingView()
                self?.mac_centerToastViewwithMsg(msg: "Network error, please try again")
                print("Order list request failed: \(error.localizedDescription)")
            }
        )
    }
    private func mancry_leftBtnAction(){
        self.mac_PopLoadingView()
        let signData: [String: Any] = [
            "orderId":mancry_orderId,
        ]
        let nosignData: [String: Any] = [
            "orderId":mancry_orderId,
            "periodNoList": [1]
          ]
        
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: nosignData, isSign: false,signData,true)
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else { return }
        
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/order/repay/extension",
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
                // 解析 data
                guard let dataDict = result["data"] as? [String: Any] else { return }
                let connect = dataDict["connect"] as? String
                let  vc = Mancry_WebViewController()
                vc.mancry_linkUrlStr = connect ?? ""
                vc.mancry_titleStr = "Deferment"
                self.navigationController?.pushViewController(vc, animated: true)

            },
            failureCallBack: { [weak self] error in
                self?.mac_hiddenLoadingView()
                self?.mac_centerToastViewwithMsg(msg: "Network error, please try again")
                print("Order list request failed: \(error.localizedDescription)")
            }
        )
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
        mancry_productCardView.addSubview(mancry_statusImageView)
        mancry_productCardView.addSubview(mancry_loanDetailsStackView)
        mancry_productCardView.addSubview(mancry_bankCardView)
        
        mancry_bankCardView.addSubview(mancry_bankIconView)
        mancry_bankCardView.addSubview(mancry_bankCardNumberLabel)
        
        // 底部按钮容器
        view.addSubview(mancry_bottomButtonContainer)
        mancry_bottomButtonContainer.addSubview(mancry_withdrawButton)
        mancry_bottomButtonContainer.addSubview(mancry_deferButton)
        mancry_bottomButtonContainer.addSubview(mancry_repayButton)
    }
    
    private func mancry_setupConstraints() {
        // 底部按钮容器约束（高度由内部按钮撑开；无按钮时再收为 0）
        mancry_bottomButtonContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        // Withdraw 按钮约束（单独显示时）
        mancry_withdrawButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        // Defer 按钮约束（与 Repay 一起显示时）
        mancry_deferButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-24)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        // Repay 按钮约束（与 Defer 一起显示时）
        mancry_repayButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.left.equalTo(mancry_deferButton.snp.right).offset(16)
            make.width.equalTo(mancry_deferButton)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        mancry_scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(mancry_bottomButtonContainer.snp.top)
        }
        
        // 四边钉住 scrollView，由内部最后一卡撑开 contentSize，小屏才能滚
        mancry_contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(mancry_scrollView)
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
            mancry_repaymentPlanViewTopConstraint = make.top.equalTo(mancry_infoBanner.snp.bottom).offset(16).constraint
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
            mancry_repaymentTableHeightConstraint = make.height.equalTo(60).constraint // 默认显示一条
        }
        
        mancry_repaymentMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(mancry_repaymentTableView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        mancry_productCardView.snp.makeConstraints { make in
            mancry_productCardViewTopConstraint = make.top.equalTo(mancry_repaymentPlanView.snp.bottom).offset(16).constraint
            make.left.right.equalToSuperview().inset(16)
            // 卡片高度包住内部；同时钉住 contentView 底部以撑开可滚动区域
            make.bottom.equalTo(mancry_bankCardView.snp.bottom).offset(16)
            mancry_productCardViewBottomConstraint = make.bottom.equalToSuperview().offset(-24).constraint
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
        
        mancry_statusImageView.snp.makeConstraints { make in
            make.centerY.equalTo(mancry_productTitleLabel)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(24)
            make.width.greaterThanOrEqualTo(80)
        }
        
        mancry_loanDetailsStackView.snp.makeConstraints { make in
            make.top.equalTo(mancry_productTitleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        mancry_bankCardView.snp.makeConstraints { make in
            mancry_bankCardViewTopConstraint = make.top.equalTo(mancry_loanDetailsStackView.snp.bottom).offset(16).constraint
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        mancry_bankIconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
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
    
    /// 根据 orderStatus 获取状态图片名称
    private func mancry_statusImageName(for orderStatus: Int) -> String? {
        let statusStr = "\(orderStatus)"
        if statusStr == "10" {
            return "flbeql_order_dzqsj"
        } else if statusStr == "30" {
            return "flbeql_order_shz"
        } else if statusStr == "31" {
            return "flbeql_order_jj"
        } else if statusStr == "32" {
            return "flbeql_order_ggyhk(1)"
        } else if statusStr == "36" {
            return "flbeql_order_ggyhk"
        } else if statusStr == "50" {
            return "flbeql_order_fkz"
        } else if statusStr == "60" {
            return "flbeql_fhzess_pendingrepayment"
        } else if statusStr == "61" {
            return "flbeql_order_yq"
        } else if statusStr == "70" {
            return "flbeql_order_jq"
        } else if statusStr == "99" {
            return "flbeql_order_qx"
        }
        return nil
    }
    
    /// 更新状态图片
    private func mancry_updateStatusImage() {
        if let imageName = mancry_statusImageName(for: mancry_orderStatus),
           let image = UIImage(named: imageName) {
            mancry_statusImageView.image = image
        } else {
            mancry_statusImageView.image = nil
        }
    }
    
    /// 根据 orderStatus 更新底部按钮显示状态
    private func mancry_updateBottomButtons() {
        // ifExtension 1 可以展期
        if mancry_orderStatus == 10 {
            mancry_withdrawButton.setTitle("Submit", for: .normal)
        }else  if mancry_orderStatus == 36 {
            mancry_withdrawButton.setTitle("Change bank account", for: .normal)
        }else if mancry_orderStatus == 61{
            mancry_withdrawButton.setTitle("Repay", for: .normal)
        }else if mancry_orderStatus == 60 && isShowLeftBtnStr == "2"{
            mancry_withdrawButton.setTitle("Repay", for: .normal)
        }
        
        if mancry_orderStatus == 10 || mancry_orderStatus == 36{
            // 显示 按钮
            mancry_bottomButtonContainer.isHidden = false
            mancry_withdrawButton.isHidden = false
            mancry_deferButton.isHidden = true
            mancry_repayButton.isHidden = true
            
            mancry_expandBottomButtonContainer()
            
            // 更新 Withdraw 按钮约束（单独显示）
            mancry_withdrawButton.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(16)
                make.left.right.equalToSuperview().inset(16)
                make.height.equalTo(56)
                make.bottom.equalToSuperview().offset(-16)
            }
        } else if mancry_orderStatus == 60 && isShowLeftBtnStr == "1"{
            // 显示 Defer 和 Repay 按钮
            mancry_bottomButtonContainer.isHidden = false
            mancry_withdrawButton.isHidden = true
            mancry_deferButton.isHidden = false
            mancry_repayButton.isHidden = false
            
            mancry_expandBottomButtonContainer()
            
            // 更新 Defer 和 Repay 按钮约束（并排显示）
            mancry_deferButton.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(16)
                make.left.equalToSuperview().offset(16)
                make.width.equalToSuperview().multipliedBy(0.5).offset(-24)
                make.height.equalTo(56)
                make.bottom.equalToSuperview().offset(-16)
            }
            
            mancry_repayButton.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.left.equalTo(mancry_deferButton.snp.right).offset(16)
                make.width.equalTo(mancry_deferButton)
                make.height.equalTo(56)
                make.bottom.equalToSuperview().offset(-16)
            }
        }else if mancry_orderStatus == 60 && isShowLeftBtnStr == "2"{
            mancry_bottomButtonContainer.isHidden = false
            mancry_withdrawButton.isHidden = false
            mancry_deferButton.isHidden = true
            mancry_repayButton.isHidden = true
            mancry_expandBottomButtonContainer()
            mancry_withdrawButton.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(16)
                make.left.right.equalToSuperview().inset(16)
                make.height.equalTo(56)
                make.bottom.equalToSuperview().offset(-16)
            }
        }else if mancry_orderStatus == 61 {
            mancry_bottomButtonContainer.isHidden = false
            mancry_withdrawButton.isHidden = false
            mancry_deferButton.isHidden = true
            mancry_repayButton.isHidden = true
            mancry_expandBottomButtonContainer()
            mancry_withdrawButton.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(16)
                make.left.right.equalToSuperview().inset(16)
                make.height.equalTo(56)
                make.bottom.equalToSuperview().offset(-16)
            }
        }
        else {
            // 隐藏所有按钮，收起底栏，把滚动区域拉满小屏
            mancry_bottomButtonContainer.isHidden = true
            mancry_withdrawButton.isHidden = true
            mancry_deferButton.isHidden = true
            mancry_repayButton.isHidden = true
            mancry_collapseBottomButtonContainer()
        }
    }
    
    private func mancry_expandBottomButtonContainer() {
        mancry_bottomButtonContainerHeightConstraint?.deactivate()
        mancry_bottomButtonContainerHeightConstraint = nil
        mancry_bottomButtonContainer.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        mancry_scrollView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(mancry_bottomButtonContainer.snp.top)
        }
    }
    
    private func mancry_collapseBottomButtonContainer() {
        // 先卸掉按钮对容器高度的撑开，再收为 0
        [mancry_withdrawButton, mancry_deferButton, mancry_repayButton].forEach { btn in
            btn.snp.remakeConstraints { make in
                make.top.left.equalToSuperview()
                make.width.height.equalTo(0)
            }
        }
        mancry_bottomButtonContainer.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            mancry_bottomButtonContainerHeightConstraint = make.height.equalTo(0).constraint
        }
        mancry_scrollView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func mancry_capContactData(){
        let iscontactsStatus = CNContactStore.authorizationStatus(for: .contacts)
        Mancry_PublicMethodS.getContactsPermissionStatusWithCompletion { contactsGranted in
                        
                    if contactsGranted == true{
                            
                        let contactsStatus = CNContactStore.authorizationStatus(for: .contacts)
                            if #available(iOS 18.0, *) {
                                if contactsStatus == .limited {
                                    Mancry_uploadData.mancry_insertPointData(insertId: "198")
                                    if mancry_homeNumCap == 1{
                                        self.get_mancry_ContactermissionAlert()
                                        return
                                    }else{
                                        self.mancry_gotoCaptureData(orderId: self.mancry_orderId)
                                    }
                                   
                                }else{
                                    Mancry_uploadData.mancry_insertPointData(insertId: "19")
                                    self.mancry_gotoCaptureData(orderId: self.mancry_orderId)
                                }
                            }else{
                                Mancry_uploadData.mancry_insertPointData(insertId: "19")
                                self.mancry_gotoCaptureData(orderId: self.mancry_orderId)
                            }
                       
                    }else{
                        Mancry_uploadData.mancry_insertPointData(insertId: "20")
                        if mancry_homeNumCap == 1{
                            if iscontactsStatus == .notDetermined{
                                
                            }else{
                                self.get_mancry_ContactermissionAlert()
                            }
                            
                            return
                        }else{
                            self.mancry_gotoCaptureData(orderId: self.mancry_orderId)
                        }
                    }
        }
    }
    
    private func mancry_gotoCaptureData(orderId: String){
        self.progressView.show()
        self.progressView.updateProgress(20)
        Mancry_uploadData.callMobileContact(
            orderId: orderId,
            contactsGranted: false,
            successCallback: {
                
            },
            failureCallback: {_ in
            }
        )
    }
    private func get_mancry_ContactermissionAlert(){
        
        let cameraPopView = Mancry_PopView(type: .cameraPermission)
        cameraPopView.configure(
            topImageName: "flbeql_tk_txl",
            title: "Contacts",
            description: "CyCash requires access to your contact information to protect your account and prevent fraud. Contact information is sent to our servers but is not stored or shared. Please be sure to select \"Allow Full Access\" when authorizing, otherwise it may affect the review results. You can change this permission in Settings.",
            leftButtonTitle: "Cancel",
            rightButtonTitle: "Confirm"
        )
        cameraPopView.onLeftButtonTapped = {
            self.navigationController?.popViewController(animated: true)
        }
        cameraPopView.onRightButtonTapped = {
            self.navigationController?.popViewController(animated: true)
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL)
        }
        cameraPopView.show()
    }
    
    // MARK: - Button Actions
    @objc private func mancry_withdrawButtonTapped() {
        // TODO: 实现 Withdraw 按钮点击逻辑
        print("Withdraw button tapped")
        if mancry_orderStatus == 10 {
            
            mancry_capContactData()
            
        }else  if mancry_orderStatus == 36 {
            mancry_changeloadBankCardList()
//            let vc = Mancry_MeOneVC()
//            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if mancry_orderStatus == 61{
            mancry_rightBtnAction()
        }else if mancry_orderStatus == 60 && isShowLeftBtnStr == "2"{
            mancry_rightBtnAction()
        }
        
    }
    
    private func mancry_changeloadBankCardList() {
        
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: ["bankCardBindId":fig_bindId])
        
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
//                        self?.mancry_bankCardList = bankCardList
                    let bankCardDic = bankCardList.first
                    
                    
                    let vc = Mancry_EditCardVC()
                    
                    vc.nestType = "edit" // 或 "edit"
                    vc.mancry_recordId = bankCardDic?["recordId"] as! String
                    vc.mancry_isSelect = bankCardDic?["defaultFlag"] as! String
                    vc.prefillAccountType = bankCardDic?["accountType"] as? String
                    vc.prefillBankName = bankCardDic?["bankCode"] as? String
                    vc.prefillAccountNo = bankCardDic?["accountNo"] as? String
                    self?.navigationController?.pushViewController(vc, animated: true)

                }
            },
            failureCallBack: { [weak self] error in
                self?.mac_hiddenLoadingView()
                self?.mac_centerToastViewwithMsg(msg: "Network error, please try again")
            }
        )
    }
    

    
    @objc private func mancry_deferButtonTapped() {
        // TODO: 实现 Defer 按钮点击逻辑
//        print("Defer button tapped")
        mancry_leftBtnAction()
    }
    
    @objc private func mancry_repayButtonTapped() {
        // TODO: 实现 Repay 按钮点击逻辑
//        print("Repay button tapped")
        mancry_rightBtnAction()
    }
    
    /// 刷新贷款详情 Stack（任意 orderStatus 下 info 均可点）
    private func mancry_reloadLoanDetailsStack() {
        mancry_loanDetailsStackView.arrangedSubviews.forEach { view in
            mancry_loanDetailsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for (index, item) in mancry_loanDetailsData.enumerated() {
            let row = Mancry_LoanDetailRowView()
            row.configure(
                title: item.title,
                value: item.value,
                showInfo: item.showInfo,
                isClickable: false,
                tag: index
            )
            row.snp.makeConstraints { make in
                make.height.equalTo(40)
            }
            row.onInfoButtonTapped = { [weak self] tag in
                guard let self = self, tag < self.mancry_loanDetailsData.count else { return }
                let tip = self.mancry_loanDetailsData[tag].tooltipMessage
                guard !tip.isEmpty else { return }
                self.mancry_showLoanDetailTip(tip)
            }
            mancry_loanDetailsStackView.addArrangedSubview(row)
        }
        
        mancry_productCardView.bringSubviewToFront(mancry_loanDetailsStackView)
    }
    
    /// 提示文案：挂到 window，避免被 ScrollView / 底部栏挡住
    private func mancry_showLoanDetailTip(_ message: String) {
        let targetView: UIView = view.window ?? view
        targetView.makeToast(
            message,
            point: CGPoint(x: targetView.bounds.midX, y: targetView.bounds.midY),
            title: nil,
            image: nil,
            completion: nil
        )
    }
    
    /// 根据 orderStatus 更新还款计划模块的显示状态
    private func mancry_updateRepaymentPlanVisibility() {
        let shouldHideRepaymentPlan = (mancry_orderStatus == 99 || mancry_orderStatus == 70)
        let shouldHideBankCard = (mancry_orderStatus == 31 || mancry_orderStatus == 99)
        
        // 更新还款计划模块的显示/隐藏
        mancry_repaymentPlanView.isHidden = shouldHideRepaymentPlan
        
        // 更新银行卡模块的显示/隐藏
        mancry_bankCardView.isHidden = shouldHideBankCard
        
        // 更新产品卡片 + 银行卡约束（一次 remake，避免重复叠加 bottom）
        mancry_productCardViewTopConstraint?.deactivate()
        mancry_productCardViewBottomConstraint?.deactivate()
        
        mancry_bankCardView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            if shouldHideBankCard {
                make.top.equalTo(mancry_loanDetailsStackView.snp.bottom)
                make.height.equalTo(0)
            } else {
                // 只保留 top + height，不要 bottom，避免约束冲突后银行卡盖住详情行
                mancry_bankCardViewTopConstraint = make.top.equalTo(mancry_loanDetailsStackView.snp.bottom).offset(16).constraint
                make.height.equalTo(48)
            }
        }
        
        mancry_productCardView.snp.remakeConstraints { make in
            if shouldHideRepaymentPlan {
                mancry_productCardViewTopConstraint = make.top.equalTo(mancry_infoBanner.snp.bottom).offset(16).constraint
            } else {
                mancry_productCardViewTopConstraint = make.top.equalTo(mancry_repaymentPlanView.snp.bottom).offset(16).constraint
            }
            make.left.right.equalToSuperview().inset(16)
            if shouldHideBankCard {
                make.bottom.equalTo(mancry_loanDetailsStackView.snp.bottom).offset(16)
            } else {
                // 底部锚到银行卡，保证卡片高度包住详情+银行卡
                make.bottom.equalTo(mancry_bankCardView.snp.bottom).offset(16)
            }
            // 钉住 contentView 底部，小屏内容超出时可滚
            mancry_productCardViewBottomConstraint = make.bottom.equalToSuperview().offset(-24).constraint
        }
        
        mancry_productCardView.bringSubviewToFront(mancry_loanDetailsStackView)
    }
    
    // 避免基类键盘收起手势影响详情行点击（基类已 cancelsTouchesInView=false，这里再显式排除）
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var current: UIView? = touch.view
        while let view = current {
            if view is Mancry_LoanDetailRowView || view is UIControl {
                return false
            }
            current = view.superview
        }
        return super.gestureRecognizer(gestureRecognizer, shouldReceive: touch)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate（仅还款计划）
extension Mancry_HomeOrderDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mancry_repaymentItems.isEmpty { return 0 }
        return mancry_isRepaymentExpanded ? mancry_repaymentItems.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Mancry_RepaymentPlanCell.identifier, for: indexPath) as! Mancry_RepaymentPlanCell
        let item = mancry_repaymentItems[indexPath.row]
        let dueDate = (item["expirationDate"] as? String) ?? "--"
        let repaymentAmount = (item["repaymentAmount"] as? String) ?? "0"
        let formattedAmount = "₱\(repaymentAmount)"
        cell.configure(dueDate: dueDate, amount: formattedAmount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
