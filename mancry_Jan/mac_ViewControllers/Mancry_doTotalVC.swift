

import UIKit
import SnapKit
import Contacts



class Mancry_doTotalVC: Mac_BaseViewController {
    
    // MARK: - Properties
    
    // 产品列表数据
    private var mancry_productList: [[String: Any]] = []
    
    
    private var mancry_dynamicParameter: [String: Any] = [:]
    
    
    private var mancry_userStatus: Int = 0
    
    
    private var mancry_selectedProductId: String?
    private var mancry_productClickLocked = false
    private var mancry_rejectUrl = ""
    
    private var isMancryFirstup = false
    private var macNoDataV : Mancry_noDataView!
    private var mancry_conditionsHrefStr = ""
    var withdrawnId = ""
    var isdownloadSuccess = false
    // 顶部容器视图
    private lazy var mancry_topContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(mancry_topContainerViewTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    // 背景图片
    private lazy var mancry_backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbeql_home_bg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // 箭头图片
    private lazy var mancry_arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbeql_home_jt")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // Logo（左侧）
    private lazy var mancry_logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbeql_home_grzx")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // 右侧图片
    private lazy var mancry_profileButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "flbeql_home_ts"), for: .normal)
        button.addTarget(self, action: #selector(mancry_profileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 欢迎文字
    private lazy var mancry_welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello CyCash"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#666666")
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.lineBreakMode = .byClipping
        return label
    }()
    
    // Welcome Back 文字
    private lazy var mancry_welcomeBackLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome Back!"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(hex: "#333333")
        return label
    }()
    
    // 提示文字
    private lazy var mancry_tipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(hex: "#666666")
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(mancry_tipLabelTapped))
        label.addGestureRecognizer(tap)
        return label
    }()
    
    // Banner 图片
    private lazy var mancry_bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbeql_home_banner")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(mancry_bannerTapped))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    // Order History 按钮
    private lazy var mancry_orderHistoryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(hex: "#FF8C42")
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        
        let iconImageView = UIImageView(image: UIImage(named: "flbeql_home_order_icon"))
        iconImageView.contentMode = .scaleAspectFit
        button.addSubview(iconImageView)
        
        let titleLabel = UILabel()
        titleLabel.text = "Order history"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .white
        button.addSubview(titleLabel)
        
        let arrowImageView = UIImageView(image: UIImage(named: "flbeql_home_order_jt"))
        arrowImageView.contentMode = .scaleAspectFit
        button.addSubview(arrowImageView)
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        button.addTarget(self, action: #selector(mancry_orderHistoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // TableView
    private lazy var mancry_tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(Mancry_ProductCell.self, forCellReuseIdentifier: "Mancry_ProductCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    // 底部容器视图
    private lazy var mancry_bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        return view
    }()
    
    // 底部图片容器
    private lazy var mancry_bottomImageContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    // 底部图片
    private lazy var mancry_bottomLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbeql_home_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // 底部文字
    private lazy var mancry_bottomLabel: UILabel = {
        let label = UILabel()
        label.text = "Registered with the Credit Information Corporation"
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = UIColor(hex: "#999999")
        label.textAlignment = .center
        return label
    }()
    
    let progressView = Mancry_uploadProgressView()
    // MARK: - Lifecycle
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mancry_setupUI()
        mancry_setupConstraints()
        
        mancry_dotailadidStr()
        
        NotificationCenter.default.addObserver(self, selector: #selector(goSucceedHomenotification(_:)), name: NSNotification.Name.init(rawValue: "mancry_uploadSucceed"), object: nil)
    }
    
    @objc func goSucceedHomenotification(_ notice:Notification){
        if isdownloadSuccess == false{
            isdownloadSuccess = true
            self.progressView.dismiss()
            let thankYouPopView = Mancry_PopView(type: .thankYou)
            thankYouPopView.configure(
                topImageName: "flbeql_tk_cg",
                title: "Success!",
                description: "Your application is under review. Once approved, the money will be credited to your bank account.",
                rightButtonTitle: "Confirm"
            )
            thankYouPopView.onRightButtonTapped = {
                self.navigationController?.popToRootViewController(animated: true)
            }
            thankYouPopView.show()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.mac_hiddenLoadingView()
        mac_getdototailbaseConfigData(mancry_type: "Mancry")
        mancry_requestHomeUserName()
        isdownloadSuccess = false
        
    }
    
    
    func mancry_dotailadidStr(){
   
     let mancry_dotailadidtoken = "mdlmzcaro7pc"
     let lorksu_environment = ADJEnvironmentProduction
     let adjustConfig = ADJConfig(appToken: mancry_dotailadidtoken,
                                           environment: lorksu_environment)

     Adjust.initSdk(adjustConfig)
       Task {
           if let adid = await mancry_dotailadidtokenrequestid() {
                 let idstr = adid
               mancry_uploadadidStrData(idStr: idstr, type: "adid")
               
           } else {
               
           }
       }
       
   }
   
    func mancry_uploadadidStrData(idStr: String, type: String){
        var mancry_parametersDic: [String: Any] = [:]
        mancry_parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: ["adid":idStr], isSign: false)
       
        guard let mancry_postData = try? JSONSerialization.data(withJSONObject: mancry_parametersDic) else { return }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/user/info",
            httpBody: mancry_postData,
            successCallBack: { [weak self] mancry_result in
                guard let self = self else { return }
                let mancry_code = mancry_result["resultCode"] as? Int ?? -1
                if mancry_code == 200{
                   
                }else{
                  
                }
                
               
            },
            failureCallBack: { [weak self] mancry_error in
                
                
            }
        )
    }
    
    func mancry_dotailadidtokenrequestid() async -> String? {
        return await Adjust.adid()
    }
    
    private func mancry_requestHomeUserName() {
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: [:], isSign: false)
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else { return }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/user/info",
            httpBody: postData,
            successCallBack: { [weak self] result in
                guard let self = self else { return }
                let code = result["resultCode"] as? Int ?? -1
                guard code == 200,
                      let data = result["data"] as? [String: Any] else {
                    return
                }
                let rawName = (data["name"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                let displayName = rawName.isEmpty ? "CyCash" : rawName
                DispatchQueue.main.async {
                    self.mancry_welcomeLabel.text = "Hello \(displayName)"
                }
            },
            failureCallBack: { _ in }
        )
    }
    
    // MARK: - Setup UI
    
    private func mancry_setupUI() {
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        
        view.addSubview(mancry_topContainerView)
        mancry_topContainerView.addSubview(mancry_backgroundImageView)
        mancry_topContainerView.addSubview(mancry_arrowImageView)
        mancry_topContainerView.addSubview(mancry_logoImageView)
        mancry_topContainerView.addSubview(mancry_profileButton)
        mancry_topContainerView.addSubview(mancry_welcomeLabel)
        mancry_topContainerView.addSubview(mancry_welcomeBackLabel)
        
        view.addSubview(mancry_tipLabel)
        view.addSubview(mancry_bannerImageView)
        view.addSubview(mancry_orderHistoryButton)
        view.addSubview(mancry_tableView)
        
        macNoDataV = Mancry_noDataView()
        view.addSubview(macNoDataV)
        
        view.addSubview(mancry_bottomContainerView)
        mancry_bottomContainerView.addSubview(mancry_bottomImageContainerView)
        mancry_bottomImageContainerView.addSubview(mancry_bottomLogoImageView)
        mancry_bottomContainerView.addSubview(mancry_bottomLabel)
        
        macNoDataV.mancry_applyButtonTapped = {
            // 跳转到申请页面
            print("Apply Now clicked")
            
            if self.mancry_userStatus == 10{
                self.mancry_getAuthenticationStepsData()
            }else if (self.mancry_userStatus == 80 || self.mancry_userStatus == 81 || self.mancry_userStatus == 41 || self.mancry_userStatus == 30 || self.mancry_userStatus == 32 ){
                let vc = Mancry_HomeOrderListVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    private func mancry_setupConstraints() {
        
        // 顶部容器
        mancry_topContainerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(mancry_NavBarHeight + 30) // 固定高度124
        }
        
        // 背景图片
        mancry_backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 箭头图片
        mancry_arrowImageView.snp.makeConstraints { make in
            make.top.equalTo(mancry_backgroundImageView.snp.bottom).offset(-12)
            make.right.equalToSuperview().offset(-30)
            make.width.height.equalTo(24)
        }
        
        // Logo
        mancry_logoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        // 个人中心按钮
        mancry_profileButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(mancry_logoImageView)
            make.width.height.equalTo(40)
        }
        
        // 欢迎文字
        mancry_welcomeLabel.snp.makeConstraints { make in
            make.left.equalTo(mancry_logoImageView.snp.right).offset(12)
            make.top.equalTo(mancry_logoImageView).offset(4)
            make.right.equalTo(mancry_profileButton.snp.left).offset(-10)
        }
        
        // Welcome Back
        mancry_welcomeBackLabel.snp.makeConstraints { make in
            make.left.equalTo(mancry_welcomeLabel)
            make.top.equalTo(mancry_welcomeLabel.snp.bottom).offset(2)
        }
        
        // 提示文字（在顶部容器下方）
        mancry_tipLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mancry_topContainerView.snp.bottom).offset(20)
        }
        
        // Banner
        mancry_bannerImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mancry_tipLabel.snp.bottom).offset(16)
            make.height.equalTo(100)
        }
        
        // Order History 按钮
        mancry_orderHistoryButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mancry_bannerImageView.snp.bottom).offset(16)
            make.height.equalTo(56)
        }
        
        // 底部容器
        mancry_bottomContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
            make.bottom.equalToSuperview().offset(-0)
        }
        
        // 底部图片容器
        mancry_bottomImageContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(40)
//            make.width.equalTo(mancry_Width - 150)
        }
        
        // 底部Logo图片
        mancry_bottomLogoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 底部文字
        mancry_bottomLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mancry_bottomImageContainerView.snp.bottom).offset(8)
        }
        
        // TableView / 空态：都停在底部容器上方，避免遮挡底部 logo
        mancry_tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mancry_orderHistoryButton.snp.bottom).offset(16)
            make.bottom.equalTo(mancry_bottomContainerView.snp.top)
        }
        
        macNoDataV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mancry_orderHistoryButton.snp.bottom).offset(16)
            make.bottom.equalTo(mancry_bottomContainerView.snp.top)
        }
    }
    
    // MARK: - Actions
    
    /// 更新提示文字（带图片）
    /// - Parameter text: 提示文字内容
    func mancry_updateTipLabel(text: String, imgStr: String) {
        guard !text.isEmpty else {
            mancry_tipLabel.text = ""
            mancry_tipLabel.attributedText = nil
            return
        }
        
        let attributedString = NSMutableAttributedString(string: text)
        
        // 设置文字样式
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 12, weight: .regular),
            .foregroundColor: UIColor(hex: "#666666") ?? .darkGray
        ], range: NSRange(location: 0, length: text.count))
        
        // 创建图片附件
        if let arrowImage = UIImage(named: imgStr) {
            // 调整图片大小
            let imageSize = CGSize(width: 12, height: 12)
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
            arrowImage.draw(in: CGRect(origin: .zero, size: imageSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let resizedImage = resizedImage {
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = resizedImage
                
                // 设置图片位置（垂直居中）
                let font = UIFont.systemFont(ofSize: 12, weight: .regular)
                let yOffset = (font.capHeight - imageSize.height) / 2
                imageAttachment.bounds = CGRect(x: 0, y: yOffset, width: imageSize.width, height: imageSize.height)
                
                // 在文字后面添加图片
                let imageString = NSAttributedString(attachment: imageAttachment)
                attributedString.append(NSAttributedString(string: " ")) // 添加一个空格
                attributedString.append(imageString)
            }
        }
        
        mancry_tipLabel.attributedText = attributedString
        mancry_tipLabel.isHidden = false
        
        // 更新布局，确保高度变化时 Banner 能够正确调整
        DispatchQueue.main.async { [weak self] in
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
        }
    }
    
    
   private func mancry_getAuthenticationStepsData(){
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: [:])
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else { return }
        
        self.mac_PopLoadingView()
        let errorMes = ""
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
                        let mac_Num = Int(willExecuteStepNumber) ?? 0
                        
                        
                        // 根据 willExecuteStepNumber 判断是否可以添加
                        let typeStr: String
                        if mac_Num == 1 {
                            typeStr = "personal"
                            
                        }else if mac_Num == 2 {
                            typeStr = "work_questionnaire"
                            
                        }else if mac_Num == 3 {
                            
                            typeStr = "urgent_contact"
                        }else if mac_Num == 4 {
                            
                            typeStr = "identity_liveness"
                        }  else {
                            
                         
                            return
                        }
                        self?.tonestPageView(titleStr: typeStr)
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
    
    func tonestPageView(titleStr: String){
        if titleStr == "personal"{
            let vc = Mancry_AuthOneStepsVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleStr == "work_questionnaire"{
            let vc = Mancry_AuthTwoStepsVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if titleStr == "urgent_contact"{
            let vc = Mancry_AuthThreeStepsVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = Mancry_AuthFourStepsVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    @objc private func mancry_tipLabelTapped() {
        print("提示文字点击")
        
        if mancry_userStatus == 10{
            self.mancry_getAuthenticationStepsData()
        }else if (mancry_userStatus == 80 || mancry_userStatus == 81 || mancry_userStatus == 41 || mancry_userStatus == 30 || mancry_userStatus == 32 ){
            let vc = Mancry_HomeOrderListVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if self.mancry_userStatus == 51 && self.mancry_rejectUrl.count > 0{
            Mancry_uploadData.mancry_insertPointData(insertId: "500")
            let vc = Mancry_OpenUrlVC()
            vc.mancry_h5URL = self.mancry_rejectUrl
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
        
    }
    
    @objc private func mancry_topContainerViewTapped() {
        print("顶部视图点击")
        let meVc = Mancry_meViewController()
        self.navigationController?.pushViewController(meVc, animated: true)
        
    }
    
    @objc private func mancry_profileButtonTapped() {
        print("个人中心")
        // 跳转到个人中心
    }
    
    @objc private func mancry_bannerTapped() {
        print("Banner点击")
        // Banner点击事件
    }
    
    @objc private func mancry_orderHistoryButtonTapped() {
        print("订单历史")
        let vc = Mancry_HomeOrderListVC()
        vc.rejestUrl = self.mancry_rejectUrl
        self.navigationController?.pushViewController(vc, animated: true)
      
              
    }
    
    
    
    /// 获取首页基础配置（参考 Lorkusi 的 requestAppConfig）并串行后续接口
    func mac_getdototailbaseConfigData(mancry_type: String) {
        let mancry_parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: [:], isSign: false)
        guard let mancry_postData = try? JSONSerialization.data(withJSONObject: mancry_parametersDic) else { return }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/app/config",
            httpBody: mancry_postData,
            successCallBack: { [weak self] mancry_result in
                guard let self = self else { return }
                let mancry_code = mancry_result["resultCode"] as? Int ?? -1
                guard mancry_code == 200,
                      let mancry_dataDict = mancry_result["data"] as? [String: Any],
                      let mancry_dynamic = mancry_dataDict["dynamicParameter"] as? [String: Any] else {
                    let mancry_msg = mancry_result["resultMsg"] as? String ?? "Config request failed"
                    self.mac_centerToastViewwithMsg(msg: mancry_msg)
                    return
                }
                
                
                self.mancry_dynamicParameter = mancry_dynamic
                self.mancry_rejectUrl = mancry_dynamic["rejectH5"] as? String ?? ""
                mancry_homeNumCap = mancry_dataDict["retrieveMobileContact"] as? Int ?? 0
                mancry_onceTotal = mancry_dataDict["pushPerCount"] as? Int ?? 0
                mancry_Total = mancry_dataDict["pushMaxCount"] as? Int ?? 0
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.mancry_requestUserSuphome(source: mancry_type)
                }
                
                
            },
            failureCallBack: { [weak self] mancry_error in
                self?.mac_centerToastViewwithMsg(msg: "Config request failed, please try again")
                print("Config request error: \(mancry_error.localizedDescription)")
            }
        )
    }
    
    
    /// 请求用户首页信息（/app/v3/user/suphome），根据 userStatus 决定是否加载产品列表
    /// - Parameter source: 区分入口，例如 \"homeEnter\" / \"cellClick\"
    private func mancry_requestUserSuphome(source: String) {
        var mancry_bizData: [String: Any] = [:]
        mancry_bizData["source"] = source    // 区分入口，参考 Lorkusi 的 requestSupHome(source:)
        
        let mancry_parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: mancry_bizData, isSign: false)
        guard let mancry_postData = try? JSONSerialization.data(withJSONObject: mancry_parametersDic) else {
            if source == "cellClick" {
                mancry_finishProductClick()
            }
            return
        }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/user/suphome",
            httpBody: mancry_postData,
            successCallBack: { [weak self] mancry_result in
                guard let self = self else { return }
                let mancry_code = mancry_result["resultCode"] as? Int ?? -1
                guard mancry_code == 200,
                      let mancry_dataDict = mancry_result["data"] as? [String: Any] else {
                    let mancry_msg = mancry_result["resultMsg"] as? String ?? ""
                    if source == "cellClick" {
                        self.mancry_finishProductClick()
                    }
                    self.mac_centerToastViewwithMsg(msg: mancry_msg)
                    return
                }
                
                self.mancry_userStatus = mancry_dataDict["userStatus"] as? Int ?? 0
                self.withdrawnId = mancry_dataDict["withdrawalOrderId"] as? String ?? ""
                let withdrawDic = mancry_dataDict["orderStatusCount"] as? [String: Any]
                let withdrawalProId = withdrawDic?["productId"] as? String ?? ""
               if self.mancry_userStatus == 32 && source != "cellClick"{
                   mancry_tobeWithDrawnPopView(withdrawnId: withdrawnId,withdrawnProductId: withdrawalProId)
                }
                
                let alertTitleStr = mancry_dataDict["promptCopy"] as? String ?? ""

                if mancry_rejectUrl.count > 0 {
                    if (mancry_userStatus == 80 || mancry_userStatus == 81 || mancry_userStatus == 41 || mancry_userStatus == 30 || mancry_userStatus == 32 || mancry_userStatus == 10 || mancry_userStatus == 51){
                        mancry_updateTipLabel(text: alertTitleStr,imgStr: "flbeql_home_tsjt")
                    }else{
                        mancry_updateTipLabel(text: alertTitleStr,imgStr: "")
                    }
                } else {
                    if (mancry_userStatus == 80 || mancry_userStatus == 81 || mancry_userStatus == 41 || mancry_userStatus == 30 || mancry_userStatus == 32 || mancry_userStatus == 10){
                        mancry_updateTipLabel(text: alertTitleStr,imgStr: "flbeql_home_tsjt")
                    }else{
                        mancry_updateTipLabel(text: alertTitleStr,imgStr: "")
                    }
                }
                
               
                
                // 简单示例：userStatus != 10 视为可展示产品列表，否则展示无数据占位
                if self.mancry_userStatus != 10 {
                    self.macNoDataV.isHidden = true
                    self.mancry_tableView.isHidden = false
                    // cell 点击已有 loading，产品列表刷新不再重复弹 HUD
                    self.mancry_loadProductList(showsLoading: source != "cellClick")
                    
                } else {
                    self.mancry_productList.removeAll()
                    self.mancry_tableView.reloadData()
                    self.mancry_tableView.isHidden = true
                    self.macNoDataV.isHidden = false
                }
                
                if isMancryFirstup == false{
                    isMancryFirstup = true
                    mancry_touploadNewVersionData()
                }
                
                // 如果是 cell 点击触发的请求，再调用 termV3 获取该产品的期数等信息

                if source == "cellClick" {
                    self.mancry_requestProductTermV3(mancry_id: "")
                }
            },
            failureCallBack: { [weak self] mancry_error in
                if source == "cellClick" {
                    self?.mancry_finishProductClick()
                }
                self?.mac_centerToastViewwithMsg(msg: "Suphome request failed")
                print("Suphome request error: \(mancry_error.localizedDescription)")
            }
        )
    }
    
    func mancry_touploadNewVersionData(){
        let mancry_parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: [:], isSign: false)
        guard let mancry_postData = try? JSONSerialization.data(withJSONObject: mancry_parametersDic) else { return }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/app/versionV2",
            httpBody: mancry_postData,
            successCallBack: { [weak self] mancry_result in
                guard let self = self else { return }
                let mancry_code = mancry_result["resultCode"] as? Int ?? -1
                guard mancry_code == 200,
                      let mancry_dataDict = mancry_result["data"] as? [String: Any] else {
                    let mancry_msg = mancry_result["resultMsg"] as? String ?? ""
                    self.mac_centerToastViewwithMsg(msg: mancry_msg)
                    return
                }
                print("版本升级-\(mancry_result)")
              let mancry_typeStr = mancry_dataDict["updateType"] as? String ?? ""
                let mancry_uploadStr = mancry_dataDict["latestVersionUrl"] as? String ?? ""
                if mancry_typeStr == "1"{
                    let forceUpgradePopView = Mancry_PopView(type: .upgrade)
                    forceUpgradePopView.configure(
                        topImageName: "flbeql_tk_gx",
                        title: "Upgrade",
                        description: "New version found",
                        rightButtonTitle: "Upgrade"
                    )
                    forceUpgradePopView.onRightButtonTapped = {
                        // 处理升级逻辑，弹窗不会自动关闭
                        // 需要手动调用 forceUpgradePopView.dismiss() 来关闭
                        guard let url  = URL(string: mancry_uploadStr ) else { return  }
                        UIApplication.shared.open(url, options: [:])
                    }
                    forceUpgradePopView.show()
                }else if mancry_typeStr == "2"{
                    let forceUpgradePopView = Mancry_PopView(type: .forceUpgrade)
                    forceUpgradePopView.configure(
                        topImageName: "flbeql_tk_gx",
                        title: "Upgrade",
                        description: "New version found",
                        rightButtonTitle: "Upgrade"
                    )
                    forceUpgradePopView.onRightButtonTapped = {
                        // 处理升级逻辑，弹窗不会自动关闭
                        // 需要手动调用 forceUpgradePopView.dismiss() 来关闭
                        guard let url  = URL(string: mancry_uploadStr ) else { return  }
                        UIApplication.shared.open(url, options: [:])
                    }
                    forceUpgradePopView.show()
                }
                
             
                
                
            },
            failureCallBack: { [weak self] mancry_error in
                self?.mac_centerToastViewwithMsg(msg: "Config request failed, please try again")
                print("Config request error: \(mancry_error.localizedDescription)")
            }
        )
    }
    
    
    func mancry_tobeWithDrawnPopView(withdrawnId: String,withdrawnProductId: String){
        let cameraPopView = Mancry_PopView(type: .cameraPermission)
        cameraPopView.configure(
            topImageName: "flbeql_tk_dtx",
            title: "To Be withdrawn",
            description: "You have an order pending withdrawal. After entering the page to confirm, the funds will be transferred to your bank account immediately.",
            leftButtonTitle: "Cancel",
            rightButtonTitle: "Withdrawn"
        )
       
      
        cameraPopView.onRightButtonTapped = {
            Mancry_PopView.hide()
            let vc = Mancry_HomeWithDrawnVC()
            vc.mancry_orderId = withdrawnId
            vc.mancry_productId = withdrawnProductId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cameraPopView.show()
    }
    
    
    private func mancry_requestProductTermV3(mancry_id: String) {
        let productId = mancry_selectedProductId ?? ""
        
        let mancry_bizData: [String: Any] = [
            "productId": productId
        ]
        
        let mancry_parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: mancry_bizData, isSign: true)
        guard let mancry_postData = try? JSONSerialization.data(withJSONObject: mancry_parametersDic) else {
            mancry_finishProductClick()
            return
        }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/product/termV3",
            httpBody: mancry_postData,
            successCallBack: { [weak self] result in
                self?.mancry_finishProductClick()
                let mancry_code = result["resultCode"] as? Int ?? -1
                let mancry_msg = result["resultMsg"] as? String ?? ""
                let data = result["data"] as? [String: Any]
                if mancry_code == 200 {
                        let vc = Mancry_ApplyDetailVC()
                        vc.mancry_termV3Data = result
                        vc.mancry_productId = productId
                        self?.navigationController?.pushViewController(vc, animated: true)
                }else if mancry_code == 6230002 || mancry_code == 6230003{
                    
                    if self?.mancry_userStatus == 32{
                        let backPopView = Mancry_PopView(type: .cameraPermission)
                        backPopView.configure(
                            topImageName: "flbeql_tk_dtx",
                            title: "Tip.",
                            description: mancry_msg,
                            leftButtonTitle: "Back",
                            rightButtonTitle: "View More"
                        )
                        
                        backPopView.onRightButtonTapped = {
//                            let vc = Mancry_HomeOrderDetailsVC()
//                            vc.mancry_orderId = self?.withdrawnId ?? ""
//                            vc.mancry_productId = self?.mancry_selectedProductId ?? ""
                            let vc = Mancry_HomeWithDrawnVC()
                            vc.mancry_orderId = self?.withdrawnId ?? ""
                            vc.mancry_productId = self?.mancry_selectedProductId ?? ""
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                        backPopView.show()
                    }else{
                        let backPopView = Mancry_PopView(type: .cameraPermission)
                        backPopView.configure(
                            topImageName: "flbeql_tk_dtx",
                            title: "Tip.",
                            description: mancry_msg,
                            leftButtonTitle: "Back",
                            rightButtonTitle: "View More"
                        )
                        
                        backPopView.onRightButtonTapped = {
                            let vc = Mancry_HomeOrderDetailsVC()
                            vc.mancry_productId = self?.mancry_selectedProductId ?? ""
                            vc.mancry_orderId = "1"
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                        backPopView.show()
                    }
                    
                       
                    
                    
                } else if mancry_code == 6234303 {
                    if self?.mancry_userStatus == 51 && (self?.mancry_rejectUrl.count ?? 0) > 0 {
                        Mancry_uploadData.mancry_insertPointData(insertId: "500")
                        let vc = Mancry_OpenUrlVC()
                        vc.mancry_h5URL = self?.mancry_rejectUrl ?? ""
                        self?.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let msg = result["resultMsg"] as? String ?? "termV3 request failed"
                        self?.mac_centerToastViewwithMsg(msg: msg)
                    }
                
                }else{
                    let msg = result["resultMsg"] as? String ?? "termV3 request failed"
                    self?.mac_centerToastViewwithMsg(msg: msg)
                }
            },
            failureCallBack: { [weak self] mancry_error in
                self?.mancry_finishProductClick()
                self?.mac_centerToastViewwithMsg(msg: "termV3 request failed")
                print("termV3 request error: \(mancry_error.localizedDescription)")
            }
        )
    }
    
    
    
    // MARK: - Network
    
    private func mancry_finishProductClick() {
        mancry_productClickLocked = false
        mac_hiddenLoadingView()
    }
    
    private func mancry_loadProductList(showsLoading: Bool = true) {
        let mancry_parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: [:], isSign: false)
        
        guard let mancry_postData = try? JSONSerialization.data(withJSONObject: mancry_parametersDic) else { return }
        
        if showsLoading {
            self.mac_PopLoadingView()
        }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/product/list",
            httpBody: mancry_postData,
            successCallBack: { [weak self] result in
                if showsLoading {
                    self?.mac_hiddenLoadingView()
                }
                let code = result["resultCode"] as? Int ?? -1
                if code == 200 {
                    guard let dataDict = result["data"] as? [String: Any],
                          let productList = dataDict["productInfoList"] as? [[String: Any]] else {
                        return
                    }
                    self?.mancry_productList = productList
                    self?.mancry_tableView.reloadData()
                }
            },
            failureCallBack: { [weak self] error in
                if showsLoading {
                    self?.mac_hiddenLoadingView()
                }
                print("加载产品列表失败: \(error.localizedDescription)")
            }
        )
    }
}

// MARK: - UITableView Delegate & DataSource

extension Mancry_doTotalVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mancry_productList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Mancry_ProductCell", for: indexPath) as! Mancry_ProductCell
        let product = mancry_productList[indexPath.row]
        cell.mancry_configure(with: product)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard !mancry_productClickLocked else { return }
        
        let product = mancry_productList[indexPath.row]
        mancry_selectedProductId = product["productId"] as? String
        
        mancry_productClickLocked = true
        mac_PopLoadingView()
        mancry_requestUserSuphome(source: "cellClick")
    }
}

// MARK: - Product Cell

class Mancry_ProductCell: UITableViewCell {
    
    var mancry_applyButtonTapped: (() -> Void)?
    
    // 容器视图
    private lazy var mancry_containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    // 标签 ScrollView
    private lazy var mancry_tagScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    // 标签容器
    private lazy var mancry_tagContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    // 产品图标
    private lazy var mancry_productIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(hex: "#F5F5F5")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // 产品名称
    private lazy var mancry_productNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Product Name"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(hex: "#333333")
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    // 金额范围
    private lazy var mancry_amountLabel: UILabel = {
        let label = UILabel()
        label.text = "₱10,000-50,000"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(hex: "#333333")
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    // 利率
    private lazy var mancry_rateLabel: UILabel = {
        let label = UILabel()
        label.text = "0.08%"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#666666")
        return label
    }()
    
    // APPLY 按钮
    private lazy var mancry_applyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("APPLY", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(UIColor(hex: "#333333"), for: .normal)
        button.backgroundColor = UIColor(hex: "#CADC00")
        button.layer.cornerRadius = 8
        button.isUserInteractionEnabled = false
        
        return button
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
        mancry_containerView.addSubview(mancry_tagScrollView)
        mancry_tagScrollView.addSubview(mancry_tagContainerView)
        mancry_containerView.addSubview(mancry_productIconView)
        mancry_containerView.addSubview(mancry_productNameLabel)
        mancry_containerView.addSubview(mancry_amountLabel)
        mancry_containerView.addSubview(mancry_rateLabel)
        mancry_containerView.addSubview(mancry_applyButton)
        
        mancry_containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        // 标签 ScrollView 在最上面
        mancry_tagScrollView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(24)
        }
        
        mancry_tagContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        mancry_productIconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(mancry_tagScrollView.snp.bottom).offset(12)
            make.width.height.equalTo(40)
        }
        
        mancry_productNameLabel.snp.makeConstraints { make in
            make.left.equalTo(mancry_productIconView.snp.right).offset(12)
            make.top.equalTo(mancry_productIconView).offset(12)
            make.right.equalTo(mancry_amountLabel.snp.left).offset(-10)
            make.bottom.lessThanOrEqualTo(mancry_applyButton.snp.top).offset(-8)
        }
        
        mancry_amountLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mancry_productIconView)
        }
        
        mancry_rateLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mancry_amountLabel.snp.bottom).offset(4)
        }
        
        mancry_applyButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(44)
        }
    }
    
    func mancry_configure(with product: [String: Any]) {
        // 产品名称
        mancry_productNameLabel.text = product["productName"] as? String ?? "Product Name"
        
        // 金额范围：lowAmount - highAmount，前面拼接 ₱，并做千分位分割
        let mancry_lowAmountString = product["lowAmount"] as? String ?? ""
        let mancry_highAmountString = product["highAmount"] as? String ?? ""
        
        let mancry_amountFormatter: (String) -> String = { value in
            let clean = value.trimmingCharacters(in: .whitespaces)
            guard let number = Double(clean) else { return clean }
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            formatter.maximumFractionDigits = 0
            return formatter.string(from: NSNumber(value: number)) ?? clean
        }
        
        let mancry_lowFormatted = mancry_amountFormatter(mancry_lowAmountString)
        let mancry_highFormatted = mancry_amountFormatter(mancry_highAmountString)
        if !mancry_lowFormatted.isEmpty, !mancry_highFormatted.isEmpty {
            mancry_amountLabel.text = "₱\(mancry_lowFormatted)-₱\(mancry_highFormatted)"
        } else if !mancry_lowFormatted.isEmpty {
            mancry_amountLabel.text = "₱\(mancry_lowFormatted)"
        } else {
            mancry_amountLabel.text = "₱0"
        }
        
        // 利率：lowestLoanInterestRate * 100，加 %，保留 2 位小数
        let mancry_lowestRateString = product["lowestLoanInterestRate"] as? String ?? "0"
        let mancry_rateValue = Double(mancry_lowestRateString) ?? 0
        let mancry_ratePercent = mancry_rateValue * 100.0
        let mancry_rateText = String(format: "%.2f%%", mancry_ratePercent)
        mancry_rateLabel.text = mancry_rateText
        
//       let mancry_logoUrl = product["productLogo"] as? String
//        let url = URL(string: mancry_logoUrl),
//        mancry_productIconView.sd_setImage(with: url)
        // 设置产品图标：productLogo URL（此处简单占位，若集成 SDWebImage 可替换为网络加载）
        if let mancry_logoUrl = product["productLogo"] as? String, !mancry_logoUrl.isEmpty,
           let url = URL(string: mancry_logoUrl) {
            mancry_productIconView.sd_setImage(with: url)
            mancry_productIconView.backgroundColor = .clear
        } else {
            mancry_productIconView.image = nil
            mancry_productIconView.backgroundColor = UIColor(hex: "#F5F5F5")
        }
        
        // 动态创建标签：productLabel 字段转为数组
        mancry_createTags(from: product)
    }
    
    private func mancry_createTags(from product: [String: Any]) {
        // 清除旧标签
        mancry_tagContainerView.subviews.forEach { $0.removeFromSuperview() }
        
        // 获取标签数据
        var tags: [String] = []
        
        if let mancry_labelString = product["productLabel"] as? String {
            // 原始字段形如 \"a,b,c,\"，需要按逗号拆分并去空
            tags = mancry_labelString
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
        }
        
        if tags.isEmpty {
            // 默认标签（无数据时）
            tags = ["Quick Lending", "Low interest rate", "Loan Term", "High Quota"]
        }
        
        var lastTagView: UIView?
        
        for (index, tagText) in tags.enumerated() {
            let tagLabel = UILabel()
            tagLabel.text = tagText
            tagLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            tagLabel.textColor = UIColor(hex: "#777C61")
            tagLabel.backgroundColor = UIColor(hex: "#EDF1D8")
            tagLabel.textAlignment = .center
            tagLabel.layer.cornerRadius = 10
            tagLabel.clipsToBounds = true
            
            mancry_tagContainerView.addSubview(tagLabel)
            
            tagLabel.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.height.equalTo(24)
                
                if let lastTag = lastTagView {
                    make.left.equalTo(lastTag.snp.right).offset(8)
                } else {
                    make.left.equalToSuperview()
                }
                
                // 根据文字内容自适应宽度
                let width = tagText.size(withAttributes: [.font: UIFont.systemFont(ofSize: 11)]).width + 16
                make.width.equalTo(max(width, 60))
                
                // 最后一个标签
                if index == tags.count - 1 {
                    make.right.equalToSuperview()
                }
            }
            
            lastTagView = tagLabel
        }
    }
    
   
}
