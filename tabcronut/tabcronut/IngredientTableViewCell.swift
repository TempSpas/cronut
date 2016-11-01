//
//  IngredientTableViewCell.swift
//  tabcronut
//
//  Created by Aditi Nataraj on 10/30/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ingrLabel: UILabel!
    //@IBOutlet weak var ingrLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
