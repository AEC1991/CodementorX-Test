//
//  SignUpViewController.swift
//  MyIdeaPool
//
//  Created by Star on 2/25/19.
//  Copyright © 2019 TopStar. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    // MARK: ------------ VC Life Cycle ----------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    // MARK: ------------ Private Methods --------------
    
    private func isValid() -> Bool {
        var result = true
        var message = ""
        
        let name = txtName.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let email = txtEmail.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let password = txtPassword.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        if name == ""{
            message = "Please input your name."
            result = false
        }
        if result == true, !email.isValidEmail(){
            message = "Please input an valid email."
            result = false
        }
        if result == true, !password.isValidPassword() {
            message = "Password must be at least 8 characters, including 1 uppercase letter, 1 lowercase letter, and 1 number."
            result = false
        }
        
        if result == false {
            self.showAlert(message: message)
        }
        return result
    }

    // MARK: ------------ Action Handlers ---------------

    @IBAction func actionSignUp(_ sender: UIButton) {
        
        guard isValid() == true else { return}
        
        let name = txtName.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let email = txtEmail.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let password = txtPassword.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        API.shared.signUp(user: User(email: email, password: password, name: name)) { (success, error) in
            if error != nil {
                self.showAlert(message: error!)
            }else {
                self.performSegue(withIdentifier: "SegueID_GotoMain", sender: self)
                UserManager.shared.isLogined = true
            }
            
        }
    }
    
    @IBAction func actionGotoLogin(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
            AppDelegate.shared.naviVC?.setViewControllers([vc], animated: true)
        }
    }
}

