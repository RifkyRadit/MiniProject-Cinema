//
//  EditTheaterViewController.swift
//  Cinema
//
//  Created by MacMini-02 on 3/29/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class EditTheaterViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
  
    @IBOutlet var nameTheaterTextField: UITextField!
    @IBOutlet var capacityTextField: UITextField!
    @IBOutlet var addressTheaterTextField: UITextView!
    @IBOutlet var theaterImageView : UIImageView!
    
    var myPickerView : UIPickerView!
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var imagePicked: UIImageView!
    
    var selectTheaters: [String: String]?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameTheaterTextField.text = self.selectTheaters?["nameTheater"]
        self.capacityTextField.text = self.selectTheaters?["capacity"]!
        self.addressTheaterTextField.text = self.selectTheaters?["address"]
        if let decodedData = Data(base64Encoded: (selectTheaters?["image"]!)!, options: .ignoreUnknownCharacters){
            let decodeImage = UIImage(data: decodedData)
            self.imagePicked.image = decodeImage
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openPhotoLibraryButton(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicked.image = image
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func updateButton(_ sender: UIButton) {
        if self.nameTheaterTextField.text == "" {
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Name Theater Cannot Be Empty!")
            return
        }
        if self.capacityTextField.text == "" {
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "capacity Cannot Be Empty!")
            return
        }
        if self.addressTheaterTextField.text == "" {
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "address Cannot Be Empty!")
            return
        }
        if self.imagePicked.image == nil {
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Image Cannot Be Empty!")
            return
        }
        
        //        let images : UIImage = UIImage(named:imagePicked.image)!
        let imageData:NSData = UIImagePNGRepresentation(imagePicked.image!)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        let param: [String: String]? = [
            "idTheater": (self.selectTheaters?["idTheater"])!,
            "nameTheater": self.nameTheaterTextField.text!,
            "capacity": self.capacityTextField.text!,
            "address": self.addressTheaterTextField.text!,
            "image"  : strBase64
        ]
        
        if DBWrapper.sharedInstance.doUpdateTheater(theater: param!) == true {
            Utilities.sharedInstance.showAlert(obj: self, title: "SUCCESS", message: "Success inserting movie")
            
        } else {
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Failed to insert movie")
        }
    }
    

    /*// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
     
    }*/

}
