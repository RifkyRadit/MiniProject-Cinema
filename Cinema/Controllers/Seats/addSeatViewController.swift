//
//  addSeatViewController.swift
//  Cinema
//
//  Created by MacMini-01 on 4/4/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class addSeatViewController: UIViewController{
    
    @IBOutlet var nameSeatTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:- Function to insert to database
    @IBAction func addSeatButton(_ sender: UIButton){
        //Validatuib text field
        if self.nameSeatTextField.text == "" {
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Name Seat Cannot Be Empty!")
            return
        }
        
        let param: [String: String]? = [
            "nameSeat": self.nameSeatTextField.text!
        ]
        if DBWrapper.sharedInstance.doInsertSeat(seatData: param!) == true {
            Utilities.sharedInstance.showAlert(obj: self, title: "SUCCESS", message: "Success inserting Seat")
            
        } else {
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Failed to insert Seat")
        }
    }

    /*// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/

}
