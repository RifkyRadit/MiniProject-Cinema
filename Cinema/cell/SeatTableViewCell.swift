//
//  SeatTableViewCell.swift
//  Cinema
//
//  Created by MacMini-01 on 4/4/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class SeatTableViewCell: UITableViewCell {

    @IBOutlet var seatNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
