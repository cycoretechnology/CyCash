import UIKit
import AVFoundation
import SnapKit

/// 人脸拍照页面（竖屏）
/// UI 逻辑：
/// - 初始：上方为取景框（正方形预览），下方提示文案，再下方底部按钮“Take a photo”
/// - 拍照完成：预览显示拍到的照片，“Take a photo”隐藏，底部出现“Restart”和“Confirm”
/// - Restart：重新启动相机，恢复取景预览
/// - Confirm：将图片通过回调传回上一个页面并返回
class Mancry_CameraFaceVC: Mac_BaseViewController, AVCapturePhotoCaptureDelegate {
    
    // 回传拍摄结果
    var mancry_onCapture: ((UIImage) -> Void)?
    
    // MARK: - Camera
    private let mancry_session = AVCaptureSession()
    private let mancry_output = AVCapturePhotoOutput()
    private var mancry_deviceInput: AVCaptureDeviceInput?
    private var mancry_previewLayer: AVCaptureVideoPreviewLayer?
    private var mancry_capturedImage: UIImage?
    
    // MARK: - UI
    private let mancry_previewContainer = UIView()
    private let mancry_previewImageView = UIImageView()
    
    private let mancry_tipsBackgroundView = UIView()
    private let mancry_tipsLabel: UILabel = {
        let label = UILabel()
        label.text = "Please put your face in the frame and take a clear selfie"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(hex: "#FFFFFF")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let mancry_takePhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Take a photo", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.backgroundColor = UIColor(hex: "#CADC00")
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        return btn
    }()
    
    private let mancry_restartButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Restart", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.backgroundColor = UIColor(hex: "#DFE4C6")
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        btn.isHidden = true
        return btn
    }()
    
    private let mancry_confirmButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Confirm", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.backgroundColor = UIColor(hex: "#CADC00")
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        btn.isHidden = true
        return btn
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        
        setupUI()
        self.mac_publiccustomnavView(title: "Face identification")
        
        mancry_setupCamera()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mancry_previewLayer?.frame = mancry_previewContainer.bounds
    }
    
    
    // MARK: - UI
    private func setupUI() {
        // 预览容器（正方形）
        mancry_previewContainer.backgroundColor = .black
        mancry_previewContainer.layer.cornerRadius = 16
        mancry_previewContainer.clipsToBounds = true
        view.addSubview(mancry_previewContainer)
        
        mancry_previewContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(55)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(32)
            make.height.equalTo(mancry_previewContainer.snp.width)
        }
        
        // 用于在拍照后展示静态图片
        mancry_previewImageView.contentMode = .scaleAspectFill
        mancry_previewImageView.clipsToBounds = true
        mancry_previewImageView.isHidden = true
        mancry_previewContainer.addSubview(mancry_previewImageView)
        mancry_previewImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 提示文案背景
        mancry_tipsBackgroundView.backgroundColor = UIColor(hex: "#5F6647")
        mancry_tipsBackgroundView.layer.cornerRadius = 10
        mancry_tipsBackgroundView.clipsToBounds = true
        view.addSubview(mancry_tipsBackgroundView)
        
        mancry_tipsBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(mancry_previewContainer.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(32)
            make.height.greaterThanOrEqualTo(60)
        }
        
        mancry_tipsBackgroundView.addSubview(mancry_tipsLabel)
        mancry_tipsLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        // 底部按钮
        view.addSubview(mancry_takePhotoButton)
        view.addSubview(mancry_restartButton)
        view.addSubview(mancry_confirmButton)
        
        mancry_takePhotoButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(56)
        }
        
        mancry_restartButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.right.equalTo(view.snp.centerX).offset(-8)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(56)
        }
        
        mancry_confirmButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.left.equalTo(view.snp.centerX).offset(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(56)
        }
        
        mancry_takePhotoButton.addTarget(self, action: #selector(mancry_takePhotoTapped), for: .touchUpInside)
        mancry_restartButton.addTarget(self, action: #selector(mancry_restartTapped), for: .touchUpInside)
        mancry_confirmButton.addTarget(self, action: #selector(mancry_confirmTapped), for: .touchUpInside)
    }
    
    private func mancry_updateButtonsForCaptured(_ captured: Bool) {
        mancry_takePhotoButton.isHidden = captured
        mancry_restartButton.isHidden = !captured
        mancry_confirmButton.isHidden = !captured
        mancry_previewImageView.isHidden = !captured
    }
  
    
 
    private func mancry_setupCamera() {
        mancry_session.beginConfiguration()
        mancry_session.sessionPreset = .hd1280x720
        
        // 使用前置摄像头
        if let currentInput = mancry_deviceInput {
            mancry_session.removeInput(currentInput)
        }
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device),
              mancry_session.canAddInput(input) else {
            mancry_session.commitConfiguration()
            return
        }
        mancry_session.addInput(input)
        mancry_deviceInput = input
        
        if mancry_session.canAddOutput(mancry_output) {
            mancry_session.addOutput(mancry_output)
        }
        
        mancry_session.commitConfiguration()
        
        if mancry_previewLayer == nil {
            let layer = AVCaptureVideoPreviewLayer(session: mancry_session)
            layer.videoGravity = .resizeAspectFill
            layer.connection?.videoOrientation = .portrait
            mancry_previewContainer.layer.insertSublayer(layer, at: 0)
            mancry_previewLayer = layer
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.mancry_session.startRunning()
        }
    }
    
    // MARK: - Actions
    @objc private func mancry_takePhotoTapped() {
        let settings = AVCapturePhotoSettings()
        mancry_output.capturePhoto(with: settings, delegate: self)
    }
    
    @objc private func mancry_restartTapped() {
        mancry_capturedImage = nil
        mancry_previewImageView.image = nil
        mancry_updateButtonsForCaptured(false)
        if !mancry_session.isRunning {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.mancry_session.startRunning()
            }
        }
    }
    
    @objc private func mancry_confirmTapped() {
        guard let img = mancry_capturedImage else { return }
        mancry_onCapture?(img)
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        if mancry_session.isRunning {
            mancry_session.stopRunning()
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let _ = error { return }
        guard let data = photo.fileDataRepresentation(),
              var image = UIImage(data: data) else { return }
        
        // 统一修正为正向朝上的竖屏图像
        if image.imageOrientation != .up {
            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
            image.draw(in: CGRect(origin: .zero, size: image.size))
            image = UIGraphicsGetImageFromCurrentImageContext() ?? image
            UIGraphicsEndImageContext()
        }
        
        mancry_capturedImage = image
        mancry_previewImageView.image = image
        mancry_updateButtonsForCaptured(true)
        
        if mancry_session.isRunning {
            mancry_session.stopRunning()
        }
    }
    
}
