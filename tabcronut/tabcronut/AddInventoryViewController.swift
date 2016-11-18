//
//  AddInventoryViewController.swift
//  tabcronut
//
//  Created by Aditi Nataraj on 11/17/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

import UIKit

class AddInventoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var recipeValue: Recipe?
    var numIngreds: Int?
    
    var selected_ingredients: [String] = []
    var num_selected: Int = 0
    
    @IBOutlet weak var ingredTable: UITableView!
    
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ingredTable.delegate = self
        self.ingredTable.dataSource = self
        self.ingredTable.allowsMultipleSelection = true
        title = "Add to Inventory List"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("okokok")
        print(self.recipeValue?.name)
        return (numIngreds)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredTable.dequeueReusableCell(withIdentifier: "ingredCell", for: indexPath) as! AddIngredTableViewCell
        //cell.accessoryType = .checkmark
        //cell.accessoryType = (self.lastSelectedIndexPath?.row == indexPath.row) ? .Checkmark : .None
        //recipeValue?.modIngredient(ingredient: cell.ingrName.text!, amount: Float(cell.ingrAmt.text!), measurement: cell.ingrUnit.text)
        let row = indexPath.row
        let ingreds = self.recipeValue?.ingredients
        
        // Fill with blanks
        let ingredientNames = [String](ingreds!.keys)
        print(ingredientNames[row])
        cell.ingrName.text = String(ingredientNames[row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //ingredTable.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
        //ingredTable.cellForRow(at: indexPath as IndexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        let currentCell = tableView.cellForRow(at: indexPath)! as! AddIngredTableViewCell
        currentCell.accessoryType = .checkmark
        selected_ingredients.append(currentCell.ingrName.text!)
        num_selected = num_selected+1
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //ingredTable.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
        let currentCell = tableView.cellForRow(at: indexPath)! as! AddIngredTableViewCell
        currentCell.accessoryType = .none
        let ingrInd = selected_ingredients.index(of: currentCell.ingrName.text!)
        selected_ingredients.remove(at: ingrInd!)
        print(selected_ingredients)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if addButton === sender as AnyObject?
        {
            print("here!")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


class AddIngredTableViewCell: UITableViewCell {
    
    
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
