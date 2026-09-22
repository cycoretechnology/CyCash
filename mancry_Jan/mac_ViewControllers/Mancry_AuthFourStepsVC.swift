

import UIKit
import PhotosUI
import SnapKit

class Mancry_AuthFourStepsVC: Mac_BaseViewController {
    
    private enum MancryUploadType {
        case idCard
        case face
    }
    
    // MARK: - UI
    private let mancry_progressImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "jdt_100"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let mancry_scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.backgroundColor = UIColor(hex: "#EDF1D8")
        return scroll
    }()
    
    private let mancry_contentView = UIView()
    
    private lazy var mancry_idCardView: Mancry_UploadCardView = {
        let view = Mancry_UploadCardView()
        view.mancry_title = "Please upload one valid ID. Supported IDs include UMID, National ID, SSS, TIN, Passport, Driver's License, Postal ID, Voter ID, or Health Card."
        view.mancry_tips = [
            "1. Please make sure that the ID card you upload is genuine and valid.",
            "2. Please make sure that the uploaded ID card photo is clear and complete, otherwise it will not pass verification."
        ]
        // 使用 UI 提供的加号图标
        view.mancry_setAddIconImage(named: "flbeql_kyc_upgrade")
        // 身份证标题左对齐
        view.mancry_setTitleCentered(false)
        view.onTap = { [weak self] in
            self?.mancry_presentPicker(for: .idCard)
        }
        view.onDelete = { [weak self] in
            self?.mancry_idImage = nil
            view.mancry_setImage(nil)
        }
        return view
    }()
    
    private lazy var mancry_faceCardView: Mancry_UploadCardView = {
        let view = Mancry_UploadCardView()
        view.mancry_title = "Face identification"
        view.mancry_tips = ["Tap the photo area to take or retake your face photo"]
        // 面部占位图 & 正方形区域
        view.mancry_setPlaceholderImage(named: "flbeql_kyc_face")
        view.mancry_setSquareLayout()
        // 人脸标题居中
        view.mancry_setTitleCentered(true)
        view.onTap = { [weak self] in
            guard let self = self else { return }
            
            mancry_checkCameraPermission(type: 2)
            
        }
        view.onDelete = { [weak self] in
            self?.mancry_faceImage = nil
            // 删除后恢复人脸占位图
            view.mancry_setPlaceholderImage(named: "flbeql_kyc_face")
        }
        return view
    }()
    
    private lazy var mancry_continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(hex: "#CEDF00")
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(mancry_continueTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data
    private var mancry_idImage: UIImage?
    private var mancry_faceImage: UIImage?
    private var mancry_currentPickType: MancryUploadType?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        self.mac_publiccustomnavView(title: "Credit standing")
        setupUI()
    }
    
    override func mancry_backbtnAction() {
        let cameraPopView = Mancry_PopView(type: .cameraPermission)
        cameraPopView.configure(
            topImageName: "flbeql_tk_xj",
            title: "Confirm to return?",
            description: "Do you want to pause the authentication and return to the homepage?",
            leftButtonTitle: "Confirm",
            rightButtonTitle: "Cancel"
        )
        cameraPopView.onLeftButtonTapped = {
            self.navigationController?.popToRootViewController(animated: true)
        }
      
        cameraPopView.show()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(mancry_progressImageView)
        view.addSubview(mancry_scrollView)
        view.addSubview(mancry_continueButton)
        
        mancry_progressImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(55)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(24)
        }
        
        mancry_scrollView.snp.makeConstraints { make in
            make.top.equalTo(mancry_progressImageView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-80)
        }
        
        mancry_scrollView.addSubview(mancry_contentView)
        mancry_contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        mancry_contentView.addSubview(mancry_idCardView)
        mancry_idCardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        mancry_contentView.addSubview(mancry_faceCardView)
        mancry_faceCardView.snp.makeConstraints { make in
            make.top.equalTo(mancry_idCardView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        mancry_continueButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Actions
    @objc private func mancry_continueTapped() {
        if mancry_idImage == nil {
            mac_centerToastViewwithMsg(msg: "Please upload your ID card")
            return
        }
        if mancry_faceImage == nil {
            mac_centerToastViewwithMsg(msg: "Please upload your face photo")
            return
        }
        Mancry_uploadData.mancry_insertPointData(insertId: "66")
        guard let idImage = mancry_idImage,
              let faceImage = mancry_faceImage else { return }
        
        // 压缩图片到 200KB~600KB 之间并转为 Base64
        guard let idData = mancry_compressImageForKYC(idImage),
              let faceData = mancry_compressImageForKYC(faceImage) else {
            mac_centerToastViewwithMsg(msg: "Image compression failed, please try again")
            return
        }
        
        let idBase64 = idData.base64EncodedString()
        let faceBase64 = faceData.base64EncodedString()
        
        let bizData: [String: Any] = [
            "identity_front_img": idBase64,
            "liveness_img": faceBase64
        ]
        
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: bizData, isSign: false)
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else {
            mac_centerToastViewwithMsg(msg: "Request build failed")
            return
        }
        
        self.mac_PopLoadingView()
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/kyc/four/liveness",
            httpBody: postData,
            successCallBack: { [weak self] result in
                guard let self = self else { return }
                self.mac_hiddenLoadingView()
                
                let code = result["resultCode"] as? Int ?? -1
                if code == 200 {
                    // 提交成功，返回首页
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                } else if code == 6212011 || code == 6212009 || code == 6212201{
                    // 指定错误码：清空页面数据
                   
//                    self.mancry_faceImage = nil
                   
//                    self.mancry_faceCardView.mancry_setPlaceholderImage(named: "flbeql_kyc_face")
                    let pop = Mancry_PopView(type: .verificationFailed)
                    pop.configure(
                        title: "Verification failed",
                        description: "Please upload the photo again.",
                        rightButtonTitle: "Confirm"
                    )
                    pop.onRightButtonTapped = {
            
                        self.mancry_idImage = nil
                        self.mancry_idCardView.mancry_setImage(nil)
                    }
                    pop.show()
                    
//                    let msg = result["resultMsg"] as? String ?? "Verification failed, please re-upload"
//                    self.mac_centerToastViewwithMsg(msg: msg)
                } else {
                    let msg = result["resultMsg"] as? String ?? "Submit failed"
                    self.mac_centerToastViewwithMsg(msg: msg)
                }
            },
            failureCallBack: { [weak self] _ in
                self?.mac_hiddenLoadingView()
                self?.mac_centerToastViewwithMsg(msg: "Network error, please try again")
            }
        )
    }
    
    
    
    private func mancry_presentPicker(for type: MancryUploadType) {
        mancry_currentPickType = type
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Open the photo library", style: .default, handler: { [weak self] _ in
            self?.mancry_openPhotoLibrary()
            Mancry_uploadData.mancry_insertPointData(insertId: "50")
            Mancry_uploadData.mancry_insertPointData(insertId: "57")
        }))
        sheet.addAction(UIAlertAction(title: "Turn on the camera", style: .default, handler: { [weak self] _ in
            self?.mancry_checkCameraPermission(type: 1)
            Mancry_uploadData.mancry_insertPointData(insertId: "53")
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(sheet, animated: true)
    }
    
    private func mancry_openPhotoLibrary() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func mancry_openCamera(type: Int) {
        
        if type == 1{
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                mac_centerToastViewwithMsg(msg: "Camera not available")
                return
            }
            let landVC = Mancry_LandViewController()
            landVC.modalPresentationStyle = .fullScreen
            landVC.CallBack = { [weak self] img in
                DispatchQueue.main.async {
                    if self?.mancry_currentPickType == .idCard {
                        self?.mancry_idImage = img
                        self?.mancry_idCardView.mancry_setImage(img)
                    } else {
                        self?.mancry_faceImage = img
                        self?.mancry_faceCardView.mancry_setImage(img)
                    }
                    
                }
            }
            
            self.present(landVC, animated: true)
        }else{
            ///
             let cameraVC = Mancry_CameraFaceVC()
            cameraVC.mancry_onCapture = { [weak self] image in
                guard let self = self else { return }
                self.mancry_faceImage = image
                self.mancry_faceCardView.mancry_setImage(image)
            }
            self.navigationController?.pushViewController(cameraVC, animated: true)
            
        }
        
       
        
       

    }
    
    private func mancry_checkCameraPermission(type: Int) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
//            print("有权限")
            self.mancry_openCamera(type: type)
            Mancry_uploadData.mancry_insertPointData(insertId: "11")
            Mancry_uploadData.mancry_insertPointData(insertId: "50")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
//                        print("有权限")
                        self?.mancry_openCamera(type: type)
                        Mancry_uploadData.mancry_insertPointData(insertId: "11")
                        Mancry_uploadData.mancry_insertPointData(insertId: "50")
                    }
                    // 首次系统弹窗拒绝：不弹自定义引导窗
                }
            }
        default:
            get_mancry_cameraPermissionAlert()
            
        }
    }
    
    
    private func get_mancry_cameraPermissionAlert(){
        // 相机权限弹窗
        let cameraPopView = Mancry_PopView(type: .cameraPermission)
        cameraPopView.configure(
            topImageName: "flbeql_tk_xj",
            title: "Camera",
            description: "Please allow CyCash to access the camera in Settings so that you can take the necessary files.",
            leftButtonTitle: "Cancel",
            rightButtonTitle: "Confirm"
        )
        cameraPopView.onLeftButtonTapped = {
            // Cancel 点击回调
        }
        cameraPopView.onRightButtonTapped = {
            // Confirm 点击回调
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL)
        }
        cameraPopView.show()
    }
    
    
    private func mancry_handlePicked(image: UIImage?) {
        guard let image else { return }
        if mancry_currentPickType == .idCard {
            mancry_idImage = image
            mancry_idCardView.mancry_setImage(image)
        } else {
            mancry_faceImage = image
            mancry_faceCardView.mancry_setImage(image)
        }
    }
    
    /// 压缩图片到约 200KB~600KB 之间，用于 KYC 上传
    /// - Parameter image: 原始图片
    /// - Returns: 压缩后的 JPEG 数据
    private func mancry_compressImageForKYC(_ image: UIImage) -> Data? {
        let minSize: Int = 200 * 1024
        let maxSize: Int = 600 * 1024
        
        // 先按较高质量压缩
        var compression: CGFloat = 0.9
        var targetImage = image
        
        // 限制最长边，避免超大分辨率
        let maxDimension: CGFloat = 1600
        if image.size.width > maxDimension || image.size.height > maxDimension {
            let scale = min(maxDimension / image.size.width, maxDimension / image.size.height)
            let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            targetImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
            UIGraphicsEndImageContext()
        }
        
        guard var imageData = targetImage.jpegData(compressionQuality: compression) else {
            return nil
        }
        
        // 如果大于最大值，逐步降低质量
        while imageData.count > maxSize && compression > 0.1 {
            compression -= 0.1
            if let data = targetImage.jpegData(compressionQuality: compression) {
                imageData = data
            } else {
                break
            }
        }
        
        // 如果依然太大则失败
        if imageData.count > maxSize {
            return nil
        }
        
        // 小于最小值时不再放大，只返回当前数据（无法可靠“变大”）
        if imageData.count < minSize {
            return imageData
        }
        
        return imageData
    }
}

// MARK: - PHPicker Delegate
extension Mancry_AuthFourStepsVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            guard let self, let image = object as? UIImage else { return }
            DispatchQueue.main.async {
                self.mancry_handlePicked(image: image)
            }
        }
    }
}

// MARK: - Upload Card View
private class Mancry_UploadCardView: UIView {
    var mancry_title: String? {
        didSet { mancry_titleLabel.text = mancry_title }
    }
    var mancry_tips: [String] = [] {
        didSet { mancry_reloadTips() }
    }
    var onTap: (() -> Void)?
    var onDelete: (() -> Void)?
    
    private let mancry_container: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 12
        v.clipsToBounds = true
        return v
    }()
    
    private let mancry_titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(hex: "#2C2F20")
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let mancry_imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(hex: "#E8EED3")
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let mancry_addIcon: UIImageView = {
        let iv = UIImageView()
        // 默认图标，具体资源由外部通过 mancry_setAddIconImage 配置
        iv.image = UIImage(named: "flbeql_kyc_upgrade")
        iv.tintColor = nil
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let mancry_deleteButton: UIButton = {
        let btn = UIButton(type: .custom)
        // 删除按钮图标由 UI 资源提供
        btn.setImage(UIImage(named: "flbeql_kyc_delete"), for: .normal)
        btn.tintColor = nil
        btn.isHidden = true
        return btn
    }()
    
    private let mancry_tipsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var mancry_tapButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(mancry_container)
        mancry_container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mancry_container.addSubview(mancry_titleLabel)
        mancry_container.addSubview(mancry_imageView)
        mancry_container.addSubview(mancry_tipsStack)
        
        mancry_titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.right.equalToSuperview().inset(12)
        }
        
        mancry_imageView.snp.makeConstraints { make in
            make.top.equalTo(mancry_titleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(180)
        }
        
        mancry_tipsStack.snp.makeConstraints { make in
            make.top.equalTo(mancry_imageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        mancry_imageView.addSubview(mancry_addIcon)
        mancry_imageView.addSubview(mancry_deleteButton)
        mancry_imageView.addSubview(mancry_tapButton)
        mancry_imageView.bringSubviewToFront(mancry_deleteButton)
        
        mancry_addIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        mancry_deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(40)
        }
        mancry_deleteButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        
        mancry_tapButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func mancry_reloadTips() {
        mancry_tipsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        mancry_tips.forEach { text in
            let label = UILabel()
            label.font = .systemFont(ofSize: 12, weight: .regular)
            label.textColor = UIColor(hex: "#777C61")
            label.numberOfLines = 0
            label.text = text
            mancry_tipsStack.addArrangedSubview(label)
        }
    }
    
    func mancry_setImage(_ image: UIImage?) {
        mancry_imageView.image = image
        let hasImage = (image != nil)
        mancry_addIcon.isHidden = hasImage
        mancry_deleteButton.isHidden = !hasImage
        mancry_imageView.backgroundColor = UIColor(hex: "#E8EED3")
        
        mancry_imageView.bringSubviewToFront(mancry_deleteButton)
    }
    
    /// 设置加号图标资源
    func mancry_setAddIconImage(named name: String) {
        mancry_addIcon.image = UIImage(named: name)
    }
    
    /// 设置占位图（用于人脸卡片等）
    func mancry_setPlaceholderImage(named name: String) {
        mancry_imageView.image = UIImage(named: name)
        mancry_addIcon.isHidden = true
        mancry_deleteButton.isHidden = true
        mancry_imageView.backgroundColor = UIColor(hex: "#EDF1D8")
        mancry_imageView.bringSubviewToFront(mancry_deleteButton)
    }
    
    /// 将图片区域改为宽高一致的正方形（用于人脸识别区域）
    func mancry_setSquareLayout() {
        mancry_imageView.snp.remakeConstraints { make in
            make.top.equalTo(mancry_titleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(mancry_imageView.snp.width)
        }
    }
    
    /// 配置标题是否居中显示
    func mancry_setTitleCentered(_ centered: Bool) {
        mancry_titleLabel.textAlignment = centered ? .center : .left
    }
    
    @objc private func handleTap() {
        onTap?()
    }
    
    @objc private func handleDelete() {
        mancry_setImage(nil)
        onDelete?()
    }
}

