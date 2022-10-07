//
//  SignUpViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 29.09.2022.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirmation: UITextField!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password.isSecureTextEntry = true
        passwordConfirmation.isSecureTextEntry = true
    }
    
    @IBAction func SignUpTapped(_ sender: Any) {
        
        if isSomeFieldAreEmpty() {
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
        
        defaults.set(email.text!, forKey: KeysDefaults.keyEmail)
        defaults.set(password.text!, forKey: KeysDefaults.keyPassword)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
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
    
    func isSomeFieldAreEmpty() -> Bool {
        firstName.text!.isEmpty || lastName.text!.isEmpty || email.text!.isEmpty || password.text!.isEmpty || passwordConfirmation.text!.isEmpty
    }
    
    func containsDigit(_ value: String) -> Bool {
        let reqularExpression = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return predicate.evaluate(with: value)
    }
}

