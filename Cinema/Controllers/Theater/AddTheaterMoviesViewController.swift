//
//  AddTheaterMoviesViewController.swift
//  Cinema
//
//  Created by MacMini-02 on 3/28/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class AddTheaterMoviesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    

    // MARK:- Declarration Field
    @IBOutlet var nameTheaterTextField : UITextField!
    @IBOutlet var capacityTextField : UITextField!
    @IBOutlet var addressTextView : UITextView!
    @IBOutlet weak var imagePicked: UIImageView!
    // MARK:- Declaration picker
    var myPickerView : UIPickerView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        self.capacityTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:- function to open galery in internal phone
    @IBAction func openPhotoLibraryButton(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    // MARK:- Function for pick image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicked.image = image
        dismiss(animated:true, completion: nil)
    }
    
    //action for save theater into database
    // MAKR:- Function to insert data to database
    @IBAction func saveButton(_ sender: UIButton) {
        if self.nameTheaterTextField.text == "" {
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Name Theater Cannot Be Empty!")
            return
        }
        if self.capacityTextField.text == "" {
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "capacity Cannot Be Empty!")
            return
        }
        if self.addressTextView.text == "" {
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "address Cannot Be Empty!")
            return
        }
        if self.imagePicked.image == nil {
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Image Cannot Be Empty!")
            return
        }
        
        //        let images : UIImage = UIImage(named:imagePicked.image)!
        // Convert image to string for insert to database
        let imageData:NSData = UIImagePNGRepresentation(imagePicked.image!)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        let param: [String: String]? = [
            "nameTheater": self.nameTheaterTextField.text!,
            "capacity": self.capacityTextField.text!,
            "address": self.addressTextView.text!,
            "image"  : strBase64
        ]
        if DBWrapper.sharedInstance.doInsertTheater(theater: param!) == true {
            Utilities.sharedInstance.showAlert(obj: self, title: "SUCCESS", message: "Success inserting movie")
            
        } else {
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Failed to insert movie")
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == capacityTextField{
            if let intValu = Int(capacityTextField.text!){
                
            }else{
                Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Capacity Must number")
            }
            return true
        }
        return true
    }
    
    /*// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }*/
}
