//
//  InstagramResponse.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 31.01.2023.
//

import Foundation

struct InstagramTestUser: Codable {
  var access_token: String
  var user_id: Int
}
struct InstagramUser: Codable {
  var id: String
  var username: String
}
struct Feed: Codable {
  var data: [MediaData]
  var paging: PagingData
}
struct MediaData: Codable {
  var id: String
  var caption: String?
}
struct PagingData: Codable {
  var cursors: CursorData
  var next: String
}
struct CursorData: Codable {
  var before: String
  var after: String
}
struct InstagramMedia: Codable {
  var id: String
  var media_type: MediaType
  var media_url: String
  var username: String
  var timestamp: String
}
enum MediaType: String,Codable {
  case IMAGE
  case VIDEO
  case CAROUSEL_ALBUM
}


class InstagramApi {
    static let shared = InstagramApi()
    private let instagramAppID = "5781481565305470"
    private let redirectURIURLEncoded = "https%3A%2F%2Fwww.google.com%2F"
    private let redirectURI = "https://www.google.com/"
    private let app_secret = "3b37200f020456147fd5472ba44b02c6"
    private let boundary = "boundary=\(NSUUID().uuidString)"
    private init () {}
    
    private enum BaseURL: String {
        case displayApi = "https://api.instagram.com/"
        case graphApi = "https://graph.instagram.com/"
    }
    
    private enum Method: String {
        case authorize = "oauth/authorize"
        case access_token = "oauth/access_token"
        
    }
    
    func authorizeApp(completion: @escaping (_ url: URL?) -> Void ) {
        let urlString = "\(BaseURL.displayApi.rawValue)\(Method.authorize.rawValue)?app_id=\(instagramAppID)&redirect_uri=\(redirectURIURLEncoded)&scope=user_profile,user_media&response_type=code"
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response {
                print(response)
                completion(response.url)
            }
        })
        task.resume()
    }
    
    func getTokenFromCallbackURL(request: URLRequest) -> String? {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.starts(with: "\(redirectURI)?code=") {
            if let range = requestURLString.range(of: "\(redirectURI)?code=") {
                return String(requestURLString[range.upperBound...].dropLast(2))
            }
        }
        return nil
    }
    
    func getTestUserIDAndToken(request: URLRequest, completion: @escaping (InstagramTestUser) -> Void){
        guard let authToken = getTokenFromCallbackURL(request: request) else { return }
        let accessToken = URL(string: "https://api.instagram.com/oauth/access_token")!
        var request = URLRequest(url: accessToken)
        let parameters = "client_id=\(instagramAppID)&client_secret=\(app_secret)&code=\(authToken)&grant_type=authorization_code&redirect_uri=\(redirectURIURLEncoded)"
        do{
            request.httpBody = parameters.data(using: String.Encoding.utf8)
        }catch let error {
            print(error)
        }
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        fetchedDataByDataTask(from: request, completion: { (data) in
            completion(data)
        })
    }
    
    func getInstagramUser(testUserData: InstagramTestUser, completion: @escaping (InstagramUser) -> Void) {
        let urlString = "\(BaseURL.graphApi.rawValue)\(testUserData.user_id)?fields=id,username&access_token=\(testUserData.access_token)"
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
            }
            do {
                let jsonData = try JSONDecoder().decode(InstagramUser.self, from: data!)
                completion(jsonData)
            } catch let error as NSError {
                print(error)
            }
        })
        dataTask.resume()
    }
    
    func fetchedDataByDataTask(from request: URLRequest, completion: @escaping (InstagramTestUser) -> Void){
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print(error as Any)
            }else{
                guard let data = data else{return}
                do {
                    let jsonData = try JSONDecoder().decode(InstagramTestUser.self, from: data)
                    completion(jsonData)
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    private func getMediaData(testUserData: InstagramTestUser, completion: @escaping (Feed) -> Void) {
        let urlString = "\(BaseURL.graphApi.rawValue)me/media?fields=id,caption&access_token=\(testUserData.access_token)"
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response {
                //print(response)
            }
            do {
                let jsonData = try JSONDecoder().decode(Feed.self, from: data!)
                //print(jsonData)
                completion(jsonData)
            } catch let error as NSError {
                print(error)
            }
        })
        task.resume()
    }
    
    func getMedia(testUserData: InstagramTestUser, completion: @escaping (InstagramMedia) -> Void) {
        getMediaData(testUserData: testUserData) { (mediaFeed) in
            let urlString = "\(BaseURL.graphApi.rawValue + mediaFeed.data[0].id)?fields=id,media_type,media_url,username,timestamp&access_token=\(testUserData.access_token)"
            let request = URLRequest(url: URL(string: urlString)!)
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                if let response = response {
                    print(response)
                }
                do {
                    let jsonData = try JSONDecoder().decode(InstagramMedia.self, from: data!)
                    print(jsonData)
                    completion(jsonData)
                } catch let error as NSError {
                    print(error)
                }
            })
            task.resume()
        }
    }
    
    func fetchImage(urlString: String, completion: @escaping (Data?) -> Void) {
      let request = URLRequest(url: URL(string: urlString)!)
      let session = URLSession.shared
      let task = session.dataTask(with: request, completionHandler: { data, response, error in
        if let response = response {
          print(response)
        }
      completion(data)
      })
      task.resume()
    }
}
