//
//  selectTheaterViewController.swift
//  Cinema
//
//  Created by MacMini-01 on 4/4/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

protocol selectTheaterDelegate {
    func selectTheaterWillDissmiss (param: [String: String])
}

class selectTheaterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet var tableView : UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var theater = [[String: String]]()
    var selectedTheater : [String: String]?
    var delegate: selectTheaterDelegate?
    
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
        if let data = DBWrapper.sharedInstance.fetchTheaters() {
            self.theater = data
            self.tableView.reloadData()
        }
    }
    
    @IBAction func doneButtonDidPush(_ sender: UIBarButtonItem){
        if self.delegate != nil && self.selectedTheater != nil{
            self.delegate?.selectTheaterWillDissmiss(param: self.selectedTheater!)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.theater.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectTheaterViewCell", for: indexPath) as! selectTheaterTableViewCell
        let dataTheater = self.theater[indexPath.row]
        cell.selectTheaterNameLabel?.text = dataTheater["nameTheater"]
        cell.selectAddressLabel?.text = dataTheater["address"]!
        if let decodedData = Data(base64Encoded: dataTheater["image"]!, options: .ignoreUnknownCharacters){
            let decodeImage = UIImage(data: decodedData)
            cell.selectTheaterImageView.image = decodeImage
        }
        if self.selectedTheater != nil && dataTheater["nameTheater"] == self.selectedTheater!["nameTheater"]{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let find = self.searchBar.text!
        if self.searchBar.text! == ""{
            if let data = DBWrapper.sharedInstance.fetchTheaters(){ // menampilkan data
                self.theater = data
            }
        }else{
            if let data = DBWrapper.sharedInstance.searchTheater(search: find){ // menampilkan data
                self.theater = data
            }
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedTheater = self.theater[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
    }

}
