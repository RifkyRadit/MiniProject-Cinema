//
//  selectTheaterTableViewCell.swift
//  Cinema
//
//  Created by MacMini-01 on 4/6/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class selectTheaterTableViewCell: UITableViewCell {
    
    @IBOutlet var selectTheaterNameLabel: UILabel!
    @IBOutlet var selectAddressLabel: UILabel!
    @IBOutlet var selectTheaterImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
