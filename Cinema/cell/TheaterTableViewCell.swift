//
//  TheaterTableViewCell.swift
//  Cinema
//
//  Created by MacMini-01 on 4/6/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class TheaterTableViewCell: UITableViewCell {

    @IBOutlet var theaterNameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var theaterImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
