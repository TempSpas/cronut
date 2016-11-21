//
//  TagCellTableViewCell.swift
//  tabcronut
//
//  Created by Aditi Nataraj on 11/19/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

// file that contains the cell for each value of the tag table
// this file is reused for the add scene, as well as the individual
// recipe scene

import UIKit

class TagCellTableViewCell: UITableViewCell {
    
    // keep track of the
    @IBOutlet weak var tagName: UITextField!
    @IBOutlet weak var tagColor: UITextField!
    @IBOutlet weak var tagCategory: UITextField!

    @IBOutlet weak var tagName2: UILabel!
    
    @IBOutlet weak var tagCategory2: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
