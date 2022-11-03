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
        let request = NSFetchRequest<NSManagedObject>(entityName: "User")
        //request.predicate = NSPredicate(format: "userEmail = %@", userEmail.text!)
        do {
            let result = try managedContext.fetch(request)
            for data in result {
                let firstName = data.value(forKey: "userFirstName") as? String
                let lastName = data.value(forKey: "userLastName") as? String
                let email = data.value(forKey: "userEmail") as? String
                userFirstName.text = firstName
                userLastName.text = lastName
                userEmail.text = email
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: Storyboards.main.rawValue, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllers.edit.rawValue) as! EditViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapFavouriteBeers(_ sender: Any) { }

    @IBAction func tapLogout(_ sender: UIButton) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.loggedInUserEmail.rawValue)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllers.login.rawValue)
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
}


