//
//  EditDirectionsTableViewCell.swift
//  tabcronut
//
//  Created by Aditi Nataraj on 11/2/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

// This file contains the edit label for the direction table

import UIKit

class EditDirectionsTableViewCell: UITableViewCell {

    @IBOutlet weak var editDir: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
