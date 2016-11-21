//
//  IngredientTableViewCell.swift
//  tabcronut
//
//  Created by Aditi Nataraj on 10/30/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

// this file contains the value for the label, amount, and unit
// of each ingredient.  this is reused for the add scene and the
// individual recipe scene

import UIKit

class IngredientTableViewCell: UITableViewCell {

    // all the labels for the name, amount, and unit
    @IBOutlet weak var ingrLabel: UILabel!
    @IBOutlet weak var ingrAmount: UILabel!
    @IBOutlet weak var ingrUnit: UILabel!
    @IBOutlet weak var ingrLabel2: UILabel!
    @IBOutlet weak var ingrAmount2: UILabel!
    @IBOutlet weak var ingrUnit2: UILabel!
    
   
    // Initialization code
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
