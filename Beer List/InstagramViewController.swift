//
//  InstagramViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 31.01.2023.
//

import Foundation
import WebKit

class InstagramViewController: UIViewController, WKNavigationDelegate {
  
    var instagramUser: InstagramUser?
    var instagramApi = InstagramApi.shared
    var testUserData: InstagramTestUser?
    var mainVC: ProfileViewController?
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
        instagramApi.authorizeApp { (url) in
            DispatchQueue.main.async {
                self.webView.load(URLRequest(url: url!))
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request = navigationAction.request
        self.instagramApi.getTestUserIDAndToken(request: request) { [weak self] (instagramTestUser) in
            self?.testUserData = instagramTestUser
            DispatchQueue.main.async {
                self?.dismissViewController()
            }
            self!.getInstagramUser()
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    func getInstagramUser() {
        self.instagramApi.getInstagramUser(testUserData: self.testUserData!) { [weak self] (user) in
            self?.instagramUser = user
        }
    }
    
    func fetchInstagramPictures() {
        guard self.instagramUser != nil else { return }
        self.instagramApi.getMedia(testUserData: self.testUserData!, index: 0) { (media) in
                guard media.media_type != MediaType.VIDEO else { return }
                let media_url = media.media_url
                self.instagramApi.fetchImage(urlString: media_url, completion: { (fetchedImage) in
                    guard let fetchedImage else { return }
                    DispatchQueue.main.async {
                        self.mainVC!.imageInstagram.image = UIImage(data: fetchedImage)
                        self.mainVC!.imageInstagram1.image = UIImage(data: fetchedImage)
                        self.mainVC!.imageInstagram2.image = UIImage(data: fetchedImage)
                }
                print("Fetched Image: \(fetchedImage)")
            })
        }
    }

    func dismissViewController() {
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                self.mainVC?.testUserData = self.testUserData!
                self.fetchInstagramPictures()
            }
        }
    }
}
