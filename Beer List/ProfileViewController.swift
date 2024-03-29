//
//  ProfileViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 25.10.2022.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userFirstName: UILabel!
    @IBOutlet weak var userLastName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var imageInstagram: UIImageView!
    @IBOutlet weak var imageInstagram1: UIImageView!
    @IBOutlet weak var imageInstagram2: UIImageView!
    
    var instagramApi = InstagramApi.shared
    var testUserData = InstagramTestUser(access_token: "", user_id: 0)
    var instagramUser: InstagramUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUser()
    }
   
    
    func getUser() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let email = UserDefaults.standard.value(forKey: UserDefaultsKeys.loggedInUserEmail.rawValue) as? String else { return }
        let request = NSFetchRequest<NSManagedObject>(entityName: "User")
        request.predicate = NSPredicate(format: "userEmail = %@", email)
        
        do {
            guard let result = try managedContext.fetch(request).first else { return }
            userFirstName.text = result.value(forKey: "userFirstName") as? String
            userLastName.text = result.value(forKey: "userLastName") as? String
            userEmail.text = result.value(forKey: "userEmail") as? String
        } catch let error as NSError {
            print("Could not get user. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: Storyboards.main.rawValue, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllers.edit.rawValue) as! EditViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapInstagramButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: Storyboards.main.rawValue, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllers.instagram.rawValue) as! InstagramViewController
        vc.instagramApi = InstagramApi.shared
        vc.mainVC = self
        self.present(vc, animated:true)
    }
        
        @IBAction func tapLogout(_ sender: UIButton) {
            let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.loggedInUserEmail.rawValue)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllers.login.rawValue) as? LoginViewController
                let navVC = UINavigationController(rootViewController: vc!)
                self.view.window?.rootViewController = navVC
                self.view.window?.makeKeyAndVisible()
                
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true, completion: nil)
        }
    }

