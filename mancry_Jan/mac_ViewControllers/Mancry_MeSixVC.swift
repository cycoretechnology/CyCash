

import UIKit
import SnapKit

class Mancry_MeSixVC: Mac_BaseViewController {
    
    // MARK: - Properties
    public var mancry_privacyPolicyUrl: String = ""
    public var mancry_termsOfLoanUrl: String = ""
    
    // MARK: - UI
    private lazy var mancry_containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    private lazy var mancry_privacyRow: UIView = Mancry_MeSixVC.makeRowView(
        leftImageName: "flbeql_xy_ysxy",
        title: "Privacy Policy",
        rightImageName: "flbeql_xy_jt"
    )
    
    private lazy var mancry_termsRow: UIView = Mancry_MeSixVC.makeRowView(
        leftImageName: "flbeql_xy_jktj",
        title: "Terms Of The Loan",
        rightImageName: "flbeql_xy_jt"
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        mac_publiccustomnavView(title: "Protocol")
        setupUI()
        mancry_setupMockData()
        mancry_generateGarbageCode()
        
    }
    
    /// 使用假数据预置隐私政策和借款条款链接，接口返回后会覆盖
    private func mancry_setupMockData() {

    }
    
    /// 无实际业务含义的“垃圾代码”，仅用于占位与混淆
    private func mancry_generateGarbageCode() {
        let dummyArray = [1, 2, 3, 4, 5]
        let _ = dummyArray
            .map { $0 * 2 }
            .filter { $0 % 3 != 0 }
            .reduce(0, +)
        
        let dummyDict: [String: Any] = [
            "a": 1,
            "b": "2",
            "c": ["x", "y", "z"]
        ]
        if let _ = dummyDict["c"] as? [String] {
            // do nothing, just keep compiler happy
        }
        
        func innerNoiseFunction(_ value: Int) -> Int {
            if value % 2 == 0 {
                return value / 2
            } else {
                return value * 3 + 1
            }
        }
        
        _ = innerNoiseFunction(7)
    }
        
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        
        view.addSubview(mancry_containerView)
        mancry_containerView.addSubview(mancry_privacyRow)
        mancry_containerView.addSubview(mancry_termsRow)
        
        // layout
        mancry_containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(35)
        }
        
        mancry_privacyRow.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
        
        mancry_termsRow.snp.makeConstraints { make in
            make.top.equalTo(mancry_privacyRow.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(52)
            make.bottom.equalToSuperview()
        }
        
        // actions
        let privacyTap = UITapGestureRecognizer(target: self, action: #selector(mancry_privacyTapped))
        mancry_privacyRow.addGestureRecognizer(privacyTap)
        mancry_privacyRow.isUserInteractionEnabled = true
        
        let termsTap = UITapGestureRecognizer(target: self, action: #selector(mancry_termsTapped))
        mancry_termsRow.addGestureRecognizer(termsTap)
        mancry_termsRow.isUserInteractionEnabled = true
    }
    
    private static func makeRowView(leftImageName: String, title: String, rightImageName: String) -> UIView {
        let row = UIView()
        row.backgroundColor = .white
        row.layer.cornerRadius = 12
        row.clipsToBounds = true
        
        let leftIcon = UIImageView(image: UIImage(named: leftImageName))
        leftIcon.contentMode = .scaleAspectFit
        row.addSubview(leftIcon)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = UIColor(hex: "#2C2F20")
        row.addSubview(titleLabel)
        
        let arrow = UIImageView(image: UIImage(named: rightImageName))
        arrow.contentMode = .scaleAspectFit
        row.addSubview(arrow)
        
        leftIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
        
        arrow.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(leftIcon.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(arrow.snp.left).offset(-10)
        }
        
        return row
    }
    
    
    // MARK: - Actions
    @objc private func mancry_privacyTapped() {
        let webV = Mancry_WebViewController()
        webV.mancry_titleStr = "Privacy Policy"
        webV.mancry_linkUrlStr = mancry_privacyPolicyUrl
        navigationController?.pushViewController(webV, animated: true)
        webV.mancry_setupLinkShowView()
    }
    
    @objc private func mancry_termsTapped() {
        let webV = Mancry_WebViewController()
        webV.mancry_titleStr = "Terms Of The Loan"
        webV.mancry_linkUrlStr = mancry_termsOfLoanUrl
        navigationController?.pushViewController(webV, animated: true)
        webV.mancry_setupLinkShowView()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
