import UIKit
import SnapKit

class Mancry_LoanDetailCell: UITableViewCell {
    
    static let identifier = "Mancry_LoanDetailCell"
    
    var onInfoButtonTapped: ((Int) -> Void)?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(hex: "#666666")
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "flbeql_loan_sm"), for: .normal)
        button.isHidden = true
        button.isUserInteractionEnabled = true
        // 扩大可点区域，避免嵌套 ScrollView / 窄按钮点不到
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(hex: "#2C2F20")
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbysw_order_jt")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private var arrowImageViewWidthConstraint: Constraint?
    private var infoButtonWidthConstraint: Constraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoButton)
        contentView.addSubview(valueLabel)
        contentView.addSubview(arrowImageView)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        infoButton.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(0)
            make.centerY.equalToSuperview()
            infoButtonWidthConstraint = make.width.equalTo(0).constraint
            make.height.equalTo(40)
        }
        
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            arrowImageViewWidthConstraint = make.width.equalTo(20).constraint
            make.height.equalTo(20)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(arrowImageView.snp.left).offset(-8)
            make.left.greaterThanOrEqualTo(infoButton.snp.right).offset(16)
        }
    }
    
    func configure(title: String,
                   value: String,
                   showInfo: Bool = false,
                   isClickable: Bool = false,
                   tag: Int = 0,
                   highlightValue: Bool = false) {
        titleLabel.text = title
        valueLabel.text = value
        valueLabel.textColor = highlightValue ? UIColor(hex: "#EA6818") : UIColor(hex: "#2C2F20")
        infoButton.isHidden = !showInfo
        infoButton.isEnabled = showInfo
        infoButtonWidthConstraint?.update(offset: showInfo ? 40 : 0)
        arrowImageView.isHidden = !isClickable
        
        // 当 arrowImageView 隐藏时，宽度设置为 0
        if isClickable {
            arrowImageViewWidthConstraint?.update(offset: 20)
        } else {
            arrowImageViewWidthConstraint?.update(offset: 0)
        }
        infoButton.tag = tag
        if showInfo {
            contentView.bringSubviewToFront(infoButton)
        }
    }
    
    @objc private func infoButtonTapped(_ sender: UIButton) {
        onInfoButtonTapped?(sender.tag)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if !infoButton.isHidden {
            let pointInButton = infoButton.convert(point, from: self)
            if infoButton.bounds.insetBy(dx: -8, dy: -8).contains(pointInButton) {
                return infoButton
            }
        }
        return view
    }
}
