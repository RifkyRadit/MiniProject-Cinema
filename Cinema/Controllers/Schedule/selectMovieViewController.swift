//
//  selectMovieViewController.swift
//  Cinema
//
//  Created by MacMini-01 on 4/5/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

protocol selectMovieDelegate {
    func selectMovieWillDissmiss (param: [String: String])
}

class selectMovieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    //MARK:- Delcaraion Collection view and search
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    //MARK;- Delcaraion array and selector
    var movies = [[String: String]]()
    var selectedMovie: [String: String]?
    var delegate: selectMovieDelegate?
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK:- Function search
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
    //MARK:- Function for implements data to collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectMovieCollectionViewCell", for: indexPath) as! selectMovieCollectionViewCell
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
        
        //action delete
        let doneAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default){ (action) in
            if self.delegate != nil && self.selectedMovie != nil{
                self.delegate?.selectMovieWillDissmiss(param: self.selectedMovie!)
            }
            self.navigationController?.popViewController(animated: true)
            
        }
        
        //cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
            actionSheet.dismiss(animated: true, completion: nil)
        }
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(doneAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    

}
