import UIKit

// MARK: - Province & City

extension Mancry_AuthOneStepsVC {
    
    func mancry_loadProvinceList(for index: Int) {
        self.mac_PopLoadingView()
        
        let requestData: [String: Any] = [
            "countryId": "63"
        ]
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: requestData, isSign: true)
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else {
            self.mac_hiddenLoadingView()
            return
        }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/sys/province",
            httpBody: postData,
            successCallBack: { [weak self] result in
                guard let self = self else { return }
                self.mac_hiddenLoadingView()
                
                let code = result["resultCode"] as? Int ?? -1
                if code == 200,
                   let data = result["data"] as? [String: Any],
                   let list = data["provinceList"] as? [[String: Any]] {
                    
                    let bundle = Mancry_AuthOneOptionLoom.mancry_bundleFromRegionList(
                        list,
                        currentValue: self.mancry_items[index].value
                    )
                    
                    let picker = Mancry_customselectPopupView()
                    self.mancry_bottomPicker = picker
                    
                    picker.configure(
                        title: self.mancry_items[index].itemName,
                        data: bundle.labels,
                        defaultIndex: bundle.defaultIndex
                    )
                    
                    picker.onConfirm = { [weak self] selectedIndex, selectedLabel in
                        guard let self = self else { return }
                        if let key = Mancry_AuthOneOptionLoom.mancry_key(at: selectedIndex, in: bundle.options) {
                            let previousProvinceId = self.mancry_selectedProvinceId
                            
                            self.mancry_selectedProvinceId = key
                            self.mancry_items[index].value = key
                            self.mancry_items[index].displayText = selectedLabel
                            
                            self.mancry_tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                            
                            if previousProvinceId != key {
                                self.mancry_clearCitySelection()
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                                self?.mancry_jumpToNextItem(from: index)
                            }
                        }
                        
                        self.mancry_bottomPicker = nil
                    }
                    
                    picker.onCancel = { [weak self] in
                        self?.mancry_bottomPicker = nil
                    }
                    
                    picker.show(in: self.view)
                } else {
                    let message = result["resultMsg"] as? String ?? "Failed to load province list"
                    self.mac_centerToastViewwithMsg(msg: message)
                }
            },
            failureCallBack: { [weak self] _ in
                self?.mac_hiddenLoadingView()
                self?.mac_centerToastViewwithMsg(msg: "Network error")
            }
        )
    }
    
    func mancry_loadCityList(provinceId: String, for index: Int) {
        self.mac_PopLoadingView()
        
        let requestData: [String: Any] = [
            "provinceId": provinceId,
            "countryId": "63"
        ]
        let parametersDic = Mancry_PublicMethodS.mancry_publicRequestBody(with: requestData, isSign: true)
        guard let postData = try? JSONSerialization.data(withJSONObject: parametersDic) else {
            self.mac_hiddenLoadingView()
            return
        }
        
        Mancry_RequestData.figures_requestnetworkBodyData(
            urlString: "/app/v3/sys/city",
            httpBody: postData,
            successCallBack: { [weak self] result in
                guard let self = self else { return }
                self.mac_hiddenLoadingView()
                
                let code = result["resultCode"] as? Int ?? -1
                if code == 200,
                   let data = result["data"] as? [String: Any],
                   let list = data["cityList"] as? [[String: Any]] {
                    
                    let bundle = Mancry_AuthOneOptionLoom.mancry_bundleFromRegionList(
                        list,
                        currentValue: self.mancry_items[index].value
                    )
                    
                    let picker = Mancry_customselectPopupView()
                    self.mancry_bottomPicker = picker
                    
                    picker.configure(
                        title: self.mancry_items[index].itemName,
                        data: bundle.labels,
                        defaultIndex: bundle.defaultIndex
                    )
                    
                    picker.onConfirm = { [weak self] selectedIndex, selectedLabel in
                        guard let self = self else { return }
                        if let key = Mancry_AuthOneOptionLoom.mancry_key(at: selectedIndex, in: bundle.options) {
                            self.mancry_items[index].value = key
                            self.mancry_items[index].displayText = selectedLabel
                            
                            self.mancry_tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                                self?.mancry_jumpToNextItem(from: index)
                            }
                        }
                        
                        self.mancry_bottomPicker = nil
                    }
                    
                    picker.onCancel = { [weak self] in
                        self?.mancry_bottomPicker = nil
                    }
                    
                    picker.show(in: self.view)
                } else {
                    let message = result["resultMsg"] as? String ?? "Failed to load city list"
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
