//
//  moviesTableViewCell.swift
//  Cinema
//
//  Created by MacMini-04 on 3/29/18.
//  Copyright © 2018 MacMini-02. All rights reserved.
//

import UIKit

class moviesTableViewCell: UITableViewCell {

    @IBOutlet var nameOfMoviesLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
