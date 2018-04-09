//
//  selectTheaterScheduleTableViewCell.swift
//  Cinema
//
//  Created by MacMini-01 on 4/9/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class selectTheaterScheduleTableViewCell: UITableViewCell {

    @IBOutlet var selectTheaterScheduleNameLabel: UILabel!
    @IBOutlet var selectAddressScheduleLabel: UILabel!
    @IBOutlet var selectTheaterScheduleImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
