//
//  updateMovieViewController.swift
//  Cinema
//
//  Created by MacMini-04 on 3/29/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class updateMovieViewController: UIViewController, UITextFieldDelegate, selectGenreUpdateDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var movieNameTextField: UITextField!
    @IBOutlet var idGenreTextField: UITextField!
    @IBOutlet var producerTextField: UITextField!
    @IBOutlet var castTextField: UITextField!
    @IBOutlet var durasiTextField: UITextField!
    @IBOutlet var yearTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var deskripsiTextView: UITextView!
    @IBOutlet var coverImageView : UIImageView!
    
    var myPickerView : UIPickerView!
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var imagePicked: UIImageView!
    
    var selectedMovie: [String: String]?
    var selectedgenre: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = self.selectedMovie?["nameOfFilm"]
        self.movieNameTextField.text = self.selectedMovie?["nameOfFilm"]
        self.idGenreTextField.text = self.selectedMovie?["nameOfGenre"]
        self.producerTextField.text = self.selectedMovie?["producer"]
        self.castTextField.text = self.selectedMovie?["cast"]
        self.durasiTextField.text = self.selectedMovie?["duration"]
        self.yearTextField.text = self.selectedMovie?["year"]
        self.priceTextField.text = self.selectedMovie?["price"]
        self.deskripsiTextView.text = self.selectedMovie?["description"]
        if let decodedData = Data(base64Encoded: (selectedMovie?["image"]!)!, options: .ignoreUnknownCharacters){
            let decodeImage = UIImage(data: decodedData)
            self.imagePicked.image = decodeImage
        }
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
    
    @IBAction func updateButtonDidPushed(_ sender: UIButton){
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
        
        //untuk memasukkan index jika genre tidak di edit
        if self.selectedgenre == nil {
            selectedgenre = [String: String]()
            self.selectedgenre?["idGenre"] = self.selectedMovie?["idGenre"]
        }
        
        let param : [String: String] = [
            "idFilm": (self.selectedMovie?["idFilm"])!,
            "nameOfFilm" : self.movieNameTextField.text!,
            "idGenre" : (self.selectedgenre?["idGenre"])!,
            "producer" : self.producerTextField.text!,
            "cast" : self.castTextField.text!,
            "duration" : self.durasiTextField.text!,
            "year" : self.yearTextField.text!,
            "price" : self.priceTextField.text!,
            "description" : self.deskripsiTextView.text!,
            "image"  : strBase64
        ]
        
        if DBWrapper.sharedInstance.updateMovie(movieData: param) == true{
            //insert success
            let alert = UIAlertController(title: "SUCCESS", message: "Success insert movies", preferredStyle: UIAlertControllerStyle.alert)
            let oke = UIAlertAction (title: "OKE", style: UIAlertActionStyle.cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(oke)
            self.present(alert, animated: true, completion: nil)
        }else{
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Failed Update Movie")
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
         if segue.identifier == "editSelectGenreSegue"{
             let obj = segue.destination as! genreUpdateMovieViewController
             obj.delegate = self
         }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        if textField == self.idGenreTextField{
            self.performSegue(withIdentifier: "editSelectGenreSegue", sender: self)
            return false
        }
        return false
    }
    
    func selectGenreUpdateWillDissmiss(param: [String : String]) {
        self.idGenreTextField.text = param["nameOfGenre"]
        self.selectedgenre = param
    }

}
