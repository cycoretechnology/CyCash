

import UIKit
import KeyboardMan
import PKHUD
import Toast_Swift

class Mac_BaseViewController: UIViewController, UIGestureRecognizerDelegate {

    let keyboardMan = KeyboardMan()
    private var seriverbtn: UIButton?
private var isUpload = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(hex: "#EDF1D8")
        self.navigationController?.navigationBar.isHidden = true

        mac_keyboardState()
        
        DispatchQueue.global(qos: .utility).async {
            mancryse_runNoiseChorus()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(mancry_UploadVersion(_:)), name: NSNotification.Name.init(rawValue: "mancry_UploadVersion"), object: nil)
        
    }
    
    @objc func mancry_UploadVersion(_ notice:Notification){
        mancrybase_touploadNewVersionData()
        
    }
    
    
    func mancrybase_touploadNewVersionData(){
        if isUpload == false{
            isUpload = true
        }else{
            return
        }
        let mancry_parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: [:], isSign: false)
        guard let mancry_postData = try? JSONSerialization.data(withJSONObject: mancry_parametersDic) else { return }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/app/versionV2",
            httpBody: mancry_postData,
            successCallBack: { [weak self] mancry_result in
                guard let self = self else { return }
                let mancry_code = mancry_result["resultCode"] as? Int ?? -1
                guard mancry_code == 200,
                      let mancry_dataDict = mancry_result["data"] as? [String: Any] else {
                    let mancry_msg = mancry_result["resultMsg"] as? String ?? ""
                    self.mac_centerToastViewwithMsg(msg: mancry_msg)
                    return
                }
//                print("版本升级-\(mancry_result)")
              let mancry_typeStr = mancry_dataDict["updateType"] as? String ?? ""
                let mancry_uploadStr = mancry_dataDict["latestVersionUrl"] as? String ?? ""
                if mancry_typeStr == "1"{
                    let forceUpgradePopView = Mancry_PopView(type: .upgrade)
                    forceUpgradePopView.configure(
                        topImageName: "flbeql_tk_gx",
                        title: "Upgrade",
                        description: "New version found",
                        rightButtonTitle: "Upgrade"
                    )
                    forceUpgradePopView.onRightButtonTapped = {
                        // 处理升级逻辑，弹窗不会自动关闭
                        // 需要手动调用 forceUpgradePopView.dismiss() 来关闭
                        guard let url  = URL(string: mancry_uploadStr ) else { return  }
                        UIApplication.shared.open(url, options: [:])
                    }
                    forceUpgradePopView.show()
                }else if mancry_typeStr == "2"{
                    let forceUpgradePopView = Mancry_PopView(type: .forceUpgrade)
                    forceUpgradePopView.configure(
                        topImageName: "flbeql_tk_gx",
                        title: "Upgrade",
                        description: "New version found",
                        rightButtonTitle: "Upgrade"
                    )
                    forceUpgradePopView.onRightButtonTapped = {
                        // 处理升级逻辑，弹窗不会自动关闭
                        // 需要手动调用 forceUpgradePopView.dismiss() 来关闭
                        guard let url  = URL(string: mancry_uploadStr ) else { return  }
                        UIApplication.shared.open(url, options: [:])
                    }
                    forceUpgradePopView.show()
                }
                
             
                
                
            },
            failureCallBack: { [weak self] mancry_error in
                self?.mac_centerToastViewwithMsg(msg: "Config request failed, please try again")
                print("Config request error: \(mancry_error.localizedDescription)")
            }
        )
    }
    

    // MARK: - Orientation (default portrait for all pages inheriting this base VC)
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return false
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let button = seriverbtn else { return }
        view.bringSubviewToFront(button)

    }
    
    

    @objc private func mac_ClickPan(_ gesture: UIPanGestureRecognizer) {
        guard let button = seriverbtn, let targetView = gesture.view?.superview else { return }
        let translation = gesture.translation(in: targetView)
        var newCenter = CGPoint(x: button.center.x + translation.x,
                                y: button.center.y + translation.y)
        let halfWidth = button.bounds.width / 2
        let halfHeight = button.bounds.height / 2
        let safeArea = view.safeAreaInsets
        let minX = halfWidth
        let maxX = targetView.bounds.width - halfWidth
        let minY = halfHeight + safeArea.top
        let maxY = targetView.bounds.height - halfHeight - safeArea.bottom
        newCenter.x = max(minX, min(maxX, newCenter.x))
        newCenter.y = max(minY, min(maxY, newCenter.y))
        button.center = newCenter
        gesture.setTranslation(.zero, in: targetView)
    }
    
    
    public func mac_publiccustomnavView(title: String) {
       
        let navV = UIView(frame: CGRectMake(0, 0,mancry_Width , mancry_NavBarHeight))
//        navV.backgroundColor = UIColor(hex: "#DFE4C6")
        self.view.addSubview(navV)
        
        let imgV = UIImageView(frame: navV.frame);
        imgV.image = UIImage(named: "bzkyc_bg")
        imgV.contentMode = .scaleToFill
        navV.addSubview(imgV)
        let backBtn = UIButton(frame: CGRectMake(0, mancry_stateHeight, 80, 44))
        backBtn.setImage(UIImage(named: "flbeql_fh"), for: .normal)
        backBtn.addTarget(self, action: #selector(mancry_backbtnAction), for: .touchUpInside)
        let titleLab = UILabel(frame: CGRectMake(mancry_Width/2 - 100, mancry_stateHeight, 200, 44))
        titleLab.text = title
        titleLab.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        titleLab.textAlignment = .center
        
        navV.addSubview(backBtn)
        navV.addSubview(titleLab)
      
    }
   
    @objc func mancry_backbtnAction(){
        
        self.navigationController?.popViewController(animated: true)
        
    }

    
    func mac_centerToastViewwithMsg(msg: String){
        self.view.makeToast(msg, point: CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2), title: nil, image: nil, completion: nil)
    }

    
    func mac_PopLoadingView(){
        DispatchQueue.main.async {
            HUD.show(.progress)
           
        }
    }
    func mac_hiddenLoadingView(){
        DispatchQueue.main.async {
            HUD.hide()
        }

    }
    
    
           
    func mac_keyboardState(){
             // 配置键盘弹出时的动画
        keyboardMan.animateWhenKeyboardAppear = { [weak self] _, keyboardHeight, _ in
                   

               }
               // 配置键盘收回时的动画
        keyboardMan.animateWhenKeyboardDisappear = { [weak self] _ in
                 
               }
        
             
             let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
             tap.cancelsTouchesInView = false
             tap.delegate = self
             view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
           view.endEditing(true) // 回收键盘核心方法
       }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var current: UIView? = touch.view
        while let view = current {
            if view is UITableView || view is UITableViewCell || view is UIControl {
                return false
            }
            if view is Mancry_customselectPopupView {
                return false
            }
            current = view.superview
        }
        return true
    }

}
