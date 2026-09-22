import UIKit
import CoreLocation
import SnapKit
import Contacts

class Mancry_ApplyDetailVC: Mac_BaseViewController, UITextViewDelegate {
    
    // MARK: - Properties
    var mancry_termV3Data: [String: Any]?
    private var mancry_selectedAmountDetail: [String: Any]?
    private var mancry_selectedTermDetail: [String: Any]?
    private var mancry_bankCardList: [[String: Any]] = []
    private var mancry_selectedBankCard: [String: Any]?
    private var mancry_selectedBankCardBindId: Int? // 保存选中的 bankCardBindId
    private var mancry_isRepaymentPlanExpanded: Bool = false
    private var mancry_isAgreedToTerms: Bool = true // 默认选中
    private var mancry_amountButtons: [UIButton] = []
    public var mancry_productId = ""
    public var mancry_termsOfLoanUrl: String = "https://cacy.cycoretechnology.com/cacy/loanContract.html"
    var mancry_OrderId = ""
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
    
    private lazy var mancry_infoBanner: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#505D2A")
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var mancry_infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Your actual loan limit depends on your credit assessment. Maintaining good credit will help you obtain a higher loan limit."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var mancry_productCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var mancry_productHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FF6B35")
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var mancry_productIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private lazy var mancry_productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var mancry_productBodyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var mancry_amountSelectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var mancry_amountTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please Select Loan Amount Manually (₱)"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(hex: "#2C2F20")
        label.textAlignment = .center
        return label
    }()
    
    private lazy var mancry_amountButtonsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var mancry_singleAmountContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    
    private lazy var mancry_singleAmountLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(hex: "#2C2F20")
        label.backgroundColor = .white
        return label
    }()
    
    private lazy var mancry_singleAmountValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(hex: "#FF6B35")
        label.backgroundColor = UIColor.init(hex: "#FCEFE7")
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    private lazy var mancry_receivingAccountView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var mancry_receivingAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Select receiving account"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(hex: "#2C2F20")
        return label
    }()
    
    private lazy var mancry_receivingAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: "#E0E0E0")?.cgColor
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 40)
        button.setTitle("Please add a receiving account.", for: .normal)
        button.setTitleColor(UIColor(hex: "#999999"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(mancry_receivingAccountTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var mancry_receivingAccountArrowView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbeql_xy_jt")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // 贷款详情数据源
    private var mancry_loanDetailsData: [(title: String, value: String, showInfo: Bool, tooltipMessage: String, isClickable: Bool)] = []
    
    private lazy var mancry_loanDetailsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(Mancry_LoanDetailCell.self, forCellReuseIdentifier: Mancry_LoanDetailCell.identifier)
        tableView.rowHeight = 40
        print("🔧 TableView initialized")
        return tableView
    }()
    
    private lazy var mancry_repaymentPlanView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var mancry_repaymentPlanHeader: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(mancry_toggleRepaymentPlan))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var mancry_repaymentPlanTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Repayment Plan"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(hex: "#2C2F20")
        return label
    }()
    
    private lazy var mancry_repaymentPlanArrowView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbeql_loan_hkjt")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var mancry_repaymentPlanContent: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hex: "#EDF1D8")?.cgColor
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var mancry_repaymentMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#666666")
        label.numberOfLines = 0
        label.text = "If you repay the first amount due on time, the remaining balance will be automatically reset to zero for you."
        return label
    }()
    
    private lazy var mancry_bottomFixedView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var mancry_termsView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var mancry_termsCheckbox: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "flbsss_qs-fxk-icon-u(1)"), for: .normal)
        button.setImage(UIImage(named: "flbsss_qs-fxk-icon-u"), for: .selected)
        button.addTarget(self, action: #selector(mancry_termsCheckboxTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var mancry_termsLabel: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isSelectable = true
        textView.delegate = self
        return textView
    }()
    
    private lazy var mancry_applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        button.backgroundColor = UIColor(hex: "#CADC00")
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(mancry_applyTapped), for: .touchUpInside)
        return button
    }()

    let progressView = Mancry_uploadProgressView()

    override func viewDidLoad() {
        super.viewDidLoad()
        mac_publiccustomnavView(title: "Loan details")
        mancry_setupUI()
        mancry_setupConstraints()
        mancry_termsCheckbox.isSelected = true // 设置默认选中
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(goSucceedHomenotification(_:)), name: NSNotification.Name.init(rawValue: "mancry_uploadSucceed"), object: nil)
      
        mancry_configureWithData()
        
        
    }
    @objc func goSucceedHomenotification(_ notice:Notification){
//        print("下单成功，触发好评apply")
        self.progressView.dismiss()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mancry_loadBankCardList()
    }
    
    override func mancry_backbtnAction(){
        backPopView()
    }
    private func backPopView(){
        let backPopView = Mancry_PopView(type: .cameraPermission)
        backPopView.configure(
            topImageName: "flbeql_tk_tip",
            title: "Tip.",
            description: "It's a pity to leave. There is still a lot of loan credits waiting for you to withdraw, so think about it!",
            leftButtonTitle: "Cancel",
            rightButtonTitle: "Confirm"
        )
        
        backPopView.onRightButtonTapped = {
            self.navigationController?.popViewController(animated: true)
        
        }
        backPopView.show()
    }
    
    
    private func mancry_setupUI() {
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        
        view.addSubview(mancry_scrollView)
        mancry_scrollView.addSubview(mancry_contentView)
        
        mancry_contentView.addSubview(mancry_infoBanner)
        mancry_infoBanner.addSubview(mancry_infoLabel)
        
        mancry_contentView.addSubview(mancry_productCard)
        mancry_productCard.addSubview(mancry_productHeaderView)
        mancry_productHeaderView.addSubview(mancry_productIconView)
        mancry_productHeaderView.addSubview(mancry_productNameLabel)
        mancry_productCard.addSubview(mancry_productBodyView)
        
        mancry_productBodyView.addSubview(mancry_amountSelectionView)
        mancry_amountSelectionView.addSubview(mancry_amountTitleLabel)
        mancry_amountSelectionView.addSubview(mancry_amountButtonsContainer)
        mancry_amountSelectionView.addSubview(mancry_singleAmountContainer)
        mancry_singleAmountContainer.addSubview(mancry_singleAmountLabel)
        mancry_singleAmountContainer.addSubview(mancry_singleAmountValueLabel)
        
        mancry_productBodyView.addSubview(mancry_receivingAccountView)
        mancry_receivingAccountView.addSubview(mancry_receivingAccountLabel)
        mancry_receivingAccountView.addSubview(mancry_receivingAccountButton)
        mancry_receivingAccountButton.addSubview(mancry_receivingAccountArrowView)
        
        mancry_productBodyView.addSubview(mancry_loanDetailsTableView)
        
        mancry_contentView.addSubview(mancry_repaymentPlanView)
        mancry_repaymentPlanView.addSubview(mancry_repaymentPlanHeader)
        mancry_repaymentPlanHeader.addSubview(mancry_repaymentPlanTitleLabel)
        mancry_repaymentPlanHeader.addSubview(mancry_repaymentPlanArrowView)
        mancry_repaymentPlanView.addSubview(mancry_repaymentPlanContent)
        mancry_repaymentPlanView.addSubview(mancry_repaymentMessageLabel)
        
        view.addSubview(mancry_bottomFixedView)
        mancry_bottomFixedView.addSubview(mancry_termsView)
        mancry_termsView.addSubview(mancry_termsCheckbox)
        mancry_termsView.addSubview(mancry_termsLabel)
        mancry_bottomFixedView.addSubview(mancry_applyButton)
        
        
    }
    
    private func mancry_setupConstraints() {
        // 底部固定视图
        mancry_bottomFixedView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        
        mancry_termsView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(20)
        }
        
        mancry_termsCheckbox.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        mancry_termsLabel.snp.makeConstraints { make in
            make.left.equalTo(mancry_termsCheckbox.snp.right).offset(8)
            make.top.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mancry_applyButton.snp.makeConstraints { make in
            make.top.equalTo(mancry_termsView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(56)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        
        // 滚动视图
        mancry_scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(mancry_bottomFixedView.snp.top)
        }
        
        mancry_contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(mancry_Width)
        }
        
        mancry_infoBanner.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        mancry_infoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        mancry_productCard.snp.makeConstraints { make in
            make.top.equalTo(mancry_infoBanner.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        mancry_productHeaderView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
        
        mancry_productIconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(100)
//            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(24)
        }
        
        mancry_productNameLabel.snp.makeConstraints { make in
            make.left.equalTo(mancry_productIconView.snp.right).offset(12)
//            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(24)
        }
        
        mancry_productBodyView.snp.makeConstraints { make in
            make.top.equalTo(mancry_productHeaderView.snp.bottom).offset(-20)
            make.left.right.bottom.equalToSuperview()
        }
        
        mancry_amountSelectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        mancry_amountTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        mancry_amountButtonsContainer.snp.makeConstraints { make in
            make.top.equalTo(mancry_amountTitleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mancry_singleAmountContainer.snp.makeConstraints { make in
            make.top.equalTo(mancry_amountTitleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mancry_singleAmountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()

        }
        
        mancry_singleAmountValueLabel.snp.makeConstraints { make in
            make.top.equalTo(mancry_singleAmountLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(48)
            make.bottom.equalToSuperview()
        }
        
        mancry_receivingAccountView.snp.makeConstraints { make in
            make.top.equalTo(mancry_amountSelectionView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
        }
        
        mancry_receivingAccountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        mancry_receivingAccountButton.snp.makeConstraints { make in
            make.top.equalTo(mancry_receivingAccountLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(48)
            make.bottom.equalToSuperview()
        }
        
        mancry_receivingAccountArrowView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        mancry_loanDetailsTableView.snp.makeConstraints { make in
            make.top.equalTo(mancry_receivingAccountView.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
            make.height.equalTo(240) // 6 rows * 44
            make.bottom.equalToSuperview().offset(-20) // 添加 bottom 约束
        }
        
        mancry_repaymentPlanView.snp.makeConstraints { make in
            make.top.equalTo(mancry_loanDetailsTableView.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
        }
        
        mancry_repaymentPlanHeader.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(56)
        }
        
        mancry_repaymentPlanTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        mancry_repaymentPlanArrowView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        mancry_repaymentPlanContent.snp.makeConstraints { make in
            make.top.equalTo(mancry_repaymentPlanHeader.snp.bottom)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(84) // 默认高度：12(top) + 60(row) + 12(bottom)
        }
        
        mancry_repaymentMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(mancry_repaymentPlanContent.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        mancry_contentView.snp.makeConstraints { make in
            make.bottom.equalTo(mancry_repaymentPlanView.snp.bottom).offset(20)
        }
    }
    
    private func mancry_updateLoanDetails() {
        guard let termDetail = mancry_selectedTermDetail else {
            
            return
        }
        
        
        
        mancry_loanDetailsData.removeAll()
        
        // 1. Select the loan tenure
        var showTerm: Int? = nil
        if let termInt = termDetail["showTerm"] as? Int {
            showTerm = termInt
        } else if let termString = termDetail["showTerm"] as? String {
            showTerm = Int(termString)
        }
        
        if let showTerm = showTerm {
            let termUnit = termDetail["productTermUnit"] as? Int ?? 1
            let termText = termUnit == 1 ? "\(showTerm) Days" : "\(showTerm) Months"
            
            // 检查 termDetailList 数组个数
            let termDetailList = mancry_selectedAmountDetail?["termDetailList"] as? [[String: Any]] ?? []
            let isClickable = termDetailList.count > 1
            let title = isClickable ? "Select the loan tenure" : "The loan tenure"
            
            mancry_loanDetailsData.append((title: title, value: termText, showInfo: false, tooltipMessage: "", isClickable: isClickable))
        }
        
        // 2. Amount received (with info icon)
        if let arrivalAmount = termDetail["arrivalAmount"] as? String {
            let formatted = mancry_formatAmount(arrivalAmount)
            mancry_loanDetailsData.append((
                title: "Amount received",
                value: "₱\(formatted)",
                showInfo: true,
                tooltipMessage: "The actual amount you receive is calculated by deducting the service fee and GST from the loan amount.",
                isClickable: false
            ))
        }
        
        // 3. Interest (with info icon)
        if let interestAmount = termDetail["interestAmount"] as? String {
            let formatted = mancry_formatAmount(interestAmount)
            mancry_loanDetailsData.append((
                title: "Interest",
                value: "₱\(formatted)",
                showInfo: true,
                tooltipMessage: "Calculated based on your loan amount, loan term, and the interest rate of the current product.",
                isClickable: false
            ))
        }
        
        // 4. Service fee (with info icon)
        if let feeAmount = termDetail["feeAmount"] as? String {
            let formatted = mancry_formatAmount(feeAmount)
            mancry_loanDetailsData.append((
                title: "Service fee",
                value: "₱\(formatted)",
                showInfo: true,
                tooltipMessage: "This is the fee charged by the financial institution for providing loan services.",
                isClickable: false
            ))
        }
        
        // 5. Date of application (使用 borrowingDate)
        if let borrowingDate = termDetail["borrowingDate"] as? String {
            mancry_loanDetailsData.append((title: "Date of application", value: borrowingDate, showInfo: false, tooltipMessage: "", isClickable: false))
        } else {
            // 如果没有 borrowingDate，使用当前日期
            let applicationDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let dateString = dateFormatter.string(from: applicationDate)
            mancry_loanDetailsData.append((title: "Date of application", value: dateString, showInfo: false, tooltipMessage: "", isClickable: false))
        }
        
        // 6. Due date (使用 repaymentDate)
        if let repaymentDate = termDetail["repaymentDate"] as? String {
            mancry_loanDetailsData.append((title: "Due date", value: repaymentDate, showInfo: false, tooltipMessage: "", isClickable: false))
        }
        
     
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mancry_loanDetailsTableView.reloadData()
        }
        
        mancry_updateRepaymentPlan()
    }
    
    private func mancry_configureWithData() {
        guard let data = mancry_termV3Data,
              let dataDict = data["data"] as? [String: Any] else {
            
            return
        }
        
        // 配置产品信息
        if let productName = dataDict["productName"] as? String {
            mancry_productNameLabel.text = productName
        }
        
        if let productLogo = dataDict["productLogo"] as? String, !productLogo.isEmpty {
            if let url = URL(string: productLogo) {
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.mancry_productIconView.image = image
                        }
                    }
                }
            }
        }
        
        // 配置金额选择
        if let amountDetailList = dataDict["amountDetailList"] as? [[String: Any]] {
            if amountDetailList.count > 1 {
                // 多金额选择
                mancry_setupMultipleAmountSelection(amountDetailList: amountDetailList)
                // 默认选中最后一条
                let lastIndex = amountDetailList.count - 1
                if let lastAmountDetail = amountDetailList.last {
                    mancry_selectAmountDetail(lastAmountDetail)
                    mancry_updateAmountButtonSelection(selectedIndex: lastIndex)
                }
            } else if amountDetailList.count == 1 {
                // 单金额输入
                mancry_amountButtonsContainer.isHidden = true
                mancry_singleAmountContainer.isHidden = false
                mancry_amountTitleLabel.text = "Loan Amount (₱)"
                
                if let loanAmount = amountDetailList[0]["loanAmount"] as? String {
                    mancry_singleAmountValueLabel.text = mancry_formatAmount(loanAmount)
                   
                    mancry_selectedAmountDetail = amountDetailList[0]
                    // 默认选中最后一个期数
                    if let termDetailList = amountDetailList.last?["termDetailList"] as? [[String: Any]],
                       let firstTerm = termDetailList.first {
                        mancry_selectedTermDetail = firstTerm
                    }
                    mancry_updateLoanDetails()
                }
            }
        }
        
      
        
        mancry_setupTermsLabel()
    }
    
    private func mancry_setupMultipleAmountSelection(amountDetailList: [[String: Any]]) {
        mancry_amountButtonsContainer.isHidden = false
        mancry_singleAmountContainer.isHidden = true
        
        mancry_amountButtons.forEach { $0.removeFromSuperview() }
        mancry_amountButtons.removeAll()
        
        let buttonWidth = (mancry_Width - 60 - 40) / 3
        let buttonHeight: CGFloat = 48
        let horizontalSpacing: CGFloat = 10
        let verticalSpacing: CGFloat = 10
        
        // 用于记录每一行的第一个按钮，以便设置 bottom 约束
        var firstButtonInLastRow: UIButton?
        
        for (index, amountDetail) in amountDetailList.enumerated() {
            let button = UIButton(type: .system)
            let loanAmount = amountDetail["loanAmount"] as? String ?? "0"
            let formattedAmount = mancry_formatAmount(loanAmount)
            button.setTitle(formattedAmount, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
            button.backgroundColor = .white
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(hex: "#E0E0E0")?.cgColor
            button.tag = index
            button.addTarget(self, action: #selector(mancry_amountButtonTapped(_:)), for: .touchUpInside)
            
            mancry_amountButtonsContainer.addSubview(button)
            mancry_amountButtons.append(button)
            
            let row = index / 3
            let col = index % 3
            
            button.snp.makeConstraints { make in
                make.width.equalTo(buttonWidth)
                make.height.equalTo(buttonHeight)
                
                // 设置 top 约束
                if row == 0 {
                    make.top.equalToSuperview()
                } else {
                    // 找到上一行同列的按钮
                    let previousRowIndex = index - 3
                    if previousRowIndex >= 0 && previousRowIndex < mancry_amountButtons.count - 1 {
                        let previousRowButton = mancry_amountButtons[previousRowIndex]
                        make.top.equalTo(previousRowButton.snp.bottom).offset(verticalSpacing)
                    }
                }
                
                // 设置 left 约束
                if col == 0 {
                    make.left.equalToSuperview()
                    firstButtonInLastRow = button // 记录每一行的第一个按钮
                } else {
                    let previousButton = mancry_amountButtons[index - 1]
                    make.left.equalTo(previousButton.snp.right).offset(horizontalSpacing)
                }
            }
        }
        
        // 设置容器的 bottom 约束到最后一行的第一个按钮
        if let lastRowFirstButton = firstButtonInLastRow {
            mancry_amountButtonsContainer.snp.makeConstraints { make in
                make.bottom.equalTo(lastRowFirstButton.snp.bottom)
            }
        }
    }
    
    private func mancry_updateAmountButtonSelection(selectedIndex: Int) {
        for (index, button) in mancry_amountButtons.enumerated() {
            if index == selectedIndex {
                button.backgroundColor = UIColor(hex: "#FF6B35")
                button.setTitleColor(.white, for: .normal)
                button.layer.borderColor = UIColor(hex: "#FF6B35")?.cgColor
            } else {
                button.backgroundColor = .white
                button.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
                button.layer.borderColor = UIColor(hex: "#E0E0E0")?.cgColor
            }
        }
    }
    
    @objc private func mancry_amountButtonTapped(_ sender: UIButton) {
        guard let data = mancry_termV3Data,
              let dataDict = data["data"] as? [String: Any],
              let amountDetailList = dataDict["amountDetailList"] as? [[String: Any]],
              sender.tag < amountDetailList.count else {
            return
        }
        
        mancry_updateAmountButtonSelection(selectedIndex: sender.tag)
        let selectedAmountDetail = amountDetailList[sender.tag]
        mancry_selectAmountDetail(selectedAmountDetail)
    }
    
    private func mancry_selectAmountDetail(_ amountDetail: [String: Any]) {
        mancry_selectedAmountDetail = amountDetail
        
        if let termDetailList = amountDetail["termDetailList"] as? [[String: Any]],
           let firstTerm = termDetailList.first {
            mancry_selectedTermDetail = firstTerm
        }
        
        mancry_updateLoanDetails()
    }
    
    private func mancry_updateRepaymentPlan() {
        guard let termDetail = mancry_selectedTermDetail,
              let productTermItemList = termDetail["productTermItemList"] as? [[String: Any]],
              !productTermItemList.isEmpty else {
            return
        }
        
        // 清空旧内容
        mancry_repaymentPlanContent.subviews.forEach { $0.removeFromSuperview() }
        
        var previousRow: UIView?
        
        // 显示第一条数据（始终显示）
        let firstRow = mancry_createRepaymentRow(item: productTermItemList[0], index: 0)
        mancry_repaymentPlanContent.addSubview(firstRow)
        
        firstRow.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(60)
        }
        previousRow = firstRow
        
        // 如果有多条数据，创建其他行（默认隐藏）
        if productTermItemList.count > 1 {
            for (index, item) in productTermItemList.enumerated() {
                if index == 0 { continue } // 跳过第一条
                
                let row = mancry_createRepaymentRow(item: item, index: index)
                row.isHidden = true // 默认隐藏
                mancry_repaymentPlanContent.addSubview(row)
                
                row.snp.makeConstraints { make in
                    make.top.equalTo(previousRow!.snp.bottom).offset(16)
                    make.left.right.equalToSuperview().inset(12)
                    make.height.equalTo(60)
                }
                previousRow = row
            }
        }
    }
    
    private func mancry_createRepaymentRow(item: [String: Any], index: Int) -> UIView {
        let rowView = UIView()
        rowView.backgroundColor = .clear
        rowView.tag = 1000 + index // 用于后续查找
        
        let dueDateLabel = UILabel()
        dueDateLabel.text = "Due Date"
        dueDateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        dueDateLabel.textColor = UIColor(hex: "#666666")
        rowView.addSubview(dueDateLabel)
        
        let amountDueLabel = UILabel()
        amountDueLabel.text = "Amount Due"
        amountDueLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        amountDueLabel.textColor = UIColor(hex: "#666666")
        rowView.addSubview(amountDueLabel)
        
        let dueDateValueLabel = UILabel()
        if let expirationDate = item["expirationDate"] as? String {
            dueDateValueLabel.text = expirationDate
        }
        dueDateValueLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        dueDateValueLabel.textColor = UIColor(hex: "#2C2F20")
        rowView.addSubview(dueDateValueLabel)
        
        let amountDueValueLabel = UILabel()
        if let repaymentAmount = item["repaymentAmount"] as? String {
            amountDueValueLabel.text = "₱\(mancry_formatAmount(repaymentAmount))"
        }
        amountDueValueLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        amountDueValueLabel.textColor = UIColor(hex: "#2C2F20")
        amountDueValueLabel.textAlignment = .right
        rowView.addSubview(amountDueValueLabel)
        
        dueDateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        amountDueLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        dueDateValueLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(dueDateLabel.snp.bottom).offset(8)
        }
        
        amountDueValueLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(dueDateValueLabel.snp.top)
        }
        
        return rowView
    }
    
   
    
    private func mancry_setupTermsLabel() {
        let fullText = "I have read and agreed with the Terms Of The Loans."
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: UIColor(hex: "#2C2F20") ?? .black
        ], range: NSRange(location: 0, length: fullText.count))
        
        if let range = fullText.range(of: "Terms Of The Loans") {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttributes([
                .foregroundColor: UIColor(hex: "#FF6B35") ?? .orange,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .link: URL(string: "terms://")!
            ], range: nsRange)
        }
        
        mancry_termsLabel.attributedText = attributedString
        mancry_termsLabel.linkTextAttributes = [
            .foregroundColor: UIColor(hex: "#FF6B35") ?? .orange,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }

    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "terms" {
            let webVC = Mancry_WebViewController()
            webVC.mancry_linkUrlStr = mancry_termsOfLoanUrl
            webVC.mancry_titleStr = "Terms Of The Loan"
            navigationController?.pushViewController(webVC, animated: true)
            webVC.mancry_setupLinkShowView()
            return false
        }
        return true
    }
    
    @objc private func mancry_receivingAccountTapped() {
        if mancry_bankCardList.isEmpty {
            
            let vc = Mancry_EditCardVC()
            vc.nestType = "add"
            navigationController?.pushViewController(vc, animated: true)
        } else {
            mancry_showBankCardSelectionPopup()
        }
    }
    
    private func mancry_showBankCardSelectionPopup() {
        let popup = Mancry_customselectPopupView()
        let bankCardTitles = mancry_bankCardList.map { bankCard -> String in
            if let accountNo = bankCard["accountNo"] as? String {
                // 格式化显示完整银行卡号（每4位加空格）
                return mancry_formatCardNumber(accountNo)
            }
            return "Bank Card"
        }
        
        popup.configure(
            title: "Select receiving account",
            data: bankCardTitles,
            extraActionTitle: "+ Add a receiving account"
        )
        popup.onConfirm = { [weak self] index, title in
            guard let self = self, index < self.mancry_bankCardList.count else { return }
            self.mancry_selectedBankCard = self.mancry_bankCardList[index]
            self.mancry_updateReceivingAccountButton()
        }
        popup.onExtraAction = { [weak self] in
            let vc = Mancry_EditCardVC()
            vc.nestType = "add"
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        popup.onCancel = {}
        popup.show()
    }
    
    private func mancry_showTermSelectionPopup() {
        guard let amountDetail = mancry_selectedAmountDetail,
              let termDetailList = amountDetail["termDetailList"] as? [[String: Any]],
              termDetailList.count > 1 else {
            return
        }
        
        let popup = Mancry_customselectPopupView()
        
        // 构建期限选项
        let termTitles = termDetailList.map { termDetail -> String in
            var showTerm: Int = 0
            if let termInt = termDetail["showTerm"] as? Int {
                showTerm = termInt
            } else if let termString = termDetail["showTerm"] as? String {
                showTerm = Int(termString) ?? 0
            }
            
            let termUnit = termDetail["productTermUnit"] as? Int ?? 1
            return termUnit == 1 ? "\(showTerm) Days" : "\(showTerm) Months"
        }
        
        popup.configure(title: "Select the loan tenure", data: termTitles)
        popup.onConfirm = { [weak self] index, title in
            guard let self = self, index < termDetailList.count else { return }
            self.mancry_selectedTermDetail = termDetailList[index]
            self.mancry_updateLoanDetails()
        }
        popup.onCancel = {}
        popup.show()
    }
    
    private func mancry_updateReceivingAccountButton() {
        guard let bankCard = mancry_selectedBankCard,
              let accountNo = bankCard["accountNo"] as? String else {
            return
        }
        
        // 保存 bankCardBindId
        if let bankCardBindId = bankCard["bankCardBindId"] as? Int {
            mancry_selectedBankCardBindId = bankCardBindId
        }
        
        let formatted = mancry_formatCardNumber(accountNo)
        mancry_receivingAccountButton.setTitle(formatted, for: .normal)
        mancry_receivingAccountButton.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
    }
    
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
    
    @objc private func mancry_toggleRepaymentPlan() {
        mancry_isRepaymentPlanExpanded.toggle()
        
        // 切换除第一行外的所有行的显示/隐藏
        var visibleRowCount = 1 // 至少有第一行
        for subview in mancry_repaymentPlanContent.subviews {
            if subview.tag >= 1001 {
                subview.isHidden = !mancry_isRepaymentPlanExpanded
                if mancry_isRepaymentPlanExpanded {
                    visibleRowCount += 1
                }
            }
        }
        
        // 计算新的高度：12(top padding) + 行数 * 60 + (行数-1) * 16(间距) + 12(bottom padding)
        let newHeight: CGFloat
        if mancry_isRepaymentPlanExpanded {
            newHeight = 12 + CGFloat(visibleRowCount) * 60 + CGFloat(visibleRowCount - 1) * 16 + 12
        } else {
            newHeight = 84 // 默认高度：12 + 60 + 12
        }
        
        // 重新设置 content 的约束
        mancry_repaymentPlanContent.snp.remakeConstraints { make in
            make.top.equalTo(mancry_repaymentPlanHeader.snp.bottom)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(newHeight)
        }
        
        // 旋转箭头并更新布局
        UIView.animate(withDuration: 0.3) {
            self.mancry_repaymentPlanArrowView.transform = self.mancry_isRepaymentPlanExpanded ?
                CGAffineTransform(rotationAngle: .pi) : .identity
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func mancry_termsCheckboxTapped() {
        mancry_isAgreedToTerms.toggle()
        mancry_termsCheckbox.isSelected = mancry_isAgreedToTerms
    }
    // MARK: - applyTapped
    @objc private func mancry_applyTapped() {
        guard mancry_isAgreedToTerms else {
            mac_centerToastViewwithMsg(msg: "Please agree to the Terms Of The Loans")
            return
        }
        
        guard mancry_selectedBankCard != nil else {
            mac_centerToastViewwithMsg(msg: "Please select a receiving account")
            return
        }
        
//        guard mancry_selectedAmountDetail != nil, mancry_selectedTermDetail != nil else {
//            mac_centerToastViewwithMsg(msg: "Please select loan amount")
//            return
//        }
        
        print("Apply button tapped")
        self.mac_PopLoadingView()
        mancry_getlocationData()
        
   
      
    }
    
    
    private func mancry_getlocationData(){
        
        let priorStatus: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            priorStatus = CLLocationManager().authorizationStatus
        } else {
            priorStatus = CLLocationManager.authorizationStatus()
        }
        let wasFirstSystemPrompt = (priorStatus == .notDetermined)
        
        Mancry_PublicMethodS.getLocationWithCompletion { [weak self] latitude, longitude, authorized, error in
            guard let self = self else { return }
            
            if !authorized {
                
                self.mac_hiddenLoadingView()
                Mancry_uploadData.mancry_insertPointData(insertId: "16")
                if wasFirstSystemPrompt {
                    
                    if mancry_homeNumCap != 1{
                        self.mac_PopLoadingView()
                        self.mancry_uploadDownOrderData(latitude: -360, longitude: -360)
                    }
                } else {
                    self.mancry_isCapture()
                }
                return
            } else {
                // 使用经纬度
                print("当前坐标：lat = \(latitude), lng = \(longitude)")
                // 继续下单流程
                Mancry_uploadData.mancry_insertPointData(insertId: "15")
                self.mancry_uploadDownOrderData(latitude: latitude, longitude: longitude)
            }
        }
        
    }
    
    func mancry_isCapture(){
        if mancry_homeNumCap == 1{
            
            let cameraPopView = Mancry_PopView(type: .cameraPermission)
            cameraPopView.configure(
                topImageName: "flbeql_tk_xj",
                title: "Location",
                description: "Please allow CyCash to access location in the settings so that you can complete the loan application",
                leftButtonTitle: "Cancel",
                rightButtonTitle: "Confirm"
            )
            
            cameraPopView.onRightButtonTapped = {
                self.mac_hiddenLoadingView()
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(settingsURL)
            }
            cameraPopView.onLeftButtonTapped = {
                self.mac_hiddenLoadingView()
            }
            cameraPopView.show()
            
            
        }else{
            // 继续下单流程
            mancry_uploadDownOrderData(latitude: -360, longitude: -360)
        }
    }
    
    func mancry_uploadDownOrderData(latitude: Double,longitude:Double){
    
            // 构建请求参数
            guard let termDetail = self.mancry_selectedTermDetail,
                  let dataDict = self.mancry_termV3Data?["data"] as? [String: Any],
                  let productIdStr = dataDict["productId"] as? String else {
                self.mac_centerToastViewwithMsg(msg: "Missing required data")
                return
            }
            
            // 获取 loanAmount
            let loanAmount = termDetail["loanAmount"] as? String ?? ""
            
            // 获取 showTerm
            var showTerm = ""
            if let showTermInt = termDetail["showTerm"] as? Int {
                showTerm = "\(showTermInt)"
            } else if let showTermStr = termDetail["showTerm"] as? String {
                showTerm = showTermStr
            }
            
            // 获取 bankCardBindId
            guard let bankCardBindId = self.mancry_selectedBankCardBindId else {
                self.mac_centerToastViewwithMsg(msg: "Please select a receiving account")
                return
            }
           
            let latitudeStr = String(format: "%.17g", latitude)
            let longitudeStr = String(format: "%.17g", longitude)
            
            let mancry_amount = loanAmount
            let mancry_showTerm = showTerm
            let mancry_productId = productIdStr
        
            // 构建签名字典（用于签名的字段）
            let signdic: [String: Any] = [
                "productId": mancry_productId,
                "loanAmount": mancry_amount,
                "latitude": latitudeStr,
                "longitude": longitudeStr,
                "serialNo": mancry_deviceId,
                "imei": "",
            ]
            
            // 构建额外数据字典（不参与签名的字段）
            let dic: [String: Any] = [
                "showTerm": mancry_showTerm,
                "bankCardBindId": "\(bankCardBindId)"
            ]
        
            let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: signdic, isSign: true, dic, false)
            guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else {
                self.mac_centerToastViewwithMsg(msg: "Failed to create request")
                return
            }
            
          
            
            Mancry_RequestData.figures_requestnetworkBodyData(
                urlString: "/app/v3/order/userSubmitV3",
                httpBody: postData,
                successCallBack: { [weak self] result in
                    guard let self = self else { return }
                    self.mac_hiddenLoadingView()
                    
                    let code = result["resultCode"] as? Int ?? -1
                    if code == 200 {
                        
                        let orderId = (result["data"] as? [String: Any])?["orderId"] as? String ?? ""
                    print("下单成功---\(orderId)")
                        
                        Mancry_uploadData.callMobileDevice(
                            orderId: orderId,
                            successCallback: {
                                print("抓取设备信息成功")
                  let iscontactsStatus = CNContactStore.authorizationStatus(for: .contacts)
                                // 步骤4: 获取通讯录权限
                    Mancry_PublicMethodS.getContactsPermissionStatusWithCompletion { contactsGranted in
                        
                                if contactsGranted == true{
                                        
                                    let contactsStatus = CNContactStore.authorizationStatus(for: .contacts)
                                        if #available(iOS 18.0, *) {
                                            if contactsStatus == .limited {
                                                Mancry_uploadData.mancry_insertPointData(insertId: "198")
                                                if mancry_homeNumCap == 1{
//                                                    self.get_mancry_ContactermissionAlert()
                                                    DispatchQueue.main.async {
                                                        self.navigationController?.popViewController(animated: true)

                                                    }
                                                    return
                                                }else{
                                                    self.mancry_gotoCaptureData(orderId: orderId)
                                                }
                                                
                                            }else{
                                                Mancry_uploadData.mancry_insertPointData(insertId: "19")
                                                self.mancry_gotoCaptureData(orderId: orderId)
                                            }
                                        }else{
                                            self.mancry_gotoCaptureData(orderId: orderId)
                                            Mancry_uploadData.mancry_insertPointData(insertId: "19")
                                        }
                                    
                                }else{
                                    Mancry_uploadData.mancry_insertPointData(insertId: "20")
                                    if mancry_homeNumCap == 1{
                                        if iscontactsStatus == .notDetermined{
                                            DispatchQueue.main.async {
                                                self.navigationController?.popViewController(animated: true)

                                            }
                                        }else{
                                            self.get_mancry_ContactermissionAlert()
                                            return
                                        }
                                        
                                      
                                    }else{
                                        self.mancry_gotoCaptureData(orderId: orderId)
                                    }
                                }
                                }
                            },
                            failureCallback: {_ in
                            }
                        )
                        
                    } else {
                        let msg = result["resultMsg"] as? String ?? ""
                        self.mac_centerToastViewwithMsg(msg: msg)
                        self.mac_hiddenLoadingView()
                    }
                },
                failureCallBack: { [weak self] error in
                    guard let self = self else { return }
                    self.mac_hiddenLoadingView()
                    self.mac_centerToastViewwithMsg(msg: "Submit failed, please try again")
                }
            )
        
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
    
    
    private func mancry_loadBankCardList() {
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: [:])
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else { return }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/payAccountInfo/list",
            httpBody: postData,
            successCallBack: { [weak self] result in
                let code = result["resultCode"] as? Int ?? -1
                if code == 200 {
                    guard let dataDict = result["data"] as? [String: Any],
                          let bankCardList = dataDict["payAccountInfoList"] as? [[String: Any]] else {
                        return
                    }
                    self?.mancry_bankCardList = bankCardList
                    
                    // 默认选择第一条数据
                    if let firstCard = bankCardList.first {
                        self?.mancry_selectedBankCard = firstCard
                        
                        // 保存 bankCardBindId
                        if let bankCardBindId = firstCard["bankCardBindId"] as? Int {
                            self?.mancry_selectedBankCardBindId = bankCardBindId
                        }
                        
                        // 更新按钮显示
                        self?.mancry_updateReceivingAccountButton()
                    }
                }
            },
            failureCallBack: { error in
                print("Load bank card list error: \(error.localizedDescription)")
            }
        )
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension Mancry_ApplyDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mancry_loanDetailsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Mancry_LoanDetailCell.identifier, for: indexPath) as? Mancry_LoanDetailCell else {
            
            return UITableViewCell()
        }
        
        let data = mancry_loanDetailsData[indexPath.row]
        
        cell.configure(title: data.title, value: data.value, showInfo: data.showInfo, isClickable: data.isClickable, tag: indexPath.row)
        
        cell.onInfoButtonTapped = { [weak self] tag in
            guard let self = self, tag < self.mancry_loanDetailsData.count else { return }
            let tooltipMessage = self.mancry_loanDetailsData[tag].tooltipMessage
            if !tooltipMessage.isEmpty {
                self.mac_centerToastViewwithMsg(msg: tooltipMessage)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = mancry_loanDetailsData[indexPath.row]
        
        // 只有第一行（Select the loan tenure）且可点击时才处理
        if indexPath.row == 0 && data.isClickable {
            mancry_showTermSelectionPopup()
        }
    }
}
// 千分位分割
public func mancry_formatAmount(_ amount: String) -> String {
    let cleaned = amount.replacingOccurrences(of: ",", with: "")
    guard let value = Int(cleaned) else { return amount }
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = ","
    formatter.maximumFractionDigits = 0
    return formatter.string(from: NSNumber(value: value)) ?? amount
}
