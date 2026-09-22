

import UIKit
import SnapKit
import AppTrackingTransparency
import AdSupport

class Mancry_LoginInVC: Mac_BaseViewController {
    
    // MARK: - Properties
    
    
    private let mancry_netAccessWatcher = Mancry_NetAccessWatcher()
    private var mancry_hasTriggeredAdjustTracking = false
    private var mancry_activeObserver: NSObjectProtocol?
    // 背景图片
    private lazy var mancry_backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbeql_dly_bg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Sign In 标题图片
    private lazy var mancry_signInImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbeql_dly_sign")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // 表单容器视图
    private lazy var mancry_formContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hex: "#BDC1AB")?.cgColor
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    // Mobile number 标签
    private lazy var mancry_mobileLabel: UILabel = {
        let label = UILabel()
        label.text = "Mobile number"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#666666")
        return label
    }()
    
    // 手机号输入容器
    private lazy var mancry_phoneContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#DFE4C6")
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    // 区号标签
    private lazy var mancry_countryCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "+63"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(hex: "#505D2A")
        return label
    }()
    
    // 手机号输入框
    private lazy var mancry_phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter mobile number"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = UIColor(hex: "#333333")
        textField.keyboardType = .numberPad
//        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        return textField
    }()
    
    // OTP 标签
    private lazy var mancry_otpLabel: UILabel = {
        let label = UILabel()
        label.text = "OTP"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#666666")
        return label
    }()
    
    // OTP 输入容器
    private lazy var mancry_otpContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#DFE4C6")
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    // OTP 输入框
    private lazy var mancry_otpTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Otp"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = UIColor(hex: "#333333")
        textField.keyboardType = .numberPad
        textField.delegate = self
        return textField
    }()
    
    // GET OTP 按钮
    private lazy var mancry_getOtpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("GET OTP", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(UIColor(hex: "#505D2A"), for: .normal)
        button.addTarget(self, action: #selector(mancry_getOtpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 倒计时相关
    private var mancry_countdownTimer: Timer?
    private var mancry_countdownSeconds = 60
    

    // Sign In 按钮
    private lazy var mancry_signInButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(UIColor(hex: "#CADC00"), for: .normal)
        button.backgroundColor = UIColor(hex: "#505D2A")
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(mancry_signInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 隐私协议复选框
    private lazy var mancry_agreementCheckbox: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "flbeql_fxk_u"), for: .selected)
        button.setImage(UIImage(named: "flbeql_fxk_n"), for: .normal)
        button.isSelected = true
        button.addTarget(self, action: #selector(mancry_checkboxTapped), for: .touchUpInside)
        return button
    }()
    
    // 隐私协议文本
    private lazy var mancry_agreementLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        
        let text = "I have read and accepted Privacy Policy and Service Agreement"
        let attributedString = NSMutableAttributedString(string: text)
        
        // 设置整体样式
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor(hex: "#666666") ?? .darkGray
        ], range: NSRange(location: 0, length: text.count))
        
        // Privacy Policy 下划线
        if let privacyRange = text.range(of: "Privacy Policy") {
            let nsRange = NSRange(privacyRange, in: text)
            attributedString.addAttributes([
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor(hex: "#333333") ?? .black
            ], range: nsRange)
        }
        
        // Service Agreement 下划线
        if let serviceRange = text.range(of: "Service Agreement") {
            let nsRange = NSRange(serviceRange, in: text)
            attributedString.addAttributes([
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor(hex: "#333333") ?? .black
            ], range: nsRange)
        }
        
        label.attributedText = attributedString
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(mancry_agreementLabelTapped(_:)))
        label.addGestureRecognizer(tap)
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mancry_setupUI()
        mancry_setupConstraints()
        
        // 获取配置信息
        mancry_requestConfig()
        // 网络就绪后再走 IDFA / Adjust 时机
        mancry_bindNetReadyForIDFA()
        
        mancry_warmLoginGateNoise()
    }
    
    deinit {
        mancry_countdownTimer?.invalidate()
        mancry_countdownTimer = nil
        mancry_netAccessWatcher.mancry_stopProbing()
        if let observer = mancry_activeObserver {
            NotificationCenter.default.removeObserver(observer)
            mancry_activeObserver = nil
        }
    }
    
    /// 监听网络首次可达 + App active，再请求 IDFA
    private func mancry_bindNetReadyForIDFA() {
        mancry_netAccessWatcher.mancry_onFirstReachable = { [weak self] in
            self?.mancry_attemptAdjustTrackingIfReady()
        }
        mancry_netAccessWatcher.mancry_startProbing()
        
        mancry_activeObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.mancry_attemptAdjustTrackingIfReady()
        }
    }
    
    
    private func mancry_attemptAdjustTrackingIfReady() {
        guard mancry_netAccessWatcher.mancry_isReachable else { return }
        guard !mancry_hasTriggeredAdjustTracking else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            guard !self.mancry_hasTriggeredAdjustTracking else { return }
            guard UIApplication.shared.applicationState == .active else { return }
            guard self.mancry_netAccessWatcher.mancry_isReachable else { return }
            
            self.mancry_hasTriggeredAdjustTracking = true
            self.mancry_tonestAdjustData()
        }
    }
    
    // MARK: - Setup UI
    
    private func mancry_setupUI() {
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        
        view.addSubview(mancry_backgroundImageView)
        view.addSubview(mancry_signInImageView)
        view.addSubview(mancry_formContainerView)
        
        mancry_formContainerView.addSubview(mancry_mobileLabel)
        mancry_formContainerView.addSubview(mancry_phoneContainerView)
        mancry_phoneContainerView.addSubview(mancry_countryCodeLabel)
        mancry_phoneContainerView.addSubview(mancry_phoneTextField)
        
        mancry_formContainerView.addSubview(mancry_otpLabel)
        mancry_formContainerView.addSubview(mancry_otpContainerView)
        mancry_otpContainerView.addSubview(mancry_otpTextField)
        mancry_otpContainerView.addSubview(mancry_getOtpButton)
        
        mancry_formContainerView.addSubview(mancry_signInButton)
        mancry_formContainerView.addSubview(mancry_agreementCheckbox)
        mancry_formContainerView.addSubview(mancry_agreementLabel)
    }
    
    private func mancry_setupConstraints() {
        
        // 背景图片
        mancry_backgroundImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(300)
        }
        
        // Sign In 标题图片
        mancry_signInImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        
        // 表单容器
        mancry_formContainerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mancry_signInImageView.snp.bottom).offset(40)
        }
        
        // Mobile number 标签
        mancry_mobileLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(20)
        }
        
        // 手机号输入容器
        mancry_phoneContainerView.snp.makeConstraints { make in
            make.top.equalTo(mancry_mobileLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        // 区号标签
        mancry_countryCodeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        // 手机号输入框
        mancry_phoneTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
        
        // OTP 标签
        mancry_otpLabel.snp.makeConstraints { make in
            make.top.equalTo(mancry_phoneContainerView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        // OTP 输入容器
        mancry_otpContainerView.snp.makeConstraints { make in
            make.top.equalTo(mancry_otpLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        // OTP 输入框
        mancry_otpTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.right.equalTo(mancry_getOtpButton.snp.left).offset(-8)
            make.height.equalTo(50)
        }
        
        // GET OTP 按钮
        mancry_getOtpButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
        }
        
        // Sign In 按钮
        mancry_signInButton.snp.makeConstraints { make in
            make.top.equalTo(mancry_otpContainerView.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        // 隐私协议复选框
        mancry_agreementCheckbox.snp.makeConstraints { make in
            make.top.equalTo(mancry_signInButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-24)
        }
        
        // 隐私协议文本
        mancry_agreementLabel.snp.makeConstraints { make in
            make.left.equalTo(mancry_agreementCheckbox.snp.right).offset(8)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(mancry_agreementCheckbox)
        }
    }
    
    // MARK: - Actions
    
    /// 手机号门禁：返回错误文案；nil 表示通过（结构差异化，逻辑不变）
    private func mancry_loginPhoneGate(_ phone: String?) -> String? {
        guard let phone = phone, !phone.isEmpty else {
            return "Please enter mobile number"
        }
        if phone.hasPrefix("0") {
            guard phone.count == 11, phone.allSatisfy({ $0.isNumber }) else {
                return "Please enter the correct mobile number"
            }
        } else {
            guard phone.count == 10, phone.allSatisfy({ $0.isNumber }) else {
                return "Please enter the correct mobile number"
            }
        }
        return nil
    }
    
    /// OTP 门禁：返回错误文案；nil 表示通过
    private func mancry_loginOtpGate(_ otp: String?) -> String? {
        guard let otp = otp, !otp.isEmpty else {
            return "Please enter verification code"
        }
        guard otp.count == 6, otp.allSatisfy({ $0.isNumber }) else {
            return "Please enter a valid verification code"
        }
        return nil
    }
    
    /// 获取验证码前的手机号校验：9 开头 10 位，或 09 开头 11 位
    private func mancry_otpRequestPhoneGate(_ phone: String?) -> String? {
        let raw = (phone ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if raw.isEmpty {
            return "Please enter mobile number"
        }
        let digitsOnly = raw.allSatisfy { $0.isNumber }
        let startsWith09 = raw.hasPrefix("09") && raw.count == 11
        let startsWith9 = raw.hasPrefix("9") && raw.count == 10
        if digitsOnly && (startsWith09 || startsWith9) {
            return nil
        }
        return "Please enter the correct mobile number"
    }
    
    @objc private func mancry_getOtpButtonTapped() {
        if let tip = mancry_otpRequestPhoneGate(mancry_phoneTextField.text) {
            mac_centerToastViewwithMsg(msg: tip)
            return
        }
        mancry_requestOTP()
    }
    
    @objc private func mancry_signInButtonTapped() {
        if let tip = mancry_otpRequestPhoneGate(mancry_phoneTextField.text) {
            mac_centerToastViewwithMsg(msg: tip)
            return
        }
        
        
        if let tip = mancry_loginPhoneGate(mancry_phoneTextField.text) {
            mac_centerToastViewwithMsg(msg: tip)
            return
        }
        if let tip = mancry_loginOtpGate(mancry_otpTextField.text) {
            mac_centerToastViewwithMsg(msg: tip)
            return
        }
        guard mancry_agreementCheckbox.isSelected else {
            mac_centerToastViewwithMsg(msg: "Please agree to Privacy Policy and Service Agreement")
            return
        }
        mancry_requestLogin()
    }
    
    @objc private func mancry_checkboxTapped() {
        mancry_agreementCheckbox.isSelected = !mancry_agreementCheckbox.isSelected
    }
    
    @objc private func mancry_agreementLabelTapped(_ gesture: UITapGestureRecognizer) {
        guard let text = mancry_agreementLabel.text else { return }
        
        let location = gesture.location(in: mancry_agreementLabel)
        let textStorage = NSTextStorage(attributedString: mancry_agreementLabel.attributedText!)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: mancry_agreementLabel.bounds.size)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = mancry_agreementLabel.numberOfLines
        textContainer.lineBreakMode = mancry_agreementLabel.lineBreakMode
        
        let characterIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // 检查点击的是哪个链接
        if let privacyRange = text.range(of: "Privacy Policy") {
            let nsRange = NSRange(privacyRange, in: text)
            if NSLocationInRange(characterIndex, nsRange) {
                mancry_openPrivacyPolicy()
                return
            }
        }
        
        if let serviceRange = text.range(of: "Service Agreement") {
            let nsRange = NSRange(serviceRange, in: text)
            if NSLocationInRange(characterIndex, nsRange) {
                mancry_openServiceAgreement()
                return
            }
        }
    }
    
    // MARK: - Network Requests
    
    /// 获取配置信息
    private func mancry_requestConfig() {
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: [:])
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else { return }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/app/config",
            httpBody: postData,
            successCallBack: { [weak self] result in
                
                // IDFA 改为「网络可达后再请求」，不再在配置回调里直接调
            },
            failureCallBack: { error in
                print("Config request failed: \(error.localizedDescription)")
            }
        )
    }
    
    
    
    /// 网络就绪后请求追踪授权并读取 IDFA（逻辑与 figures.getIDFA 等价，写法差异化）
    func mancry_tonestAdjustData() {
        mancry_resolveIDFAString { idfa in
            if idfa.isEmpty {
                print("mancry ATT/IDFA unavailable")
            } else {
                print("mancry login IDFA: \(idfa)")
            }
        }
    }
    
    private func mancry_resolveIDFAString(done: @escaping (String) -> Void) {
        guard UIApplication.shared.applicationState == .active else {
            done("")
            return
        }
        
        if #available(iOS 14, *) {
            switch ATTrackingManager.trackingAuthorizationStatus {
            case .authorized:
                done(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
            case .notDetermined:
                ATTrackingManager.requestTrackingAuthorization { next in
                    DispatchQueue.main.async {
                        if next == .authorized {
                            done(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
                        } else {
                            done("")
                        }
                    }
                }
            case .denied, .restricted:
                done("")
            @unknown default:
                done("")
            }
        } else {
            done(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
        }
    }
    /// 获取验证码
    private func mancry_requestOTP() {
        let phone = mancry_phoneTextField.text ?? ""
        let fullPhone = phone
        
        let requestData: [String: Any] = [
            "mobile": fullPhone,
            "verifyType": "1"
        ]
        
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: requestData, isSign: true)
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else {
            mac_centerToastViewwithMsg(msg: "Request failed")
            return
        }
        
        self.mac_PopLoadingView()
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/sms/sendVerifySms",
            httpBody: postData,
            successCallBack: { [weak self] result in
                self?.mac_hiddenLoadingView()
                let code = result["resultCode"] as? Int ?? -1
                if code == 200 {
                    self?.mac_centerToastViewwithMsg(msg: "OTP has been sent")
                   
                } else {
                    let message = result["resultMsg"] as? String ?? ""
                    self?.mac_centerToastViewwithMsg(msg: message)
                }
                self?.mancry_startCountdown()
            },
            failureCallBack: { [weak self] error in
                self?.mac_hiddenLoadingView()
                self?.mac_centerToastViewwithMsg(msg: "Network error, please try again")
            }
        )
    }
    
    /// 登录或注册
    private func mancry_requestLogin() {
        let phone = mancry_phoneTextField.text ?? ""
        let fullPhone = phone
        let otp = mancry_otpTextField.text ?? ""
        
        let requestData: [String: Any] = [
            "mobile": fullPhone,
            "verifyCode": otp,
            "longitude": "-360",
            "latitude": "-360",
            "imei": "",
            "serialNo": mancry_deviceId
        ]
        
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: requestData, isSign: true)
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else {
            mac_centerToastViewwithMsg(msg: "Request failed")
            return
        }
        
        self.mac_PopLoadingView()
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/auth/registerOrLogin",
            httpBody: postData,
            successCallBack: { [weak self] result in
                let code = result["resultCode"] as? Int ?? -1
                if code == 200 {
                    guard let dataDict = result["data"] as? [String: Any],
                          let token = dataDict["token"] as? String,
                          let userId = dataDict["userId"] as? String else {
                        self?.mac_hiddenLoadingView()
                        self?.mac_centerToastViewwithMsg(msg: "Login failed, please try again")
                        return
                    }
                    
                    // 保存登录信息
                    UserDefaults.standard.set(token, forKey: "token")
                    UserDefaults.standard.set(userId, forKey: "userId")
                    UserDefaults.standard.synchronize()
                    // 登录成功后注册设备
                    self?.mancry_registerDevice()
                    self?.mancry_navigateToHome()
                } else {
                    self?.mac_hiddenLoadingView()
                    let message = result["resultMsg"] as? String ?? "Login failed, please try again"
                    self?.mac_centerToastViewwithMsg(msg: message)
                }
            },
            failureCallBack: { [weak self] error in
                self?.mac_hiddenLoadingView()
                self?.mac_centerToastViewwithMsg(msg: "Network error, please try again")
            }
        )
    }
    
    /// 注册设备
    private func mancry_registerDevice() {
        let registerDic = Mancry_getDevicebaseData.mancry_getResgiterData()
        
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: registerDic as? [String : Any],isSign: false)
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else {
            self.mac_hiddenLoadingView()
            self.mancry_navigateToHome()
            return
        }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/mobile/registerDevice",
            httpBody: postData,
            successCallBack: { [weak self] result in
                self?.mac_hiddenLoadingView()
                let code = result["resultCode"] as? Int ?? -1
                if code == 200 {
                    print("抓取设备信息成功")
                  
                }
                    
               
                
            },
            failureCallBack: { [weak self] error in
                self?.mac_hiddenLoadingView()
                

            }
        )
    }
    
   
    
    // MARK: - Countdown Timer
    
    /// 开始倒计时
    private func mancry_startCountdown() {
        mancry_countdownSeconds = 60
        mancry_getOtpButton.isEnabled = false
        mancry_updateCountdownButton()
        
        mancry_countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            self.mancry_countdownSeconds -= 1
            
            if self.mancry_countdownSeconds <= 0 {
                self.mancry_stopCountdown()
            } else {
                self.mancry_updateCountdownButton()
            }
        }
    }
    
    /// 更新倒计时按钮
    private func mancry_updateCountdownButton() {
        mancry_getOtpButton.setTitle("\(mancry_countdownSeconds)s", for: .normal)
        mancry_getOtpButton.setTitleColor(UIColor(hex: "#999999"), for: .normal)
    }
    
    /// 停止倒计时
    private func mancry_stopCountdown() {
        mancry_countdownTimer?.invalidate()
        mancry_countdownTimer = nil
        mancry_getOtpButton.isEnabled = true
        mancry_getOtpButton.setTitle("Reacquire", for: .normal)
        mancry_getOtpButton.setTitleColor(UIColor(hex: "#333333"), for: .normal)
    }
    
    // MARK: - Navigation
    
    private func mancry_navigateToHome() {
        // 跳转到主页逻辑
        DispatchQueue.main.async {
            
            let rootVc = Mancry_NavigationController(rootViewController: Mancry_doTotalVC())
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = rootVc
            } else if let delegate = UIApplication.shared.delegate,
                      let window = delegate.window,
                      let mainWindow = window {
                mainWindow.rootViewController = rootVc
            }
        }
    }
    
    private func mancry_openPrivacyPolicy() {
        
        let webV = Mancry_WebViewController()
        webV.mancry_titleStr = "Privacy Policy"
        webV.mancry_linkUrlStr = "https://cacy.cycoretechnology.com/cacy/PrivacyPolicy.html"
        self.navigationController?.pushViewController(webV, animated: true)
        
    }
    
    private func mancry_openServiceAgreement() {
        
        let webV = Mancry_WebViewController()
        webV.mancry_titleStr = "Service Agreement"
        webV.mancry_linkUrlStr = "https://cacy.cycoretechnology.com/cacy/ServiceAgreement.html"
        self.navigationController?.pushViewController(webV, animated: true)
    }
    
    // MARK: - Binary noise (Login: BKDR + 弧形 ShapeLayer，异于 MeOne SDBM / Auth DJB2)
    
    private var mancry_loginNoiseTag: String = ""
    private var mancry_loginNoiseArc: CAShapeLayer?
    
    private func mancry_warmLoginGateNoise() {
        let seed = Mancry_LoginGateNoiseVault.mancry_bkdr("login-gate-otp-arc")
        mancry_loginNoiseTag = Mancry_LoginGateNoiseVault.mancry_gateStamp(seed)
        let spokes = Mancry_LoginGateNoiseVault.mancry_otpSpokes(count: 7, radius: 0.42)
        mancry_loginNoiseAttachArc(spokes: spokes)
        mancry_loginNoiseFlickerArc()
        mancry_loginNoiseSidecar(seed: seed, spokes: spokes)
        mancry_loginNoiseBitScramble(seed: seed)
    }
    
    private func mancry_loginNoiseAttachArc(spokes: [CGPoint]) {
        guard mancry_loginNoiseArc == nil else { return }
        let arc = CAShapeLayer()
        arc.frame = CGRect(x: -6100, y: -6100, width: 96, height: 96)
        arc.fillColor = UIColor.clear.cgColor
        arc.strokeColor = UIColor(white: 0.72, alpha: 0.15).cgColor
        arc.lineWidth = 1.2
        arc.opacity = 0.03
        
        let path = UIBezierPath()
        if let first = spokes.first {
            path.move(to: CGPoint(x: 48 + first.x * 40, y: 48 + first.y * 40))
            for p in spokes.dropFirst() {
                path.addLine(to: CGPoint(x: 48 + p.x * 40, y: 48 + p.y * 40))
            }
            path.close()
        }
        arc.path = path.cgPath
        view.layer.addSublayer(arc)
        mancry_loginNoiseArc = arc
    }
    
    private func mancry_loginNoiseFlickerArc() {
        guard let arc = mancry_loginNoiseArc else { return }
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.fromValue = 0.92
        anim.toValue = 1.0
        anim.duration = 0.18
        anim.autoreverses = true
        anim.isRemovedOnCompletion = true
        arc.add(anim, forKey: "mancry.login.noise.stroke")
    }
    
    private func mancry_loginNoiseSidecar(seed: UInt32, spokes: [CGPoint]) {
        let energy = spokes.reduce(CGFloat(0)) { $0 + abs($1.x) + abs($1.y) }
        let ghost = UIView(frame: CGRect(x: -6200, y: -6200, width: 12, height: 12))
        ghost.isHidden = true
        ghost.alpha = 0
        ghost.isUserInteractionEnabled = false
        ghost.layer.cornerRadius = 3
        ghost.layer.borderWidth = 0.4
        ghost.layer.borderColor = UIColor(white: 0.75, alpha: 0.18).cgColor
        view.addSubview(ghost)
        ghost.transform = CGAffineTransform(rotationAngle: 0.02)
        ghost.transform = .identity
        ghost.removeFromSuperview()
        _ = ["tag": mancry_loginNoiseTag, "seed": seed, "energy": Double(energy)] as [String: Any]
    }
    
    private func mancry_loginNoiseBitScramble(seed: UInt32) {
        var lane = seed
        var tape = [UInt8]()
        tape.reserveCapacity(8)
        for _ in 0..<8 {
            lane = lane &* 1664525 &+ 1013904223
            tape.append(UInt8(truncatingIfNeeded: lane &>> 24))
        }
        let folded = tape.reduce(0) { ($0 &<< 1) ^ Int($1) }
        let glyph = Mancry_LoginGateNoiseVault.mancry_foldGlyph(folded)
        _ = glyph.count + Int(seed & 0xFF)
    }
}

/// Login 噪声金库：BKDR + OTP 辐条点（异于 MeOne SDBM / Auth DJB2/FNV/Adler/XOR）
private enum Mancry_LoginGateNoiseVault {
    static func mancry_bkdr(_ text: String) -> UInt32 {
        var hash: UInt32 = 0
        let seed: UInt32 = 131
        for b in text.utf8 {
            hash = hash &* seed &+ UInt32(b)
        }
        return hash
    }
    
    static func mancry_gateStamp(_ value: UInt32) -> String {
        String(format: "lg-%06x", value & 0xFFFFFF)
    }
    
    static func mancry_otpSpokes(count: Int, radius: CGFloat) -> [CGPoint] {
        let n = max(3, count)
        let r = max(CGFloat(0.1), radius)
        var points: [CGPoint] = []
        points.reserveCapacity(n)
        for i in 0..<n {
            let theta = CGFloat(i) / CGFloat(n) * CGFloat.pi * 2 + 0.17
            let x = cos(theta) * r
            let y = sin(theta) * r * 0.86
            points.append(CGPoint(x: x, y: y))
        }
        return points
    }
    
    static func mancry_foldGlyph(_ value: Int) -> String {
        let masked = abs(value) % 9973
        return String(format: "otp#%04d", masked)
    }
}

// MARK: - UITextField Delegate

extension Mancry_LoginInVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     
        // 获取当前文本
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // 处理手机号输入框
        if textField == mancry_phoneTextField {
            
            
            let mancry_filter = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            
            if mancry_filter != string {
                
                let currentText = textField.text ?? ""
                let newText = (currentText as NSString).replacingCharacters(in: range, with: mancry_filter)
            
                let maxLength: Int
                if newText.hasPrefix("0") {
                    maxLength = 11
                } else {
                    maxLength = 10
                }
                if newText.count <= maxLength {
                    textField.text = newText
                }
                return false
            }
            
            
            
            // 如果是0开头，限制11位
            if updatedText.hasPrefix("0") {
                return updatedText.count <= 11
            } else {
                // 非0开头，限制10位
                return updatedText.count <= 10
            }
        }
        
        // 处理OTP输入框：只保留数字，最多 6 位
        if textField == mancry_otpTextField {
            let filtered = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            let current = textField.text ?? ""
            let merged = (current as NSString).replacingCharacters(in: range, with: filtered)
            let limited = String(merged.prefix(6))
            if textField.text != limited {
                textField.text = limited
            }
            return false
        }
        
        return true
    }
}

// MARK: - UIColor Extension

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        let length = hexSanitized.count
        let r, g, b, a: CGFloat
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            a = 1.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
