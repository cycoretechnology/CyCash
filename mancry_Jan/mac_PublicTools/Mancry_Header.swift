

import Foundation
import UIKit



let mancry_appId = "cycash"
let mancry_salt = "ZDEqguGMcHgbd3Ai"

let mancry_clientVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]

let mancry_deviceId = Mancry_getDevicebaseData.mancry_getdeviceIdUUID()


public var mancry_StatusBarHeight: CGFloat {
    let application = UIApplication.shared
    return application.statusBarFrame.height
}

let mancry_Height = max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
let mancry_Width = min(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
let mancry_stateHeight = UIApplication.shared.statusBarFrame.height
let mancry_NavBarHeight = mancry_stateHeight + 44
