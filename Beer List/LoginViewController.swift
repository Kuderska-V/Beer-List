//
//  LoginViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 02.10.2022.
//

import UIKit

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
        let userEmail = email.text!
        let userPassword = password.text!
        
        if userEmail != defaults.string(forKey: KeysDefaults.keyEmail) {
            let ac = UIAlertController(title: "Login Failed", message: "This email is not registered.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        } else if userPassword != defaults.string(forKey: KeysDefaults.keyPassword) {
            let ac = UIAlertController(title: "Login Failed", message: "Your password is incorrect. Please try agail.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func pressSignUp(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
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


