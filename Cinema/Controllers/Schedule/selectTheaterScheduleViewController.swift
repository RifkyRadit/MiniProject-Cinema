//
//  selectTheaterScheduleViewController.swift
//  Cinema
//
//  Created by MacMini-01 on 4/9/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

protocol selectTheaterScheduleDelegate {
    func selectTheaterScheduleWillDissmiss (param: [String: String])
}

class selectTheaterScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    //MARK:- Declaration table and search
    @IBOutlet var tableView : UITableView!
    @IBOutlet var searchBar : UISearchBar!
    //MARK;- Delcararation array and selector
    var selectedMovie : [String: String]?
    var theaters = [[String: String]]()
    var selectedTheater : [String: String]?
    var delegate: selectTheaterScheduleDelegate?
    
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
        let idFilm = selectedMovie!["idFilm"]!
        if let data = DBWrapper.sharedInstance.fetchTheaterSchedule(idFilm : idFilm){
            self.theaters = data
            self.tableView.reloadData()
        }
    }

    //MARK:- Function done button
    @IBAction func doneScheduleButtonDidPush(_ sender: UIBarButtonItem){
        if self.delegate != nil && self.selectedTheater != nil{
            self.delegate?.selectTheaterScheduleWillDissmiss(param: self.selectedTheater!)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK:- Implement data to table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.theaters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectTheaterScheduleViewCell", for: indexPath) as! selectTheaterScheduleTableViewCell
        let dataTheater = self.theaters[indexPath.row]
        cell.selectTheaterScheduleNameLabel?.text = dataTheater["nameTheater"]
        cell.selectAddressScheduleLabel?.text = dataTheater["address"]!
        if let decodedData = Data(base64Encoded: dataTheater["image"]!, options: .ignoreUnknownCharacters){
            let decodeImage = UIImage(data: decodedData)
            cell.selectTheaterScheduleImageView.image = decodeImage
        }
        if self.selectedTheater != nil && dataTheater["nameTheater"] == self.selectedTheater!["nameTheater"]{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedTheater = self.theaters[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
    }
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        let find = self.searchBar.text!
//        if self.searchBar.text! == ""{
//            if let data = DBWrapper.sharedInstance.fetchTheaterSchedule(){ // menampilkan data
//                self.theaters = data
//            }
//        }else{
//            if let data = DBWrapper.sharedInstance.searchTheaterSchedule(search: find){ // menampilkan data
//                self.theaters = data
//            }
//        }
//        self.tableView.reloadData()
//    }
    //MARK:- Function search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let find = self.searchBar.text!
        let idFilm = selectedMovie!["idFilm"]!
        if self.searchBar.text! == ""{
            if let data = DBWrapper.sharedInstance.fetchTheaterSchedule(idFilm: idFilm){ // menampilkan data
                self.theaters = data
            }
        }else{
            if let data = DBWrapper.sharedInstance.searchTheaterSchedule(search: find, idFilm: idFilm){ // menampilkan data
                self.theaters = data
            }
        }
        self.tableView.reloadData()
    }
    
    

}
