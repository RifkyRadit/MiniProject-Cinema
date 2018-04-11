//
//  AdminViewController.swift
//  Cinema
//
//  Created by MacMini-02 on 3/28/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tmpbtn = UIBarButtonItem()
        self.navigationItem.leftBarButtonItem = tmpbtn
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func theaterDidPushButton (_ sender: UIButton){
        self.performSegue(withIdentifier: "theaterSegue", sender: self)
    }
    
    @IBAction func movieDidPushButton (_ sender: UIButton){
        self.performSegue(withIdentifier: "movieSegue", sender: self)
    }
    
    @IBAction func scheduleDidPushButton (_ sender: UIButton){
        self.performSegue(withIdentifier: "scheduleSegue", sender: self)
    }
    
    @IBAction func seatDidPushButton (_ sender: UIButton){
        self.performSegue(withIdentifier: "seatSegue", sender: self)
    }
    
    @IBAction func historyDidPushButton (_ sender: UIButton){
        self.performSegue(withIdentifier: "historyOrderSegue", sender: self)
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
