//
//  EditTabTableViewCell.swift
//  tabcronut
//
//  Created by Aditi Nataraj on 11/19/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

import UIKit

class EditTabTableViewCell: UITableViewCell {

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
