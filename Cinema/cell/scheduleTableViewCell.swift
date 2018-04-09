//
//  scheduleTableViewCell.swift
//  Cinema
//
//  Created by MacMini-01 on 4/5/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class scheduleTableViewCell: UITableViewCell {

    @IBOutlet var movieNameLabel: UILabel!
    @IBOutlet var theaterNameLabel: UILabel!
    @IBOutlet var hoursLabel: UILabel!
    @IBOutlet var coverImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
