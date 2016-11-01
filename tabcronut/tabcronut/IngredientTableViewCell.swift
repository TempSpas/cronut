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
    @IBOutlet weak var ingrAmount: UILabel!
    @IBOutlet weak var ingrUnit: UILabel!
    
    
    @IBOutlet weak var ingrLabel2: UILabel!
    
    @IBOutlet weak var ingrAmount2: UILabel!
    
    @IBOutlet weak var ingrUnit2: UILabel!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
