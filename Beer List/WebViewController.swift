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
    var testUserData: InstagramTestUser?
    var mainVC: ProfileViewController?
    
    @IBOutlet weak var webView: WKWebView!
    
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
          self.instagramApi?.getTestUserIDAndToken(request: request) { [weak self] (instagramTestUser) in
            self?.testUserData = instagramTestUser
            DispatchQueue.main.async {
              self?.dismissViewController()
            }
          }
      decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    func dismissViewController() {
      self.dismiss(animated: true) {
        self.mainVC?.testUserData = self.testUserData!
      }
    }
    
    

}
