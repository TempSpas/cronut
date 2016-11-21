//
//  EditIngredientTableViewCell.swift
//  tabcronut
//
//  Created by Aditi Nataraj on 11/2/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

// this file contains the name, unit, and amount
// of ingredients in the edit ingredient table

import UIKit

class EditIngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var ingrName: UITextField!
    
    @IBOutlet weak var ingrUnit: UITextField!
    @IBOutlet weak var ingrAmt: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
