

import UIKit
import SnapKit

/// 订单列表页面（Order history）
class Mancry_HomeOrderListVC: Mac_BaseViewController {
    public var rejestUrl = ""
    // MARK: - Data Model
    struct Mancry_OrderItem {
        let productName: String
        let loanAmount: String
        let applyDate: String
        let dueDate: String
        let statusText: String
        let productId: String
        let orderId: String
        let repayDate: String
        let loanDate: String
    }
    
    // MARK: - Properties
    private var mancry_orderList: [Mancry_OrderItem] = []
    
    // MARK: - UI
    private lazy var mancry_tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor(hex: "#EDF1D8")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        tableView.register(Mancry_HomeOrderCell.self, forCellReuseIdentifier: "Mancry_HomeOrderCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mac_publiccustomnavView(title: "Order history")
        setupUI()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mancry_requestOrderList()
        
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        view.addSubview(mancry_tableView)
        
        mancry_tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.left.right.bottom.equalToSuperview()
        }
        
        mancry_tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    // MARK: - Network
    private func mancry_requestOrderList(page: Int = 1, pageSize: Int = 20) {
        let bizData: [String: Any] = [
            "orderStatus":"66"

        ]
        
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: bizData, isSign: false)
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else { return }
        
        mac_PopLoadingView()
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/order/list",
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
                print("列表接口成功")
                // 尝试解析 data.list 或 data.records
                guard let dataDict = result["data"] as? [String: Any] else { return }
                let listArray = (dataDict["orderList"] as? [[String: Any]]) ?? (dataDict["records"] as? [[String: Any]]) ?? []
                
                var items: [Mancry_OrderItem] = []
                for dict in listArray {
                    let productName = dict["productName"] as? String ?? "Product Name"
                    
                    
                    let mancry_amountFormatter: (String) -> String = { value in
                        let clean = value.trimmingCharacters(in: .whitespaces)
                        guard let number = Double(clean) else { return clean }
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .decimal
                        formatter.groupingSeparator = ","
                        formatter.maximumFractionDigits = 0
                        return formatter.string(from: NSNumber(value: number)) ?? clean
                    }
                    
                    
                    // 贷款金额格式化
                    var loanAmountText = "₱ 0"
                   if let amountString = dict["loanAmount"] as? String, !amountString.isEmpty {
                        loanAmountText = mancry_amountFormatter(amountString)
                        loanAmountText = "₱ \(loanAmountText)"
                    }
                    
                    let applyDate = dict["applyDate"] as? String
                        ?? dict["applicationDate"] as? String
                        ?? "--"
                    let dueDate = dict["dueDate"] as? String ?? "--"
                    let repayDate = dict["repayDate"] as? String ?? "--"
                    let loanDate = dict["loanDate"] as? String ?? "__"
                    let statusNum = dict["orderStatus"] as? Int ?? 0
                    let statusText = "\(statusNum)"
                    let productId = dict["productId"] as? String ?? ""
                    let orderId = dict["orderId"] as? String ?? ""
                    let item = Mancry_OrderItem(
                        productName: productName,
                        loanAmount: loanAmountText,
                        applyDate: applyDate,
                        dueDate: dueDate,
                        statusText: statusText,
                        productId:productId,
                        orderId: orderId,
                        repayDate: repayDate,
                        loanDate: loanDate
                        
                    )
                    items.append(item)
                }
                
                self.mancry_orderList = items
                DispatchQueue.main.async {
                    self.mancry_tableView.reloadData()
                }
            },
            failureCallBack: { [weak self] error in
                self?.mac_hiddenLoadingView()
                self?.mac_centerToastViewwithMsg(msg: "Network error, please try again")
                print("Order list request failed: \(error.localizedDescription)")
            }
        )
    }
    
    /// 根据状态文案映射状态图片名称
    private func mancry_statusImageName(for status: String) -> String? {
        let lower = status
        if lower == "10" {
            return "flbeql_order_dzqsj"
        } else if lower == "30" {
            return "flbeql_order_shz"
        } else if lower == "31" {
            return "flbeql_order_jj"
        } else if lower == "32" {
            return "flbeql_order_ggyhk(1)"
        } else if lower == "36" {
            return "flbeql_order_ggyhk"
        } else if lower == "50" {
            return "flbeql_order_fkz"
        } else if lower == "60" {
            return "flbeql_fhzess_pendingrepayment"
        } else if lower == "61" {
            return "flbeql_order_yq"
        } else if lower == "70" {
            return "flbeql_order_jq"
        }
        else if lower == "99" {
            return "flbeql_order_qx"
        }
        return nil
    }
}

// MARK: - UITableViewDataSource & Delegate
extension Mancry_HomeOrderListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mancry_orderList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Mancry_HomeOrderCell", for: indexPath) as! Mancry_HomeOrderCell
        
        let item = mancry_orderList[indexPath.row]
        let statusImageName = mancry_statusImageName(for: item.statusText)
        cell.configure(with: item, statusImageName: statusImageName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = mancry_orderList[indexPath.row]
        let mancry_productId = item.productId
        let mancry_orderId = item.orderId
        if item.statusText == "31" && self.rejestUrl.count > 0 {
            let vc = Mancry_OpenUrlVC()
            vc.mancry_h5URL = self.rejestUrl
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        if item.statusText == "32"{
            let vc = Mancry_HomeWithDrawnVC()
            vc.mancry_productId = mancry_productId
            vc.mancry_orderId = mancry_orderId
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = Mancry_HomeOrderDetailsVC()
            vc.mancry_productId = mancry_productId
            vc.mancry_orderId = mancry_orderId
            self.navigationController?.pushViewController(vc, animated: true)
        }
      
    }
}

// MARK: - 自定义订单 Cell
class Mancry_HomeOrderCell: UITableViewCell {
    
    private let cardView = UIView()
    private let productTitleLabel = UILabel()
    private let productValueLabel = UILabel()

    public let statusImageView = UIImageView()
    
    private let loanAmountTitleLabel = UILabel()
    private let loanAmountValueLabel = UILabel()
    
    private let applyDateTitleLabel = UILabel()
    private let applyDateValueLabel = UILabel()
    
    private let dueDateTitleLabel = UILabel()
    private let dueDateValueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(cardView)
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 16
        cardView.clipsToBounds = true
        
        productTitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        productTitleLabel.textColor = UIColor(hex: "#777C61")
        productTitleLabel.text = "Product Name"
        
        
        productValueLabel.font = .systemFont(ofSize: 12, weight: .regular)
        productValueLabel.textColor = UIColor(hex: "#2C2F20")
        productValueLabel.text = ""
        
        statusImageView.contentMode = .scaleAspectFit
        
        loanAmountTitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        loanAmountTitleLabel.textColor = UIColor(hex: "#777C61")
        loanAmountTitleLabel.text = "Loan Amount"
        
        loanAmountValueLabel.font = .systemFont(ofSize: 16, weight: .bold)
        loanAmountValueLabel.textColor = UIColor(hex: "#2C2F20")
        
        applyDateTitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        applyDateTitleLabel.textColor = UIColor(hex: "#777C61")
        applyDateTitleLabel.text = "Date of application"
        
        applyDateValueLabel.font = .systemFont(ofSize: 14, weight: .regular)
        applyDateValueLabel.textColor = UIColor(hex: "#2C2F20")
        
        dueDateTitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        dueDateTitleLabel.textColor = UIColor(hex: "#777C61")
        dueDateTitleLabel.text = "Due date"
        
        dueDateValueLabel.font = .systemFont(ofSize: 14, weight: .regular)
        dueDateValueLabel.textColor = UIColor(hex: "#2C2F20")
        
        cardView.addSubview(productTitleLabel)
        cardView.addSubview(productValueLabel)
        cardView.addSubview(statusImageView)
        cardView.addSubview(loanAmountTitleLabel)
        cardView.addSubview(loanAmountValueLabel)
        cardView.addSubview(applyDateTitleLabel)
        cardView.addSubview(applyDateValueLabel)
        cardView.addSubview(dueDateTitleLabel)
        cardView.addSubview(dueDateValueLabel)
        
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
        
        productTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(16)
        }
        
        productValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(productTitleLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        statusImageView.snp.makeConstraints { make in
            make.centerY.equalTo(productTitleLabel).offset(-26)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(24)
            make.width.greaterThanOrEqualTo(80)
        }
        
        loanAmountTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(productTitleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        loanAmountValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(loanAmountTitleLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        applyDateTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(loanAmountTitleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
        }
        
        applyDateValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(applyDateTitleLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        dueDateTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(applyDateTitleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
        }
        
        dueDateValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dueDateTitleLabel)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func configure(with item: Mancry_HomeOrderListVC.Mancry_OrderItem, statusImageName: String?) {
        loanAmountValueLabel.text = item.loanAmount
       
        productValueLabel.text = item.productName
        if let name = statusImageName, let image = UIImage(named: name) {
            statusImageView.image = image
        } else {
            statusImageView.image = nil
        }
        
       
        if item.statusText == "60" || item.statusText == "61" || item.statusText == "70"{
            if item.statusText == "70"{
                self.dueDateTitleLabel.text = "Repayment date"
                dueDateValueLabel.text = item.repayDate
            }else{
                self.dueDateTitleLabel.text = "Due date"
                dueDateValueLabel.text = item.dueDate
            }
            self.applyDateTitleLabel.text = "Payment Date"
            applyDateValueLabel.text = item.loanDate
        }else{
            self.applyDateTitleLabel.text = "Date of application"
            applyDateValueLabel.text = item.applyDate
            dueDateValueLabel.text = "-"
        }
        
    }
}
