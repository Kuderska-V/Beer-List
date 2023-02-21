//
//  WebViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 31.01.2023.
//

import Foundation
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
  
    var instagramUser: InstagramUser?

    var instagramApi = InstagramApi.shared
    //var instagramApi: InstagramApi?
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
//                let token = instagramApi?.getTokenFromCallbackURL(request: request)
//                if let token {
//                    dismiss(animated: true)
//                    }
//                }
//                decisionHandler(WKNavigationActionPolicy.allow)
//            }
        
        self.instagramApi.getTestUserIDAndToken(request: request) { [weak self] (instagramTestUser) in
            self?.testUserData = instagramTestUser
            print("User: \(instagramTestUser)")
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
            print("Got the user: \(self?.instagramUser)")
        }
    }
    
    func fetchInstagramPictures() {
        if self.instagramUser != nil {
            self.instagramApi.getMedia(testUserData: self.testUserData!) { (media) in
                if media.media_type != MediaType.VIDEO {
                    let media_url = media.media_url
                    self.instagramApi.fetchImage(urlString: media_url, completion: { (fetchedImage) in
                        if let imageData = fetchedImage {
                            DispatchQueue.main.async {
                                self.mainVC!.imageInstagram.image = UIImage(data: imageData)
                                self.mainVC!.imageInstagram1.image = UIImage(data: imageData)
                                self.mainVC!.imageInstagram2.image = UIImage(data: imageData)
                            }
                        } else {
                            print("Didn’t fetched the data")
                        }
                    })
                print(media_url)
                } else {
                    print("Fetched media is a video")
                }
            }
        } else {
            print("Not signed in")
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
