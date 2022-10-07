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
    @IBOutlet weak var passwordValidationLabel: UILabel!
    @IBOutlet weak var emailValidationLabel: UILabel!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password.isSecureTextEntry = true
        passwordConfirmation.isSecureTextEntry = true
        passwordValidationLabel.isEnabled = false
        emailValidationLabel.isEnabled = false
    }
    
    @IBAction func SignUpTapped(_ sender: Any) {
        let userFirstName = firstName.text!
        let userLastName = lastName.text!
        let userEmail = email.text!
        let userPassword = password.text!
        let userPasswordConfirmation = passwordConfirmation.text!
        
        if (userFirstName.isEmpty || userLastName.isEmpty || userEmail.isEmpty || userPassword.isEmpty || userPasswordConfirmation.isEmpty) {
            let ac = UIAlertController(title: "Error", message: "Please, fill all the required fields", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)

        } else if (invalidEmail(userEmail) != nil) {
            emailValidationLabel.isEnabled = true
            emailValidationLabel.textColor = .red
            emailValidationLabel.text = "Email is invalid"
        } else if (invalidPassword(userPassword) != nil) {
            passwordValidationLabel.isEnabled = true
            passwordValidationLabel.textColor = .red
            passwordValidationLabel.text = "Password must contain at least 5 characters, including numbers."

        } else if (userPassword != userPasswordConfirmation) {
            let ac = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        } else {
            defaults.set(userEmail, forKey: KeysDefaults.keyEmail)
            defaults.set(userPassword, forKey: KeysDefaults.keyPassword)
            print(userEmail, userPassword)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
    func invalidEmail(_ value: String) -> String? {
        let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        if !predicate.evaluate(with: value) {
            return "Invalid Email Address"
        }
        return nil
    }
    
    func invalidPassword(_ value: String) -> String? {
        if value.count < 5 {
            return "Password must be at least 5 characters"
        }
        if containsDigit(value) {
            return "Password must contain at least 1 digit"
        }
        return nil
    }
    
    func containsDigit(_ value: String) -> Bool {
        let reqularExpression = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}

