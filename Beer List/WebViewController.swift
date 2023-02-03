//
//  WebViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 31.01.2023.
//

import Foundation
import WebKit
class WebViewController: UIViewController, WKNavigationDelegate {
  
    var instagramApi: InstagramApi?
    var mainVC: ProfileViewController?
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
        instagramApi?.authorizeApp { (url) in
            DispatchQueue.main.async {
                self.webView.load(URLRequest(url: url!))
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request = navigationAction.request
        let token = instagramApi?.getTokenFromCallbackURL(request: request)
        if let token {
            dismiss(animated: true)
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
}
