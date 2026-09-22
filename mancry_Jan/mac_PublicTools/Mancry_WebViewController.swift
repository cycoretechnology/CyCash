
import UIKit
import WebKit

class Mancry_WebViewController: Mac_BaseViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler{
    
    var mancry_titleStr = ""
    var mancry_linkUrlStr = ""
    private var mancry_isLoadingShown = false
    private var mancry_hasStartedLoad = false

    private lazy var mancry_webView: WKWebView = {
        let contentController = WKUserContentController()
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.showsVerticalScrollIndicator = false
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mac_publiccustomnavView(title: mancry_titleStr)
        mancry_setupLinkShowView()
    }
    
    deinit {
        mancry_hideWebLoadingIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent || isBeingDismissed {
            mancry_hideWebLoadingIfNeeded()
        }
    }
    
    func mancry_setupLinkShowView(){
        if mancry_webView.superview == nil {
            view.addSubview(mancry_webView)
            mancry_webView.frame = CGRectMake(0, mancry_NavBarHeight, mancry_Width, mancry_Height - mancry_NavBarHeight)
        }

        guard !mancry_hasStartedLoad else { return }
        guard let url = URL(string: mancry_linkUrlStr), !mancry_linkUrlStr.isEmpty else {
            return
        }
        mancry_hasStartedLoad = true
        mancry_showWebLoading()
        mancry_webView.load(URLRequest(url: url))
    }
    
    private func mancry_showWebLoading() {
        guard !mancry_isLoadingShown else { return }
        mancry_isLoadingShown = true
        mac_PopLoadingView()
    }
    
    private func mancry_hideWebLoadingIfNeeded() {
        guard mancry_isLoadingShown else { return }
        mancry_isLoadingShown = false
        mac_hiddenLoadingView()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void) {
                if let url = navigationAction.request.url{
                    if url.absoluteString.hasPrefix("http"){
                        decisionHandler(.allow)
                    }else{
                        UIApplication.shared.open(url, options: [:]) { result in
                            if result == false {
                                self.mac_centerToastViewwithMsg(msg: "Please install the app first.")
                            }
                        }
                        decisionHandler(.cancel)
                    }
                    
                    
                }else{
                    decisionHandler(.allow)
                }
               
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        mancry_hideWebLoadingIfNeeded()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        mancry_hideWebLoadingIfNeeded()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        mancry_hideWebLoadingIfNeeded()
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
}
