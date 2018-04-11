//
//  genreUpdateMovieViewController.swift
//  Cinema
//
//  Created by Kahlil Fauzan on 01/04/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

protocol selectGenreUpdateDelegate {
    func selectGenreUpdateWillDissmiss (param: [String: String])
}

class genreUpdateMovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    // MARK:- Delcaration array
    var genre = [[String: String]]()
    var selectedgenre : [String: String]?
    var delegate :selectGenreUpdateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let data = DBWrapper.sharedInstance.fetchgenre(){
            self.genre = data
            self.tableView.reloadData()
        }
    }
    // FUnction for done
    @IBAction func doneButtonDidPush(_ sender: UIBarButtonItem){
        if self.delegate != nil && self.selectedgenre != nil{
            self.delegate?.selectGenreUpdateWillDissmiss(param: self.selectedgenre!)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK:- Implements data to table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.genre.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier: "cell")
        let dataGenre = self.genre[indexPath.row]
        cell.textLabel?.text = dataGenre["nameOfGenre"]
        
        if self.selectedgenre != nil && dataGenre["nameOfGenre"] == self.selectedgenre!["nameOfGenre"]{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedgenre = self.genre[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
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
