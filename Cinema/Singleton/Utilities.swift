//
//  Utilities.swift
//  Cinema
//
//  Created by MacMini-02 on 3/28/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class Utilities {
    static let sharedInstance = Utilities()
    let logindatakey = "kbatch141logindata"
    func showAlert(obj: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        { (action) in
            //alert.dismiss(animated: true, completion: nil)
            obj.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        obj.present(alert, animated: true, completion: nil)
    }
    
    func showAlertCancel(obj: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        { (action) in
            alert.dismiss(animated: true, completion: nil)
            //obj.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        obj.present(alert, animated: true, completion: nil)
    }
    
}

