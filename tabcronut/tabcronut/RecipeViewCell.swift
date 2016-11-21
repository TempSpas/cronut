//
//  RecipeViewCell.swift
//  tabcronut
//
//  Created by Nico Verbeek on 10/25/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

// this file contains the elements that are shown in a recipe view table

import UIKit

class RecipeViewCell: UITableViewCell {
    
    // label for recipe cell
    @IBOutlet weak var recipeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
