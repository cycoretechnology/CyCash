//
//  Mancry_noDataView.swift
//  mancry_Jan
//
//

import UIKit
import SnapKit

class Mancry_noDataView: UIView {
    
    // MARK: - Properties
    
    // 按钮点击回调
    var mancry_applyButtonTapped: (() -> Void)?
    
    // 小屏可滚动，避免内容被裁切或盖住底部区域
    private lazy var mancry_scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    // 容器视图
    private lazy var mancry_containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // 图片视图
    private lazy var mancry_imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flbeql_home_kzt")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // Apply Now 按钮
    private lazy var mancry_applyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Apply Now", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        button.backgroundColor = UIColor(hex: "#CADC00")
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(mancry_applyButtonAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mancry_setupUI()
        mancry_setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        mancry_setupUI()
        mancry_setupConstraints()
    }
    
    // MARK: - Setup UI
    
    private func mancry_setupUI() {
        backgroundColor = .clear
        
        addSubview(mancry_scrollView)
        mancry_scrollView.addSubview(mancry_containerView)
        mancry_containerView.addSubview(mancry_imageView)
        mancry_containerView.addSubview(mancry_applyButton)
    }
    
    private func mancry_setupConstraints() {
        
        mancry_scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mancry_containerView.snp.makeConstraints { make in
            make.edges.equalTo(mancry_scrollView.contentLayoutGuide)
            make.width.equalTo(mancry_scrollView.frameLayoutGuide)
        }
        
        // 图片
        mancry_imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(140)
        }
        
        // Apply Now 按钮
        mancry_applyButton.snp.makeConstraints { make in
            make.top.equalTo(mancry_imageView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    // MARK: - Actions
    
    @objc private func mancry_applyButtonAction() {
        mancry_applyButtonTapped?()
    }
}
