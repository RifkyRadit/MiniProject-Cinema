//
//  addScheduleViewController.swift
//  Cinema
//
//  Created by MacMini-01 on 4/5/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class addScheduleViewController: UIViewController, UITextFieldDelegate, selectMovieDelegate, selectTheaterDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK:- Declaration text field
    @IBOutlet var movieTitleTextField: UITextField!
    @IBOutlet var theaterTextField: UITextField!
    @IBOutlet var hoursTextField: UITextField!
    //MARK:- Delcaraion array 2 demension
    var movies = [[String: String]]()
    var theaters = [[String: String]]()
    //MARK:- Declaration picker view
    var myPickerView : UIPickerView!
    var hours = ["09.00", "12.00", "14.00", "16.00", "19.00", "22.00"]
    //MARK:- Declaration selector
    var selectedMovie: [String: String]?
    var selectedTheaters : [String: String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pickUp(hoursTextField)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Function picker view
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
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
        
    }
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hours.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hours[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.hoursTextField.text = hours[row]
    }
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUp(hoursTextField)
    }
    
    //MARK:- Button
    @objc func doneClick() {
        hoursTextField.resignFirstResponder()
    }
    @objc func cancelClick() {
        hoursTextField.resignFirstResponder()
    }
    
    @IBAction func addScheduleButton(_ sender: UIButton){
        if self.movieTitleTextField.text == ""{
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Movie cannot be empty")
        }
        
        if self.theaterTextField.text == ""{
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Theater cannot be empty")
        }
        
        let param: [String: String]? = [
            "idFilm": selectedMovie!["idFilm"]!,
            "idTheater": selectedTheaters!["idTheater"]!,
            "hours": self.hoursTextField.text!
        ]
        
        if DBWrapper.sharedInstance.insertSchedule(schedule: param!) == true{
            Utilities.sharedInstance.showAlert(obj: self, title: "SUCCESS", message: "Success insert scehdule")
        }else{
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Error insert scehdule")
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "selectMovieSegue"{
            let obj = segue.destination as! selectMovieViewController
            obj.delegate = self
        }
        if segue.identifier == "selectTheaterScheduleSegue"{
            let obj = segue.destination as! selectTheaterViewController
            obj.delegate = self
        }
    }
    //MARK:- Function when text field begine edit
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.movieTitleTextField{
            self.performSegue(withIdentifier: "selectMovieSegue", sender: self)
            return false
        }
        if textField == self.theaterTextField{
            self.performSegue(withIdentifier: "selectTheaterScheduleSegue", sender: self)
            return false
        }
        return false
    }
    //MARK:- Set data to field from selector
    func selectMovieWillDissmiss(param: [String : String]) {
        self.movieTitleTextField.text = param["nameOfFilm"]
        self.selectedMovie = param
    }
    func selectTheaterWillDissmiss(param: [String : String]) {
        self.theaterTextField.text = param["nameTheater"]
        self.selectedTheaters = param
    }

}
