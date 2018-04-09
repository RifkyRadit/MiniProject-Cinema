//
//  updateSeatViewController.swift
//  Cinema
//
//  Created by MacMini-01 on 4/4/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class updateSeatViewController: UIViewController, UITextFieldDelegate, selectTheaterDelegate {

    @IBOutlet var nameSeatTextField: UITextField!
    @IBOutlet var nameTheaterTextField: UITextField!
    
    var selectedSeat: [String: String]?
    var selectedTheater : [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = self.selectedSeat?["nameSeat"]
        self.nameSeatTextField.text = self.selectedSeat?["nameSeat"]
        self.nameTheaterTextField.text = self.selectedSeat?["nameTheater"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func updateSeatButton(_ sender: UIButton){
        if self.nameSeatTextField.text == ""{
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Seat cannot be empty")
        }
        if self.nameTheaterTextField.text == ""{
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Theater cannot be empty")
        }
        
        //untuk memasukkan index jika genre tidak di edit
        if self.selectedTheater == nil {
            selectedTheater = [String: String]()
            self.selectedTheater?["idTheater"] = self.selectedSeat?["idTheater"]
        }
        
        let param : [String: String] = [
            "idSeat": (self.selectedSeat?["idSeat"])!,
            "nameSeat" : self.nameSeatTextField.text!,
            "idTheater" : (self.selectedTheater?["idTheater"])!
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
