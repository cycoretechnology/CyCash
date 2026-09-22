

import UIKit
import IQKeyboardManagerSwift


var  mancry_UrlStr = "https://api.cycashph.com"
var  mancry_homeNumCap = 0
var  mancry_Total = 0
var  mancry_onceTotal = 0

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var mancry_numIndex = 0

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
         
         UserDefaults.standard.set(mancry_UrlStr, forKey: "mancry_urlStr")
         UserDefaults.standard.synchronize()
          
            
        self.mac_getdototailbaseConfigData()
        
        
         let mancrytoken = UserDefaults.standard.object(forKey: "token")
         if mancrytoken == nil || mancrytoken as! String == ""{
             let nav = Mancry_NavigationController(rootViewController: Mancry_LoginInVC())
             self.window?.rootViewController = nav
             
         }else{
             let nav = Mancry_NavigationController(rootViewController: Mancry_doTotalVC())

             self.window?.rootViewController = nav
         }
        
        mancry_creatkeyboardmanager()
        
        mancry_runSceneNoiseCode()
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func mancry_creatkeyboardmanager(){
            IQKeyboardManager.shared.isEnabled = true
            IQKeyboardManager.shared.enableAutoToolbar = true  //
            IQKeyboardManager.shared.resignOnTouchOutside = true
        
    }
    
    private func mancry_runSceneNoiseCode() {
        let dummyArray = (0..<5).map { $0 * 3 }
        let filtered = dummyArray.filter { $0 % 2 == 0 }
        let sum = filtered.reduce(0, +)
        let _ = ["count": filtered.count, "sum": sum] as [String: Int]
    }
    func mac_getdototailbaseConfigData() {
        let mancry_parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: [:], isSign: false)
        guard let mancry_postData = try? JSONSerialization.data(withJSONObject: mancry_parametersDic) else { return }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/app/config",
            httpBody: mancry_postData,
            successCallBack: { [weak self] mancry_result in
                guard let self = self else { return }
                
            },
            failureCallBack: { [weak self] mancry_error in
                
                
            }
        )
    }
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

