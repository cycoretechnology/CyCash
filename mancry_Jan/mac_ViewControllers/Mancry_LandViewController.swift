
import UIKit
import AVFoundation



class Mancry_LandViewController: UIViewController {
    typealias CallBack = (_ img:UIImage) -> Void
    public var CallBack:CallBack?
    
    
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let photoOutput = AVCapturePhotoOutput()
    
    // 预览圆角裁剪容器 + 虚线边框
    private let previewContainerView = UIView()
    private let dashedBorderLayer = CAShapeLayer()
    private let previewCornerRadius: CGFloat = 12
    private let dashedBorderLineWidth: CGFloat = 1
    private let dashedBorderPattern: [NSNumber] = [6, 4]
    
    private let captureButton = UIButton(type: .custom)
    
    private let cancelButton = UIButton(type: .custom)
    private let flashButton = UIButton(type: .custom)
    private let trueBtn = UIButton(type: .custom)
    private let deleteBtn = UIButton(type: .custom)
    private var leftV = UIView()
    private var topV = UIView()
    private var rightV = UIView()
    private var bottomV = UIView()
    private var resultImg = UIImage()
    private var alertLabel = UILabel()
    
    private var currentCameraPosition: AVCaptureDevice.Position = .back
    private var isFlashOn = false
    
    
    var type = 0
    
    private var isTransitioningBack = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkCameraPermissions()
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutPreviewContainer()
        previewLayer?.frame = previewContainerView.bounds
        updateDashedBorder()
    }
    
    @objc private func backAction() {
           guard !isTransitioningBack else { return }
           isTransitioningBack = true
           
           UIView.setAnimationsEnabled(false)
           
           
           if let window = UIApplication.shared.windows.first,
              let rootVC = window.rootViewController {
               
               let tempVC = OrientationHelperViewController()
               window.rootViewController = tempVC
               window.rootViewController?.supportedInterfaceOrientations
               UIViewController.attemptRotationToDeviceOrientation()
               
               if let nav = navigationController {
                   nav.popViewController(animated: false)
               } else {
                   dismiss(animated: false)
               }
               
               window.rootViewController = rootVC
               
                   UIView.setAnimationsEnabled(true)
                   isTransitioningBack = false
           }
       }
       
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           navigationItem.hidesBackButton = true
           
           UIViewController.attemptRotationToDeviceOrientation()
       }
       
       override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
           return .landscapeRight
       }
       
       override var shouldAutorotate: Bool {
           return true
       }
       
       override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
           return .landscapeRight
       }
    
    
    
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.setupCamera()
                    } else {
                        self?.showPermissionAlert()

                    }
                }
            }
        case .denied, .restricted:
            showPermissionAlert()
        @unknown default:
            showPermissionAlert()
            
        }
    }
    
    
    private func showPermissionAlert() {

    
        
    }
    
    
    private func setupCamera() {
        ///********************
        captureSession.sessionPreset = .hd1280x720
        
        guard let captureDevice = getCameraDevice(position: currentCameraPosition),
              let input = try? AVCaptureDeviceInput(device: captureDevice),
              captureSession.canAddInput(input) else {
            
            return
        }
        
        captureSession.addInput(input)
        
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .landscapeRight
        
        previewContainerView.layer.insertSublayer(previewLayer, at: 0)
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
        
    }
    
    
    private func getCameraDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        // 优先超广角，不可用时再回退普通广角等
        let preferredTypes: [AVCaptureDevice.DeviceType] = [
            .builtInUltraWideCamera,
            .builtInWideAngleCamera,
            .builtInDualWideCamera,
            .builtInDualCamera,
            .builtInTrueDepthCamera
        ]
        
        let devices = AVCaptureDevice.DiscoverySession(
            deviceTypes: preferredTypes,
            mediaType: .video,
            position: position
        ).devices
        
        for type in preferredTypes {
            if let device = devices.first(where: { $0.deviceType == type }) {
                return device
            }
        }
        return devices.first
    }
    
    
    private func configureFlash(for device: AVCaptureDevice) {
        guard device.hasFlash else {
            flashButton.isHidden = true
            return
        }
        
        do {
            try device.lockForConfiguration()
            device.torchMode = .off
            device.unlockForConfiguration()
            isFlashOn = false
        } catch {
            print(": \(error)")
            flashButton.isHidden = true
        }
    }
    
    
    private func setupUI() {
        let surroundingColor = UIColor(hex: "#EDF1D8") ?? .black
        view.backgroundColor = surroundingColor
        
        // 预览容器（圆角裁剪 + 虚线边框）
        previewContainerView.backgroundColor = .clear
        previewContainerView.layer.cornerRadius = previewCornerRadius
        previewContainerView.layer.masksToBounds = true
        view.addSubview(previewContainerView)
        
        dashedBorderLayer.fillColor = UIColor.clear.cgColor
        dashedBorderLayer.strokeColor = (UIColor(hex: "#EA6818") ?? .white).cgColor
        dashedBorderLayer.lineWidth = dashedBorderLineWidth
        dashedBorderLayer.lineDashPattern = dashedBorderPattern
        previewContainerView.layer.addSublayer(dashedBorderLayer)
        
        leftV = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: view.frame.height))
        leftV.backgroundColor = surroundingColor
        view.addSubview(leftV)
        topV = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
        topV.backgroundColor = surroundingColor
        view.addSubview(topV)
        
        rightV = UIView(frame: CGRect(x: view.frame.width - 137, y: 0, width: 137, height: view.frame.height))
        rightV.backgroundColor = surroundingColor
        view.addSubview(rightV)
        
        bottomV = UIView(frame: CGRect(x: 0, y: view.frame.height - 20, width: view.frame.width, height: 20))
        bottomV.backgroundColor = surroundingColor
        view.addSubview(bottomV)
        
        
        captureButton.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        captureButton.setImage(UIImage(named: "flbeql_kyc_pz"), for: .normal)

        trueBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        trueBtn.addTarget(self, action: #selector(trueBtnAction), for: .touchUpInside)
        trueBtn.setImage(UIImage(named: "flbeql_kyc_sc"), for: .normal)
        trueBtn.isHidden = true
        deleteBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        deleteBtn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        deleteBtn.setImage(UIImage(named: "flbeql_kyc_cxpz"), for: .normal)
        deleteBtn.isHidden = true
        

        cancelButton.setImage(UIImage(named: "flbeql_kyc_fh"), for: .normal)
        cancelButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        cancelButton.addTarget(self, action: #selector(cancelCapture), for: .touchUpInside)
        
        
        
        flashButton.setImage(UIImage(named: "flbeql_kyc_cxpz"), for: .normal)
        flashButton.tintColor = .white
        flashButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        flashButton.addTarget(self, action: #selector(toggleFlash), for: .touchUpInside)
        
        // 提示文案放到虚线框内（previewContainerView 里）
        alertLabel = UILabel(frame: .zero)
        alertLabel.text = "When taking the photo, please align the dotted frame with the edges of your ID."
        alertLabel.textColor = .white
        alertLabel.backgroundColor = .gray
        alertLabel.alpha = 0.8
        alertLabel.numberOfLines = 0
        
        view.addSubview(captureButton)
        view.addSubview(cancelButton)
        view.addSubview(flashButton)
        view.addSubview(trueBtn)
        view.addSubview(deleteBtn)
        previewContainerView.addSubview(alertLabel)
        
        setupLayout()
    }
    
    
    private func setupLayout() {
        
        captureButton.center = CGPoint(x: view.frame.height - 60,y: view.center.x)
     
        cancelButton.center = CGPoint(x: 40,y: view.center.x + 10)
        
        flashButton.center = CGPoint(x: view.frame.width - 40,y: view.frame.height - 60
        )
        leftV.frame = CGRect(x: 0, y: 0, width: 100, height: view.frame.height)
        rightV.frame = CGRect(x: view.frame.height - 137, y: 0, width: 137, height: view.frame.height)
        topV.frame = CGRect(x: 0, y: 0, width: view.frame.height, height: 20)
        bottomV.frame = CGRect(x: 0, y: view.frame.width - 20, width: view.frame.height, height: 20)
        trueBtn.frame = CGRect(x: view.frame.height - 109, y: view.center.x + 34, width: 60, height: 60)
        deleteBtn.frame = CGRect(x: view.frame.height - 109, y: view.center.x - 94, width: 60, height: 60)
        
        layoutPreviewContainer()
        
        // alertLabel 位于虚线框内底部，带内边距
        let padding: CGFloat = 1
        let labelHeight: CGFloat = 44
        alertLabel.frame = CGRect(
            x: padding,
            y: max(padding, previewContainerView.bounds.height - labelHeight - padding),
            width: max(0, previewContainerView.bounds.width - padding * 2),
            height: labelHeight
        )
    }

    private func layoutPreviewContainer() {
        // 这里沿用当前控制器的“横屏坐标习惯”（大量用 view.frame.height 作为横向宽度）
        // 预览区域：位于四周黑边之间
        let left = leftV.frame.maxX
        let top = topV.frame.maxY
        let right = rightV.frame.minX
        let bottom = bottomV.frame.minY
        let width = max(0, right - left)
        let height = max(0, bottom - top)
        previewContainerView.frame = CGRect(x: left, y: top, width: width, height: height)
    }
    
    private func updateDashedBorder() {
        dashedBorderLayer.frame = previewContainerView.bounds
        let inset = dashedBorderLineWidth / 2
        let rect = previewContainerView.bounds.insetBy(dx: inset, dy: inset)
        dashedBorderLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: previewCornerRadius).cgPath
    }
    
    
    @objc private func capturePhoto() {
        
    
        let settings = AVCapturePhotoSettings()
        
        
        if currentCameraPosition == .back, let device = getCameraDevice(position: .back), device.hasFlash {
            settings.flashMode = isFlashOn ? .on : .off
        }
        
        photoOutput.capturePhoto(with: settings, delegate: self)
        
        
        captureButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.2) {
            self.captureButton.transform = .identity
        }
    }
    @objc private func trueBtnAction(){
                if let callBack = self.CallBack{
                    callBack(resultImg)
                }
           self.backAction()
     
    }
    @objc private func cancelBtnAction(){
      
        captureButton.isHidden = false
        trueBtn.isHidden = true
        deleteBtn.isHidden = true
        
        if captureSession.isRunning == false {
            captureSession.startRunning()
        }
    }
    
    
    @objc private func flipCamera() {
        
        captureSession.stopRunning()
        
        
        if let input = captureSession.inputs.first {
            captureSession.removeInput(input)
        }
        
        
        currentCameraPosition = currentCameraPosition == .back ? .front : .back
        
        
        setupCamera()
    }
    
    
    @objc private func cancelCapture() {
        backAction()
      
    }
    
    
    @objc private func toggleFlash() {
        guard currentCameraPosition == .back,
              let device = getCameraDevice(position: .back),
              device.hasFlash else { return }
        
        do {
            try device.lockForConfiguration()
            isFlashOn = !isFlashOn
            device.torchMode = isFlashOn ? .on : .off
            flashButton.tintColor = isFlashOn ? .yellow : .white
            device.unlockForConfiguration()
        } catch {
            print(": \(error)")
        }
    }
    
    private func processCapturedImage(_ image: UIImage) {
        captureButton.isHidden = true
        trueBtn.isHidden = false
        deleteBtn.isHidden = false
        
         resultImg = image
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    deinit {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
}


extension Mancry_LandViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {

            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let capturedImage = UIImage(data: imageData) else {

            return
        }
        
        
        let fixedImage = fixImageOrientation(for: capturedImage)
        guard let img = fixedImage.mancry_rotateLeftDegreesImg() else { return  }
        processCapturedImage(img)
    }
    
    
    private func fixImageOrientation(for image: UIImage) -> UIImage {
        
        guard image.imageOrientation != .up else { return image }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage ?? image
    }
}


class OrientationHelperViewController: UIViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
