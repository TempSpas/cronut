//
//  AddInventoryViewController.swift
//  tabcronut
//
//  Created by Aditi Nataraj on 11/17/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

// This file represents the add inventory page where
// the user can add ingredients to their inventory.

import UIKit

class AddInventoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // initialize variables
    var recipeValue: Recipe?
    var numIngreds: Int?
    
    var selected_ingredients: [String] = []
    var num_selected: Int = 0
    
    @IBOutlet weak var ingredTable: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        self.ingredTable.delegate = self
        self.ingredTable.dataSource = self
        self.ingredTable.allowsMultipleSelection = true
        title = "Add to Shopping List"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (numIngreds)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredTable.dequeueReusableCell(withIdentifier: "ingredCell", for: indexPath) as! AddIngredTableViewCell
        let row = indexPath.row
        let ingreds = self.recipeValue?.ingredients
        
        // Fill with blanks
        let ingredientNames = [String](ingreds!.keys)
        print(ingredientNames[row])
        cell.ingrName.text = String(ingredientNames[row])
        
        return cell
    }
    
    // Allows a user to select multiple rows in the table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)! as! AddIngredTableViewCell
        currentCell.accessoryType = .checkmark
        selected_ingredients.append(currentCell.ingrName.text!)
        num_selected = num_selected+1
    }
    
    // Allows a user to deselect a row by tapping
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)! as! AddIngredTableViewCell
        currentCell.accessoryType = .none
        let ingrInd = selected_ingredients.index(of: currentCell.ingrName.text!)
        selected_ingredients.remove(at: ingrInd!)
        print(selected_ingredients)
    }
    
    // make sure that the sender is chosen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if addButton === sender as AnyObject?
        {
            print("here!")
        }
    }
}


// class for each cell of the inventory table
class AddIngredTableViewCell: UITableViewCell {
    
    // ingredient label
    @IBOutlet weak var ingrName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
