//
//  DBWrapper.swift
//  SQLiteLearn
//
//  Created by MacMini-03 on 3/19/18.
//  Copyright © 2018 Bootcamp141. All rights reserved.
//

import UIKit
import SQLite3

class DBWrapper {
    
    static let sharedInstance = DBWrapper()
    var db: OpaquePointer?
    
    init() {
        let fileURL = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("cinema.db")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print ("ERROR: Error opening videorental.db in \(fileURL.path)")
        } else {
            print ("SUCCESS: Successfully open cinema.db in \(fileURL.path)")
        }
    }
    
    func createTables() {
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Users (idUser INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE,  password TEXT, level TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: Error creating table Users: \(errmsg)")
        }
//        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Employes (idEmploye INTEGER PRIMARY KEY AUTOINCREMENT, nameEmploye TEXT,  idUser INTEGER AUTOINCREMENT)", nil, nil, nil) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("ERROR: Error creating table Employe: \(errmsg)")
//        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Movies (idFilm INTEGER PRIMARY KEY AUTOINCREMENT, nameOfFilm TEXT, idGenre INTEGER, producer TEXT, cast TEXT, duration TEXT, year TEXT, description TEXT, image TEXT, price TEXT)", nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: Error creating table movies: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Genre (idGenre INTEGER PRIMARY KEY AUTOINCREMENT, nameOfGenre TEXT)", nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: Error creating table genre: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Theaters (idTheater INTEGER PRIMARY KEY AUTOINCREMENT, nameTheater TEXT, capacity INTEGER , address TEXT, image TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: Error creating table Theaters: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Seats (idSeat INTEGER PRIMARY KEY AUTOINCREMENT, nameSeat TEXT, idTheater INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: Error creating table Seats: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Schedule (idSchedule INTEGER PRIMARY KEY AUTOINCREMENT,  idFilm INTEGER, idTheater INTEGER, hours TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: Error creating table Seats: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Orders (idOrder INTEGER PRIMARY KEY AUTOINCREMENT, customerName TEXT, telephone TEXT, idFilm INTEGER, idSeat INTEGER, idTheater INTEGER, idSchedule INTEGER, hours TEXT, date DATE)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: Error creating table Seats: \(errmsg)")
        }
    }
    
    func doLogin(username: String, password: String) -> [String: String]? {
        var stmt: OpaquePointer?
        let queryString = "SELECT * FROM Users WHERE username='\(username)' AND password='\(password)'"
//        print("QUERY LOGIN:  \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK
        {
            let errmsg = String (cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing login: \(errmsg)")
            return nil
        }
        var user: [String: String]?
        if sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int(stmt, 0)
            let username = String(cString: sqlite3_column_text(stmt, 1))
            let password = String(cString: sqlite3_column_text(stmt, 2))
            user = [String: String]()
            user?["id"] = String(id)
            user?["username"] = String(username)
            user?["password"] = String(password)
        }
        return user
    }
    
//    func doRegister(username: String, password: String, nameEmploye: String, level: String) -> Bool {
//        var stmt: OpaquePointer?
//        let queryString = "INSERT INTO Users (username, password, level) VALUES ('\(username)','\(password)','\(level)')"
//        let query = "INSERT INTO Employes (nameEmploye) VALUES ('\(nameEmploye)')"
////        print ("QUERY REGISTER: \(queryString)")
////        print ("QUERY EMPLOYE: \(query)")
//
//        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK
//        {
//            let errmsg = String (cString: sqlite3_errmsg(db)!)
//            print("ERROR: SaveMethod: Error preparing insert: \(errmsg)")
//            return false
//        }
//        return sqlite3_step(stmt) == SQLITE_DONE
//    }
    
    func checklUserLevel(username: String) -> String? {
        var stmt: OpaquePointer?
        let queryString = "SELECT level FROM Users WHERE username='\(username)'"
//        print("QUERY CHECK LEVEL USER: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK
        {
            let errmsg = String (cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing login: \(errmsg)")
            return nil
        }
        
        var levels = ""
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch movies: \(errmsg)")
            return nil
        }
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let level = String(cString: sqlite3_column_text(stmt, 0))
            levels = level
        }
//        print("level: \(levels)")
        return levels
    }
    
    //MARK:- THEATERS
    //Theater
    func doInsertTheater(theater: [String: String]) -> Bool{
        var stmt: OpaquePointer?
        let nameTheater = theater["nameTheater"]!
        let address = theater["address"]!
        let capacity = theater["capacity"]!
        let image = theater["image"]!
        
        let queryString = "INSERT INTO Theaters (nameTheater, capacity, address, image) VALUES ('\(nameTheater)', '\(capacity)', '\(address)', '\(image)')"
//        print("QUERY INSERT THEATERS: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK
        {
            let errmsg = String (cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing insert: \(errmsg)")
            return false
        }
        return sqlite3_step(stmt) == SQLITE_DONE
        
    }
    
    //select theater
    func fetchTheaters() -> [[String: String]]? {
        let queryString = "SELECT Theaters.idTheater, Theaters.nameTheater, Theaters.address, Theaters.image, Theaters.capacity FROM Theaters"
//        print("QUERY FETCH GENRE: \(queryString)")
        var stmt: OpaquePointer?
        
        var theater: [[String: String]]?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch Movies: \(errmsg)")
        }
        
        theater = [[String: String]]()
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let idTheater = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let address = String(cString: sqlite3_column_text(stmt, 2))
            let image = String(cString: sqlite3_column_text(stmt, 3))
            let capacity = String(cString: sqlite3_column_text(stmt, 4))
            
            let tmp = [
                "idTheater" : String(idTheater),
                "nameTheater" : String(name),
                "address" : String(address),
                "image" : String(image),
                "capacity" : String(capacity)
            ]
            theater?.append(tmp)
        }
        
        return theater
        
    }
    
    //Update theater
    func doUpdateTheater(theater: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        let idTheater = theater["idTheater"]!
        let nameTheater = theater["nameTheater"]!
        let address = theater["address"]!
        let capacity = theater["capacity"]!
        let image = theater["image"]!
        
        let queryString = "UPDATE Theaters SET nameTheater='\(nameTheater)', capacity='\(capacity)', address='\(address)', image='\(image)' WHERE idTheater='\(idTheater)'"
//        print("QUERY UPDATE THEATERS: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK
        {
            let errmsg = String (cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing insert: \(errmsg)")
            return false
        }
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    //delete Theater
    func doDeleteTheater(theater: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        let idTheater = theater["idTheater"]!
        
        let queryString = "DELETE FROM Theaters WHERE idTheater='\(idTheater)'"
//        print("QUERY DELETE THEATER: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing update: \(errmsg)")
            return false
        }
        
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    //search theaters
    func searchTheater(search: String) -> [[String: String]]?{
        let queryString = "SELECT Theaters.nameTheater, Theaters.address, Theaters.image, Theaters.capacity FROM Theaters WHERE Theaters.nameTheater LIKE '%\(search)%' OR Theaters.address LIKE '%\(search)%'"
//        print("QUERY FETCH GENRE: \(queryString)")
        var stmt: OpaquePointer?
        
        var theater: [[String: String]]?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch Movies: \(errmsg)")
        }
        
        theater = [[String: String]]()
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let name = String(cString: sqlite3_column_text(stmt, 0))
            let address = String(cString: sqlite3_column_text(stmt, 1))
            let image = String(cString: sqlite3_column_text(stmt, 2))
            let capacity = String(cString: sqlite3_column_text(stmt, 3))
            
            let tmp = [
                "nameTheater" : String(name),
                "address" : String(address),
                "image" : String(image),
                "capacity" : String(capacity)
            ]
            theater?.append(tmp)
        }
        
        return theater
    
    }
    
    //MARK:- MOVIES
    //Movie
    //show movie
    func fetchMovies() -> [[String: String]]? {
        let queryString = "SELECT Movies.idFilm, Movies.nameOfFilm, Movies.idGenre, Movies.producer, Movies.cast, Movies.duration, Movies.year, Movies.price, Movies.description, Movies.image, Genre.nameOfGenre FROM Movies INNER JOIN Genre on Genre.idGenre = Movies.idGenre"
//        print ("QUERY FETCH MOVIES: \(queryString)")
        var stmt: OpaquePointer?
        
        var movies: [[String: String]]?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch Movies: \(errmsg)")
        }
        
        movies = [[String: String]]()
        while (sqlite3_step(stmt) == SQLITE_ROW){
            let idFilm = sqlite3_column_int(stmt, 0)
            let film = String(cString: sqlite3_column_text(stmt, 1))
            let idGenre = sqlite3_column_int(stmt, 2)
            let producer = String(cString: sqlite3_column_text(stmt, 3))
            let cast = String(cString: sqlite3_column_text(stmt, 4))
            let duration = String(cString: sqlite3_column_text(stmt, 5))
            let year = String(cString: sqlite3_column_text(stmt, 6))
            let price = String(cString: sqlite3_column_text(stmt, 7))
            let description = String(cString: sqlite3_column_text(stmt, 8))
            let image = String(cString: sqlite3_column_text(stmt, 9))
            let genre = String(cString: sqlite3_column_text(stmt, 10))
            
            let tmp = [
                "idFilm" : String(idFilm),
                "idGenre" : String(idGenre),
                "nameOfFilm" : film,
                "producer" : producer,
                "cast" : cast,
                "duration" : duration,
                "year" : year,
                "price" : price,
                "description" : description,
                "image" : image,
                "nameOfGenre" : genre
            ]
            movies?.append(tmp)
        }
        
        return movies
    }
    
    //insert movie
    func doInsertMovie(movieData: [String: String]) -> Bool{
        var stmt : OpaquePointer?
        
        let movieName = movieData["nameOfFilm"]!
        let idGenre = movieData["idGenre"]!
        let producer = movieData["producer"]!
        let cast = movieData["cast"]!
        let duration = movieData["duration"]!
        let year = movieData["year"]!
        let description = movieData["description"]!
        let image = movieData["image"]!
        let price = movieData["price"]!
        
        let queryString = "INSERT INTO MOVIES (nameOfFilm, idGenre, producer, cast, duration, year, description, image, price) VALUES ('\(movieName)','\(idGenre)','\(producer)','\(cast)','\(duration)','\(year)','\(description)', '\(image)', '\(price)')"
//        print ("QUERY INSERT MOVIES: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing insert Movies: \(errmsg)")
        }
        return sqlite3_step(stmt) == SQLITE_DONE
    }
     
     //updateMovie
    func updateMovie(movieData: [String: String]) -> Bool{
        var stmt: OpaquePointer?
        
        let idFilm = movieData["idFilm"]!
        let movieName = movieData["nameOfFilm"]!
        let idGenre = movieData["idGenre"]!
        let producer = movieData["producer"]!
        let cast = movieData["cast"]!
        let duration = movieData["duration"]!
        let year = movieData["year"]!
        let description = movieData["description"]!
        let image = movieData["image"]!
        let price = movieData["price"]!
        
        let queryString = "UPDATE Movies SET nameOfFilm='\(movieName)', idGenre='\(idGenre)', producer='\(producer)', cast='\(cast)', duration='\(duration)', year='\(year)', description='\(description)', image='\(image)', price='\(price)' WHERE idFilm = '\(idFilm)'"
//        print ("QUERY UPDATE MOVIES: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing update Movies: \(errmsg)")
        }
        return sqlite3_step(stmt) == SQLITE_DONE
        
    }
     
     //delete movie
     func deleteMovie(movieData: [String: String]) -> Bool{
        var stmt: OpaquePointer?
        
        let idFilm = movieData["idFilm"]!
        
        let queryString = "DELETE FROM Movies WHERE idFIlm = '\(idFilm)'"
//        print("QUERY UPDATE MOVIE: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing update: \(errmsg)")
            return false
        }
        
        return sqlite3_step(stmt) == SQLITE_DONE     
     }
    
    //search Movie
    func searchMovie(search: String) -> [[String: String]]?{
        let queryString = "SELECT Movies.idFilm, Movies.nameOfFilm,Movies.year, Movies.image, Genre.nameOfGenre FROM Movies INNER JOIN Genre on Genre.idGenre = Movies.idGenre WHERE Movies.nameOfFilm like '%\(search)%'"
//        print("QUERY FETCH GENRE: \(queryString)")
        var stmt: OpaquePointer?
        
        var movies: [[String: String]]?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch Movies: \(errmsg)")
        }
        
        movies = [[String: String]]()
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let idFilm = sqlite3_column_int(stmt, 0)
            let title = String(cString: sqlite3_column_text(stmt, 1))
            let year = String(cString: sqlite3_column_text(stmt, 2))
            let image = String(cString: sqlite3_column_text(stmt, 3))
            let nameOfGenre = String(cString: sqlite3_column_text(stmt, 4))
            
            let tmp = [
                "nameOfFilm" : String(title),
                "year" : String(year),
                "image" : String(image),
                "nameOfGenre" : String(nameOfGenre),
                "idFilm" : String(idFilm)
            ]
            movies?.append(tmp)
        }
        
        return movies
        
    }
    
    //MARK:- GENRE
    //Genre
    //show genre
    func fetchgenre() -> [[String: String]]? {
        let queryString = "SELECT * FROM Genre"
//        print("QUERY FETCH GENRE: \(queryString)")
        var stmt : OpaquePointer?
        
        var genre : [[String: String]]?
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch Movies: \(errmsg)")
        }
        
        genre = [[String: String]]()
        while (sqlite3_step(stmt)) == SQLITE_ROW {
            let idGenre = sqlite3_column_int(stmt, 0)
            let nameOfGenre = String(cString: sqlite3_column_text(stmt, 1))
            
            let tmp = [
                "idGenre" : String(idGenre),
                "nameOfGenre" : String(nameOfGenre)
            ]
            
            genre?.append(tmp)
        }
        return genre
    }
    
     //insert genre
    func insertGenre(genreData: [String : String]) -> Bool {
        var stmt: OpaquePointer?
     
         let nameOfGenre = genreData["nameOfGenre"]!
     
         let queryString = "INSERT INTO Genre (nameOfGenre) VALUES ('\(nameOfGenre)')"
//         print ("QUERY INSERT GENRE: \(queryString)")
     
         if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
             let errmsg = String(cString: sqlite3_errmsg(db)!)
             print("ERROR: ReadValues: Error preparing insert Genre: \(errmsg)")
         }
     
         return sqlite3_step(stmt) == SQLITE_DONE
     }
    
     //update genre
     func updateGenre(genreData: [String: String]) -> Bool{
     
         var stmt: OpaquePointer?
     
         let idGenre = genreData["idGenre"]!
         let nameOfGenre = genreData["nameOfGenre"]!
     
         let queryString = "UPDATE Genre SET nameOfGenre='\(nameOfGenre)' WHERE idGenre = '\(idGenre)'"
//         print ("QUERY UPDATE GENRE: \(queryString)")
     
         if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
             let errmsg = String(cString: sqlite3_errmsg(db)!)
             print("ERROR: ReadValues: Error preparing insert Genre: \(errmsg)")
         }
     
         return sqlite3_step(stmt) == SQLITE_DONE
     
     }
     
     //delete genre
    func deleteGenre(genreData: [String: String]) -> Bool {
         var stmt: OpaquePointer?
     
         let idGenre = genreData["idGenre"]!
     
         let queryString = "DELETE FROM Genre WHERE idGenre='\(idGenre)'"
//         print("QUERY DELETE MOVIES: \(queryString)")
     
         if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
             let errmsg = String(cString: sqlite3_errmsg(db)!)
             print("ERROR: ReadValues: Error preparing insert Genre: \(errmsg)")
         }
         return sqlite3_step(stmt) == SQLITE_DONE
     }
    
    //MARK:- SEATS
    //seats
    //func insertSeats
    //insert Seat
    func doInsertSeat(seatData: [String: String]) -> Bool{
        var stmt : OpaquePointer?
        
        let seatName = seatData["nameSeat"]!
        let idTheater = seatData["idTheater"]!
        
        let queryString = "INSERT INTO Seats (nameSeat, idTheater) VALUES ('\(seatName)','\(idTheater)')"
//        print ("QUERY INSERT MOVIES: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing insert Seat: \(errmsg)")
        }
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    //show seat
    func fetchSeat() -> [[String: String]]? {
        let queryString = "SELECT Seats.*, Theaters.nameTheater FROM Seats inner join Theaters on Seats.idTheater = Theaters.idTheater"
//        print("QUERY FETCH GENRE: \(queryString)")
        var stmt : OpaquePointer?
        
        var seat : [[String: String]]?
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch seat: \(errmsg)")
        }
        
        seat = [[String: String]]()
        while (sqlite3_step(stmt)) == SQLITE_ROW {
            let idSeat = sqlite3_column_int(stmt, 0)
            let nameSeat = String(cString: sqlite3_column_text(stmt, 1))
            let idTheater = sqlite3_column_int(stmt, 2)
            let nameTheater = String(cString: sqlite3_column_text(stmt, 3))
            
            let tmp = [
                "idSeat" : String(idSeat),
                "nameSeat" : String(nameSeat),
                "idTheater" : String(idTheater),
                "nameTheater" : String(nameTheater)
            ]
            
            seat?.append(tmp)
        }
        return seat
    }
    
    //update Seat
    func updateSeat(seatData: [String: String]) -> Bool{
        var stmt : OpaquePointer?
        
        let idSeat = seatData["idSeat"]!
        let nameSeat = seatData["nameSeat"]!
        let idTheater = seatData["idTheater"]!
        
        let queryString = "UPDATE Seats SET nameSeat='\(nameSeat)', idTheater='\(idTheater)' WHERE idSeat = '\(idSeat)'"
//        print ("QUERY UPDATE SEATS: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing update Seat: \(errmsg)")
        }
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    //delete Seat
    func deleteSeat(seatData: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        let idSeat = seatData["idSeat"]!
        
        let queryString = "DELETE FROM Seats WHERE idSeat='\(idSeat)'"
//        print("QUERY DELETE MOVIES: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing insert Genre: \(errmsg)")
        }
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    //MARK:- SCHEDULE
    //schedule
    //insert schedule
    func insertSchedule(schedule: [String: String]) -> Bool {
        var stmt : OpaquePointer?
        
        let idFilm = schedule["idFilm"]!
        let idTheater = schedule["idTheater"]!
        let hour = schedule["hours"]!
        let queryString = "INSERT INTO Schedule (idFilm, idTheater, hours) VALUES ('\(idFilm)','\(idTheater)','\(hour)')"
//        print ("QUERY INSERT SCHEDULE: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing insert Schedule: \(errmsg)")
        }
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    //show schedule
    func fetchSchedule() -> [[String: String]]? {
        var stmt : OpaquePointer?
        let queryString = "SELECT Schedule.idSchedule, Schedule.idFilm, Schedule.idTheater, Movies.nameOfFilm,  Theaters.nameTheater, Schedule.hours, Movies.image FROM Schedule INNER JOIN Movies ON Schedule.idFilm = Movies.idFilm INNER JOIN Theaters ON Schedule.idTheater = Theaters.idTheater"
//        print("QUERY FETCH SCHEDULE: \(queryString)")
        
        var schedule : [[String: String]]?
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch schedule: \(errmsg)")
        }
        
        schedule = [[String: String]]()
        while (sqlite3_step(stmt)) == SQLITE_ROW {
            let idSchedule = sqlite3_column_int(stmt, 0)
            let idFilm = sqlite3_column_int(stmt, 1)
            let idTheater = sqlite3_column_int(stmt, 2)
            let nameOfFilm = String(cString: sqlite3_column_text(stmt, 3))
            let nameTheater = String(cString: sqlite3_column_text(stmt, 4))
            let hours = String(cString: sqlite3_column_text(stmt, 5))
            let image = String(cString: sqlite3_column_text(stmt, 6))
            
            let tmp = [
                "idSchedule" : String(idSchedule),
                "idFilm" : String(idFilm),
                "idTheater" : String(idTheater),
                "nameOfFilm" : nameOfFilm,
                "nameTheater" : nameTheater,
                "hours" : hours,
                "image" : image
            ]
            
            schedule?.append(tmp)
        }
        return schedule
    }
    
    //search Schedule
    func searchSchedule(search: String) -> [[String: String]]?{
        let queryString = "SELECT Schedule.idSchedule, Schedule.idFilm, Schedule.idTheater, Movies.nameOfFilm,  Theaters.nameTheater, Schedule.hours, Movies.image FROM Schedule INNER JOIN Movies ON Schedule.idFilm = Movies.idFilm INNER JOIN Theaters ON Schedule.idTheater = Theaters.idTheater WHERE Movies.nameOfFilm like '%\(search)%' OR Theaters.nameTheater LIKE '%\(search)%'"
//        print("QUERY FETCH GENRE: \(queryString)")
        var stmt: OpaquePointer?
        
        var schedule: [[String: String]]?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch Movies: \(errmsg)")
        }
        
        schedule = [[String: String]]()
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let idSchedule = sqlite3_column_int(stmt, 0)
            let idFilm = sqlite3_column_int(stmt, 1)
            let idTheater = sqlite3_column_int(stmt, 2)
            let nameOfFilm = String(cString: sqlite3_column_text(stmt, 3))
            let nameTheater = String(cString: sqlite3_column_text(stmt, 4))
            let hours = String(cString: sqlite3_column_text(stmt, 5))
            let image = String(cString: sqlite3_column_text(stmt, 6))
            
            
            let tmp = [
                "idSchedule" : String(idSchedule),
                "idFilm" : String(idFilm),
                "idTheater" : String(idTheater),
                "nameOfFilm" : nameOfFilm,
                "nameTheater" : nameTheater,
                "hours" : hours,
                "image" : image
            ]
            schedule?.append(tmp)
        }
        
        return schedule
    }
    //MARK:- ORDERS
    //order
    //insert order
    func doInsertOrder(order:[String: String]) -> Bool {
        var stmt: OpaquePointer?
        let customerName = order["customerName"]!
        let telephone = order["telephone"]!
        let idFilm = order["idFilm"]!
        let idSeat = order["idSeat"]!
        let idTheater = order["idTheater"]!
        let idSchedule = order["idSchedule"]!
        let date = order["date"]!
        let hours = order["hours"]!
        let queryString = "INSERT INTO Orders (customerName, telephone, idFilm, idSeat, idTheater, date, hours, idSchedule) VALUES ('\(customerName)', '\(telephone)','\(idFilm)', '\(idSeat)', '\(idTheater)', '\(date)', '\(hours)', '\(idSchedule)')"
        print("QUERY INSERT Orders: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK
        {
            let errmsg = String (cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing insert: \(errmsg)")
            return false
        }
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func fetchSeatOrder(order:[String: String]) -> [[String: String]]? {
        let date = order["date"]!
        let hours = order["hours"]!
        let idFilm = order["idFilm"]!
        let idSchedule = order["idSchedule"]!
        let idTheater = order["idTheater"]!
        let queryString = "SELECT Seats.idSeat, Seats.nameSeat FROM Seats LEFT JOIN Orders ON Seats.idseat=Orders.idSeat WHERE Seats.idSeat <= (select Theaters.capacity from Theaters WHERE Theaters.idTheater = '\(idTheater)') AND Seats.idTheater = '\(idTheater)' AND Seats.idSeat NOT IN (SELECT Seats.idSeat FROM Seats INNER JOIN Orders ON Seats.idSeat=Orders.idseat INNER JOIN Schedule ON Orders.idSchedule=Schedule.idSchedule INNER JOIN Theaters ON Theaters.idTheater=Schedule.idTheater WHERE Orders.date='\(date)' AND Schedule.hours='\(hours)' AND Schedule.idFilm='\(idFilm)' AND Schedule.idSchedule='\(idSchedule)' AND Seats.idSeat < Theaters.capacity AND Seats.idTheater='\(idTheater)')"
        //        let queryString = "SELECT idSeat, nameSeat FROM Seats"
//        print("QUERY FETCH ORDER SEAT: \(queryString)")
        var stmt : OpaquePointer?
        
        var seat : [[String: String]]?
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch seat: \(errmsg)")
        }
        
        seat = [[String: String]]()
        while (sqlite3_step(stmt)) == SQLITE_ROW {
            let idSeat = sqlite3_column_int(stmt, 0)
            let nameSeat = String(cString: sqlite3_column_text(stmt, 1))
            
            let tmp = [
                "idSeat" : String(idSeat),
                "nameSeat" : String(nameSeat)
            ]
            
            seat?.append(tmp)
        }
        return seat
    }
    
    //hour
    func fetchHours(idFilm: String, idTheater: String) -> [[String: String]]? {
        let queryString = "SELECT idSchedule, hours FROM Schedule WHERE idFilm='\(idFilm)' AND idTheater='\(idTheater)'"
//        print ("QUERY FETCH HOURS: \(queryString)")
        var stmt: OpaquePointer?
        
        var movies: [[String: String]]?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch Movies: \(errmsg)")
        }
        
        movies = [[String: String]]()
        while (sqlite3_step(stmt) == SQLITE_ROW){
            let idSchedule = sqlite3_column_int(stmt, 0)
            let hours = String(cString: sqlite3_column_text(stmt, 1))
            
            let tmp = [
                "idSchedule" : String(idSchedule),
                "hours" : String(hours),
                ]
            movies?.append(tmp)
        }
        
        return movies
    }
    
    //select thetaer for order when has schedule
    func fetchTheaterSchedule(idFilm: String) -> [[String: String]]? {
        let queryString = "SELECT Theaters.idTheater, Theaters.nameTheater, Theaters.address, Theaters.image, Theaters.capacity FROM Theaters INNER JOIN Schedule ON Theaters.idTheater = Schedule.idTheater WHERE Schedule.idFilm = '\(idFilm)' GROUP BY Theaters.nameTheater"
        //        print("QUERY FETCH GENRE: \(queryString)")
        var stmt: OpaquePointer?
        
        var theater: [[String: String]]?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch Movies: \(errmsg)")
        }
        
        theater = [[String: String]]()
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let idTheater = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let address = String(cString: sqlite3_column_text(stmt, 2))
            let image = String(cString: sqlite3_column_text(stmt, 3))
            let capacity = String(cString: sqlite3_column_text(stmt, 4))
            
            let tmp = [
                "idTheater" : String(idTheater),
                "nameTheater" : String(name),
                "address" : String(address),
                "image" : String(image),
                "capacity" : String(capacity)
            ]
            theater?.append(tmp)
        }
        
        return theater
        
    }
    
    //search theaters for order
    func searchTheaterSchedule(search: String, idFilm: String) -> [[String: String]]?{
        let queryString = "SELECT Theaters.idTheater, Theaters.nameTheater, Theaters.address, Theaters.image, Theaters.capacity FROM Theaters INNER JOIN Schedule ON Theaters.idTheater = Schedule.idTheater WHERE Schedule.idFilm = '\(idFilm)' AND Theaters.nameTheater LIKE '%\(search)%' OR Theaters.address LIKE '%\(search)%' GROUP BY Theaters.idTheaters"
        //        print("QUERY FETCH GENRE: \(queryString)")
        var stmt: OpaquePointer?
        
        var theater: [[String: String]]?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch Movies: \(errmsg)")
        }
        
        theater = [[String: String]]()
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let name = String(cString: sqlite3_column_text(stmt, 0))
            let address = String(cString: sqlite3_column_text(stmt, 1))
            let image = String(cString: sqlite3_column_text(stmt, 2))
            let capacity = String(cString: sqlite3_column_text(stmt, 3))
            
            let tmp = [
                "nameTheater" : String(name),
                "address" : String(address),
                "image" : String(image),
                "capacity" : String(capacity)
            ]
            theater?.append(tmp)
        }
        
        return theater
        
    }
    
    //MARK:- HISTORY
    //show history
    func fetchHistory() -> [[String: String]]? {
        var stmt: OpaquePointer?
        let queryString = "select Orders.customerName, Orders.telephone, Movies.nameOfFilm, Movies.image, Theaters.nameTheater, Seats.nameSeat, Orders.date, Orders.hours from Orders inner join Seats on Orders.idSeat=Seats.idSeat inner join Schedule on Schedule.idSchedule=Orders.idSchedule inner join Movies on Movies.idFilm=Schedule.idFilm inner join Theaters on Theaters.idTheater=Schedule.idTheater"
//        print ("QUERY FETCH HOURS: \(queryString)")
        
        var history: [[String: String]]?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch history: \(errmsg)")
        }
        
        history = [[String: String]]()
        while (sqlite3_step(stmt) == SQLITE_ROW){
            let customerName = String(cString: sqlite3_column_text(stmt, 0))
            let telephone = String(cString: sqlite3_column_text(stmt, 1))
            let nameOfFilm = String(cString: sqlite3_column_text(stmt, 2))
            let image = String(cString: sqlite3_column_text(stmt, 3))
            let nameTheater = String(cString: sqlite3_column_text(stmt, 4))
            let nameSeat = String(cString: sqlite3_column_text(stmt, 5))
            let date = String(cString: sqlite3_column_text(stmt, 6))
            let hours = String(cString: sqlite3_column_text(stmt, 7))
            
            let tmp = [
                "customerName" : customerName,
                "telephone" : telephone,
                "nameOfFilm" : nameOfFilm,
                "image" : image,
                "nameTheater" : nameTheater,
                "nameSeat" : nameSeat,
                "date" : date,
                "hours" : hours
                ]
            history?.append(tmp)
        }
        
        return history
    }
    
    func searchHistory(date: String) -> [[String: String]]? {
        var stmt: OpaquePointer?
        let queryString = "select Orders.customerName, Orders.telephone, Movies.nameOfFilm, Movies.image, Theaters.nameTheater, Seats.nameSeat, Orders.date, Orders.hours from Orders inner join Seats on Orders.idSeat=Seats.idSeat inner join Schedule on Schedule.idSchedule=Orders.idSchedule inner join Movies on Movies.idFilm=Schedule.idFilm inner join Theaters on Theaters.idTheater=Schedule.idTheater WHERE Orders.date LIKE '%\(date)'%"
//        print ("QUERY FETCH HOURS: \(queryString)")
        
        var history: [[String: String]]?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch history: \(errmsg)")
        }
        
        history = [[String: String]]()
        while (sqlite3_step(stmt) == SQLITE_ROW){
            let customerName = String(cString: sqlite3_column_text(stmt, 0))
            let telephone = String(cString: sqlite3_column_text(stmt, 1))
            let nameOfFilm = String(cString: sqlite3_column_text(stmt, 2))
            let image = String(cString: sqlite3_column_text(stmt, 3))
            let nameTheater = String(cString: sqlite3_column_text(stmt, 4))
            let nameSeat = String(cString: sqlite3_column_text(stmt, 5))
            let date = String(cString: sqlite3_column_text(stmt, 6))
            let hours = String(cString: sqlite3_column_text(stmt, 7))
            
            let tmp = [
                "customerName" : customerName,
                "telephone" : telephone,
                "nameOfFilm" : nameOfFilm,
                "image" : image,
                "nameTheater" : nameTheater,
                "nameSeat" : nameSeat,
                "date" : date,
                "hours" : hours
            ]
            history?.append(tmp)
        }
        
        return history
    }
    
}
