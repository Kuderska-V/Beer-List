//
//  LoginViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 02.10.2022.
//

import UIKit
import CoreData
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    
    let defaults = UserDefaults.standard
    let validator: ValidatorProtocol = Validator()
    var googleSignIn = GIDSignIn.sharedInstance
    var configuration = UIButton.Configuration.filled()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password.isSecureTextEntry = true
        email.delegate = self
        password.delegate = self
        btnFacebook.setImage(UIImage(named: "facebook"), for: .normal)
        btnFacebook.configuration?.imagePadding = 10
        btnGoogle.setImage(UIImage(named: "google"), for: .normal)
        btnGoogle.configuration?.imagePadding = 10
    }
    
    @IBAction func pressLogin(_ sender: Any) {
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
        getUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if AccessToken.current != nil {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllers.tabbar.rawValue) as! UITabBarController
            self.view.window?.rootViewController = vc
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    func getUser() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate(format: "userEmail = %@", email.text!)
        
        guard let result = try? managedContext.fetch(request) else { return presentAlert(with: "Error", message: AlertController.somethingWentWrong.rawValue) }
        guard let user = result.first else { return presentAlert(with: "Error", message: AlertController.userNotFound.rawValue) }
        
        let e = (user as AnyObject).value(forKey: "userEmail") as! String
        let p = (user as AnyObject).value(forKey: "userPassword") as! String
        if e == email.text! {
            if p == password.text! {
                defaults.set(email.text!, forKey: UserDefaultsKeys.loggedInUserEmail.rawValue)
                let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllers.tabbar.rawValue) as! UITabBarController
                self.view.window?.rootViewController = vc
                self.view.window?.makeKeyAndVisible()
            } else {
                presentAlert(with: "Error", message: AlertController.incorrectPassword.rawValue)
            }
        } else {
            presentAlert(with: "Error", message: AlertController.userNotFound.rawValue)
        }
    }

    @IBAction func pressFacebookLogin(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self, handler: { result, error  in
            if result?.isCancelled ?? false {
                print("Cancelled")
            } else if error != nil {
                print("ERROR: Trying to get login results")
            } else {
                print("Logged in")
                self.getFacebookData()
                self.viewWillAppear(true)
            }
        })
    }
    
    func getFacebookData() {
        let request = GraphRequest(graphPath: "me", parameters: ["fields":" email, first_name, last_name"])
        request.start { _, result, error in
            if error == nil {
                let data: [String: AnyObject] = result as! [String: AnyObject]
                let fbEmail = data["email"] as? String
                let fbFirstName = data["first_name"] as? String
                let fbLastName = data["last_name"] as? String
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let managedContext = appDelegate.persistentContainer.viewContext
                let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedContext) as NSManagedObject
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
                request.predicate = NSPredicate(format: "userEmail = %@", fbEmail!)
                do {
                    let count = try managedContext.count(for: request)
                    if(count == 0){
                        newUser.setValue(fbEmail, forKey: "userEmail")
                        newUser.setValue(fbFirstName, forKey: "userFirstName")
                        newUser.setValue(fbLastName, forKey: "userLastName")
                        try managedContext.save()
                        self.defaults.set(fbEmail, forKey: UserDefaultsKeys.loggedInUserEmail.rawValue)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllers.tabbar.rawValue) as! UITabBarController
                        self.view.window?.rootViewController = vc
                        self.view.window?.makeKeyAndVisible()
                        print("no present")
                    } else {
                        self.defaults.set(fbEmail, forKey: UserDefaultsKeys.loggedInUserEmail.rawValue)
                        print("one matching item found")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllers.tabbar.rawValue) as! UITabBarController
                        self.view.window?.rootViewController = vc
                        self.view.window?.makeKeyAndVisible()
                    }
                } catch let error as NSError {
                    print("Could not fetch \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    @IBAction func pressGoogleLogin(_ sender: Any) {
        self.googleAuthLogin()
    }
    
    func googleAuthLogin() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }
            let user = signInResult.user
            
            let emailGoogle = user.profile!.email
            let firstName = user.profile!.givenName
            let lastName = user.profile!.familyName

            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedContext) as NSManagedObject
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            request.predicate = NSPredicate(format: "userEmail = %@", emailGoogle)
            do {
                let count = try managedContext.count(for: request)
                if(count == 0){
                    newUser.setValue(emailGoogle, forKey: "userEmail")
                    newUser.setValue(firstName, forKey: "userFirstName")
                    newUser.setValue(lastName, forKey: "userLastName")
                    try managedContext.save()
                    self.defaults.set(emailGoogle, forKey: UserDefaultsKeys.loggedInUserEmail.rawValue)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllers.tabbar.rawValue) as! UITabBarController
                    self.view.window?.rootViewController = vc
                    self.view.window?.makeKeyAndVisible()
                    print("no present")
                } else {
                    self.defaults.set(emailGoogle, forKey: UserDefaultsKeys.loggedInUserEmail.rawValue)
                    print("one matching item found")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllers.tabbar.rawValue) as! UITabBarController
                    self.view.window?.rootViewController = vc
                    self.view.window?.makeKeyAndVisible()
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
    }
    
    @IBAction func pressSignUp(_ sender: Any) {
        let storyboard = UIStoryboard(name: Storyboards.main.rawValue, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllers.signUp.rawValue) as! SignUpViewController
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
