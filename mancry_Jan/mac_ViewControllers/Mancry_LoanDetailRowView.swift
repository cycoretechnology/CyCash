import UIKit
import SnapKit

/// 贷款详情单行（ScrollView 内使用，整行可点出说明）
class Mancry_LoanDetailRowView: UIView {
    
    var onInfoButtonTapped: ((Int) -> Void)?
    private(set) var rowIndex: Int = 0
    private(set) var showsInfo: Bool = false
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(hex: "#666666")
        label.numberOfLines = 1
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private lazy var infoIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbeql_loan_sm")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(hex: "#2C2F20")
        label.textAlignment = .right
        label.numberOfLines = 1
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbysw_order_jt")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    /// 覆盖标题+图标区域的透明热区，保证一定能点到
    private lazy var infoHitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.isHidden = true
        button.addTarget(self, action: #selector(infoHitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var arrowImageViewWidthConstraint: Constraint?
    private var infoIconWidthConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        isUserInteractionEnabled = true
        
        addSubview(titleLabel)
        addSubview(infoIconView)
        addSubview(valueLabel)
        addSubview(arrowImageView)
        addSubview(infoHitButton)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        infoIconView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(6)
            make.centerY.equalToSuperview()
            infoIconWidthConstraint = make.width.equalTo(0).constraint
            make.height.equalTo(18)
        }
        
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            arrowImageViewWidthConstraint = make.width.equalTo(0).constraint
            make.height.equalTo(20)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(arrowImageView.snp.left).offset(-8)
            make.left.greaterThanOrEqualTo(infoIconView.snp.right).offset(8)
        }
        
        // 热区：从左边到 value 之前，足够大
        infoHitButton.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(valueLabel.snp.left).offset(-4)
        }
    }
    
    func configure(title: String,
                   value: String,
                   showInfo: Bool = false,
                   isClickable: Bool = false,
                   tag: Int = 0,
                   highlightValue: Bool = false) {
        rowIndex = tag
        showsInfo = showInfo
        titleLabel.text = title
        valueLabel.text = value
        valueLabel.textColor = highlightValue ? UIColor(hex: "#EA6818") : UIColor(hex: "#2C2F20")
        
        infoIconView.isHidden = !showInfo
        infoIconWidthConstraint?.update(offset: showInfo ? 18 : 0)
        infoHitButton.isHidden = !showInfo
        infoHitButton.isUserInteractionEnabled = showInfo
        
        arrowImageView.isHidden = !isClickable
        arrowImageViewWidthConstraint?.update(offset: isClickable ? 20 : 0)
        
        if showInfo {
            bringSubviewToFront(infoHitButton)
        }
    }
    
    @objc private func infoHitButtonTapped() {
        onInfoButtonTapped?(rowIndex)
    }
}
