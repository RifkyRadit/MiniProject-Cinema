//
//  historyOrderTableViewCell.swift
//  Cinema
//
//  Created by Kahlil Fauzan on 08/04/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class historyOrderTableViewCell: UITableViewCell {

    @IBOutlet var customerNameLabel: UILabel!
    @IBOutlet var telephoneLabel: UILabel!
    @IBOutlet var nameOfFilmLabel: UILabel!
    @IBOutlet var nameOfTheaterLabel: UILabel!
    @IBOutlet var nameOfSeatLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var hourLabel: UILabel!
    @IBOutlet var filmOfHistoryImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
