//
//  DBWrapper.swift
//  Cinema
//
//  Created by MacMini-02 on 3/28/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit
import SQLite3

class DBWrapper1 {
    static let sharedInstance = DBWrapper()
    var db: OpaquePointer?
    
    init() {
        let fileURL = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("batch141.db")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print ("ERROR: Error opening videorental.db in \(fileURL.path)")
        } else {
            print ("SUCCESS: Successfully open batch141.db in \(fileURL.path)")
        }
    }
    
    func createTables() {
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Users (idUser INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE, password TEXT), level TEXT", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: Error creating table Users: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Employes (id INTEGER PRIMARY KEY AUTOINCREMENT, nameEmploye TEXT,  idUser INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: Error creating table Users: \(errmsg)")
        }
    }
    
    func doLogin(username: String, password: String) -> [String: String]? {
        var stmt: OpaquePointer?
        let queryString = "SELECT * FROM Users WHERE username='\(username)' AND password='\(password)'"
        print("QUERY LOGIN:  \(queryString)")
        
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
    
    func checklUserLevel(username: String) -> [[String: String]]? {
        var stmt: OpaquePointer?
        let queryString = "SELECT level FROM Users WHERE usrename='\(username)'"
        print("QUERY CHECK LEVEL USER")
        
        var level : [[String: String]]?
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK
        {
            let errmsg = String (cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing login: \(errmsg)")
            return nil
        }
        
        var levels : [[String: String]]?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch movies: \(errmsg)")
            return nil
        }
        levels = [[String: String]]()
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let level = String(cString: sqlite3_column_text(stmt, 0))
            
            let tmp = [
                "level" : String(level),
                ]
            levels?.append(tmp)
        }
        return levels
    }
}
