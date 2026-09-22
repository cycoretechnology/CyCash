
import UIKit
import SnapKit

class Mancry_MeThreeVC: Mac_BaseViewController {
    
    // MARK: - Properties
    public var mancry_officialWebsite = ""  // 官方网址，可根据实际需求修改
    
    // MARK: - UI Components
    
    // 白色卡片容器
    private lazy var mancry_cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    // 描述文字（使用 UITextView 支持富文本和点击）
    private lazy var mancry_descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.delegate = self
        return textView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mac_publiccustomnavView(title: "Official Website")
        setupUI()
        setupDescriptionText()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        
        view.addSubview(mancry_cardView)
        mancry_cardView.addSubview(mancry_descriptionTextView)
        
        mancry_cardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(55)
            make.left.right.equalToSuperview().inset(20)
        }
        
        mancry_descriptionTextView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func setupDescriptionText() {
        let fullText = "When encountering issues with your app, you can also apply and repay through the official website. We recommend that you save the official website address, click to copy."
        let clickToCopyText = "click to copy"
        
        // 创建富文本
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // 设置整体文字样式
        let fullRange = NSRange(location: 0, length: fullText.count)
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: UIColor(hex: "#2C2F20") ?? .black
        ], range: fullRange)
        
        // 设置"click to copy"为橙色并添加链接
        if let range = fullText.range(of: clickToCopyText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttributes([
                .foregroundColor: UIColor(hex: "#FF6B35") ?? .orange,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .link: URL(string: "copy://clicktocopy") ?? URL(string: "https://copy")!
            ], range: nsRange)
        }
        
        mancry_descriptionTextView.attributedText = attributedString
        mancry_descriptionTextView.linkTextAttributes = [
            .foregroundColor: UIColor(hex: "#FF6B35") ?? .orange,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }
    
    // MARK: - Actions
    
    private func mancry_copyToClipboard() {
        UIPasteboard.general.string = mancry_officialWebsite
        mac_centerToastViewwithMsg(msg: "website address copied to clipboard")
    }
}

// MARK: - UITextViewDelegate
extension Mancry_MeThreeVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "copy" {
            mancry_copyToClipboard()
            return false
        }
        return true
    }
}
