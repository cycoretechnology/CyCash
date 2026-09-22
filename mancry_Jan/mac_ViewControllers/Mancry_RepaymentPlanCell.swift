import UIKit
import SnapKit

/// 还款计划 Cell - 左右两列布局，每列都是标题在上，值在下
class Mancry_RepaymentPlanCell: UITableViewCell {
    
    static let identifier = "Mancry_RepaymentPlanCell"
    
    // MARK: - Left Column (Due Date)
    private lazy var leftTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#666666")
        label.numberOfLines = 1
        label.text = "Due Date"
        return label
    }()
    
    private lazy var leftValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(hex: "#2C2F20")
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Right Column (Amount Due)
    private lazy var rightTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#666666")
        label.numberOfLines = 1
        label.text = "Amount Due"
        label.textAlignment = .right
        return label
    }()
    
    private lazy var rightValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(hex: "#2C2F20")
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Background container with light color and rounded corners
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.layer.borderColor = UIColor(hex: "#EDF1D8")?.cgColor
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.cornerRadius = 12
        backgroundView.clipsToBounds = true
        
        // Left column container
        let leftContainer = UIView()
        leftContainer.backgroundColor = .clear
        
        // Right column container
        let rightContainer = UIView()
        rightContainer.backgroundColor = .clear
        
        contentView.addSubview(backgroundView)
        backgroundView.addSubview(leftContainer)
        backgroundView.addSubview(rightContainer)
        
        leftContainer.addSubview(leftTitleLabel)
        leftContainer.addSubview(leftValueLabel)
        
        rightContainer.addSubview(rightTitleLabel)
        rightContainer.addSubview(rightValueLabel)
        
        // Background view constraints
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
        }
        
        // Left column constraints
        leftContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(backgroundView.snp.centerX).offset(-8)
        }
        
        leftTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        leftValueLabel.snp.makeConstraints { make in
            make.top.equalTo(leftTitleLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // Right column constraints
        rightContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.left.equalTo(backgroundView.snp.centerX).offset(8)
            make.right.equalToSuperview().offset(-16)
        }
        
        rightTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        rightValueLabel.snp.makeConstraints { make in
            make.top.equalTo(rightTitleLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(dueDate: String, amount: String) {
        leftValueLabel.text = dueDate
        rightValueLabel.text = amount
    }
}
