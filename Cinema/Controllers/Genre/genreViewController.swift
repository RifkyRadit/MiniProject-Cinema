//
//  genreViewController.swift
//  Cinema
//
//  Created by MacMini-04 on 3/29/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

protocol selectGenreDelegate {
    func selectGenreWillDissmiss (param: [String: String])
}

class genreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var genre = [[String: String]]()
    var selectedgenre : [String: String]?
    var delegate :selectGenreDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //delete back button in left bar navigation item
        let tmpbtn = UIBarButtonItem()
        self.navigationItem.leftBarButtonItem = tmpbtn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let data = DBWrapper.sharedInstance.fetchgenre(){
            self.genre = data
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func addGenreDidPushButton(_ sender: UIBarButtonItem){
        self.performSegue(withIdentifier: "addGenreSegue", sender: self)
    }
    
//    @IBAction func doneButtonDidPush(_ sender: UIBarButtonItem){
//        if self.delegate != nil && self.selectedgenre != nil{
//            self.delegate?.selectGenreWillDissmiss(param: self.selectedgenre!)
//        }
//        self.navigationController?.popViewController(animated: true)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editGenreSegue" {
            let obj = segue.destination as! editGenreViewController
            obj.selectedgenre = self.selectedgenre
        }
    }
    
//    @IBAction func editButtonDidPush(_ sender: UIButton){
//        self.performSegue(withIdentifier: "editGenreSegue", sender: self)
//    }
//
    //fungsi delete genre
//     @IBAction func deleteButtonDidPush(_ sender: UIButton){
//
//            //action confirmasi delete
//            let confirmAlert = UIAlertController(title: self.selectedgenre?["nameOfGenre"], message: "Are You Sure", preferredStyle: UIAlertControllerStyle.alert)
//
//            //cancel delete
//            let cancelDelete = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in confirmAlert.dismiss(animated: true, completion: nil) })
//
//            //action untuk delete
//            let okeDelete = UIAlertAction(title: "Oke", style: UIAlertActionStyle.default, handler: { (action) in
//
//                confirmAlert.dismiss(animated: true, completion: nil)
//                let param: [String: String] = [
//                    "idGenre": (self.selectedgenre?["idGenre"])!
//                ]
//
//                if DBWrapper.sharedInstance.deleteGenre(genreData: param) == true{
//                    if let data = DBWrapper.sharedInstance.fetchgenre(){
//                        self.genre = data
//                        self.tableView.reloadData()
//                    }
//                }
//
//            })
//            confirmAlert.addAction(cancelDelete)
//            confirmAlert.addAction(okeDelete)
//            self.present(confirmAlert, animated: true, completion: nil)
//
////        let param: [String: String] = [
////            "idGenre": (self.selectedgenre?["idGenre"])!
////        ]
////
////         if DBWrapper.sharedInstance.deleteGenre(genreData: param) == true{
////             if let data = DBWrapper.sharedInstance.fetchgenre(){
////                 self.genre = data
////                 self.tableView.reloadData()
////             }
////         }
//     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.genre.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier: "cell")
        let dataGenre = self.genre[indexPath.row]
        cell.textLabel?.text = dataGenre["nameOfGenre"]
        
//        if self.selectedgenre != nil && dataGenre["nameOfGenre"] == self.selectedgenre!["nameOfGenre"]{
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.selectedgenre = self.genre[indexPath.row]
//        tableView.deselectRow(at: indexPath, animated: true)
//        self.tableView.reloadData()
        let dataGenre = self.genre[indexPath.row]
        self.selectedgenre = dataGenre
        tableView.deselectRow(at: indexPath, animated: true)
        
        let actionSheet = UIAlertController(title: "What do you want to do with :", message: self.selectedgenre?["nameOfGenre"], preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: UIAlertActionStyle.default) { (action) in
            self.performSegue(withIdentifier: "editGenreSegue", sender: self)
        }
        
        //done action
        let doneAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (action) in
            if self.delegate != nil && self.selectedgenre != nil{
                self.delegate?.selectGenreWillDissmiss(param: self.selectedgenre!)
            }
            self.navigationController?.popViewController(animated: true)
        }
        
        //delete action
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.default) {
            (action) in
            let actionSheet = UIAlertController(title: "Are you sure to delete", message: self.selectedgenre?["nameOfGenre"], preferredStyle: UIAlertControllerStyle.alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
                (action) in
                
                actionSheet.dismiss(animated: true, completion: nil)
                let param: [String: String] = [
                    "idGenre": (self.selectedgenre?["idGenre"])!
                ]
                
                if DBWrapper.sharedInstance.deleteGenre(genreData: param) == true{
                    // Succes delete movie
                    let alert = UIAlertController(title: "SUCCESS", message: "Genre Deleted!", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                        
                        // dismiss alert
                        alert.dismiss(animated: true, completion: nil)
                        
                        //reload controller
                        if let data = DBWrapper.sharedInstance.fetchgenre(){
                            self.genre = data
                            self.tableView.reloadData()
                        }
                        
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                } else {
                    // Failed update movie
                    Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Something wrong happened")
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                (action) in
                actionSheet.dismiss(animated: true, completion: nil)
            }
            actionSheet.addAction(yesAction)
            actionSheet.addAction(cancelAction)
            
            self.present(actionSheet, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
            actionSheet.dismiss(animated: true, completion: nil)
        }
        
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(editAction)
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(doneAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
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
