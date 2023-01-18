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
    
    let defaults = UserDefaults.standard
    let validator: ValidatorProtocol = Validator()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        password.delegate = self
        passwordConfirmation.delegate = self
        password.isSecureTextEntry = true
        passwordConfirmation.isSecureTextEntry = true
//        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(tapBackButton))
//        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @IBAction func SignUpTapped(_ sender: Any) {
        if areSomeFieldsEmpty() {
            presentAlert(with: "Error", message: AlertController.fieldsEmpty.rawValue)
            return
        }
        
        if !validator.isValid(email: email.text!) {
            presentAlert(with: "Error", message: AlertController.invalidEmail.rawValue)
            return
        }
        
        if !validator.isValid(password: password.text!) {
            presentAlert(with: "Error", message: AlertController.invalidPassword.rawValue)
            return
        }
        
        if password.text! != passwordConfirmation.text! {
            presentAlert(with: "Error", message: AlertController.matchPasswords.rawValue)
            return
        }
        save()
    }

    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedContext) as NSManagedObject
        newUser.setValue(firstName.text, forKey: "userFirstName")
        newUser.setValue(lastName.text, forKey: "userLastName")
        newUser.setValue(email.text, forKey: "userEmail")
        newUser.setValue(password.text, forKey: "userPassword")
        do {
            try managedContext.save()
            defaults.set(email.text!, forKey: UserDefaultsKeys.loggedInUserEmail.rawValue)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllers.tabbar.rawValue) as! UITabBarController
//            UIApplication.shared.windows.first?.rootViewController = vc
//            UIApplication.shared.windows.first?.makeKeyAndVisible()
            self.view.window?.rootViewController = vc
            self.view.window?.makeKeyAndVisible()
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
    
//    @objc func tapBackButton() {
//        //let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllers.login.rawValue)
//        self.navigationController?.popViewController(animated: true)
//    }
}

extension SignUpViewController {
    
    func areSomeFieldsEmpty() -> Bool {
        firstName.text!.isEmpty || lastName.text!.isEmpty || email.text!.isEmpty || password.text!.isEmpty || passwordConfirmation.text!.isEmpty
    }
    
    func presentAlert(with title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
}

