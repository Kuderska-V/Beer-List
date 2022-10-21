//
//  SignUpViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 29.09.2022.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirmation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        password.delegate = self
        passwordConfirmation.delegate = self
        password.isSecureTextEntry = true
        passwordConfirmation.isSecureTextEntry = true
    }
    
    @IBAction func SignUpTapped(_ sender: Any) {
        
        if areSomeFieldsEmpty() {
            let ac = UIAlertController(title: "Error", message: "Please, fill all the required fields", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            return
        }
        
        if !isValid(email: email.text!) {
            let ac = UIAlertController(title: "Error", message: "Email is invalid", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            return
        }
        
        if !isValid(password: password.text!) {
            let ac = UIAlertController(title: "Error", message: "Password must contain at least 5 characters, including numbers.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            return
        }
        
        if password.text! != passwordConfirmation.text! {
            let ac = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            return
        }
        save()
    }

    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedContext) as NSManagedObject
        newUser.setValue(email.text, forKey: "userEmail")
        newUser.setValue(password.text, forKey: "userPassword")
        do {
            try managedContext.save()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        print(newUser)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstName {
            lastName.becomeFirstResponder()
        } else if textField == lastName {
            email.becomeFirstResponder()
        } else if textField == email {
            password.becomeFirstResponder()
        } else if textField == password {
            passwordConfirmation.becomeFirstResponder()
        } else if textField == passwordConfirmation {
            SignUpTapped(textField)
        }
        return true
    }
}

extension SignUpViewController {
    
    //Validation
    func isValid(email: String) -> Bool {
        let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return predicate.evaluate(with: email)
    }
    
    func isValid(password: String) -> Bool {
        guard password.count > 4 else { return false }
        return containsDigit(password)
    }
    
    func areSomeFieldsEmpty() -> Bool {
        firstName.text!.isEmpty || lastName.text!.isEmpty || email.text!.isEmpty || password.text!.isEmpty || passwordConfirmation.text!.isEmpty
    }
    
    func containsDigit(_ value: String) -> Bool {
        let reqularExpression = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return predicate.evaluate(with: value)
    }
}

