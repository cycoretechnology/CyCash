
import UIKit
import CoreLocation
import Contacts
import Foundation
import CommonCrypto


class Mancry_PublicMethodS: NSObject {


        @objc static func mancryy_getcurrentmzhieClientwhTimeStr() -> Int64 {
            let timestampMilliseconds = Int64(Date().timeIntervalSince1970 * 1000)

              return timestampMilliseconds
          }
       
      
        @objc static func mancry_gen16stringwoshiwhystr() -> String {
            generateUppercaseString(length: 16)
        }
        
        static func generateUppercaseString(length: Int) -> String {
               
               let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
               let characterArray = Array(characters)
               var result = ""
               
               for _ in 0..<length {
                   let randomIndex = Int(arc4random_uniform(UInt32(characterArray.count)))
                   result.append(characterArray[randomIndex])
               }
               
               return result
           }
        static func getIdentifierForVendor() -> String? {
             return UIDevice.current.identifierForVendor?.uuidString
         }
         
        
        static func mancryy_findCurrentShowVC() -> UIViewController? {
            
            var mancry_window: UIWindow? = UIApplication.shared.delegate?.window ?? nil
            
            if mancry_window?.windowLevel != .normal {
                let windows = UIApplication.shared.windows
                for tmpWin in windows {
                    if tmpWin.windowLevel == .normal {
                        mancry_window = tmpWin
                        break
                    }
                }
            }
            guard let rootVC = mancry_window?.rootViewController else {
                return nil
            }
            var mancry_activeVC: UIViewController? = rootVC
            
            while true {
                if let mancry_navVC = mancry_activeVC as? UINavigationController {
                    mancry_activeVC = mancry_navVC.visibleViewController
                } else if let mancry_tabVC = mancry_activeVC as? UITabBarController {
                    mancry_activeVC = mancry_tabVC.selectedViewController
                } else if let mancry_presentedVC = mancry_activeVC?.presentedViewController {
                    mancry_activeVC = mancry_presentedVC
                } else if let mancry_lastChild = mancry_activeVC?.children.last {
                    /// last window
                    mancry_activeVC = mancry_lastChild
                } else {
                    break
                }
            }
            return mancry_activeVC
        }
        
        
        static func mancryy_getmyProDeviceModel() -> String {
            
            let hardwareIdentifier = getHardwareIdentifier()
            return mancryy_getwihtHardwareIdentifierToModelid(hardwareIdentifier)
        }
        
        @objc static func figures_userAgment() -> String{
            
            let mancry_deviceModel = Mancry_PublicMethodS.mancryy_getmyProDeviceModel()
            let mancry_version = UIDevice.current.systemVersion
            let mancry_userAgment = "\(mancry_appId)/\("1.0.0") (Apple;Mobile;\(mancry_deviceModel);iOS \(mancry_version)"
            return mancry_userAgment
        }
        
        private static func getHardwareIdentifier() -> String {
            var systemInfo = utsname()
            uname(&systemInfo)
            
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children
                .compactMap { $0.value as? Int8 }
                .filter { $0 != 0 }
                .map { String(UnicodeScalar(UInt8($0))) }
                .joined()
            
            return identifier
        }
        
        private static func mancryy_getwihtHardwareIdentifierToModelid(_ identifier: String) -> String {
            switch identifier {
            case "iPhone7,1": return "iPhone 6 Plus"
            case "iPhone7,2": return "iPhone 6"
            case "iPhone8,1": return "iPhone 6s"
            case "iPhone8,2": return "iPhone 6s Plus"
            case "iPhone8,4": return "iPhone SE (1st generation)"
            case "iPhone9,1", "iPhone9,3": return "iPhone 7"
            case "iPhone9,2", "iPhone9,4": return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4": return "iPhone 8"
            case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6": return "iPhone X"
            case "iPhone11,2": return "iPhone XS"
            case "iPhone11,4", "iPhone11,6": return "iPhone XS Max"
            case "iPhone11,8": return "iPhone XR"
            case "iPhone12,1": return "iPhone 11"
            case "iPhone12,2": return "iPhone 11 Pro Max"
            case "iPhone12,3": return "iPhone 11 Pro"
            case "iPhone12,4": return "iPhone SE (2nd generation)"
            case "iPhone13,1": return "iPhone 12 mini"
            case "iPhone13,2": return "iPhone 12"
            case "iPhone13,3": return "iPhone 12 Pro"
            case "iPhone13,4": return "iPhone 12 Pro Max"
            case "iPhone17,1": return "iPhone SE (3rd generation)"
            case "iPhone14,1": return "iPhone 13 Pro"
            case "iPhone14,2": return "iPhone 13 Pro Max"
            case "iPhone14,3": return "iPhone 13"
            case "iPhone14,4": return "iPhone 13 mini"
            case "iPhone14,5": return "iPhone 14"
            case "iPhone14,8": return "iPhone 14 Plus"
            case "iPhone15,2": return "iPhone 14 Pro"
            case "iPhone15,3": return "iPhone 14 Pro Max"
            case "iPhone15,4": return "iPhone 15"
            case "iPhone15,5": return "iPhone 15 Plus"
            case "iPhone16,1": return "iPhone 15 Pro"
            case "iPhone16,2": return "iPhone 15 Pro Max"
            case "iPhone16,3": return "iPhone 16"
            case "iPhone16,4": return "iPhone 16 Plus"
            case "iPhone16,5": return "iPhone 16 Pro"
            case "iPhone16,6": return "iPhone 16 Pro Max"
            case "iPhone18,1": return "iPhone 17 Pro"
            case "iPhone18,2": return "iPhone 17 Pro Max"
            case "iPhone18,3": return "iPhone 17"
            case "iPhone18,4": return "iPhone Air"
            case "iphone18,5": return "iPhone 17e"
            case "iPhone19,2": return "iPhone 18 Pro"
            case "iPhone19,3": return "iPhone 18 Pro Max (USA)"
            case "iPhone19,7": return "iPhone 18 Pro Max"
            case "iPhone19,4": return "iPhone Duo"
            // iPad
            case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7": return "iPad Air (5th generation)"
            case "iPad14,1", "iPad14,2": return "iPad mini (6th generation)"
            case "iPad14,3", "iPad14,4": return "iPad Air (6th generation)"
            case "iPad14,5", "iPad14,6": return "iPad (10th generation)"
            case "iPad15,1", "iPad15,2": return "iPad Pro 11-inch (4th generation)"
            case "iPad15,3", "iPad15,4": return "iPad Pro 12.9-inch (6th generation)"
                
    
            default: return identifier
            }
        }
        
        // MARK: - 签名相关（Swift 实现）
        
        @objc static func mancryy_getrequestSignwithDicsortStr(with dic: [String: String]?) -> String? {
            guard let dic = dic, dic.isEmpty == false else {
                return nil
            }
            
            let sortedValues = dic.values.sorted { $0.compare($1) == .orderedAscending }
            
            
            var descendingList: [String] = []
            for idx in stride(from: sortedValues.count - 1, through: 0, by: -1) {
                descendingList.append(sortedValues[idx])
            }
            
            let sortStr = descendingList.joined(separator: ";")
            
            let allStr = sortStr + mancry_salt
            // MD5（大写）
            let md5Str = mancryy_towhithmd5str(allStr)
            
            return md5Str
            
        }
        
        static func mancryy_towhithmd5str(_ str: String) -> String {
            return str.toMd5String()
        }
        
        
        @objc static func mancry_publicRequestBody(with data: [String: Any]? = nil, isSign: Bool = false,_ signDic: [String: Any]? = nil, _ isSubSign: Bool = false) -> [String: Any] {
            let clientTime = Mancry_PublicMethodS.mancryy_getcurrentmzhieClientwhTimeStr()
            let nonce = Mancry_PublicMethodS.mancry_gen16stringwoshiwhystr()
            
            let defaults = UserDefaults.standard
            let tokenStr = defaults.string(forKey: "token") ?? ""
            let userIdStr = defaults.string(forKey: "userId") ?? ""
            
            let deviceId = mancry_deviceId
            let appId = mancry_appId
            let channel = "app_store"
            let version = "2.0"
            let os = "2"
            let clientLanguage = "en"
            
            var bizData: [String: Any] = data ?? [:]
            
            // 签名字段字典（要求 String:String）
            var signsDic: [String: String] = [:]
            if isSign == true{
                for (k, v) in bizData {
                    signsDic[k] = "\(v)"
                }
            }
            
            if isSubSign == true{
                let orderIdData: [String: Any] = signDic ?? [:]
                for (k, v) in orderIdData {
                    signsDic[k] = "\(v)"
                }
            }else{
                if signDic?.count ?? 0 > 0{
                    let orderIdData: [String: Any] = signDic ?? [:]
                    for (k, v) in orderIdData {
                        bizData[k] = "\(v)"
                    }
                }
             
            }
          
            signsDic["appId"] = appId
            signsDic["nonce"] = nonce
            signsDic["deviceId"] = deviceId
            signsDic["channel"] = channel
            signsDic["version"] = version
            
            let signStr = Mancry_PublicMethodS.mancryy_getrequestSignwithDicsortStr(with: signsDic) ?? ""
            
            var body: [String: Any] = [:]
            body["nonce"] = nonce
            body["deviceId"] = deviceId
            body["sign"] = signStr
            body["clientVersion"] = mancry_clientVersion ?? "1.0.0"
            body["appId"] = appId
            body["token"] = tokenStr
            body["os"] = os
            body["data"] = bizData
            body["clientTime"] = clientTime
            body["channel"] = channel
            body["userId"] = userIdStr
            body["version"] = version
            body["clientLanguage"] = clientLanguage
            return body
        }
      
    
    
    
    
    // MARK: - Location
    private final class Mancry_LocationProbe: NSObject, CLLocationManagerDelegate {
        private let manager: CLLocationManager
        private var callback: ((double_t, double_t, Bool, NSError?) -> Void)?
        private var didFinish = false
        private var hasRequestedAuth = false
        private var timeoutTimer: Timer?

        override init() {
            self.manager = CLLocationManager()
            super.init()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        }

        func start(_ completion: @escaping (double_t, double_t, Bool, NSError?) -> Void) {
            callback = completion

            let status: CLAuthorizationStatus
            if #available(iOS 14.0, *) {
                status = manager.authorizationStatus
            } else {
                status = CLLocationManager.authorizationStatus()
            }

            // 设置超时定时器（30秒）
            timeoutTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false) { [weak self] _ in
                self?.handleTimeout()
            }

            switch status {
            case .notDetermined:
                hasRequestedAuth = true
                manager.requestWhenInUseAuthorization()
                // 不要在这里直接返回，等待权限回调
            case .authorizedAlways, .authorizedWhenInUse:
                manager.requestLocation()
            case .restricted, .denied:
                finish(latitude: 0, longitude: 0, authorized: false, error: nil)
            @unknown default:
                finish(latitude: 0, longitude: 0, authorized: false, error: nil)
            }
        }

        private func handleTimeout() {
            let error = NSError(domain: "LocationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Location request timeout"])
            finish(latitude: 0, longitude: 0, authorized: false, error: error)
        }

        private func finish(latitude: double_t, longitude: double_t, authorized: Bool, error: NSError?) {
            guard !didFinish else { return }
            didFinish = true
            
            // 取消定时器
            timeoutTimer?.invalidate()
            timeoutTimer = nil
            
            let block = callback
            callback = nil
            DispatchQueue.main.async {
                block?(latitude, longitude, authorized, error)
            }
        }

        // iOS 14+
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            // 避免初始化时的重复调用
            guard callback != nil else { return }
            
            let status = manager.authorizationStatus
            handleAuthChange(status: status)
        }

        // iOS 13-
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            // 避免初始化时的重复调用
            guard callback != nil else { return }
            
            handleAuthChange(status: status)
        }

        private func handleAuthChange(status: CLAuthorizationStatus) {
            // 如果已经完成，不再处理
            guard !didFinish else { return }
            
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                manager.requestLocation()
            case .restricted, .denied:
                // 只有在用户明确拒绝后才返回失败
                if hasRequestedAuth {
                    finish(latitude: 0, longitude: 0, authorized: false, error: nil)
                }
            case .notDetermined:
                // 仍在等待用户决定，不做处理
                break
            @unknown default:
                finish(latitude: 0, longitude: 0, authorized: false, error: nil)
            }
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let last = locations.last else {
                finish(latitude: 0, longitude: 0, authorized: true, error: nil)
                return
            }
            print("定位状态改变")
            finish(latitude: last.coordinate.latitude, longitude: last.coordinate.longitude, authorized: true, error: nil)
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            finish(latitude: 0, longitude: 0, authorized: true, error: error as NSError)
        }
        
        deinit {
            timeoutTimer?.invalidate()
        }
    }

    private static var mancry_locationProbe: Mancry_LocationProbe?

    
    @objc static func getLocationWithCompletion(_ completion: @escaping (Double, Double, Bool, NSError?) -> Void) {
        let probe = Mancry_LocationProbe()
        mancry_locationProbe = probe
        probe.start { lat, lng, ok, err in
            // retain-cycle breaker: one-shot
            mancry_locationProbe = nil
            completion(lat, lng, ok, err)
        }
    }

    // MARK: - Contacts
    /// Swift 版：获取通讯录权限状态；若未决定则先请求一次，再回调。
    @objc static func getContactsPermissionStatusWithCompletion(_ completion: @escaping (Bool) -> Void) {
        let current = CNContactStore.authorizationStatus(for: .contacts)

        let replyOnMain: (Bool) -> Void = { granted in
            DispatchQueue.main.async { completion(granted) }
        }

        switch current {
        case .authorized:
            replyOnMain(true)
        case .denied, .restricted:
            replyOnMain(false)
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { granted, _ in
                replyOnMain(granted)
            }
        case .limited:
            replyOnMain(true)
        @unknown default:
            replyOnMain(false)
        }
    }
}

extension String {
    func toMd5String() -> String {
        guard let originalStr = self.cString(using: .utf8) else {
            return ""
        }
        
        var result = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(originalStr, CC_LONG(strlen(originalStr)), &result)
        
        let hash = NSMutableString()
        for i in 0..<16 {
            hash.appendFormat("%02X", result[i])
        }
        return hash as String
    }
}
