//
//  seatViewController.swift
//  Cinema
//
//  Created by MacMini-01 on 4/4/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class seatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Delcaration table view
    @IBOutlet var tableView: UITableView!
    //MARK:- Declaration array
    var seat = [[String: String]]()
    var selectedSeat: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let data = DBWrapper.sharedInstance.fetchSeat() {
            self.seat = data
            self.tableView.reloadData()
        }
    }
    //MARK:- Fucntion add seat
    @IBAction func addSeatDidPushButton(_ sender: UIBarButtonItem){
        self.performSegue(withIdentifier: "addSeatSegue", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "updateSeat"{
            let obj = segue.destination as! updateSeatViewController
            obj.selectedSeat = self.selectedSeat
        }
    }
    // MARK:- Implement data to table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.seat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "seatsViewCell", for: indexPath) as! SeatTableViewCell
        let dataSeat = self.seat[indexPath.row]
        cell.seatNameLabel.text = dataSeat["nameSeat"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        let seat = self.seat[indexPath.row]
        self.selectedSeat = seat
        
        //actionSheet popUp
        let actionSheet = UIAlertController(title: "What do you want to do with :", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        //action edit
        let editAction = UIAlertAction(title: "Update", style: UIAlertActionStyle.default){ (action) in self.performSegue(withIdentifier: "updateSeat", sender: self) }
        
        //action delete
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.default){ (action) in
            
            //action confirmasi delete
            let confirmAlert = UIAlertController(title: "Are you sure to delete" , message: self.selectedSeat?["nameSeat"], preferredStyle: UIAlertControllerStyle.alert)
            
            //cancel delete
            let cancelDelete = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in confirmAlert.dismiss(animated: true, completion: nil) })
            
            //action untuk delete
            let okeDelete = UIAlertAction(title: "Oke", style: UIAlertActionStyle.default, handler: { (action) in
                
                confirmAlert.dismiss(animated: true, completion: nil)
                let param: [String: String] = [
                    "idSeat" : (self.selectedSeat?["idSeat"])!
                ]
                
                //delete film
                if DBWrapper.sharedInstance.deleteSeat(seatData: param) == true{
                    if let data = DBWrapper.sharedInstance.fetchSeat(){
                        self.seat = data
                        self.tableView.reloadData()
                    }
                }else{
                    Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Something Wrong!")
                }
                
            })
            confirmAlert.addAction(cancelDelete)
            confirmAlert.addAction(okeDelete)
            self.present(confirmAlert, animated: true, completion: nil)
            
        }
        
        //cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
            actionSheet.dismiss(animated: true, completion: nil)
        }
        actionSheet.addAction(editAction)
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(deleteAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
