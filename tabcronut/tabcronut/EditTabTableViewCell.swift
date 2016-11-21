//
//  EditTabTableViewCell.swift
//  tabcronut
//
//  Created by Aditi Nataraj on 11/19/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

// This is used for the edit scene for the tag table, representing
// a cell being displayed.

import UIKit

class EditTabTableViewCell: UITableViewCell {

    //keep track of all of the labels available for the tag table
    @IBOutlet weak var tagCategory: UITextField!
    @IBOutlet weak var tagName: UITextField!
    @IBOutlet weak var tagColor: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
