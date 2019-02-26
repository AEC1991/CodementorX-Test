//
//  LoginViewController.swift
//  MyIdeaPool
//
//  Created by Star on 2/25/19.
//  Copyright © 2019 TopStar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    // MARK: ------------ VC Life Cycle ----------------

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: ------------ Private Methods --------------
    
    private func isValid() -> Bool {
        var result = true
        var message = ""
        
        let email = txtEmail.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let password = txtPassword.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        if !email.isValidEmail(){
            message = "Invalid email."
            result = false
        }
        if result == true, !password.isValidPassword() {
            message = "Invalid Password."
            result = false
        }
        
        if result == false {
            self.showAlert(message: message)
        }
        return result
    }
    
    // MARK: ------------ Action Handlers ---------------

    @IBAction func actionLogin(_ sender: Any) {
        guard isValid() == true else { return}
        
        let email = txtEmail.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let password = txtPassword.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        API.shared.login(user: User(email: email, password: password)) { (success, error) in
            if error != nil {
                self.showAlert(message: error!)
            }else {
                self.performSegue(withIdentifier: "SegueID_GotoMain", sender: self)
                UserManager.shared.isLogined = true
            }
        }

    }
    @IBAction func actionCreateAccount(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") {
            AppDelegate.shared.naviVC?.setViewControllers([vc], animated: true)
        }

    }
}
