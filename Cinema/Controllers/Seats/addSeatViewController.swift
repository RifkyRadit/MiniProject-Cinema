//
//  addSeatViewController.swift
//  Cinema
//
//  Created by MacMini-01 on 4/4/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class addSeatViewController: UIViewController, UITextFieldDelegate, selectTheaterDelegate {
    
    @IBOutlet var nameSeatTextField: UITextField!
    @IBOutlet var nameTheaterTextField: UITextField!
    var selectedTheater : [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addSeatButton(_ sender: UIButton){
        if self.nameSeatTextField.text == "" {
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Name Seat Cannot Be Empty!")
            return
        }
        
        if self.nameTheaterTextField.text == "" {
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Name Theater Cannot Be Empty!")
            return
        }
        
        let param: [String: String]? = [
            "nameSeat": self.nameSeatTextField.text!,
            "idTheater": selectedTheater!["idTheater"]!,
        ]
        if DBWrapper.sharedInstance.doInsertSeat(seatData: param!) == true {
            Utilities.sharedInstance.showAlert(obj: self, title: "SUCCESS", message: "Success inserting movie")
            
        } else {
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Failed to insert movie")
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "selectTheaterSegue"{
            let obj = segue.destination as! selectTheaterViewController
            obj.delegate = self
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.nameTheaterTextField{
            self.performSegue(withIdentifier: "selectTheaterSegue", sender: self)
            return false
        }
        return false
    }
    
    func selectTheaterWillDissmiss(param: [String : String]) {
        self.nameTheaterTextField.text = param["nameTheater"]
        self.selectedTheater = param
    }

}
