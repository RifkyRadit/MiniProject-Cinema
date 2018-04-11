//
//  historyOrderViewController.swift
//  Cinema
//
//  Created by Kahlil Fauzan on 08/04/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class historyOrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    //Declaration array
    var history = [[String: String]]()
    
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
        if let data = DBWrapper.sharedInstance.fetchHistory(){
            self.history = data
            self.tableView.reloadData()
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
    //MARK:- Implements data hostory to table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyViewCell", for: indexPath) as! historyOrderTableViewCell
        let dataHistory = self.history[indexPath.row]
        //        cell.movieNameLabel?.text = dataSchedule["nameofFilm"]
        cell.customerNameLabel.text = dataHistory["customerName"]!
        cell.telephoneLabel?.text = dataHistory["telephone"]!
        cell.nameOfFilmLabel?.text = dataHistory["nameOfFilm"]!
        cell.nameOfTheaterLabel?.text = dataHistory["nameTheater"]!
        cell.nameOfSeatLabel?.text = dataHistory["nameSeat"]!
        cell.dateLabel?.text = dataHistory["date"]!
        cell.hourLabel?.text = dataHistory["hours"]!
        if let decodedData = Data(base64Encoded: dataHistory["image"]!, options: .ignoreUnknownCharacters){
            let decodeImage = UIImage(data: decodedData)
            cell.filmOfHistoryImageView.image = decodeImage
        }
        return cell
    }

}
