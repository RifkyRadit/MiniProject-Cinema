//
//  addMovieViewController.swift
//  Cinema
//
//  Created by MacMini-04 on 3/29/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit
class addMovieViewController: UIViewController, UITextFieldDelegate, selectGenreDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    
    @IBOutlet var movieNameTextField: UITextField!
    @IBOutlet var idGenreTextField: UITextField!
    @IBOutlet var producerTextField: UITextField!
    @IBOutlet var castTextField: UITextField!
    @IBOutlet var durasiTextField: UITextField!
    @IBOutlet var yearTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var deskripsiTextView: UITextView!
    
    var myPickerView : UIPickerView!
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var imagePicked: UIImageView!
    
    
    var selectedgenre : [String: String]?
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
    @IBAction func openPhotoLibraryButton(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            var imagePicker = UIImagePickerController()
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 211.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 211.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
   
    
    @IBAction func addMovieDidPushButton(_ sender: UIButton){
        if self.movieNameTextField.text == ""{
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Movie Name cannot be empty")
            return
        }
        if self.idGenreTextField.text == ""{
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Genre cannot be empty")
        }
        if self.producerTextField.text == ""{
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Producer cannot be empty")
            return
        }
        if self.castTextField.text == ""{
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Cast Cannot be empty")
        }
        if self.durasiTextField.text == ""{
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Duration cannot be empty")
            return
        }
        if self.yearTextField.text == ""{
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Year cannot be empty")
        }
        if self.priceTextField.text == ""{
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Price cannot be empty")
        }
        if self.deskripsiTextView.text == ""{
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Deskription cannot be empty")
            return
        }
        if self.imagePicked.image == nil {
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Image Cannot Be Empty!")
            return
        }
//        let images : UIImage = UIImage(named:imagePicked.image)!
        let imageData:NSData = UIImagePNGRepresentation(imagePicked.image!)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        
        let param : [String: String] = [
            "nameOfFilm" : self.movieNameTextField.text!,
            "idGenre" : selectedgenre!["idGenre"]!,
            "producer" : self.producerTextField.text!,
            "cast" : self.castTextField.text!,
            "duration" : self.durasiTextField.text!,
            "year" : self.yearTextField.text!,
            "price" : self.priceTextField.text!,
            "description" : self.deskripsiTextView.text!,
            "image"  : strBase64
        ]
        
        if DBWrapper.sharedInstance.doInsertMovie(movieData: param) == true{
            //insert success
            let alert = UIAlertController(title: "SUCCESS", message: "Success insert movies", preferredStyle: UIAlertControllerStyle.alert)
            let oke = UIAlertAction (title: "OKE", style: UIAlertActionStyle.cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(oke)
            self.present(alert, animated: true, completion: nil)
        }else{
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Failed Insert Movie")
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "selectGenreSegue"{
            let obj = segue.destination as! genreViewController
            obj.delegate = self
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.idGenreTextField{
            self.performSegue(withIdentifier: "selectGenreSegue", sender: self)
            return false
        }
        return false
    }
    
    func selectGenreWillDissmiss(param: [String : String]) {
        self.idGenreTextField.text = param["nameOfGenre"]
        self.selectedgenre = param
    }

}
