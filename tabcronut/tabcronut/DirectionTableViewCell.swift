//
//  DirectionTableViewCell.swift
//  tabcronut
//
//  Created by Aditi Nataraj on 11/1/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

// this file has the direction name for the direction table
// this is reused in the add scene and the individual recipe scene

import UIKit

class DirectionTableViewCell: UITableViewCell {

    //@IBOutlet weak var directionName: UILabel!
    @IBOutlet weak var directionName: UILabel!
    
    @IBOutlet weak var directionName2: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
