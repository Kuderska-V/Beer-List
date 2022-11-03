//
//  EditViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 26.10.2022.
//

import UIKit
import CoreData

class EditViewController: UIViewController {

    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var editFirstName: UITextField!
    @IBOutlet weak var editLastName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
        firstName.text = "First name"
        lastName.text = "Last name"
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
            editFirstName.text = result.value(forKey: "userFirstName") as? String
            editLastName.text = result.value(forKey: "userLastName") as? String
        } catch let error as NSError {
            print("Could not get user. \(error), \(error.userInfo)")
        }
    }
    
    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let email = UserDefaults.standard.value(forKey: UserDefaultsKeys.loggedInUserEmail.rawValue) as? String else { return }
        let request = NSFetchRequest<NSManagedObject>(entityName: "User")
        request.predicate = NSPredicate(format: "userEmail = %@", email)
        do {
            let user = try managedContext.fetch(request).first
            user?.setValue(editFirstName.text, forKey: "userFirstName")
            user?.setValue(editLastName.text, forKey: "userLastName")
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not update user. \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Could not get user. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        save()
    }
}
