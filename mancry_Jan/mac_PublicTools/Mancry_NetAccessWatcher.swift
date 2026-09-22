import Foundation
import Network
import UIKit


final class Mancry_NetAccessWatcher {
    
    private let mancry_pathProbe = NWPathMonitor()
    private let mancry_probeQueue = DispatchQueue(label: "com.mancry.login.netprobe")
    private(set) var mancry_isReachable = false
    private var mancry_hasNotifiedSatisfied = false
    
    
    var mancry_onFirstReachable: (() -> Void)?
    
    func mancry_startProbing() {
        mancry_pathProbe.pathUpdateHandler = { [weak self] path in
            let reachable = (path.status == .satisfied)
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.mancry_isReachable = reachable
                guard reachable, !self.mancry_hasNotifiedSatisfied else { return }
                self.mancry_hasNotifiedSatisfied = true
                self.mancry_onFirstReachable?()
            }
        }
        mancry_pathProbe.start(queue: mancry_probeQueue)
    }
    
    func mancry_stopProbing() {
        mancry_pathProbe.cancel()
        mancry_onFirstReachable = nil
    }
}
