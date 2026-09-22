
import UIKit
import SnapKit
import Toast_Swift

/// 弹窗类型枚举
enum Mancry_PopViewType {
    case tip              // 第一张图：Tip弹窗
    case success          // 第二张图：成功结算弹窗
    case upgrade          // 第三张图：升级弹窗
    case forceUpgrade     // 强制更新弹窗
    case cameraPermission // 相机权限弹窗
    case thankYou         // 感谢反馈弹窗
    case rating           // 好评弹窗
    case verificationFailed // 验证失败（证件上传）
}

/// 通用弹窗视图
class Mancry_PopView: UIView {

    // MARK: - Properties
    private let type: Mancry_PopViewType
    private static weak var currentShownPopView: Mancry_PopView?
    private var containerView: UIView!
    private var backgroundMaskView: UIView!
    private var topBackgroundImageView: UIImageView!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var textBackgroundImageView: UIImageView?  // 仅用于升级弹窗
    private var closeButton: UIButton?                  // 仅用于成功弹窗
    private var leftButton: UIButton?
    private var rightButton: UIButton!
    private var amountLabel: UILabel?                   // 仅用于成功弹窗
    private var productIcon: UIImageView?
    private var productNameLabel: UILabel?              // 仅用于成功弹窗
    private var tipLabel: UILabel?                      // 仅用于Tip弹窗
    private var tipLabelBackgroundImageView: UIImageView?  // tipLabel的背景图片
    private var amountLabelBackgroundImageView: UIImageView?  // amountLabel的背景图片
    private var ratingButtons: [UIButton] = []  // 好评弹窗的心形图标按钮
    private var currentRating: Int = 0  // 当前选中的评分（1-5）
    private var verificationStatusImageView: UIImageView? // 验证失败弹窗中间状态图（整图）
    
    // MARK: - Callbacks
    var onLeftButtonTapped: (() -> Void)?
    var onRightButtonTapped: (() -> Void)?
    var onCloseTapped: (() -> Void)?
    
    // MARK: - Initialization
    init(type: Mancry_PopViewType) {
        self.type = type
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .clear
        
        // 遮罩层
        backgroundMaskView = UIView()
        backgroundMaskView.backgroundColor = .black
        backgroundMaskView.alpha = 0.8
        backgroundMaskView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(maskTapped))
        backgroundMaskView.addGestureRecognizer(tap)
        addSubview(backgroundMaskView)
        backgroundMaskView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 容器视图
        containerView = UIView()
        containerView.backgroundColor = UIColor(hex: "#EDF1D8")
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        addSubview(containerView)
        
        // 根据类型设置不同的UI
        switch type {
        case .tip:
            setupTipUI()
        case .success:
            setupSuccessUI()
        case .upgrade:
            setupUpgradeUI()
        case .forceUpgrade:
            setupForceUpgradeUI()
        case .cameraPermission:
            setupCameraPermissionUI()
        case .thankYou:
            setupThankYouUI()
        case .rating:
            setupRatingUI()
        case .verificationFailed:
            setupVerificationFailedUI()
        }
    }
    
    // MARK: - Tip UI (第一张图)
    private func setupTipUI() {
        // 顶部背景图片
        topBackgroundImageView = UIImageView()
        topBackgroundImageView.image = UIImage(named: "flbeql_tk_tip")
        topBackgroundImageView.contentMode = .scaleAspectFill
        topBackgroundImageView.clipsToBounds = true
        containerView.addSubview(topBackgroundImageView)
        
        // tipLabel的背景图片
        tipLabelBackgroundImageView = UIImageView()
        tipLabelBackgroundImageView?.image = UIImage(named: "flbeql_tk_btk")
        tipLabelBackgroundImageView?.contentMode = .scaleAspectFit
        tipLabelBackgroundImageView?.clipsToBounds = true
        containerView.addSubview(tipLabelBackgroundImageView!)
        
        // Tip标题文字（显示在背景图片上面）
        tipLabel = UILabel()
        tipLabel?.text = "Tip"
        tipLabel?.font = .boldSystemFont(ofSize: 16)
        tipLabel?.textColor = .white
        tipLabel?.textAlignment = .center
        containerView.addSubview(tipLabel!)
        
        // 描述文字
        descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = UIColor(hex: "#2C2F20")
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        containerView.addSubview(descriptionLabel)
        
        // 底部按钮容器
        let buttonContainer = UIView()
        containerView.addSubview(buttonContainer)
        
        // Back按钮
        leftButton = UIButton(type: .system)
        leftButton?.setTitle("Back", for: .normal)
        leftButton?.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        leftButton?.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        leftButton?.backgroundColor = UIColor(hex: "#DFE4C6")
        leftButton?.layer.cornerRadius = 22
        
        leftButton?.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        buttonContainer.addSubview(leftButton!)
        
        // View More按钮
        rightButton = UIButton(type: .system)
        rightButton.setTitle("View More", for: .normal)
        rightButton.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        rightButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        rightButton.backgroundColor = UIColor(hex: "#CEDF00")
        rightButton.layer.cornerRadius = 22
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        buttonContainer.addSubview(rightButton)
        
        // 布局
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(mancry_Width - 40)
            make.height.equalTo(320)
        }
        
        topBackgroundImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(120)
        }
        
        // tipLabel背景图片布局
        tipLabelBackgroundImageView?.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(80)
            make.height.equalTo(48)
        }
        
        // tipLabel显示在背景图片上面
        tipLabel?.snp.makeConstraints { make in
            make.center.equalTo(tipLabelBackgroundImageView!)
            make.left.right.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(topBackgroundImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        buttonContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(56)
        }
        
        leftButton?.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
        
        rightButton.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
    }
    
    // MARK: - Success UI (第二张图)
    private func setupSuccessUI() {
        // 顶部背景图片
        topBackgroundImageView = UIImageView()
        topBackgroundImageView.image = UIImage(named: "flbeql_tk_fj")
        topBackgroundImageView.contentMode = .scaleAspectFill
        topBackgroundImageView.clipsToBounds = true
        containerView.addSubview(topBackgroundImageView)
        
        // 右上角关闭按钮
        closeButton = UIButton(type: .custom)
        closeButton?.setImage(UIImage(named: "bzkyc_tk_gb"), for: .normal)
        closeButton?.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton?.isHidden = true  // 初始隐藏，延迟3秒后显示
        containerView.addSubview(closeButton!)
        
        // amountLabel的背景图片
        amountLabelBackgroundImageView = UIImageView()
        amountLabelBackgroundImageView?.image = UIImage(named: "flbeql_tk_btk")
        amountLabelBackgroundImageView?.contentMode = .scaleAspectFit
        amountLabelBackgroundImageView?.clipsToBounds = true
        containerView.addSubview(amountLabelBackgroundImageView!)
        
        // 金额文字（显示在背景图片上面）
        amountLabel = UILabel()
        amountLabel?.text = "₱10,000"  // 默认值，可通过配置方法修改
        amountLabel?.font = .boldSystemFont(ofSize: 20)
        amountLabel?.textColor = UIColor(hex: "#CEDF00")
        amountLabel?.textAlignment = .center
        containerView.addSubview(amountLabel!)
        
        // 产品信息容器
        let productContainer = UIView()
        containerView.addSubview(productContainer)
        
        productIcon = UIImageView()
        productIcon?.backgroundColor = UIColor(hex: "#CCCCCC")
        productIcon?.layer.cornerRadius = 8
        productContainer.addSubview(productIcon!)
        
        productNameLabel = UILabel()
        productNameLabel?.text = "Product Name"  // 默认值，可通过配置方法修改
        productNameLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        productNameLabel?.textColor = UIColor(hex: "#999999")
        productNameLabel?.textAlignment = .right
        productContainer.addSubview(productNameLabel!)
        
        // 描述文字
        descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = UIColor(hex: "#2C2F20")
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        containerView.addSubview(descriptionLabel)
        
        // Apply Now按钮
        rightButton = UIButton(type: .system)
        rightButton.setTitle("Apply Now", for: .normal)
        rightButton.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        rightButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        rightButton.backgroundColor = UIColor(hex: "#CEDF00")
        rightButton.layer.cornerRadius = 22
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        containerView.addSubview(rightButton)
        
        // 布局
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(mancry_Width - 40)
            make.height.equalTo(380)
        }
        
        topBackgroundImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(140)
        }
        
        closeButton?.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.width.height.equalTo(30)
        }
        
        // amountLabel背景图片布局
        amountLabelBackgroundImageView?.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(48)
        }
        
        // amountLabel显示在背景图片上面
        amountLabel?.snp.makeConstraints { make in
            make.center.equalTo(amountLabelBackgroundImageView!)
            make.left.right.equalToSuperview().inset(20)
        }
        
        productContainer.snp.makeConstraints { make in
            make.top.equalTo(topBackgroundImageView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        productIcon?.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        productNameLabel?.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(productContainer.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
        }
        
        rightButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(56)
        }
    }
    
    // MARK: - Upgrade UI (第三张图)
    private func setupUpgradeUI() {
        // 顶部背景图片
        topBackgroundImageView = UIImageView()
        topBackgroundImageView.image = UIImage(named: "flbeql_tk_gx")
        topBackgroundImageView.contentMode = .scaleAspectFill
        topBackgroundImageView.clipsToBounds = true
        containerView.addSubview(topBackgroundImageView)
        
        // 文字背景图片（作为titleLabel的背景）
        textBackgroundImageView = UIImageView()
        textBackgroundImageView?.image = UIImage(named: "flbeql_tk_btk")
        textBackgroundImageView?.contentMode = .scaleAspectFit
        textBackgroundImageView?.clipsToBounds = true
        containerView.addSubview(textBackgroundImageView!)
        
        // 标题文字（显示在textBackgroundImageView上面）
        titleLabel = UILabel()
        titleLabel.text = "Upgrade"  // 默认值，可通过配置方法修改
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        // 描述文字
        descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = UIColor(hex: "#2C2F20")
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = "New version found"  // 默认值，可通过配置方法修改
        containerView.addSubview(descriptionLabel)
        
        // 底部按钮容器
        let buttonContainer = UIView()
        containerView.addSubview(buttonContainer)
        
        // Cancel按钮
        leftButton = UIButton(type: .system)
        leftButton?.setTitle("Cancel", for: .normal)
        leftButton?.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        leftButton?.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        leftButton?.backgroundColor = UIColor(hex: "#DFE4C6")
        leftButton?.layer.cornerRadius = 22
        leftButton?.layer.borderWidth = 0
        leftButton?.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        buttonContainer.addSubview(leftButton!)
        
        // Upgrade按钮
        rightButton = UIButton(type: .system)
        rightButton.setTitle("Upgrade", for: .normal)
        rightButton.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        rightButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        rightButton.backgroundColor = UIColor(hex: "#CEDF00")
        rightButton.layer.cornerRadius = 22
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        buttonContainer.addSubview(rightButton)
        
        // 布局
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(mancry_Width - 40)
            make.height.equalTo(360)
        }
        
        topBackgroundImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(140)
        }
        
        // textBackgroundImageView 作为 titleLabel 的背景
        textBackgroundImageView?.snp.makeConstraints { make in
            make.top.equalTo(topBackgroundImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        // titleLabel 显示在 textBackgroundImageView 上面
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(textBackgroundImageView!)
            make.left.right.equalToSuperview().inset(40)
        }
        
        // 描述文字在 textBackgroundImageView 下方
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(textBackgroundImageView!.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(40)
        }
        
        buttonContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(56)
        }
        
        leftButton?.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
        
        rightButton.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
    }
    
    // MARK: - Force Upgrade UI (强制更新弹窗)
    private func setupForceUpgradeUI() {
        // 顶部背景图片
        topBackgroundImageView = UIImageView()
        topBackgroundImageView.image = UIImage(named: "flbeql_tk_gx")
        topBackgroundImageView.contentMode = .scaleAspectFill
        topBackgroundImageView.clipsToBounds = true
        containerView.addSubview(topBackgroundImageView)
        
        // 文字背景图片（作为titleLabel的背景）
        textBackgroundImageView = UIImageView()
        textBackgroundImageView?.image = UIImage(named: "flbeql_tk_btk")
        textBackgroundImageView?.contentMode = .scaleAspectFit
        textBackgroundImageView?.clipsToBounds = true
        containerView.addSubview(textBackgroundImageView!)
        
        // 标题文字（显示在textBackgroundImageView上面）
        titleLabel = UILabel()
        titleLabel.text = "Upgrade"  // 默认值，可通过配置方法修改
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        // 描述文字
        descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = UIColor(hex: "#2C2F20")
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = "New version found"  // 默认值，可通过配置方法修改
        containerView.addSubview(descriptionLabel)
        
        // Upgrade按钮（只显示一个按钮）
        rightButton = UIButton(type: .system)
        rightButton.setTitle("Upgrade", for: .normal)
        rightButton.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        rightButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        rightButton.backgroundColor = UIColor(hex: "#CEDF00")
        rightButton.layer.cornerRadius = 22
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        containerView.addSubview(rightButton)
        
        // 布局
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(mancry_Width - 40)
            make.height.equalTo(360)
        }
        
        topBackgroundImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(140)
        }
        
        // textBackgroundImageView 作为 titleLabel 的背景
        textBackgroundImageView?.snp.makeConstraints { make in
            make.top.equalTo(topBackgroundImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        // titleLabel 显示在 textBackgroundImageView 上面
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(textBackgroundImageView!)
            make.left.right.equalToSuperview().inset(40)
        }
        
        // 描述文字在 textBackgroundImageView 下方
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(textBackgroundImageView!.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(40)
        }
        
        // Upgrade按钮布局（全宽）
        rightButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(56)
        }
    }
    
    // MARK: - Camera Permission UI (相机权限弹窗)
    private func setupCameraPermissionUI() {
        // 顶部背景图片
        topBackgroundImageView = UIImageView()
        topBackgroundImageView.image = UIImage(named: "flbeql_tk_xj")
        topBackgroundImageView.contentMode = .scaleAspectFill
        topBackgroundImageView.clipsToBounds = true
        containerView.addSubview(topBackgroundImageView)
        
        // 标题背景图片
        textBackgroundImageView = UIImageView()
        textBackgroundImageView?.image = UIImage(named: "flbeql_tk_btk")
        textBackgroundImageView?.contentMode = .scaleAspectFit
        textBackgroundImageView?.clipsToBounds = true
        containerView.addSubview(textBackgroundImageView!)
        
        // 标题文字（显示在背景图片上面）
        titleLabel = UILabel()
        titleLabel.text = "Camera"  // 默认值，可通过配置方法修改
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        // 描述文字
        descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = UIColor(hex: "#2C2F20")
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = "相机权限二次弹窗文案"  // 默认值，可通过配置方法修改
        containerView.addSubview(descriptionLabel)
        
        // 底部按钮容器
        let buttonContainer = UIView()
        containerView.addSubview(buttonContainer)
        
        // Cancel按钮
        leftButton = UIButton(type: .system)
        leftButton?.setTitle("Cancel", for: .normal)
        leftButton?.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        leftButton?.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        leftButton?.backgroundColor = UIColor(hex: "#DFE4C6")
        leftButton?.layer.cornerRadius = 22
        leftButton?.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        buttonContainer.addSubview(leftButton!)
        
        // Confirm按钮
        rightButton = UIButton(type: .system)
        rightButton.setTitle("Confirm", for: .normal)
        rightButton.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        rightButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        rightButton.backgroundColor = UIColor(hex: "#CEDF00")
        rightButton.layer.cornerRadius = 22
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        buttonContainer.addSubview(rightButton)
        
        // 布局
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(mancry_Width - 40)
            // 高度由内容动态决定，不设置固定高度
        }
        
        topBackgroundImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(140)
        }
        
        // 标题背景图片布局
        textBackgroundImageView?.snp.makeConstraints { make in
            make.top.equalTo(topBackgroundImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        // 标题文字显示在背景图片上面
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(textBackgroundImageView!)
            make.left.right.equalToSuperview().inset(40)
        }
        
        // 描述文字在标题背景图片下方，根据内容自适应高度
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(textBackgroundImageView!.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(40)
        }
        
        buttonContainer.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(56)
        }
        
        leftButton?.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
        
        rightButton.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
    }
    
    // MARK: - Thank You UI (感谢反馈弹窗)
    private func setupThankYouUI() {
        // 顶部背景图片
        topBackgroundImageView = UIImageView()
        topBackgroundImageView.image = UIImage(named: "flbeql_tk_df")
        topBackgroundImageView.contentMode = .scaleAspectFill
        topBackgroundImageView.clipsToBounds = true
        containerView.addSubview(topBackgroundImageView)
        
        // 标题背景图片
        textBackgroundImageView = UIImageView()
        textBackgroundImageView?.image = UIImage(named: "flbeql_tk_btk")
        textBackgroundImageView?.contentMode = .scaleAspectFit
        textBackgroundImageView?.clipsToBounds = true
        containerView.addSubview(textBackgroundImageView!)
        
        // 标题文字（显示在背景图片上面）
        titleLabel = UILabel()
        titleLabel.text = "Thank"  // 默认值，可通过配置方法修改
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        // 描述文字
        descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = UIColor(hex: "#2C2F20")
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = "Thank you very much! We have received your valuable feedback."  // 默认值，可通过配置方法修改
        containerView.addSubview(descriptionLabel)
        
        // Confirm按钮（只显示一个按钮）
        rightButton = UIButton(type: .system)
        rightButton.setTitle("Confirm", for: .normal)
        rightButton.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        rightButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        rightButton.backgroundColor = UIColor(hex: "#CEDF00")
        rightButton.layer.cornerRadius = 22
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        containerView.addSubview(rightButton)
        
        // 布局
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(mancry_Width - 40)
            // 高度由内容动态决定，不设置固定高度
        }
        
        topBackgroundImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(140)
        }
        
        // 标题背景图片布局
        textBackgroundImageView?.snp.makeConstraints { make in
            make.top.equalTo(topBackgroundImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        // 标题文字显示在背景图片上面
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(textBackgroundImageView!)
            make.left.right.equalToSuperview().inset(40)
        }
        
        // 描述文字在标题背景图片下方，根据内容自适应高度
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(textBackgroundImageView!.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(40)
        }
        
        // Confirm按钮布局（全宽）
        rightButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(56)
        }
    }
    
    // MARK: - Verification Failed UI（验证失败）
    private func setupVerificationFailedUI() {
        topBackgroundImageView = UIImageView()
        topBackgroundImageView.image = UIImage(named: "flbeql_tk_tip")
        topBackgroundImageView.contentMode = .scaleAspectFill
        topBackgroundImageView.clipsToBounds = true
        containerView.addSubview(topBackgroundImageView)
        
        textBackgroundImageView = UIImageView()
        textBackgroundImageView?.image = UIImage(named: "flbeql_tk_btk")
        textBackgroundImageView?.contentMode = .scaleAspectFit
        textBackgroundImageView?.clipsToBounds = true
        containerView.addSubview(textBackgroundImageView!)
        
        titleLabel = UILabel()
        titleLabel.text = "Verification failed"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor.init(hex: "#CADC00")
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        containerView.addSubview(titleLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = UIColor(hex: "#2C2F20")
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = "Please upload the photo again."
        containerView.addSubview(descriptionLabel)
        
        let statusImageView = UIImageView()
        statusImageView.image = UIImage(named: "flbeql_sfzyl")
        statusImageView.contentMode = .scaleAspectFit
        statusImageView.clipsToBounds = true
        verificationStatusImageView = statusImageView
        containerView.addSubview(statusImageView)
        
        rightButton = UIButton(type: .system)
        rightButton.setTitle("Confirm", for: .normal)
        rightButton.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        rightButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        rightButton.backgroundColor = UIColor(hex: "#CEDF00")
        rightButton.layer.cornerRadius = 22
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        containerView.addSubview(rightButton)
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(mancry_Width - 40)
        }
        
        topBackgroundImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(120)
        }
        
        textBackgroundImageView?.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(110)
            make.height.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(textBackgroundImageView!)
            make.left.right.equalToSuperview().inset(24)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(topBackgroundImageView.snp.bottom).offset(60)
            make.left.right.equalToSuperview().inset(20)
        }
        
        statusImageView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(120)
        }
        
        rightButton.snp.makeConstraints { make in
            make.top.equalTo(statusImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(56)
        }
    }
    
    // MARK: - Rating UI (好评弹窗)
    private func setupRatingUI() {
        // 顶部背景图片
        topBackgroundImageView = UIImageView()
        topBackgroundImageView.image = UIImage(named: "flbeql_tk_hpyd")
        topBackgroundImageView.contentMode = .scaleAspectFill
        topBackgroundImageView.clipsToBounds = true
        containerView.addSubview(topBackgroundImageView)
        
        // 标题背景图片
        textBackgroundImageView = UIImageView()
        textBackgroundImageView?.image = UIImage(named: "flbeql_tk_btk")
        textBackgroundImageView?.contentMode = .scaleAspectFit
        textBackgroundImageView?.clipsToBounds = true
        containerView.addSubview(textBackgroundImageView!)
        
        // 标题文字（显示在背景图片上面）
        titleLabel = UILabel()
        titleLabel.text = "Support us!"  // 默认值，可通过配置方法修改
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        // 描述文字
        descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = UIColor(hex: "#2C2F20")
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = "If you like our app, please consider giving us a five-star rating, which would greatly support us!"  // 默认值，可通过配置方法修改
        containerView.addSubview(descriptionLabel)
        
        // 评分心形图标容器
        let ratingContainer = UIView()
        containerView.addSubview(ratingContainer)
        
        // 创建5个心形图标按钮
        ratingButtons = []
        for i in 1...5 {
            let heartButton = UIButton(type: .custom)
            heartButton.setImage(UIImage(named: "flbeql_tk_hpyd_n"), for: .normal)
            heartButton.tag = i
            heartButton.addTarget(self, action: #selector(ratingButtonTapped(_:)), for: .touchUpInside)
            ratingContainer.addSubview(heartButton)
            ratingButtons.append(heartButton)
        }
        
        // 底部按钮容器
        let buttonContainer = UIView()
        containerView.addSubview(buttonContainer)
        
        // Cancel按钮
        leftButton = UIButton(type: .system)
        leftButton?.setTitle("Cancel", for: .normal)
        leftButton?.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        leftButton?.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        leftButton?.backgroundColor = UIColor(hex: "#DFE4C6")
        leftButton?.layer.cornerRadius = 22
        leftButton?.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        buttonContainer.addSubview(leftButton!)
        
        // Submit按钮
        rightButton = UIButton(type: .system)
        rightButton.setTitle("Submit", for: .normal)
        rightButton.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        rightButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        rightButton.backgroundColor = UIColor(hex: "#CEDF00")
        rightButton.layer.cornerRadius = 22
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        buttonContainer.addSubview(rightButton)
        
        // 布局
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(mancry_Width - 40)
            // 高度由内容动态决定，不设置固定高度
        }
        
        topBackgroundImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(140)
        }
        
        // 标题背景图片布局
        textBackgroundImageView?.snp.makeConstraints { make in
            make.top.equalTo(topBackgroundImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        // 标题文字显示在背景图片上面
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(textBackgroundImageView!)
            make.left.right.equalToSuperview().inset(40)
        }
        
        // 描述文字在标题背景图片下方，根据内容自适应高度
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(textBackgroundImageView!.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(40)
        }
        
        // 评分容器布局
        ratingContainer.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(200)
        }
        
        // 心形图标按钮布局
        let heartSize: CGFloat = 32
        let spacing: CGFloat = 8
        let totalWidth = CGFloat(5) * heartSize + CGFloat(4) * spacing
        let startX = (200 - totalWidth) / 2
        
        for (index, button) in ratingButtons.enumerated() {
            button.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(startX + CGFloat(index) * (heartSize + spacing))
                make.centerY.equalToSuperview()
                make.width.height.equalTo(heartSize)
            }
        }
        
        // 底部按钮容器布局
        buttonContainer.snp.makeConstraints { make in
            make.top.equalTo(ratingContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(56)
        }
        
        leftButton?.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
        
        rightButton.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
    }
    
    // MARK: - Rating Actions
    @objc private func ratingButtonTapped(_ sender: UIButton) {
        let selectedRating = sender.tag
        currentRating = selectedRating
        
        // 更新所有心形图标的状态
        for (index, button) in ratingButtons.enumerated() {
            if index < selectedRating {
                button.setImage(UIImage(named: "flbeql_tk_hpyd_u"), for: .normal)
            } else {
                button.setImage(UIImage(named: "flbeql_tk_hpyd_n"), for: .normal)
            }
        }
    }
    
    // MARK: - Public Methods
    /// 配置弹窗内容（用于 Tip、Upgrade、ForceUpgrade、CameraPermission、ThankYou、Rating、VerificationFailed 弹窗）
    func configure(topImageName: String? = nil,
                   title: String? = nil,
                   description: String? = nil,
                   leftButtonTitle: String? = nil,
                   rightButtonTitle: String? = nil) {
        if let imageName = topImageName, let image = UIImage(named: imageName) {
            topBackgroundImageView.image = image
        }
        // Tip类型使用tipLabel，其他类型使用titleLabel
        if let title = title {
            if type == .tip {
                tipLabel?.text = title
            } else {
                titleLabel?.text = title
            }
        }
        if let description = description {
            descriptionLabel.text = description
        }
        if let leftTitle = leftButtonTitle {
            leftButton?.setTitle(leftTitle, for: .normal)
        }
        if let rightTitle = rightButtonTitle {
            rightButton.setTitle(rightTitle, for: .normal)
        }
    }
    
    /// 配置成功弹窗内容
    func configureSuccess(amount: String? = nil,
                          productName: String? = nil,
                          productLogo: String? = nil,
                          description: String? = nil) {
        if let amount = amount {
            amountLabel?.text = amount
        }
        if let productName = productName {
            productNameLabel?.text = productName
        }
        if let productLogo = productLogo{
            productIcon?.sd_setImage(with: URL(string: productLogo))
        }
        if let desc = description {
            descriptionLabel.text = desc
        }
    }
    
    /// 获取当前评分（仅用于Rating弹窗）
    func getCurrentRating() -> Int {
        return currentRating
    }
    
    /// 显示弹窗
    func show(in superView: UIView? = nil) {
        let targetView: UIView
        if let superView = superView {
            targetView = superView
        } else {
            // 获取当前窗口
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                targetView = window
            } else {
                targetView = UIView()
            }
        }
        frame = targetView.bounds
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        targetView.addSubview(self)
        Mancry_PopView.currentShownPopView = self
        
        // 初始状态
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        // 动画显示
        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
        
        // Success类型弹窗，closeButton延迟3秒显示
        if type == .success {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.closeButton?.isHidden = false
            }
        }
    }
    
    /// 隐藏弹窗（暴露给外部调用，特别是成功弹窗的Apply Now按钮）
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundMaskView.alpha = 0
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            self.removeFromSuperview()
            if Mancry_PopView.currentShownPopView === self {
                Mancry_PopView.currentShownPopView = nil
            }
        }
    }

    /// 类方法：隐藏当前显示的弹窗（若存在）
    @MainActor
    static func hide() {
        if let current = Mancry_PopView.currentShownPopView {
            current.dismiss()
            return
        }
        
        // 兜底：遍历所有窗口，隐藏残留的弹窗
        let windows: [UIWindow] = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
        
        for window in windows {
            for subview in window.subviews {
                if let popView = subview as? Mancry_PopView {
                    popView.dismiss()
                }
            }
        }
    }
    
    // MARK: - Actions
    @objc private func maskTapped() {
        // 强制更新弹窗不允许点击遮罩关闭
//        if type == .forceUpgrade {
//            return
//        }
//        dismiss()
//        onCloseTapped?()
    }
    
    @objc private func closeButtonTapped() {
        dismiss()
        onCloseTapped?()
    }
    
    @objc private func leftButtonTapped() {
        onLeftButtonTapped?()
        // Tip、Upgrade、CameraPermission和Rating弹窗点击左侧按钮时隐藏
        if type == .tip || type == .upgrade || type == .cameraPermission || type == .rating {
            dismiss()
        }
    }
    
    @objc private func rightButtonTapped() {
        // Rating弹窗需要非空判断
        if type == .rating {
            if currentRating == 0 {
                // 未选择评分，提示用户
                let centerPoint = CGPoint(x: containerView.frame.size.width / 2, y: containerView.frame.size.height / 2)
                containerView.makeToast("Please select a rating before clicking Confirm.", point: centerPoint, title: nil, image: nil, completion: nil)
                return
            }
            // 有评分，触发回调，不自动隐藏（在回调中处理隐藏）
            onRightButtonTapped?()
            return
        }
        
        onRightButtonTapped?()
        // 成功弹窗和强制更新弹窗点击按钮时不隐藏，其他类型隐藏
        if type != .success && type != .forceUpgrade {
            dismiss()
        }
    }
}
