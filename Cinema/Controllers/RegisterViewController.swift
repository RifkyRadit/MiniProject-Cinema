//
//  RegisterViewController.swift
//  Cinema
//
//  Created by MacMini-02 on 3/28/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet var usernameTextField : UITextField?
    @IBOutlet var passwordTextField : UITextField?
    @IBOutlet var nameEmployeTextField : UITextField?
    @IBOutlet var levelTextField : UITextField?
//    @IBOutlet var nameTextField : UITextField?
//    @IBOutlet var levelTextField : UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func doRegistrationButton(_ sender: UIButton) {
//        let username = usernameTextField?.text
//        let password = passwordTextField?.text
//        let nameEmploye = nameEmployeTextField?.text
//        let level = levelTextField?.text
//        if DBWrapper.sharedInstance.doRegister(username: username!, password: password!, nameEmploye: nameEmploye!, level: level!) == true {
//            Utilities.sharedInstance.showAlert(obj: self, title: "SUCCESS", message: "Youre now registered!")
//        } else {
//            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Register Failed!")
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
