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
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "User")
        //request.predicate = NSPredicate(format: "userEmail = %@", userEmail.text!)
        do {
            let result = try managedContext.fetch(request)
            for data in result {
                let firstName = data.value(forKey: "userFirstName") as? String
                let lastName = data.value(forKey: "userLastName") as? String
                editFirstName.text = firstName
                editLastName.text = lastName
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        user.setValue(editFirstName.text, forKey: "userFirstName")
        user.setValue(editLastName.text, forKey: "userLastName")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        save()
    }
}
