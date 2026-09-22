
import UIKit
import SnapKit

class Mancry_MeSevenVC: Mac_BaseViewController {
    
    // MARK: - UI Components
    
    // 滚动视图
    private lazy var mancry_scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = UIColor(hex: "#EDF1D8")
        return scrollView
    }()
    
    // 内容容器
    private lazy var mancry_contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        return view
    }()
    
    // 白色卡片容器
    private lazy var mancry_cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    // 描述文字
    private lazy var mancry_descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#2C2F20")
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "CyCash unlocks convenient financial access, focusing on openness, quick responses and stable service for all users."  // 占位文字，可根据实际需求修改
        return label
    }()
    
    // 应用信息容器
    private lazy var mancry_appInfoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // 应用图标
    private lazy var mancry_appIconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bzkyc__logo")
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    // 应用名称
    private lazy var mancry_appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "CyCash"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(hex: "#2C2F20")
        return label
    }()
    
    // 版本号
    private lazy var mancry_versionLabel: UILabel = {
        let label = UILabel()
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        label.text = "V \(version)"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#777C61")
        return label
    }()
    
    // Delete Account按钮
    private lazy var mancry_deleteAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete Account", for: .normal)
        button.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(hex: "#DFE4C6")
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(mancry_deleteAccountTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mac_publiccustomnavView(title: "About")
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        
        view.addSubview(mancry_scrollView)
        mancry_scrollView.addSubview(mancry_contentView)
        
        mancry_contentView.addSubview(mancry_cardView)
        mancry_cardView.addSubview(mancry_descriptionLabel)
        mancry_cardView.addSubview(mancry_appInfoContainer)
        
        mancry_appInfoContainer.addSubview(mancry_appIconView)
        mancry_appInfoContainer.addSubview(mancry_appNameLabel)
        mancry_appInfoContainer.addSubview(mancry_versionLabel)
        
        view.addSubview(mancry_deleteAccountButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        mancry_scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(mancry_deleteAccountButton.snp.top).offset(-20)
        }
        
        mancry_contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        mancry_cardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        mancry_descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        mancry_appInfoContainer.snp.makeConstraints { make in
            make.top.equalTo(mancry_descriptionLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        
        mancry_appIconView.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(48)
        }
        
        mancry_appNameLabel.snp.makeConstraints { make in
            make.left.equalTo(mancry_appIconView.snp.right).offset(12)
            make.centerY.equalToSuperview().offset(0)
        }
        
        mancry_versionLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview().offset(0)
        }
        
        mancry_deleteAccountButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(56)
        }
    }
    
    // MARK: - Actions
    
    @objc private func mancry_deleteAccountTapped() {
        // TODO: 处理删除账户逻辑
       
        let deletePopView = Mancry_PopView(type: .cameraPermission)
        deletePopView.configure(
            topImageName: "flbeql_tk_ts",
            title: "Delete Account?",
            description: "When your loan order is under review and loan processing, you cannot cancel your account. When your loan order has not been settled, you cannot cancel your account. After confirming the cancellation, the account will not be restored. Please operate with caution.",
            leftButtonTitle: "Confirm",
            rightButtonTitle: "Cancel"
        )
        deletePopView.onLeftButtonTapped = {
            self.mancry_deleteData()
        }
      
        deletePopView.show()
        
        
    }
    
    
   func mancry_deleteData() {
        self.mac_PopLoadingView()
        let mancry_parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: [:], isSign: false)
        guard let mancry_postData = try? JSONSerialization.data(withJSONObject: mancry_parametersDic) else { return }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/auth/close",
            httpBody: mancry_postData,
            successCallBack: { [weak self] mancry_result in
                self?.mac_hiddenLoadingView()
                guard let self = self else { return }
                let mancry_code = mancry_result["resultCode"] as? Int ?? -1
             
                if mancry_code == 200{
                    mancry_deleteSuccess()
                }else{
                    mancry_deletefail()
                }
             
               
            },
            failureCallBack: { [weak self] mancry_error in
                self?.mac_hiddenLoadingView()
                
            }
        )
    }
    
    
    func mancry_deleteSuccess(){
        // 感谢反馈弹窗
        let thankYouPopView = Mancry_PopView(type: .thankYou)
        thankYouPopView.configure(
            topImageName: "flbeql_tk_cg",
            title: "Success!",
            description: "Account canceled successfully.",
            rightButtonTitle: "Confirm"
        )
        thankYouPopView.onRightButtonTapped = {
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
        thankYouPopView.show()
    }
    
    
    func mancry_deletefail(){
        let thankYouPopView = Mancry_PopView(type: .thankYou)
        thankYouPopView.configure(
            topImageName: "flbeql_tk_sb",
            title: "Failed!",
            description: "Account cancellation failed, please check your order.",
            rightButtonTitle: "Confirm"
        )
        thankYouPopView.onRightButtonTapped = {
            // Confirm 点击回调
        }
        thankYouPopView.show()
    }
    
    
}
