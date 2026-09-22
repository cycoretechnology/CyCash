import UIKit

// MARK: - Submit

extension Mancry_AuthOneStepsVC {
    
    @objc func mancry_continueButtonTapped() {
        view.endEditing(true)
        
        if let missing = Mancry_AuthOnePayloadForge.mancry_firstMissingRequired(in: mancry_items) {
            mac_centerToastViewwithMsg(msg: missing.mancry_requiredHintMessage())
            return
        }
        
        mancry_submitPersonalInfo()
    }
    
    func mancry_submitPersonalInfo() {
        let dataDict = Mancry_AuthOnePayloadForge.mancry_buildDataDictionary(from: mancry_items)
        
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: dataDict, isSign: false)
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else {
            mac_centerToastViewwithMsg(msg: "Failed to prepare request data")
            return
        }
        
        self.mac_PopLoadingView()
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/kyc/four/personal",
            httpBody: postData,
            successCallBack: { [weak self] result in
                guard let self = self else { return }
                self.mac_hiddenLoadingView()
                
                let code = result["resultCode"] as? Int ?? -1
                if code == 200 {
                    let vc = Mancry_AuthTwoStepsVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let message = result["resultMsg"] as? String ?? "Submit failed"
                    self.mac_centerToastViewwithMsg(msg: message)
                }
            },
            failureCallBack: { [weak self] _ in
                self?.mac_hiddenLoadingView()
                self?.mac_centerToastViewwithMsg(msg: "Network error")
            }
        )
    }
}
