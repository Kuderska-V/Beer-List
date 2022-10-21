//
//  LoginViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 02.10.2022.
//

import UIKit
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let defaults = UserDefaults.standard
    let validator: ValidatorProtocol = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password.isSecureTextEntry = true
        email.delegate = self
        password.delegate = self
    }
    
    @IBAction func pressLogin(_ sender: Any) {
        
        if areSomeFieldsEmpty() {
            presentAlert(with: "Error", message: "Please, fill all the required fields")
            return
        }
        
        if !validator.isValid(email: email.text!) {
            presentAlert(with: "Error", message: "Email is invalid")
            return
        }
        
        if !validator.isValid(password: password.text!) {
            presentAlert(with: "Error", message: "Password must contain at least 5 characters, including numbers.")
            return
        }
        getUser()
    }
    
    func getUser() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate(format: "userEmail = %@", email.text!)
        
        guard let result = try? managedContext.fetch(request) else { return presentAlert(with: "Error", message: "Something went wrong") }
        guard let user = result.first else { return presentAlert(with: "Error", message: "User not found") }
        
        let e = (user as AnyObject).value(forKey: "userEmail") as! String
        let p = (user as AnyObject).value(forKey: "userPassword") as! String
        if e == email.text! {
            if p == password.text! {
                defaults.set(email.text!, forKey: "loggedInUserEmail")
                let vc = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                UIApplication.shared.windows.first?.rootViewController = vc
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            } else {
                presentAlert(with: "Error", message: "Password incorrect")
            }
        } else {
            presentAlert(with: "Error", message: "User not found")
        }
    }
    
    @IBAction func pressSignUp(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == email {
            password.becomeFirstResponder()
        } else if textField == password {
            pressLogin(textField)
        }
        return true
    }
}

extension LoginViewController {
    
    func areSomeFieldsEmpty() -> Bool {
        email.text!.isEmpty || password.text!.isEmpty
    }
    
    func presentAlert(with title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
}


