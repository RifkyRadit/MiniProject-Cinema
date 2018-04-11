//
//  updateSeatViewController.swift
//  Cinema
//
//  Created by MacMini-01 on 4/4/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class updateSeatViewController: UIViewController, UITextFieldDelegate{

    // MARK:- Declaration field
    @IBOutlet var nameSeatTextField: UITextField!
    // MARK:- Declaration array (Dictonary)
    var selectedSeat: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = self.selectedSeat?["nameSeat"]
        self.nameSeatTextField.text = self.selectedSeat?["nameSeat"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Fucntion to update to database
    @IBAction func updateSeatButton(_ sender: UIButton){
        if self.nameSeatTextField.text == ""{
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Seat cannot be empty")
        }
        
        
        
        let param : [String: String] = [
            "idSeat": (self.selectedSeat?["idSeat"])!,
            "nameSeat" : self.nameSeatTextField.text!
        ]
        
        if DBWrapper.sharedInstance.updateSeat(seatData: param) == true{
            //insert success
            let alert = UIAlertController(title: "SUCCESS", message: "Success update Seat", preferredStyle: UIAlertControllerStyle.alert)
            let oke = UIAlertAction (title: "OKE", style: UIAlertActionStyle.cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(oke)
            self.present(alert, animated: true, completion: nil)
        }else{
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Failed Update Seat")
        }
    }

    
    /*// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/

}
