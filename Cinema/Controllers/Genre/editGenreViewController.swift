//
//  editGenreViewController.swift
//  Cinema
//
//  Created by MacMini-04 on 3/29/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class editGenreViewController: UIViewController {

    @IBOutlet var nameOfGenreTextField: UITextField! //textfield input genre
    
    var selectedgenre : [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.title = self.selectedgenre?["nameOfGenre"]
        self.nameOfGenreTextField.text = self.selectedgenre?["nameOfGenre"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Function to update to database
     @IBAction func updateGenreButtonDidPush(_ sender: UIButton){
     
         if self.nameOfGenreTextField.text == ""{
     
            Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Genre cannot be empty")
            return
         }
     
         let param: [String: String] = [
             "idGenre" : (self.selectedgenre?["idGenre"])!,
             "nameOfGenre" : self.nameOfGenreTextField.text!
         ]
     
         if DBWrapper.sharedInstance.updateGenre(genreData: param) == true{
             //success
             let alert = UIAlertController(title: "SUCCESS", message: "Genre Updated!", preferredStyle: UIAlertControllerStyle.alert)
             let oke = UIAlertAction(title: "OKE", style: UIAlertActionStyle.cancel, handler : { (action) in
     
             alert.dismiss(animated: true, completion: nil)
             self.navigationController?.popViewController(animated: true)
     
             })
             alert.addAction(oke)
             self.present(alert, animated: true, completion: nil)
         }else{
             //Error
             Utilities.sharedInstance.showAlertCancel(obj: self, title: "ERROR", message: "Genre error saved")
         }
     
     }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
