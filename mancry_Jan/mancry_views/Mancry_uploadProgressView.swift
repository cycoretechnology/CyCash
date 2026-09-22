
import UIKit
import SnapKit

/// 上传进度弹窗视图
class Mancry_uploadProgressView: UIView {

    // MARK: - Properties
    private var containerView: UIView!
    private var backgroundMaskView: UIView!
    private var titleLabel: UILabel!
    private var rotatingImageView: UIImageView!  // 转圈旋转的图片
    private var progressLabel: UILabel!  // 进度百分比文字
    private var firstDescriptionLabel: UILabel!
    private var progressContainerView: UIView!  // 包含进度图片和说明文字的容器
    private var progressImageView: UIImageView!  // 显示进度的图片
    private var secondDescriptionLabel: UILabel!
    
    private var rotationAnimation: CABasicAnimation?
    private var progressTimer: Timer?
    private var currentProgress: Int = 0
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        backgroundMaskView.backgroundColor = UIColor(hex: "#505D2A")?.withAlphaComponent(0.8) ?? UIColor.black.withAlphaComponent(0.8)
        backgroundMaskView.isUserInteractionEnabled = false  // 不允许点击遮罩关闭
        addSubview(backgroundMaskView)
        backgroundMaskView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 容器视图
        containerView = UIView()
        containerView.backgroundColor = UIColor(hex: "#EDF1D8")
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        containerView.backgroundColor = .clear
        addSubview(containerView)
        
        // 标题
        titleLabel = UILabel()
        titleLabel.text = "Under review"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = UIColor(hex: "#FF6B35") ?? .orange
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        // 转圈旋转的图片
        rotatingImageView = UIImageView()
        rotatingImageView.image = UIImage(named: "flbeql_jd")
        rotatingImageView.contentMode = .scaleAspectFit
        containerView.addSubview(rotatingImageView)
        
        // 进度百分比文字（显示在旋转图片中心）
        progressLabel = UILabel()
        progressLabel.text = "0%"
        progressLabel.font = .boldSystemFont(ofSize: 24)
        progressLabel.textColor = UIColor(hex: "#CEDF00") ?? .green
        progressLabel.textAlignment = .center
        containerView.addSubview(progressLabel)
        
        // 第一段说明文字
        firstDescriptionLabel = UILabel()
        firstDescriptionLabel.text = "Updating your credit score, please do not leave this page. This process takes about 15 seconds..."
        firstDescriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        firstDescriptionLabel.textColor = .white
        firstDescriptionLabel.numberOfLines = 0
        firstDescriptionLabel.textAlignment = .center
        containerView.addSubview(firstDescriptionLabel)
        
        // 进度容器（包含进度图片和说明文字）
        progressContainerView = UIView()
        progressContainerView.backgroundColor = .clear
        progressContainerView.layer.borderWidth = 0.6
        progressContainerView.layer.borderColor = UIColor.white.cgColor
        progressContainerView.layer.cornerRadius = 20
        progressContainerView.alpha = 0.8
        progressContainerView.clipsToBounds = true
        containerView.addSubview(progressContainerView)
        
        // 显示进度的图片
        progressImageView = UIImageView()
        progressImageView.image = UIImage(named: "flbeql_sb")
        progressImageView.contentMode = .scaleAspectFit
        progressContainerView.addSubview(progressImageView)
        
        // 第二段说明文字
        secondDescriptionLabel = UILabel()
        secondDescriptionLabel.text = "Just one step left before your loan is received. Please do not leave this page."
        secondDescriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        secondDescriptionLabel.textColor = .white
        secondDescriptionLabel.numberOfLines = 0
        secondDescriptionLabel.textAlignment = .center
        progressContainerView.addSubview(secondDescriptionLabel)
        
        setupConstraints()
        startRotationAnimation()
        startProgressTimer()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(mancry_Width - 60)
            make.height.lessThanOrEqualTo(mancry_Height * 0.8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.right.equalToSuperview().inset(20)
        }
        
        rotatingImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        progressLabel.snp.makeConstraints { make in
            make.center.equalTo(rotatingImageView)
        }
        
        firstDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(rotatingImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        progressContainerView.snp.makeConstraints { make in
            make.top.equalTo(firstDescriptionLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(140)
            make.bottom.equalToSuperview().offset(-24)
        }
        
        progressImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(mancry_Width - 160)
            make.height.equalTo(40)
        }
        
        secondDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(progressImageView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    // MARK: - Helper Methods
    
    /// 开始旋转动画
    private func startRotationAnimation() {
        rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation?.fromValue = 0
        rotationAnimation?.toValue = Double.pi * 2
        rotationAnimation?.duration = 2.0
        rotationAnimation?.repeatCount = .greatestFiniteMagnitude
        rotatingImageView.layer.add(rotationAnimation!, forKey: "rotation")
    }
    
    /// 停止旋转动画
    private func stopRotationAnimation() {
        rotatingImageView.layer.removeAnimation(forKey: "rotation")
    }
    
    /// 开始进度定时器：从 0% 开始，每 0.1s 增加 2%，直到 100%
    private func startProgressTimer() {
        progressTimer?.invalidate()
        currentProgress = 0
        updateProgress(currentProgress)
        
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            if self.currentProgress >= 100 {
                timer.invalidate()
                return
            }
            self.currentProgress = min(100, self.currentProgress + 2)
            self.updateProgress(self.currentProgress)
        }
    }
    
    /// 停止进度定时器
    private func stopProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
    
    // MARK: - Public Methods
    
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
        
        // 动画显示
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    /// 隐藏弹窗（暴露给外部调用）
    func dismiss() {
        stopRotationAnimation()
        stopProgressTimer()
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundMaskView.alpha = 0
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    /// 更新进度百分比
    func updateProgress(_ progress: Int) {
        progressLabel.text = "\(progress)%"
        currentProgress = progress
    }
    
    deinit {
        stopRotationAnimation()
        stopProgressTimer()
    }
}
