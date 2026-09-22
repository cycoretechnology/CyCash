import UIKit

// MARK: - Network (init items)

extension Mancry_AuthOneStepsVC {
    
    func mancry_getOneStepinitData() {
        let requestData: [String: Any] = [
            "": ""
        ]
        let mancry_parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: requestData, isSign: false)
        
        guard let postData = try? JSONSerialization.data(withJSONObject: mancry_parametersDic) else { return }
        
        self.mac_PopLoadingView()
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/kyc/four/search-iterm",
            httpBody: postData,
            successCallBack: { [weak self] result in
                guard let self = self else { return }
                self.mac_hiddenLoadingView()
                let code = result["resultCode"] as? Int ?? -1
                if code == 200,
                   let data = result["data"] as? [String: Any],
                   let list = data["kycItemList"] as? [[String: Any]] {
                    
                    self.mancry_items = Mancry_AuthOneItemMapper.mancry_buildItems(from: list)
                    self.mancry_tableView.reloadData()
                } else {
                    let message = result["resultMsg"] as? String ?? "Network error"
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
