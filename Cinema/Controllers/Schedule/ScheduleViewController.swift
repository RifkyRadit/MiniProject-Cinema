//
//  ScheduleViewController.swift
//  Cinema
//
//  Created by MacMini-04 on 3/28/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var schedule = [[String: String]]()
    var selectedSchedule: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Schedule"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let data = DBWrapper.sharedInstance.fetchSchedule(){
            self.schedule = data
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addScheduleButton(_ sender: UIBarButtonItem){
        self.performSegue(withIdentifier: "addScheduleSegue", sender: self)
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
        return self.schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleViewCell", for: indexPath) as! scheduleTableViewCell
        let dataSchedule = self.schedule[indexPath.row]
//        cell.movieNameLabel?.text = dataSchedule["nameofFilm"]
        cell.movieNameLabel.text = dataSchedule["nameOfFilm"]!
        cell.theaterNameLabel?.text = dataSchedule["nameTheater"]
        cell.hoursLabel?.text = dataSchedule["hours"]!
        if let decodedData = Data(base64Encoded: dataSchedule["image"]!, options: .ignoreUnknownCharacters){
            let decodeImage = UIImage(data: decodedData)
            cell.coverImageView.image = decodeImage
        }
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let find = self.searchBar.text!
        if self.searchBar.text! == ""{
            if let data = DBWrapper.sharedInstance.fetchSchedule(){ // menampilkan data
                self.schedule = data
            }
        }else{
            if let data = DBWrapper.sharedInstance.searchSchedule(search: find){ // menampilkan data
                self.schedule = data
            }
        }
        self.tableView.reloadData()
    }

}
