

import UIKit
import SnapKit

class Mancry_meViewController: Mac_BaseViewController {
    
    // MARK: - Properties
    
    // 菜单数据
    private var mancry_menuList: [[String: Any]] = []
    
    // 用户信息
    private var mancry_userName: String = ""
    private var mancry_userPhone: String = ""
    
    private var mancry_emailStr = ""
    private var mancry_guanwangurlStr = ""

    // 背景图片
    private lazy var mancry_backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbeql_me_kbg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // TableView
    private lazy var mancry_tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = true
        tableView.layer.cornerRadius = 20
        tableView.clipsToBounds = true
        tableView.register(Mancry_MeHeaderCell.self, forCellReuseIdentifier: "Mancry_MeHeaderCell")
        tableView.register(Mancry_MeMenuCell.self, forCellReuseIdentifier: "Mancry_MeMenuCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        set_customnavView(title: "Me")
        mancry_setupMenuData()
        mancry_setupUI()
        mancry_setupConstraints()
        mancry_requestMeViewInfor()
        mac_getmebaseConfigData()
        
        
        let dummyViewControllers: [UIViewController] = [
            mancryse_VqKelmTraw(),
            mancryse_PxHubNexor(),
            mancryse_ZwMirCalyx(),
            mancryse_JtOvaSpinx(),
            mancryse_RyQuaDelph(),
            mancryse_BnWexFlora(),
            mancryse_SkYorPlume(),
            mancryse_HfCinVesper(),
            mancryse_UmDraSolix(),
            mancryse_LcNexThale()
        ]
        
        for vc in dummyViewControllers {
            if let provider = vc as? mancryse_NoiseProvider {
                _ = provider.mancryse_generateNoiseDescription()
            }
        }
    }
    func mac_getmebaseConfigData() {
        let mancry_parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: [:], isSign: false)
        guard let mancry_postData = try? JSONSerialization.data(withJSONObject: mancry_parametersDic) else { return }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/app/config",
            httpBody: mancry_postData,
            successCallBack: { [weak self] mancry_result in
                guard let self = self else { return }
                let mancry_code = mancry_result["resultCode"] as? Int ?? -1
                guard mancry_code == 200,
                      let mancry_dataDict = mancry_result["data"] as? [String: Any] else {
                    return
                }
                
                mancry_emailStr = mancry_dataDict["appEmail"] as? String ?? ""
                mancry_guanwangurlStr = mancry_dataDict["officialWebsiteUrl"] as? String ?? ""
            
                
            },
            failureCallBack: { [weak self] mancry_error in
                self?.mac_centerToastViewwithMsg(msg: "Config request failed, please try again")
                
            }
        )
    }
    
    private func mancry_requestMeViewInfor(){
        self.mac_PopLoadingView()
        let mancry_parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: [:], isSign: false)
        guard let mancry_postData = try? JSONSerialization.data(withJSONObject: mancry_parametersDic) else { return }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/user/info",
            httpBody: mancry_postData,
            successCallBack: { [weak self] mancry_result in
                self?.mac_hiddenLoadingView()
                guard let self = self else { return }
                let mancry_code = mancry_result["resultCode"] as? Int ?? -1
                guard mancry_code == 200,
                      let mancry_dataDict = mancry_result["data"] as? [String: Any] else {
                    return
                }
                
                // 提取 name 和 phone 字段
                if let name = mancry_dataDict["name"] as? String {
                    
                        self.mancry_userName = name.isEmpty ? "CyCash":name
                }
                
                if let phone = mancry_dataDict["phone"] as? String {
                    self.mancry_userPhone = phone
                    UserDefaults.standard.set(phone, forKey: "phoneNum")
                    UserDefaults.standard.synchronize()
                }
               
                // 刷新 tableView 以更新用户信息
                DispatchQueue.main.async {
                    self.mancry_tableView.reloadData()
                }
            },
            failureCallBack: { [weak self] mancry_error in
                self?.mac_hiddenLoadingView()
                
            }
        )
    }
    
    
    // MARK: - Setup
    
    private func mancry_setupMenuData() {
        mancry_menuList = [
            [
                "title": "Bank Account",
                "icon": "flbeql_me_bank",
                "type": "bank"
            ],
            [
                "title": "Feedback",
                "icon": "flbeql_me_feedback",
                "type": "feedback"
            ],
            [
                "title": "Official Website",
                "icon": "flbeql_me_gwfj",
                "type": "website"
            ],
            [
                "title": "Contact us",
                "icon": "flbeql_me_contactus",
                "type": "contact"
            ],
            [
                "title": "Repayment Instructions",
                "icon": "flbeql_me_hkxz",
                "type": "repayment"
            ],
            [
                "title": "Protocol",
                "icon": "flbeql_me_xy",
                "type": "protocol"
            ],
            [
                "title": "About",
                "icon": "flbeql_me_about",
                "type": "about"
            ],
            [
                "title": "Sign Out",
                "icon": "flbeql_me_signout",
                "type": "signout"
            ]
        ]
    }
    
    private func mancry_setupUI() {
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        view.addSubview(mancry_backgroundImageView)
        view.addSubview(mancry_tableView)
    }
    
    private func mancry_setupConstraints() {
        // TableView（左右间距20，允许滚动）
        mancry_tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(54)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        // 背景图片
        mancry_backgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(84)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
            
        }
    }
    
    private func set_customnavView(title: String) {
       
        let imgV = UIImageView(frame: CGRectMake(0, 0,mancry_Width , 250));
        imgV.image = UIImage(named: "flbeql_me_bg")
        imgV.contentMode = .scaleToFill
        self.view.addSubview(imgV)
        
        let navV = UIView(frame: CGRectMake(0, 0,mancry_Width , mancry_NavBarHeight))
        self.view.addSubview(navV)
        
        let backBtn = UIButton(frame: CGRectMake(0, mancry_stateHeight, 80, 44))
        backBtn.setImage(UIImage(named: "flbeql_fh"), for: .normal)
        backBtn.addTarget(self, action: #selector(backbtnAction), for: .touchUpInside)
        let titleLab = UILabel(frame: CGRectMake(mancry_Width/2 - 100, mancry_stateHeight, 200, 44))
        titleLab.text = title
        titleLab.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        titleLab.textAlignment = .center
        
        navV.addSubview(backBtn)
        navV.addSubview(titleLab)
      
    }
   
    @objc func backbtnAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Actions
    
    private func mancry_handleMenuAction(type: String) {
        switch type {
        case "bank":
            
            // 跳转到银行账户页面
            let oneVc = Mancry_MeOneVC()
            self.navigationController?.pushViewController(oneVc, animated: true)
        case "feedback":
            
            // 跳转到反馈页面
            let twoVc = Mancry_MeTwoVC()
            self.navigationController?.pushViewController(twoVc, animated: true)
        case "website":
        
            let threddVC = Mancry_MeThreeVC()
            threddVC.mancry_officialWebsite = "https://www.cycoretechnology.com"
            self.navigationController?.pushViewController(threddVC, animated: true)
        case "contact":
            print("Contact us")
            // 跳转到联系我们页面
            let webV = Mancry_WebViewController()
            webV.mancry_titleStr = "Contact us"
            webV.mancry_linkUrlStr = "https://cacy.cycoretechnology.com/cacy/contactUs.html"
            self.navigationController?.pushViewController(webV, animated: true)
            
        case "repayment":
            print("Repayment Instructions")
            // 跳转到还款说明页面
            let riVC = Mancry_MeFiveVC()
            riVC.mancry_websiteUrl = "https://www.cycoretechnology.com"
            riVC.mancry_emailAddress = "contact@cycoretechnology.com"
            self.navigationController?.pushViewController(riVC, animated: true)

        case "protocol":
            print("Protocol")
            // 跳转到协议页面
            let proVC = Mancry_MeSixVC()
            proVC.mancry_privacyPolicyUrl = "https://cacy.cycoretechnology.com/cacy/PrivacyPolicy.html"
            proVC.mancry_termsOfLoanUrl = "https://cacy.cycoretechnology.com/cacy/loanContract.html"
            self.navigationController?.pushViewController(proVC, animated: true)
        case "about":
            print("About")
            // 跳转到关于页面
            let aboutVc = Mancry_MeSevenVC()
            self.navigationController?.pushViewController(aboutVc, animated: true)
        case "signout":
            mancry_handleSignOut()
        default:
            break
        }
    }
    
    private func mancry_handleSignOut() {
        let cameraPopView = Mancry_PopView(type: .cameraPermission)
        cameraPopView.configure(
            topImageName: "flbeql_tk_ts",
            title: "Sign Out?",
            description: "Are you sure to sign out your account?",
            leftButtonTitle: "Confirm",
            rightButtonTitle: "Cancel"
        )
        cameraPopView.onLeftButtonTapped = {
            // 清除登录信息
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.removeObject(forKey: "userId")
            UserDefaults.standard.synchronize()
            
            // 跳转到登录页
            DispatchQueue.main.async {
                let loginVC = Mancry_LoginInVC()
                let nav = Mancry_NavigationController(rootViewController: loginVC)
                nav.modalPresentationStyle = .fullScreen
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = nav
                }
            }
        }
      
        cameraPopView.show()
        
        
        
       
    }
}

// MARK: - UITableView Delegate & DataSource

extension Mancry_meViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mancry_menuList.count + 1 // +1 是用户信息头部
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // 用户信息头部
            let cell = tableView.dequeueReusableCell(withIdentifier: "Mancry_MeHeaderCell", for: indexPath) as! Mancry_MeHeaderCell
            cell.mancry_configure(userName: mancry_userName, phoneNumber: mancry_userPhone)
            return cell
        } else {
            // 菜单项
            let cell = tableView.dequeueReusableCell(withIdentifier: "Mancry_MeMenuCell", for: indexPath) as! Mancry_MeMenuCell
            let menuItem = mancry_menuList[indexPath.row - 1]
            cell.mancry_configure(title: menuItem["title"] as? String ?? "", icon: menuItem["icon"] as? String ?? "")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 158 // 用户信息头部高度
        }
        return 58 // 菜单项高度48 + 间距10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row > 0 {
            let menuItem = mancry_menuList[indexPath.row - 1]
            if let type = menuItem["type"] as? String {
                mancry_handleMenuAction(type: type)
            }
        }
    }
}

// MARK: - Header Cell

class Mancry_MeHeaderCell: UITableViewCell {
    
    // 容器视图
    private lazy var mancry_containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    // 头像
    private lazy var mancry_avatarImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.backgroundColor = UIColor(hex: "#F5F5F5")
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "bzkyc__logo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // 用户名
    private lazy var mancry_userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(hex: "#333333")
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // 手机号
    private lazy var mancry_phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#777C61")
        label.textAlignment = .center
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
        mancry_containerView.addSubview(mancry_avatarImageView)
        mancry_containerView.addSubview(mancry_userNameLabel)
        mancry_containerView.addSubview(mancry_phoneLabel)
        
        mancry_containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        mancry_avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        mancry_userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(mancry_avatarImageView.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        mancry_phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(mancry_userNameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()

        }
    }
    
    func mancry_configure(userName: String, phoneNumber: String) {
        mancry_userNameLabel.text = userName
        mancry_phoneLabel.text = "+63 " + phoneNumber
    }
}

// MARK: - Menu Cell

class Mancry_MeMenuCell: UITableViewCell {
    
    // 容器视图
    private lazy var mancry_containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    // 图标
    private lazy var mancry_iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // 标题
    private lazy var mancry_titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(hex: "#333333")
        return label
    }()
    
    // 箭头
    private lazy var mancry_arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbeql_me_jt")
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
        mancry_containerView.addSubview(mancry_iconImageView)
        mancry_containerView.addSubview(mancry_titleLabel)
        mancry_containerView.addSubview(mancry_arrowImageView)
        
        // 容器视图：左右间距20，上下间距5（实现cell之间10的间距）
        mancry_containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(48)
        }
        
        mancry_iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        mancry_titleLabel.snp.makeConstraints { make in
            make.left.equalTo(mancry_iconImageView.snp.right).offset(16)
            make.centerY.equalToSuperview()
        }
        
        mancry_arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
    
    func mancry_configure(title: String, icon: String) {
        mancry_titleLabel.text = title
        mancry_iconImageView.image = UIImage(named: icon)
    }
}


