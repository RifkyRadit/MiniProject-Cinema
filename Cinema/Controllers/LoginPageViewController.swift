//
//  LoginPageViewController.swift
//  Cinema
//
//  Created by MacMini-02 on 3/28/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField?
    @IBOutlet var passwordTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordTextField?.layer.cornerRadius = 4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: UIButton){
        //validation data username and password
        if self.usernameTextField?.text == "" {
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Username cannot be empty")
            return
        }
        
        if self.passwordTextField?.text == "" {
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Password cannot be empty")
            return
        }
        
        if self.passwordTextField?.text == "" && self.usernameTextField?.text == ""{
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Password and Username cannot be empty")
            return
        }
        
        let username = self.usernameTextField?.text!
        let password = self.passwordTextField?.text!
        
        //cek username and password match
        if DBWrapper.sharedInstance.doLogin(username: username!, password: password!) != nil {
            let data = DBWrapper.sharedInstance.checklUserLevel(username: username!)
             if data == "admin"{
                self.performSegue(withIdentifier: "adminSegue", sender: self)
            }
       } else {
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "You're paaword or uaername wrong")
       }
    }
    @IBAction func registrationButton(_ sender: UIButton){
        self.performSegue(withIdentifier: "regisSegue", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
