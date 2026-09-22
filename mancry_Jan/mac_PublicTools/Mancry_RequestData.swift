

import UIKit
import Alamofire
import HandyJSON

typealias SuccessCallBack = (_ result: [String: Any]) -> Void
typealias FailureCallBack = (_ error: Error) -> Void

class Mancry_RequestData: NSObject {
    
    var methodType : HTTPMethod = .post
    var url : String = ""
    var parameters : [String : Any] = [:]
    var isNestedData : Bool = false
    var useBaseUrl : Bool = false
    var file : String = "0"
    var lineNum : Int = 0
    var successCallBack : ((_ result:[String: Any]) -> ())?
    var failureCallBack : ((_ error: Error) -> ())?
    
    static let lastNetWorkRequestParamers = Mancry_RequestData()
    
    // MARK: - Junk Code for Binary Variation
    private static var fig_requestJunkCache: [String: Any] = [:]
    private static var fig_requestRandomSeed: Int = 0
    private static var fig_requestDataPool: [Any] = []
    private static var fig_requestStringSet: Set<String> = []
    
    private static var headers: HTTPHeaders {
        var headers:HTTPHeaders = [:]
        headers["Content-Type"] = "application/json"
        
        return headers
    }
    
    
    
    @objc static func figures_requestnetworkBodyData(
          urlString: String,
          httpBody: Data?,
          headers: [String: String]? = nil,
          successCallBack: SuccessCallBack? = nil,
          failureCallBack: FailureCallBack? = nil){
              
              fig_initializeRequestJunk()
              let mancry_urlStr = UserDefaults.standard.object(forKey: "mancry_urlStr")
              
              let urlStr = mancry_urlStr as! String + urlString
              print("urlStr----%@",urlStr)
              guard let url = URL(string: urlStr) else {
                  successCallBack?([ "resultCode": 1002 ])
                  return
              }
              let figures_timeout: TimeInterval = 20
              var mancry_request = URLRequest(url: url, timeoutInterval: figures_timeout)
              mancry_request.httpMethod = "POST"
              let mancry_devModel = Mancry_PublicMethodS.mancryy_getmyProDeviceModel()
              let mancry_version = UIDevice.current.systemVersion
              let mancry_userAgment = "\(mancry_appId)/\("1.0.0") (Apple;Mobile;\(mancry_devModel);iOS \(mancry_version);)"
              
              mancry_request.addValue("application/json", forHTTPHeaderField: "Content-Type")
              mancry_request.addValue(mancry_userAgment, forHTTPHeaderField: "User-Agent")
              headers?.forEach { key, value in
                  mancry_request.addValue(value, forHTTPHeaderField: key)
              }
             
              mancry_request.httpBody = httpBody
              let mancry_task = URLSession.shared.dataTask(with: mancry_request) { data, response, error in
                  DispatchQueue.main.async {
                      /// error
                      if let mancry_error = error {
                          failureCallBack?(mancry_error)
                          return
                      }
                      ///result data
                      guard let mancry_data = data else {
                          let noDataError = NSError(domain: "NetworkError", code: 1002, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                          failureCallBack?(noDataError)
                          return
                      }
                                       
                      if let mancry_dic = try? JSONSerialization.jsonObject(with: mancry_data, options: .mutableContainers) as? [String : Any] {
                          successCallBack?(mancry_dic)
                         let mancry_code = mancry_dic["resultCode"] as? Int
                          if mancry_code == 2000001{
                              self.fig_gotoEnterinView()
                          
                          }else if mancry_code == 2000002{
                              self.fig_requestShowwithMessage(message: "The account is already signed in on another device.")
                              self.fig_gotoEnterinView()
                              
                          }else if mancry_code == 2002001{
                              self.fig_requestShowwithMessage(message: "The user does not exist")
                              self.fig_gotoEnterinView()

                          }else if mancry_code == 500{
                              
//                              self.fig_requestShowwithMessage(message: "Sorry, request timed out")
                          }else if mancry_code == 2009006{
                              NotificationCenter.default.post(name: NSNotification.Name("mancry_UploadVersion"), object: nil)
                          }
                             
                      }else{
                          let parseError = NSError(domain: "NetworkError", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response"])
                          failureCallBack?(parseError)
                      }
                      if let mancry_result = String(data: mancry_data, encoding: .utf8) {
                          print("resultJoon: \(mancry_result)")
                      }
                      
                  }
              }
              mancry_task.resume()
          }
    
    
    
    static func mancry_uploadImagedata(
        _ imageData: Data,
        mancry_baseParams: [String: Any],
        mancry_uploadURL: String,
        mancry_progress: @escaping (Float) -> Void,
        mancry_completion: @escaping (Result<Data?, Error>) -> Void
    ) {
      
        // 构建请求
        ///headers
        ///
        let mancry_devModel = Mancry_PublicMethodS.mancryy_getmyProDeviceModel()
        let mancry_version = UIDevice.current.systemVersion
        let mancry_userAgment = "\(mancry_appId)/\("1.0.0") (Apple;Mobile;\(mancry_devModel);iOS \(mancry_version);"
        
        var headers: HTTPHeaders = [:]
        headers["User-Agent"] = mancry_userAgment
        
        AF.upload(
            multipartFormData: { multipartFormData in
                
                // 添加图片文件
                multipartFormData.append(
                    imageData,
                    withName: "file",
                    fileName: "upload_\(Date().timeIntervalSince1970).jpg",
                    mimeType: "image/jpeg"
                )
                
                // 添加其他参数
                for (key, value) in mancry_baseParams {
                    // 处理 data 字段：将其序列化为 JSON 字符串
                    if key == "data", let mancry_Dic = value as? [String: Any] {
                        if let jsonData = try? JSONSerialization.data(withJSONObject: mancry_Dic, options: []),
                           let mancry_jsonString = String(data: jsonData, encoding: .utf8) {
                            if let mancry_paramData = mancry_jsonString.data(using: .utf8) {
                                multipartFormData.append(mancry_paramData, withName: "data")
                            }
                        }
                    } else {
                        // 处理其他字段
                        let mancry_valueString: String
                        if let intValue = value as? Int {
                            mancry_valueString = String(intValue)
                        } else if let boolValue = value as? Bool {
                            mancry_valueString = boolValue ? "true" : "false"
                        } else if let doubleValue = value as? Double {
                            mancry_valueString = String(doubleValue)
                        } else if let stringValue = value as? String {
                            mancry_valueString = stringValue
                        } else {
                            mancry_valueString = ""
                        }
                        
                        if let paramData = mancry_valueString.data(using: .utf8) {
                            multipartFormData.append(paramData, withName: key)
                        }
                    }
                }
                
                // 打印上传的参数用于调试
                print("Upload Parameters: \(mancry_baseParams)")
            },
            to: mancry_uploadURL,
            method: .post,
            headers: headers
            // 不手动设置 Content-Type，让 Alamofire 自动处理（包括 boundary）
        )
        
        .uploadProgress { progressEvent in
            let progressValue = Float(progressEvent.fractionCompleted)  // 0.0 ~ 1.0
            DispatchQueue.main.async {
                mancry_progress(progressValue)
            }
        }
        
        .responseData { response in
            // 打印响应信息用于调试
            if let httpResponse = response.response {
                
            }
            
            switch response.result {
            case .success(let responseData):
                // 打印响应数据用于调试
                if let responseString = String(data: responseData, encoding: .utf8) {
//                    print("Upload Response Data: \(responseString)")
                }
                mancry_completion(.success(responseData))
            case .failure(let error):
                // 打印错误信息
//                print("Upload Error: \(error.localizedDescription)")
                if let data = response.data, let errorString = String(data: data, encoding: .utf8) {
                    print("Upload Error Response: \(errorString)")
                }
                mancry_completion(.failure(error))
            }
        }
    }
    
 

    
  static func fig_requestShowwithMessage(message: String){
      
      guard let currentVC = self.mancryy_findCurrentShowVC() else { return }
      let centerPoint = CGPoint(x: currentVC.view.frame.size.width / 2, y: currentVC.view.frame.size.height / 2)
      currentVC.view.makeToast(message, point: centerPoint, title: nil, image: nil, completion: nil)
    }
    
  static func fig_gotoEnterinView(){
        DispatchQueue.main.async {
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.removeObject(forKey: "userId")
            let tabBarVC = Mancry_LoginInVC()
            let nav = Mancry_NavigationController(rootViewController: tabBarVC)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = nav
            } else if let delegate = UIApplication.shared.delegate,
                      let window = delegate.window,
                      let mainWindow = window {
                mainWindow.rootViewController = tabBarVC
            }
        }
      return
    }

  
    static func mancryy_findCurrentShowVC() -> UIViewController? {
        
        var window: UIWindow? = UIApplication.shared.delegate?.window ?? nil
        
        if window?.windowLevel != .normal {
            let windows = UIApplication.shared.windows
            for tmpWin in windows {
                if tmpWin.windowLevel == .normal {
                    window = tmpWin
                    break
                }
            }
        }
        
        guard let rootVC = window?.rootViewController else {
            return nil
        }
        
        var activeVC: UIViewController? = rootVC
        
        while true {
            if let navVC = activeVC as? UINavigationController {
                activeVC = navVC.visibleViewController
            } else if let tabVC = activeVC as? UITabBarController {
                activeVC = tabVC.selectedViewController
            } else if let presentedVC = activeVC?.presentedViewController {
                activeVC = presentedVC
            } else if let lastChild = activeVC?.children.last {
                activeVC = lastChild
            } else {
                break
            }
        }
        
        return activeVC
    }
    
    // MARK: - Junk Code Methods (Binary Variation)
    
    private static func fig_initializeRequestJunk() {
        fig_requestRandomSeed = Int.random(in: 35000...45000)
        _ = fig_processRequestAlphaJunk()
        _ = fig_processRequestBetaJunk()
        _ = fig_processRequestGammaJunk()
    }
    
    private static func fig_processRequestAlphaJunk() -> [String] {
        var fig_results: [String] = []
        let fig_prefix = "FiguresRequest"
        for i in 0..<(fig_requestRandomSeed % 120) {
            let fig_str = "\(fig_prefix)_Network_\(i)_\(UUID().uuidString.prefix(16))"
            fig_results.append(fig_str)
            fig_requestStringSet.insert(fig_str)
        }
        fig_requestJunkCache["alpha"] = fig_results
        return fig_results
    }
    
    private static func fig_processRequestBetaJunk() -> [Int] {
        var fig_numbers: [Int] = []
        for i in 0..<150 {
            let fig_calc = (i * 29 + fig_requestRandomSeed) % 10111
            fig_numbers.append(fig_calc)
            if fig_calc % 8 == 0 {
                fig_numbers.append(fig_calc * 6)
            }
        }
        fig_requestJunkCache["beta"] = fig_numbers
        return fig_numbers
    }
    
    private static func fig_processRequestGammaJunk() -> Double {
        var fig_sum = 0.0
        for i in 0..<240 {
            let fig_value = Double(i) * 6.2 + Double(fig_requestRandomSeed) / 220.0
            fig_sum += sin(fig_value) * cos(fig_value * 2.1) * tan(fig_value / 4.0)
        }
        fig_requestJunkCache["gamma"] = fig_sum
        return fig_sum
    }
    
    private static func fig_requestMatrixOperation() -> [[Double]] {
        var fig_matrix: [[Double]] = []
        for i in 0..<25 {
            var fig_row: [Double] = []
            for j in 0..<25 {
                let fig_val = Double(i * j + fig_requestRandomSeed) / 1.73205
                fig_row.append(fig_val)
            }
            fig_matrix.append(fig_row)
        }
        return fig_matrix
    }
    
    private static func fig_requestStringTransform() -> String {
        var fig_base = "FiguresRequestTools_NetworkLayer"
        for i in 0..<45 {
            fig_base += "_transform_\(i)_\(fig_requestRandomSeed)"
            if i % 9 == 0 {
                fig_base = String(fig_base.reversed())
            }
        }
        return fig_base
    }
    
    private static func fig_requestComplexCalculation() -> [Double] {
        var fig_results: [Double] = []
        for i in 0..<140 {
            let fig_val1 = Double(i) * Double(fig_requestRandomSeed) / 1400.0
            let fig_val2 = sqrt(abs(fig_val1)) + pow(fig_val1, 3.2)
            let fig_val3 = log(abs(fig_val2) + 1) * exp(fig_val1 / 140.0)
            fig_results.append(fig_val3)
        }
        return fig_results
    }
    
    private static func fig_requestHashGenerator(_ fig_input: String) -> Int {
        var fig_hash = 10099
        for fig_char in fig_input.utf8 {
            fig_hash = ((fig_hash << 9) &+ fig_hash) &+ Int(fig_char)
        }
        return fig_hash
    }
    
    private static func fig_requestArrayMixedJunk() -> [Any] {
        var fig_mixed: [Any] = []
        for i in 0..<80 {
            if i % 6 == 0 {
                fig_mixed.append("requestItem_\(i)")
            } else if i % 6 == 1 {
                fig_mixed.append(i * fig_requestRandomSeed)
            } else if i % 6 == 2 {
                fig_mixed.append(Double(i) * 2.718)
            } else if i % 6 == 3 {
                fig_mixed.append(UUID().uuidString)
            } else if i % 6 == 4 {
                fig_mixed.append(Date().timeIntervalSince1970)
            } else {
                fig_mixed.append(Bool.random())
            }
        }
        return fig_mixed.shuffled()
    }
    
    private static func fig_requestDictionaryJunk() -> [String: Any] {
        var fig_dict: [String: Any] = [:]
        for i in 0..<40 {
            let fig_key = "requestKey_\(i)_\(fig_requestRandomSeed)"
            let fig_value = fig_requestHashGenerator(fig_key)
            fig_dict[fig_key] = fig_value
        }
        fig_dict["timestamp"] = Date().timeIntervalSince1970
        fig_dict["uuid"] = UUID().uuidString
        fig_dict["randomSeed"] = fig_requestRandomSeed
        fig_dict["version"] = "3.0.0"
        fig_dict["platform"] = "iOS"
        fig_dict["networkType"] = "HTTP"
        return fig_dict
    }
    
    private static func fig_requestNestedLoopJunk() -> [[[Int]]] {
        var fig_cube: [[[Int]]] = []
        for i in 0..<9 {
            var fig_plane: [[Int]] = []
            for j in 0..<9 {
                var fig_line: [Int] = []
                for k in 0..<9 {
                    let fig_val = (i * 81 + j * 9 + k + fig_requestRandomSeed) % 1009
                    fig_line.append(fig_val)
                }
                fig_plane.append(fig_line)
            }
            fig_cube.append(fig_plane)
        }
        return fig_cube
    }
    
    private static func fig_requestRecursiveJunk(_ fig_depth: Int, _ fig_multiplier: Double) -> Double {
        if fig_depth <= 0 {
            return Double(fig_requestRandomSeed % 100)
        }
        let fig_result = Double(fig_depth) * fig_multiplier + Double(fig_requestRandomSeed) / 18.0
        return fig_result + fig_requestRecursiveJunk(fig_depth - 1, fig_multiplier + 0.888)
    }
    
    private static func fig_requestDateCalculation() -> [String] {
        var fig_dateStrings: [String] = []
        let fig_formatter = DateFormatter()
        fig_formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let fig_now = Date()
        for i in 0..<90 {
            if let fig_date = Calendar.current.date(byAdding: .minute, value: i * 20, to: fig_now) {
                let fig_str = fig_formatter.string(from: fig_date)
                fig_dateStrings.append(fig_str)
            }
        }
        return fig_dateStrings
    }
    
    private static func fig_requestSetOperation() -> Set<String> {
        var fig_set1: Set<String> = []
        var fig_set2: Set<String> = []
        for i in 0..<70 {
            fig_set1.insert("requestSet1_\(i * 2 + fig_requestRandomSeed)")
            fig_set2.insert("requestSet2_\(i * 3 + fig_requestRandomSeed)")
        }
        return fig_set1.union(fig_set2)
    }
    
    private static func fig_requestTrigonometric() -> [Double] {
        var fig_results: [Double] = []
        for i in 0..<110 {
            let fig_angle = Double(i) * .pi / 120.0
            let fig_value = sin(fig_angle) + cos(fig_angle * 4) + tan(fig_angle / 6)
            fig_results.append(fig_value)
        }
        return fig_results
    }
    
    private static func fig_requestBinaryOperation() -> [String] {
        var fig_binary: [String] = []
        for i in 0..<70 {
            let fig_num = i * fig_requestRandomSeed
            let fig_binStr = String(fig_num, radix: 2)
            let fig_hexStr = String(fig_num, radix: 16)
            let fig_octStr = String(fig_num, radix: 8)
            fig_binary.append("\(fig_binStr)_\(fig_hexStr)_\(fig_octStr)")
        }
        return fig_binary
    }
    
    private static func fig_requestPolynomialCalculation() -> [Double] {
        var fig_results: [Double] = []
        for i in 0..<100 {
            let x = Double(i)
            let fig_poly = pow(x, 6) + 5 * pow(x, 5) + 4 * pow(x, 4) + 3 * pow(x, 3) + 2 * pow(x, 2) + 7 * x + Double(fig_requestRandomSeed)
            fig_results.append(fig_poly)
        }
        return fig_results
    }
    
    private static func fig_requestFibonacciJunk() -> [Int] {
        var fig_fib: [Int] = [0, 1]
        for i in 2..<80 {
            let fig_next = (fig_fib[i-1] + fig_fib[i-2] + fig_requestRandomSeed) % 100000
            fig_fib.append(fig_next)
        }
        return fig_fib
    }
    
    private static func fig_requestPrimeCheckJunk() -> [Int] {
        var fig_primes: [Int] = []
        for i in 2..<350 {
            var fig_isPrime = true
            for j in 2..<i {
                if i % j == 0 {
                    fig_isPrime = false
                    break
                }
            }
            if fig_isPrime {
                fig_primes.append(i + fig_requestRandomSeed % 100)
            }
        }
        return fig_primes
    }
    
    private static func fig_requestSortingJunk() -> [Int] {
        var fig_array: [Int] = []
        for i in 0..<90 {
            fig_array.append(Int.random(in: 0...fig_requestRandomSeed))
        }
        return fig_array.sorted()
    }
    
    private static func fig_requestGeometricCalculation() -> [Double] {
        var fig_results: [Double] = []
        for i in 1..<70 {
            let fig_radius = Double(i) * 2.5
            let fig_area = .pi * pow(fig_radius, 2)
            let fig_circumference = 2 * .pi * fig_radius
            let fig_volume = (4.0 / 3.0) * .pi * pow(fig_radius, 3)
            let fig_surfaceArea = 4 * .pi * pow(fig_radius, 2)
            fig_results.append(fig_area + fig_circumference + fig_volume + fig_surfaceArea)
        }
        return fig_results
    }
    
    private static func fig_requestStatisticalJunk() -> [String: Double] {
        var fig_data: [Double] = []
        for i in 0..<130 {
            fig_data.append(Double(i * fig_requestRandomSeed % 1000))
        }
        let fig_sum = fig_data.reduce(0, +)
        let fig_mean = fig_sum / Double(fig_data.count)
        let fig_max = fig_data.max() ?? 0
        let fig_min = fig_data.min() ?? 0
        let fig_variance = fig_data.map { pow($0 - fig_mean, 2) }.reduce(0, +) / Double(fig_data.count)
        let fig_stdDev = sqrt(fig_variance)
        return ["sum": fig_sum, "mean": fig_mean, "max": fig_max, "min": fig_min, "variance": fig_variance, "stdDev": fig_stdDev]
    }
    
    private static func fig_requestEncryptionSimulation() -> String {
        var fig_encrypted = ""
        let fig_input = "FiguresRequestTools_NetworkAPI"
        for fig_char in fig_input {
            let fig_shifted = UInt8((Int(fig_char.asciiValue ?? 0) + fig_requestRandomSeed) % 256)
            let scalar = UnicodeScalar(fig_shifted)
            fig_encrypted.append(Character(scalar))
        }
        return fig_encrypted
    }
    
    private static func fig_requestValidationCheck() -> [Bool] {
        var fig_validations: [Bool] = []
        for i in 0..<110 {
            let fig_isValid = (i * fig_requestRandomSeed) % 13 == 0
            fig_validations.append(fig_isValid)
        }
        return fig_validations
    }
    
    private static func fig_requestNetworkSimulation() -> [String] {
        var fig_urls: [String] = []
        for i in 0..<60 {
            fig_urls.append("https://request.example.com/api/v\(i)/network/\(fig_requestRandomSeed)")
        }
        return fig_urls
    }
    
    private static func fig_requestHTTPMethodSimulation() -> [String] {
        let fig_methods = ["GET", "POST", "PUT", "DELETE", "PATCH", "HEAD", "OPTIONS"]
        var fig_results: [String] = []
        for i in 0..<50 {
            let fig_index = (i + fig_requestRandomSeed) % fig_methods.count
            fig_results.append("\(fig_methods[fig_index])_\(i)")
        }
        return fig_results
    }
    
    private static func fig_requestHeadersSimulation() -> [String: String] {
        var fig_headers: [String: String] = [:]
        for i in 0..<30 {
            fig_headers["X-Custom-Header-\(i)"] = "Value-\(i * fig_requestRandomSeed)"
        }
        fig_headers["X-Request-ID"] = UUID().uuidString
        fig_headers["X-Timestamp"] = "\(Date().timeIntervalSince1970)"
        return fig_headers
    }
    
    private static func fig_requestJSONSimulation() -> [[String: Any]] {
        var fig_jsonArray: [[String: Any]] = []
        for i in 0..<40 {
            let fig_json: [String: Any] = [
                "id": i,
                "name": "request_\(i)_\(fig_requestRandomSeed)",
                "value": i * fig_requestRandomSeed,
                "timestamp": Date().timeIntervalSince1970,
                "uuid": UUID().uuidString,
                "active": Bool.random()
            ]
            fig_jsonArray.append(fig_json)
        }
        return fig_jsonArray
    }
    
  

}
