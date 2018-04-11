//
//  MovieViewController.swift
//  Cinema
//
//  Created by MacMini-04 on 3/29/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    // MAKR:- Delcaration table and search
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    // Delcaration array
    var movies = [[String: String]]()
    var selectedMovie: [String: String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let data = DBWrapper.sharedInstance.fetchMovies(){
            self.movies = data
            self.collectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addMovieDidPushButton(_ sender: UIBarButtonItem){
        self.performSegue(withIdentifier: "addMovieSegue", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "editMovieSegue"{
            let obj = segue.destination as! updateMovieViewController
            obj.selectedMovie = self.selectedMovie
        }
        
        if segue.identifier == "detailMovieSegue"{
            let obj = segue.destination as! detailMovieViewController
            obj.selectedMovie = self.selectedMovie
        }
        if segue.identifier == "buyTicketSegue"{
            let obj = segue.destination as! orderViewController
            obj.selectedMovie = self.selectedMovie
        }
    }
    // MARK:- Implemetn data to collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        let data = self.movies[indexPath.item]
        
        cell.nameOfFilmLabel.text = data["nameOfFilm"]!
        if let decodedData = Data(base64Encoded: data["image"]!, options: .ignoreUnknownCharacters){
            let decodeImage = UIImage(data: decodedData)
            cell.coverImageView.image = decodeImage
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = self.movies[indexPath.item]
        self.selectedMovie = movie
        
        //actionSheet popUp
        let actionSheet = UIAlertController(title: "What do you want to do with :", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        //action detail movie
        let detailAction = UIAlertAction(title: "Detail", style: UIAlertActionStyle.default){ (action) in self.performSegue(withIdentifier: "detailMovieSegue", sender: self) }
        
        //action buy ticket
        let buyAction = UIAlertAction(title: "Buy", style: UIAlertActionStyle.default){ (action) in self.performSegue(withIdentifier: "buyTicketSegue", sender: self) }
        
        //action edit
        let editAction = UIAlertAction(title: "Update", style: UIAlertActionStyle.default){ (action) in self.performSegue(withIdentifier: "editMovieSegue", sender: self) }
        
        //action delete
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.default){ (action) in
            
            //action confirmasi delete
            let confirmAlert = UIAlertController(title: "Are you sure to delete" , message: self.selectedMovie?["nameOfFilm"], preferredStyle: UIAlertControllerStyle.alert)
            
            //cancel delete
            let cancelDelete = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in confirmAlert.dismiss(animated: true, completion: nil) })
            
            //action untuk delete
            let okeDelete = UIAlertAction(title: "Oke", style: UIAlertActionStyle.default, handler: { (action) in
                
                confirmAlert.dismiss(animated: true, completion: nil)
                let param: [String: String] = [
                    "idFilm" : (self.selectedMovie?["idFilm"])!
                ]
                
                //delete film
                if DBWrapper.sharedInstance.deleteMovie(movieData: param) == true{
                    if let data = DBWrapper.sharedInstance.fetchMovies(){
                        self.movies = data
                        self.collectionView.reloadData()
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
        actionSheet.addAction(buyAction)
        actionSheet.addAction(detailAction)
        actionSheet.addAction(editAction)
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(deleteAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // MARK:- Seacrh bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let find = self.searchBar.text!
        if self.searchBar.text! == ""{
            if let data = DBWrapper.sharedInstance.fetchMovies(){ // menampilkan data
                self.movies = data
            }
        }else{
            if let data = DBWrapper.sharedInstance.searchMovie(search: find){ // menampilkan data
                self.movies = data
            }
        }
        self.collectionView.reloadData()
    }
    
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "movieViewCell", for: indexPath) as! moviesTableViewCell
//        let data = self.movies[indexPath.row]
//        cell.nameOfMoviesLabel.text = data["nameOfFilm"]
//        cell.genreLabel.text = data["nameOfGenre"]
//        cell.yearLabel.text = data["year"]
//        return cell
//    }
//
    
}
