//
//  TheaterMoviesViewController.swift
//  Cinema
//
//  Created by MacMini-02 on 3/28/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class TheaterMoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet var searchBar : UISearchBar!
    
    var theaters = [[String: String]]()
    var selectedTheaters : [String: String]?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let data = DBWrapper.sharedInstance.fetchTheaters() {
            self.theaters = data
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addTheaterButton(_ sender: UIBarButtonItem){
        self.performSegue(withIdentifier: "addTheaterSegue", sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editTheaterSegue" {
            let obj = segue.destination as! EditTheaterViewController
            obj.selectTheaters = self.selectedTheaters
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.theaters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "theaterViewCell", for: indexPath) as! TheaterTableViewCell
        let theater = self.theaters[indexPath.row]
        
        cell.theaterNameLabel?.text = theater["nameTheater"]!
        cell.addressLabel?.text = theater["address"]!
        if let decodedData = Data(base64Encoded: theater["image"]!, options: .ignoreUnknownCharacters){
            let decodeImage = UIImage(data: decodedData)
            cell.theaterImageView.image = decodeImage
        }
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let find = self.searchBar.text!
        if self.searchBar.text! == ""{
            if let data = DBWrapper.sharedInstance.fetchTheaters(){ // menampilkan data
                self.theaters = data
            }
        }else{
            if let data = DBWrapper.sharedInstance.searchTheater(search: find){ // menampilkan data
                self.theaters = data
            }
        }
        self.tableView.reloadData()
    }
 
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theater = self.theaters[indexPath.row]
        self.selectedTheaters = theater
        
        
        let actionSheet = UIAlertController(title: "What do you want to do with :", message: self.selectedTheaters?["nameTheater"], preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let editAction = UIAlertAction(title: "Update", style: UIAlertActionStyle.default) { (action) in
            self.performSegue(withIdentifier: "editTheaterSegue", sender: self)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.default) {
            (action) in
            let actionSheet = UIAlertController(title: "Are you sure to delete", message: self.selectedTheaters?["nameTheater"], preferredStyle: UIAlertControllerStyle.alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
                (action) in
                actionSheet.dismiss(animated: true, completion: nil)
                
                let param: [String: String] = [
                    "idTheater": (self.selectedTheaters?["idTheater"])!
                ]
            
                if DBWrapper.sharedInstance.doDeleteTheater(theater: param) == true {
                    // Succes update movie
                    let alert = UIAlertController(title: "SUCCESS", message: "Movie Deleted!", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                        
                        // dismiss alert
                        alert.dismiss(animated: true, completion: nil)
                        
                        //reload controller
                        if let data = DBWrapper.sharedInstance.fetchTheaters() {
                            self.theaters = data
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
        
        self.present(actionSheet, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
