

import UIKit
import SnapKit
import Photos

class Mancry_MeTwoVC: Mac_BaseViewController {
    
    // MARK: - Properties
    
    // 已上传的图片URL列表
    private var mancry_uploadedImageUrls: [String] = []
    // 本地选择的图片列表
    private var mancry_selectedImages: [UIImage] = []
    // 最大图片数量
    private let mancry_maxImageCount = 3
    // 最大文件大小（600KB）
    private let mancry_maxFileSize: Int = 600 * 1024
    
    // MARK: - UI Components
    
    // 滚动视图
    private lazy var mancry_scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = UIColor(hex: "#EDF1D8")
        return scrollView
    }()
    
    // 内容容器
    private lazy var mancry_contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        return view
    }()
    
    // 提示信息容器
    private lazy var mancry_infoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#505D2A")
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    // 提示文字
    private lazy var mancry_infoLabel: UILabel = {
        let label = UILabel()
        label.text = "You can describe the problem you encounter in detail on this page, or send your problem to our email, leave your contact information, and we will contact you as soon as possible!"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    // 主容器（白色背景）
    private lazy var mancry_mainContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    // 问题标题
    private lazy var mancry_questionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let title = "* Your Question"
        let normalColor = UIColor(hex: "#2C2F20")
        let attributed = NSMutableAttributedString(
            string: title,
            attributes: [
                .font: label.font as Any,
                .foregroundColor: normalColor
            ]
        )
        
        // Make all "*" red
        let nsTitle = title as NSString
        var searchRange = NSRange(location: 0, length: nsTitle.length)
        while true {
            let range = nsTitle.range(of: "*", options: [], range: searchRange)
            if range.location == NSNotFound { break }
            attributed.addAttribute(.foregroundColor, value: UIColor.red, range: range)
            let nextLocation = range.location + range.length
            if nextLocation >= nsTitle.length { break }
            searchRange = NSRange(location: nextLocation, length: nsTitle.length - nextLocation)
        }
        
        label.attributedText = attributed
        return label
    }()
    
    // 问题输入框
    private lazy var mancry_questionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textView.textColor = UIColor(hex: "#333333")
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 8
        textView.clipsToBounds = true
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.delegate = self
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(hex: "#EDF1D8")?.cgColor
        textView.placeholder = "Please enter"
        return textView
    }()
    
    // 字数统计
    private lazy var mancry_charCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/1000"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(hex: "#999999")
        label.textAlignment = .right
        return label
    }()
    
    // 上传图片按钮
    private lazy var mancry_uploadButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(hex: "#EDF1D8")
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(mancry_uploadButtonTapped), for: .touchUpInside)
        
        // 图标
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "flbeql_feedback_upload")
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.isUserInteractionEnabled = false // 禁用交互，让事件穿透到 button
        
        // 文字
        let titleLabel = UILabel()
        titleLabel.text = "Upload Pictures"
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLabel.textColor = UIColor(hex: "#505D2A")
        titleLabel.isUserInteractionEnabled = false // 禁用交互，让事件穿透到 button
        
        // 水平布局
        let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = false // 禁用交互，让事件穿透到 button
        
        button.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        
        return button
    }()
    
    // 图片容器
    private lazy var mancry_imagesContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    // 提交按钮
    private lazy var mancry_submitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(UIColor(hex: "#505D2A"), for: .normal)
        button.backgroundColor = UIColor(hex: "#CADC00")
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(mancry_submitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mac_publiccustomnavView(title: "Feedback")
        mancry_setupUI()
        mancry_setupConstraints()
    
    }
    
    // MARK: - Setup UI
    
    private func mancry_setupUI() {
        view.backgroundColor = UIColor(hex: "#EDF1D8")
        
        view.addSubview(mancry_scrollView)
        mancry_scrollView.addSubview(mancry_contentView)
        
        mancry_contentView.addSubview(mancry_infoContainerView)
        mancry_infoContainerView.addSubview(mancry_infoLabel)
        
        mancry_contentView.addSubview(mancry_mainContainerView)
        mancry_mainContainerView.addSubview(mancry_questionTitleLabel)
        mancry_mainContainerView.addSubview(mancry_questionTextView)
        mancry_mainContainerView.addSubview(mancry_charCountLabel)
        mancry_mainContainerView.addSubview(mancry_uploadButton)
        mancry_mainContainerView.addSubview(mancry_imagesContainerView)
        
        view.addSubview(mancry_submitButton)
    }
    
    private func mancry_setupConstraints() {
        
        // 提交按钮
        mancry_submitButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }
        
        // 滚动视图
        mancry_scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(44)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(mancry_submitButton.snp.top).offset(-16)
        }
        
        // 内容容器
        mancry_contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(mancry_scrollView)
        }
        
        // 提示信息容器
        mancry_infoContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        mancry_infoLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        // 主容器
        mancry_mainContainerView.snp.makeConstraints { make in
            make.top.equalTo(mancry_infoContainerView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        // 问题标题
        mancry_questionTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
        }
        
        // 问题输入框
        mancry_questionTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mancry_questionTitleLabel.snp.bottom).offset(12)
            make.height.equalTo(180)
        }
        
        // 字数统计
        mancry_charCountLabel.snp.makeConstraints { make in
            make.right.equalTo(mancry_questionTextView).offset(-8)
            make.bottom.equalTo(mancry_questionTextView).offset(-8)
        }
        
        // 上传按钮
        mancry_uploadButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mancry_questionTextView.snp.bottom).offset(16)
            make.height.equalTo(44)
        }
        
        // 图片容器
        mancry_imagesContainerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mancry_uploadButton.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(110) // 初始高度为0，动态调整
        }
    }
    
    // MARK: - Actions
    
    @objc private func mancry_uploadButtonTapped() {
        print("select picture")
        // 检查是否已达到最大数量
        if mancry_selectedImages.count >= mancry_maxImageCount {
//            mac_centerToastViewwithMsg(msg: "You can upload up to \(mancry_maxImageCount) images")
            return
        }
        
        mancry_showImagePicker()
    }
    
    @objc private func mancry_submitButtonTapped() {
        // 验证输入
        let questionText = mancry_questionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if questionText.isEmpty {
            mac_centerToastViewwithMsg(msg: "Please enter your question")
            return
        }
        
        // 提交反馈
        mancry_submitFeedback(question: questionText)
    }
    
    // MARK: - Image Picker
    
    private func mancry_showImagePicker() {
        self.mancry_openPhotoLibrary()
    }
    
  
    
    private func mancry_openPhotoLibrary() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = false
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true)
    }
    
    // MARK: - Image Handling
    
    private func mancry_handleSelectedImage(_ image: UIImage) {
        // 压缩图片
        guard let compressedImage = mancry_compressImage(image, maxSize: mancry_maxFileSize) else {
            mac_centerToastViewwithMsg(msg: "Image compression failed")
            return
        }
        
        // 添加到列表
        mancry_selectedImages.append(compressedImage)
        
        // 上传图片
        mancry_uploadImage(compressedImage)
        
        // 更新UI
        mancry_updateImagesContainer()
    }
    
    /// 压缩图片到指定大小以下
    private func mancry_compressImage(_ image: UIImage, maxSize: Int) -> UIImage? {
        var compression: CGFloat = 0.8
        var imageData = image.jpegData(compressionQuality: compression)
        
        // 如果图片太大，先缩小尺寸
        var targetImage = image
        let maxDimension: CGFloat = 1200
        if image.size.width > maxDimension || image.size.height > maxDimension {
            let scale = min(maxDimension / image.size.width, maxDimension / image.size.height)
            let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            targetImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
            UIGraphicsEndImageContext()
        }
        
        // 逐步降低质量直到满足大小要求
        while let data = imageData, data.count > maxSize && compression > 0.1 {
            compression -= 0.1
            imageData = targetImage.jpegData(compressionQuality: compression)
        }
        
        guard let finalData = imageData, finalData.count <= maxSize else {
            return nil
        }
        
        return UIImage(data: finalData)
    }
    
    /// 更新图片容器UI
    private func mancry_updateImagesContainer() {
        // 清除旧的图片视图
        mancry_imagesContainerView.subviews.forEach { $0.removeFromSuperview() }
        
        let imageSize: CGFloat = (mancry_Width - 40 - 48)/3
        let spacing: CGFloat = 10
        
        guard !mancry_selectedImages.isEmpty else {
            // 使用 remakeConstraints 更新高度约束为0
            mancry_imagesContainerView.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.top.equalTo(mancry_uploadButton.snp.bottom).offset(16)
                make.bottom.equalToSuperview().offset(-16)
                make.height.equalTo(0)
            }
            return
        }
        
        for (index, image) in mancry_selectedImages.enumerated() {
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            imageView.tag = index
            
            // 删除按钮
            let deleteButton = UIButton(type: .custom)
            deleteButton.setImage(UIImage(named: "flbeql_feedback_delete"), for: .normal)
            deleteButton.tag = index
            deleteButton.addTarget(self, action: #selector(mancry_deleteImage(_:)), for: .touchUpInside)
            
            let containerView = UIView()
            containerView.addSubview(imageView)
            containerView.addSubview(deleteButton)
            
            mancry_imagesContainerView.addSubview(containerView)
            
            let x = CGFloat(index) * (imageSize + spacing)
            containerView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(x)
                make.top.equalToSuperview()
                make.width.height.equalTo(imageSize)
                make.height.equalTo(110)
            }
            
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            deleteButton.snp.makeConstraints { make in
                make.top.left.equalToSuperview().offset(4)
                make.width.height.equalTo(20)
            }
        }
        
        // 使用 remakeConstraints 更新容器高度
        mancry_imagesContainerView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mancry_uploadButton.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(imageSize)
        }
    }
    
    @objc private func mancry_deleteImage(_ sender: UIButton) {
        let index = sender.tag
        guard index < mancry_selectedImages.count else { return }
        
        // 删除图片
        mancry_selectedImages.remove(at: index)
        if index < mancry_uploadedImageUrls.count {
            mancry_uploadedImageUrls.remove(at: index)
        }
        
        // 更新UI
        mancry_updateImagesContainer()
    }
    
    // MARK: - Network Requests
    
    /// 上传图片
    private func mancry_uploadImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            mac_centerToastViewwithMsg(msg: "Image data conversion failed")
            return
        }
        
        self.mac_PopLoadingView()
        
        // 创建上传请求
//        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: [:], isSign: false)
        
        let clientTime = Mancry_PublicMethodS.mancryy_getcurrentmzhieClientwhTimeStr()
        let nonce = Mancry_PublicMethodS.mancry_gen16stringwoshiwhystr()
        
        let defaults = UserDefaults.standard
        let tokenStr = defaults.string(forKey: "token") ?? ""
        let userIdStr = defaults.string(forKey: "userId") ?? ""
        
        let deviceId = mancry_deviceId
        let appId = mancry_appId
       
        guard let signsDic = [
            
            "appId": "\(appId)",
            "nonce": "\(nonce)",
            "deviceId": deviceId,
            "channel": "app_store",
            "version": "2.0"
            
        ] as? [String : String] else { return  }
        
        let signStr = Mancry_PublicMethodS.mancryy_getrequestSignwithDicsortStr(with: signsDic) ?? ""
        
        
        guard let parametersDic = [
            "nonce": nonce,
            "deviceId": deviceId,
            "sign": signStr,
            "clientVersion": mancry_clientVersion ?? "",
            "appId": appId,
            "token": tokenStr,
            "os": "2",
            "data": [
            ],
            "clientTime": "\(clientTime)",
            "channel": "app_store",
            "userId": userIdStr,
            "version": "2.0",
            "clientLanguage": "en"
//            "file":imgData
        ] as? [String : Any] else{return}
        
        
        // 构建完整的上传URL
        let urlStr = UserDefaults.standard.object(forKey: "mancry_urlStr")
        
        let uploadURL = urlStr as! String + "/app/v3/sys/upload"
        
        // 使用 multipart/form-data 上传
        Mancry_RequestData.mancry_uploadImagedata(
            imageData,
            mancry_baseParams: parametersDic,
            mancry_uploadURL: uploadURL,
            mancry_progress: { _ in }
        ) { [weak self] result in
            self?.mac_hiddenLoadingView()
            
            switch result {
            case .success(let responseData):
                guard let data = responseData,
                      let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    self?.mac_centerToastViewwithMsg(msg: "Failed to parse response")
                    // 上传失败，移除对应的图片
                    if let count = self?.mancry_selectedImages.count, count > 0 {
                        self?.mancry_selectedImages.removeLast()
                        self?.mancry_updateImagesContainer()
                    }
                    return
                }
                
                let code = jsonObject["resultCode"] as? Int ?? -1
                if code == 200 {
                    if let dataDict = jsonObject["data"] as? [String: Any],
                       let imageUrl = dataDict["src"] as? String {
                        self?.mancry_uploadedImageUrls.append(imageUrl)
                        print("图片上传成功")
                    } else {
                        self?.mac_centerToastViewwithMsg(msg: "Failed to get image URL")
                        // 上传失败，移除对应的图片
                        if let count = self?.mancry_selectedImages.count, count > 0 {
                            self?.mancry_selectedImages.removeLast()
                            self?.mancry_updateImagesContainer()
                        }
                    }
                } else {
                    let message = jsonObject["resultMsg"] as? String ?? "Image upload failed"
                    self?.mac_centerToastViewwithMsg(msg: message)
                    // 上传失败，移除对应的图片
                    if let count = self?.mancry_selectedImages.count, count > 0 {
                        self?.mancry_selectedImages.removeLast()
                        self?.mancry_updateImagesContainer()
                    }
                }
                
            case .failure(let error):
                self?.mac_centerToastViewwithMsg(msg: "Network error, please try again")
                // 上传失败，移除对应的图片
                if let count = self?.mancry_selectedImages.count, count > 0 {
                    self?.mancry_selectedImages.removeLast()
                    self?.mancry_updateImagesContainer()
                }
            }
        }
    }
    
    /// 提交反馈
    private func mancry_submitFeedback(question: String) {
        var pictureString = ""
        if !mancry_uploadedImageUrls.isEmpty {
            pictureString = mancry_uploadedImageUrls.joined(separator: ", ")
        }
        
        let requestData: [String: Any] = [
            "description": question,
            "pictureUrl": pictureString
        ]
//        print("submit - \(requestData)")
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: requestData, isSign: false)
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else {
            mac_centerToastViewwithMsg(msg: "Request failed")
            return
        }
        
        self.mac_PopLoadingView()
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/user/problemFeedback",
            httpBody: postData,
            successCallBack: { [weak self] result in
                self?.mac_hiddenLoadingView()
                let code = result["resultCode"] as? Int ?? -1
                if code == 200 {
                    self?.mac_centerToastViewwithMsg(msg: "Thanks for your feedback！")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.navigationController?.popViewController(animated: true)
                    }
                } else {
                    let message = result["resultMsg"] as? String ?? ""
                    self?.mac_centerToastViewwithMsg(msg: message)
                }
            },
            failureCallBack: { [weak self] error in
                self?.mac_hiddenLoadingView()
                self?.mac_centerToastViewwithMsg(msg: "Network error, please try again")
            }
        )
    }
}

// MARK: - UITextViewDelegate

extension Mancry_MeTwoVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        let count = text.count
        
        // 限制最大长度
        if count > 1000 {
            let index = text.index(text.startIndex, offsetBy: 1000)
            textView.text = String(text[..<index])
            mancry_charCountLabel.text = "1000/1000"
        } else {
            mancry_charCountLabel.text = "\(count)/1000"
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension Mancry_MeTwoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            mac_centerToastViewwithMsg(msg: "Failed to get image")
            return
        }
        
        mancry_handleSelectedImage(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UITextView Placeholder Extension

extension UITextView {
    private struct AssociatedKeys {
        static var placeholder = "placeholder"
    }
    
    var placeholder: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.placeholder) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.placeholder, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(textViewDidChangePlaceholder),
                name: UITextView.textDidChangeNotification,
                object: self
            )
            setNeedsDisplay()
        }
    }
    
    @objc private func textViewDidChangePlaceholder() {
        setNeedsDisplay()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let placeholder = placeholder, text.isEmpty {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(hex: "#999999") ?? .gray,
                .font: UIFont.systemFont(ofSize: 14, weight: .regular)
            ]
            let rect = CGRect(x: 16, y: 12, width: bounds.width - 32, height: bounds.height - 24)
            placeholder.draw(in: rect, withAttributes: attributes)
        }
    }
}

