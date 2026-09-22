
import UIKit
import SnapKit

class Mancry_MeFiveVC: Mac_BaseViewController {
    
    // MARK: - Properties
   public var mancry_emailAddress = ""  // 邮箱地址，可根据实际需求修改
    public var mancry_websiteUrl = ""  // 官网地址，可根据实际需求修改
    
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
    
    // 第一段说明文字
    private lazy var mancry_firstDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#2C2F20")
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "If you encounter any suspicious situations during the repayment process, please contact customer service via email first. We will promptly assist you to resolve any issues."
        return label
    }()
    
    // E-mail部分容器
    private lazy var mancry_emailContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // E-mail图标
    private lazy var mancry_emailIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbeql_contactus_email")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // E-mail标签
    private lazy var mancry_emailLabel: UILabel = {
        let label = UILabel()
        label.text = "E-mail"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(hex: "#2C2F20")
        return label
    }()
    
    // E-mail地址
    private lazy var mancry_emailAddressLabel: UILabel = {
        let label = UILabel()
        label.text = mancry_emailAddress
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#777C61")
        return label
    }()
    
    // E-mail COPY按钮
    private lazy var mancry_emailCopyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("COPY", for: .normal)
        button.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = UIColor(hex: "#EDF1D8")
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(mancry_copyEmailTapped), for: .touchUpInside)
        return button
    }()
    
    // 第二段说明文字
    private lazy var mancry_secondDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#2C2F20")
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "When making repayments, we kindly request you to first use the app to obtain the repayment link. In case the app is not accessible, you may also log in to our official website for repayment: [https://www.cycoretechnology.com]. Please note that if the repayment link used is different from the one displayed on the app or official website, it will be considered a repayment failure."
        return label
    }()
    
    // Website部分容器
    private lazy var mancry_websiteContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // Website图标
    private lazy var mancry_websiteIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbeql_contactus_website")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // Website标签
    private lazy var mancry_websiteLabel: UILabel = {
        let label = UILabel()
        label.text = "Website"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(hex: "#2C2F20")
        return label
    }()
    
    // Website地址
    private lazy var mancry_websiteUrlLabel: UILabel = {
        let label = UILabel()
        label.text = mancry_websiteUrl
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#777C61")
        return label
    }()
    
    // Website COPY按钮
    private lazy var mancry_websiteCopyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("COPY", for: .normal)
        button.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = UIColor(hex: "#EDF1D8")
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(mancry_copyWebsiteTapped), for: .touchUpInside)
        return button
    }()
    
    // 最后一段警告文字
    private lazy var mancry_warningLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#2C2F20")
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "If someone contacts you to split the total repayment amount into multiple payments, or sends you a repayment link that does not match what is displayed on the app or official website, please contact customer service for assistance. After verifying the situation, we will waive the service fee for you."
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mac_publiccustomnavView(title: "Repayment Instructions")
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        
        view.addSubview(mancry_scrollView)
        mancry_scrollView.addSubview(mancry_contentView)
        
        mancry_contentView.addSubview(mancry_cardView)
        
        // 卡片内容
        mancry_cardView.addSubview(mancry_firstDescriptionLabel)
        mancry_cardView.addSubview(mancry_emailContainer)
        mancry_cardView.addSubview(mancry_secondDescriptionLabel)
        mancry_cardView.addSubview(mancry_websiteContainer)
        mancry_cardView.addSubview(mancry_warningLabel)
        
        // E-mail部分
        mancry_emailContainer.addSubview(mancry_emailIcon)
        mancry_emailContainer.addSubview(mancry_emailLabel)
        mancry_emailContainer.addSubview(mancry_emailAddressLabel)
        mancry_emailContainer.addSubview(mancry_emailCopyButton)
        
        // Website部分
        mancry_websiteContainer.addSubview(mancry_websiteIcon)
        mancry_websiteContainer.addSubview(mancry_websiteLabel)
        mancry_websiteContainer.addSubview(mancry_websiteUrlLabel)
        mancry_websiteContainer.addSubview(mancry_websiteCopyButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        mancry_scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.left.right.bottom.equalToSuperview()
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
        
        // 第一段说明文字
        mancry_firstDescriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        // E-mail部分
        mancry_emailContainer.snp.makeConstraints { make in
            make.top.equalTo(mancry_firstDescriptionLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        mancry_emailIcon.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        mancry_emailLabel.snp.makeConstraints { make in
            make.left.equalTo(mancry_emailIcon.snp.right).offset(12)
            make.top.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        mancry_emailAddressLabel.snp.makeConstraints { make in
            make.left.equalTo(mancry_emailIcon.snp.right).offset(12)
            make.top.equalTo(mancry_emailLabel.snp.bottom).offset(8)
            make.right.equalToSuperview()
        }
        
        mancry_emailCopyButton.snp.makeConstraints { make in

            make.top.equalTo(mancry_emailAddressLabel.snp.bottom).offset(12)
            make.left.equalTo(mancry_websiteIcon.snp.right).offset(12)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(48)
            make.bottom.equalToSuperview()
        }
        
        // 第二段说明文字
        mancry_secondDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(mancry_emailContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        // Website部分
        mancry_websiteContainer.snp.makeConstraints { make in
            make.top.equalTo(mancry_secondDescriptionLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        mancry_websiteIcon.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        mancry_websiteLabel.snp.makeConstraints { make in
            make.left.equalTo(mancry_websiteIcon.snp.right).offset(12)
            make.top.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        mancry_websiteUrlLabel.snp.makeConstraints { make in
            make.left.equalTo(mancry_websiteIcon.snp.right).offset(12)
            make.top.equalTo(mancry_websiteLabel.snp.bottom).offset(8)
            make.right.equalToSuperview()
        }
        
        mancry_websiteCopyButton.snp.makeConstraints { make in
            make.top.equalTo(mancry_websiteUrlLabel.snp.bottom).offset(12)
            make.left.equalTo(mancry_websiteIcon.snp.right).offset(12)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(48)
            make.bottom.equalToSuperview()
        }
        
        // 警告文字
        mancry_warningLabel.snp.makeConstraints { make in
            make.top.equalTo(mancry_websiteContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    // MARK: - Actions
    
    @objc private func mancry_copyEmailTapped() {
        UIPasteboard.general.string = mancry_emailAddress
        mac_centerToastViewwithMsg(msg: "Email copied to clipboard")
    }
    
    @objc private func mancry_copyWebsiteTapped() {
        UIPasteboard.general.string = mancry_websiteUrl
        mac_centerToastViewwithMsg(msg: "Website address copied to clipboard")
    }
}
