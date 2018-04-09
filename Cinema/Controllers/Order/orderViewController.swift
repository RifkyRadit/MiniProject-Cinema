//
//  orderViewController.swift
//  Cinema
//
//  Created by MacMini-01 on 4/6/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class orderViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate, selectTheaterDelegate {

    @IBOutlet var customerNameTextField: UITextField!
    @IBOutlet var telephoneTextField: UITextField!
    @IBOutlet var nameOfFilmTextField: UITextField!
    @IBOutlet var nameOfTheaterTextField: UITextField!
    @IBOutlet var dateOfTextField: UITextField!
    @IBOutlet var hourOfFilmTextField: UITextField!
    @IBOutlet var priceOfFilmTextField: UITextField!
    @IBOutlet var seatTextField: UITextField!
    
    var selectedMovie: [String: String]?
    var selectedTheater : [String: String]?
    
    var myPickerView : UIPickerView!
    var seatPickerView : UIPickerView!
    var hours = [[String: String]]()
    var idseat = ""
    var idSchedule = ""
    
    var seats = [[String: String]]()
    var schedule = [[String: String]]()
    var dateformatter = DateFormatter()
    var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = DBWrapper.sharedInstance.fetchHours(id: selectedMovie!["idFilm"]!) {
            self.hours = data
        }
        // Do any additional setup after loading the view.
        // picker for hour
        pickUp(hourOfFilmTextField)
        pickUp(seatTextField)
        // end of hour
        nameOfFilmTextField.text = selectedMovie?["nameOfFilm"]!
        hourOfFilmTextField.text = "09.00"
        priceOfFilmTextField.text = selectedMovie?["price"]!
        
        // picker date
        self.dateformatter.dateFormat = "yyyy-MM-dd"
        let stringoftoday = self.dateformatter.string(from: Date())
        self.dateOfTextField.text = stringoftoday
        setupdatepicker()
        //end date
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupdatepicker() {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216)
        self.datePicker = UIDatePicker(frame: frame)
        self.datePicker?.datePickerMode = .date
        self.datePicker?.minimumDate = Date()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let donebutton = UIBarButtonItem(title: "DONE", style: .done, target: self, action: #selector(datePickerdonebuttonpushed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(datecancelClick))
        toolbar.setItems([cancelButton, spaceButton, donebutton], animated: false)
        
        self.dateOfTextField.inputAccessoryView = toolbar
        self.dateOfTextField.inputView = self.datePicker
    }
    
    @objc func datePickerdonebuttonpushed() {
        let selecteddate = self.datePicker?.date
        self.dateOfTextField.text = self.dateformatter.string(from: selecteddate!)
        self.dateOfTextField.resignFirstResponder()
    }
    @objc func datecancelClick() {
        dateOfTextField.resignFirstResponder()
    }
    // picker
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        if textField == hourOfFilmTextField {
            self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
            self.myPickerView.delegate = self
            self.myPickerView.dataSource = self
            self.myPickerView.backgroundColor = UIColor.white
            textField.inputView = self.myPickerView
            // ToolBar
            let toolBar = UIToolbar()
            toolBar.barStyle = .default
            toolBar.isTranslucent = true
            toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
            toolBar.sizeToFit()
            
            // Adding Button ToolBar
            
            
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            textField.inputAccessoryView = toolBar
        } else if textField == seatTextField {
            self.seatPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
            self.seatPickerView.delegate = self
            self.seatPickerView.dataSource = self
            self.seatPickerView.backgroundColor = UIColor.white
            textField.inputView = self.seatPickerView
            // ToolBar
            let toolBar = UIToolbar()
            toolBar.barStyle = .default
            toolBar.isTranslucent = true
            toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
            toolBar.sizeToFit()
            
            // Adding Button ToolBar
            
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClickSeat))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClickSeat))
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            textField.inputAccessoryView = toolBar
        }
        
        
        
        
    }
    func selectTheaterWillDissmiss(param: [String : String]) {
        self.nameOfTheaterTextField.text = param["nameTheater"]
        self.selectedTheater = param
    }
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == myPickerView {
            return hours.count
        } else if pickerView == seatPickerView {
            return seats.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == myPickerView {
            return hours[row]["hours"]
        } else if pickerView == seatPickerView {
            return seats[row]["nameSeat"]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == myPickerView {
            self.hourOfFilmTextField.text = hours[row]["hours"]
            self.idSchedule = self.hours[row]["idSchedule"]!
        } else if pickerView == seatPickerView {
            //if seat == nil will alert this seat sold out
            
            self.seatTextField.text = seats[row]["nameSeat"]
            self.idseat = seats[row]["idSeat"]!
            
        }
    }
    //MARK:- TextFiled Delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.nameOfTheaterTextField{
            self.performSegue(withIdentifier: "selectTheaterSegue", sender: self)
            return false
        }
        if textField ==  self.hourOfFilmTextField {
            self.pickUp(hourOfFilmTextField)
            return false
        }
        if textField == self.seatPickerView {
            self.pickUp(seatTextField)
            return false
        }
        if textField == self.dateOfTextField {
            return false
        }
        return false
    }
    
    //MARK:- Button
    @objc func doneClick() {
        
        hourOfFilmTextField.resignFirstResponder()
        let param : [String: String] = [
            "date" : dateOfTextField.text!,
            "hours" : hourOfFilmTextField.text!,
            "idFilm" : selectedMovie!["idFilm"]!,
            "idSchedule" : self.idSchedule
        ]
        if let data = DBWrapper.sharedInstance.fetchSeatOrder(order: param){
            self.seats = data
        }
    }
    @objc func cancelClick() {
        hourOfFilmTextField.resignFirstResponder()
    }
    @objc func doneClickSeat() {
        seatTextField.resignFirstResponder()
    }
    @objc func cancelClickSeat() {
        seatTextField.resignFirstResponder()
    }
    
    @IBAction func saveOrder(_ sender: UIButton){
        let param : [String: String] = [
            "customerName" : self.customerNameTextField.text!,
            "telephone" : self.telephoneTextField.text!,
            "idFilm" : self.selectedMovie!["idFilm"]!,
            "idSeat" : self.idseat,
            "idTheater" : self.selectedTheater!["idTheater"]!,
            "date" : dateOfTextField.text!,
            "hours" : self.hourOfFilmTextField.text!,
            "idSchedule" : self.idSchedule
        ]
        
        if DBWrapper.sharedInstance.doInsertOrder(order: param) == true{
            //insert success
            let alert = UIAlertController(title: "SUCCESS", message: "Success insert order", preferredStyle: UIAlertControllerStyle.alert)
            let oke = UIAlertAction (title: "OKE", style: UIAlertActionStyle.cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(oke)
            self.present(alert, animated: true, completion: nil)
        }else{
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Failed Insert Movie")
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

}
