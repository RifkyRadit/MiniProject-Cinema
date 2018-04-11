//
//  detailMovieViewController.swift
//  Cinema
//
//  Created by MacMini-01 on 4/2/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class detailMovieViewController: UIViewController {

    // MARK:- Delcaration field and table
    @IBOutlet var tableView: UITableView!
    @IBOutlet var movieNamelabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var producerLabel: UILabel!
    @IBOutlet var castLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var coverImageView : UIImageView!
    // MARK:- Delcaration array
    var movies = [[String: String]]()
    var selectedMovie: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = self.selectedMovie?["nameOfFilm"]
        self.movieNamelabel.text = self.selectedMovie?["nameOfFilm"]
        self.genreLabel.text = self.selectedMovie?["nameOfGenre"]
        self.producerLabel.text = self.selectedMovie?["producer"]
        self.castLabel.text = self.selectedMovie?["cast"]
        self.durationLabel.text = self.selectedMovie?["duration"]
        self.yearLabel.text = self.selectedMovie?["year"]
        self.descriptionTextView.text = self.selectedMovie?["description"]
        if let decodedData = Data(base64Encoded: (selectedMovie?["image"]!)!, options: .ignoreUnknownCharacters){
            let decodeImage = UIImage(data: decodedData)
            self.coverImageView.image = decodeImage
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:- Funtion for to view buy ticket
    @IBAction func buyTicket(_ sender: UIBarButtonItem){
        self.performSegue(withIdentifier: "buyTicketSegue", sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "buyTicketSegue"{
            let obj = segue.destination as! orderViewController
            obj.selectedMovie = self.selectedMovie
        }
    }

}
