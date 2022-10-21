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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password.isSecureTextEntry = true
        email.delegate = self
        password.delegate = self
    }
    
    @IBAction func pressLogin(_ sender: Any) {
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
        getUser()
    }
    
    func getUser() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let searchEmail = email.text!
        let searchPassword = password.text!
        request.predicate = NSPredicate(format: "userEmail = %@", searchEmail)
        do {
            let result = try managedContext.fetch(request)
            if result.count > 0 {
                let e = (result[0] as AnyObject).value(forKey: "userEmail") as! String
                let p = (result[0] as AnyObject).value(forKey: "userPassword") as! String
                
                if (searchEmail == e && searchPassword == p) {
                    defaults.set(true, forKey: "isUserLoggedIn")
                    let vc = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    UIApplication.shared.windows.first?.rootViewController = vc
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                } else if (searchEmail == e || searchPassword == p) {
                    let ac = UIAlertController(title: "Error", message: "Password incorrect", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(ac, animated: true, completion: nil)
                }
            } else {
                let ac = UIAlertController(title: "User not found", message: "", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(ac, animated: true, completion: nil)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
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
    
    func isValid(email: String) -> Bool {
        let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return predicate.evaluate(with: email)
    }
    
    func isValid(password: String) -> Bool {
        guard password.count > 4 else { return false }
        return containsDigit(password)
    }
    
    func containsDigit(_ value: String) -> Bool {
        let reqularExpression = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return predicate.evaluate(with: value)
    }
}


