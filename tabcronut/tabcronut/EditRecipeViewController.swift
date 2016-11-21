//
//  EditRecipeViewController.swift
//  tabcronut
//
//  Created by Aditi Nataraj on 11/2/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

// edit recipe view controller
// manages edit scene
// allows a user to edit an existing recipe

import UIKit

class EditRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    // initialize variables
    // all of the following recipes are passed in from the individual recipe scene
    var recipeValue: Recipe?
    var sample: String?
    
    var numIngreds: Int?
    var numDirs: Int?
    var numTags: Int?
    
    // initialize outlets to the storyboard
    @IBOutlet weak var saveEditButton: UIBarButtonItem!
    @IBOutlet weak var dirTable: UITableView!
    @IBOutlet weak var ingrTable: UITableView!
    @IBOutlet weak var editRecipeName: UITextField!
    @IBOutlet weak var tagTable: UITableView!
    
    
    // add an empty ingredient row to the ingredient table
    @IBAction func addEmptyIngredientRow(_ sender: AnyObject) {
        
        self.ingrTable.beginUpdates()
        let r = self.ingrTable.numberOfRows(inSection: 0)
        numIngreds? += 1
        ingrTable.insertRows(at: [NSIndexPath(row: r, section: 0) as IndexPath], with: .bottom)
        self.ingrTable.endUpdates()
    }

    // add an empty direction row to the direction table
    @IBAction func addEmptyDirectionRow(_ sender: AnyObject) {
        
        self.dirTable.beginUpdates()
        let d = self.dirTable.numberOfRows(inSection: 0)
        numDirs? += 1
        dirTable.insertRows(at: [NSIndexPath(row: d, section: 0) as IndexPath], with: .bottom)
        self.dirTable.endUpdates()
        
    }
    
    // add an empty tag row to the tag table
    @IBAction func addEmptyTagRow(_ sender: Any) {
        self.tagTable.beginUpdates()
        let t = self.tagTable.numberOfRows(inSection: 0)
        numTags? += 1
        tagTable.insertRows(at:[NSIndexPath(row: t, section: 0) as IndexPath], with: .bottom)
        self.tagTable.endUpdates()
    }
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        
        // set data source and delegates for all the tables
        self.dirTable.dataSource = self
        self.dirTable.delegate = self
        self.ingrTable.dataSource = self
        self.ingrTable.delegate = self
        self.tagTable.delegate = self
        self.tagTable.dataSource = self
        
        self.editRecipeName.text = self.recipeValue?.name

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //number of rows in each of the table sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // number of rows in each of the sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count: Int = 0
        if tableView == self.ingrTable {
            return (numIngreds)!
        }
        if tableView == self.dirTable{
            return (numDirs)!
        }
        if tableView == self.tagTable   {
            return (numTags)!
        }
        return count
    }
    
    
    // Prepopulates text fields in both the ingredient table and
    // direction table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell1: UITableViewCell?
        
        // ingredient table
        if tableView == self.ingrTable  {
            let cell = ingrTable.dequeueReusableCell(withIdentifier: "EditIngrCell", for: indexPath) as! EditIngredientTableViewCell
            let row = indexPath.row
            let ingreds = self.recipeValue?.ingredients
            
            // return the cell if nothing is set
            if numIngreds! > (self.recipeValue?.ingredients.count)!    {
                cell.ingrName.text = ""
                cell.ingrAmt.text = ""
                cell.ingrUnit.text = ""
                return cell
            }
            let ingredientNames = [String](ingreds!.keys)
            let ingredientValues = [(Float, String)](ingreds!.values)
            
            // otherwise set the text to what it's supposed to be
            cell.ingrName.text = String(ingredientNames[row])
            cell.ingrAmt.text = String(ingredientValues[row].0)
            cell.ingrUnit.text = ingredientValues[row].1
            
            return cell
            
        }
        
        //direction table
        if tableView == self.dirTable   {
            let cell = dirTable.dequeueReusableCell(withIdentifier: "EditDirCell", for: indexPath) as! EditDirectionsTableViewCell
            let row = indexPath.row
            
            // same idea: set the text if the passed recipe has values
            // otherwise, leave it blank
            if numDirs! > (self.recipeValue?.directions.count)! {
                cell.editDir.text = ""
                return cell
            }
            let dir = recipeValue?.directions[row]
            cell.editDir.text = dir
            return cell
        }
        
        // tags table
        if tableView == self.tagTable   {
            let cell = tagTable.dequeueReusableCell(withIdentifier: "tagcell", for: indexPath) as! EditTabTableViewCell
            let row = indexPath.row
            print("hi")
            let tagz = self.recipeValue?.tags
            if numTags! > (self.recipeValue?.tags.count)! {
                cell.tagName.text = ""
                cell.tagColor.text = ""
                cell.tagCategory.text = ""
                return cell
            }
            let tagNames = [String](tagz!.keys)
            let tagValues = [(UIColor, String)](tagz!.values)
            
            cell.tagName.text = String(tagNames[row])
            cell.tagColor.text = String(describing: tagValues[row].0)
            cell.tagCategory.text = tagValues[row].1
            
            return cell
        }
        return cell1!
    }
    
    // allows a user to delete a row if necessary from any table
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // delete from local storage if the user deletes a value
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            // ingredient table specifics
            if tableView == self.ingrTable    {
                let currentCell = tableView.cellForRow(at: indexPath)! as! EditIngredientTableViewCell
                self.recipeValue?.removeIngredient(ingredient: currentCell.ingrName.text!)
                numIngreds? -= 1
                ingrTable.deleteRows(at: [indexPath], with: .fade)
            }
            
            // direction table specifics
            if tableView == self.dirTable {
                let currentCell = tableView.cellForRow(at: indexPath)! as! EditDirectionsTableViewCell
                let success = self.recipeValue?.removeDirection(direction: currentCell.editDir.text!)
                if success == false   {
                    print("failed to remove direction")
                }
                else    {
                    numDirs? -= 1
                    dirTable.deleteRows(at: [indexPath], with: .fade)
                }
                
            }
            
            // tag table specifics
            if tableView == self.tagTable   {
                let currentCell = tableView.cellForRow(at: indexPath)! as! EditTabTableViewCell
                let success = recipeValue?.removeTag(oldTag: currentCell.tagName.text!)
                if success == false {
                    print("failed to remove tag")
                }
                else    {
                    numTags? -= 1
                    tagTable.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }

    
    // MARK: - Navigation

    // Function that saves recipe changes
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // save button for edit view
        if saveEditButton === sender as AnyObject?
        {
            let r = ingrTable.numberOfRows(inSection: 0)
            let ingreds = self.recipeValue?.ingredients
            var workingKeys: [String] = []
            
            // Saves information to the ingredient table
            if r != 0   {
                for index in 0...(r-1)  {
                    let iPath = IndexPath(row: index, section: 0)
                    let cell = ingrTable.cellForRow(at: iPath) as! EditIngredientTableViewCell
                    if cell.ingrName.text == nil    {
                        continue
                    }
                    let keyExists = ingreds?[cell.ingrName.text!]
                    
                    // just in case the ingredient key already exists
                    if keyExists != nil {
                        let success = self.recipeValue?.modIngredient(ingredient: cell.ingrName.text!, amount: Float(cell.ingrAmt.text!), measurement: cell.ingrUnit.text)
                        if success == false {
                            print("failed to mod ingredient")
                        }
                        else    {
                            workingKeys.append(cell.ingrName.text!)
                        }
                    }
                        
                    // if the ingredient does not exist
                    // do checks about the ingredient unit and amount
                    else  {
                        let success: Bool?
                        if cell.ingrAmt.text == "" && cell.ingrUnit.text == ""  {
                            success = self.recipeValue?.addIngredient(ingredient: cell.ingrName.text!, amount: Float(0), measurement: "")
                        }
                        else if cell.ingrAmt.text != "" && cell.ingrUnit.text == ""  {
                            success = self.recipeValue?.addIngredient(ingredient: cell.ingrName.text!, amount: Float(cell.ingrAmt.text!)!, measurement: "")
                        }
                        else if cell.ingrAmt.text == "" && cell.ingrUnit.text != ""  {
                            continue
                        }
                        else    {
                            success = self.recipeValue?.addIngredient(ingredient: cell.ingrName.text!, amount: Float(cell.ingrAmt.text!)!, measurement: cell.ingrUnit.text!)
                        }
                        if success == false {
                            print("error with new ingredient")
                        }
                        workingKeys.append(cell.ingrName.text!)
                    }
                }
                
                // check to see if any of the ingredients have been removed by the user
                let allingreds = self.recipeValue?.ingredients
                let allNames = [String](allingreds!.keys)
                for index in 0...(allNames.count-1) {
                    let keyExists = workingKeys.index(of: allNames[index])
                    if keyExists == nil {
                        self.recipeValue?.removeIngredient(ingredient: allNames[index])
                    }
                }
            }
            
            
            // Saves information to the direction table
            // either change or add direction if necessary
            let d = dirTable.numberOfRows(inSection: 0)
            let dirs = self.recipeValue?.directions
            if d != 0   {
                for index in 0...(d-1) {
                    let iPath = IndexPath(row: index, section: 0)
                    let cell = dirTable.cellForRow(at: iPath) as! EditDirectionsTableViewCell
                    let success: Bool?
                    if index >= (dirs?.count)!-1 {
                        success = self.recipeValue?.addDirection(direction: cell.editDir.text!)
                        if success == false {
                            print("error adding dir")
                        }
                        continue
                    }
                    if dirs?[index] != cell.editDir.text {
                        success = self.recipeValue?.changeDirection(direction: (dirs?[index])!, newDirection: cell.editDir.text!)
                        if success == false {
                            print("error changing dir")
                        }
                    }
                }
            }
            
            // do the same for the tags table
            let t = tagTable.numberOfRows(inSection: 0)
            let ts = self.recipeValue?.tags
            if t != 0   {
                for index in 0...(t-1)  {
                    let iPath = IndexPath(row: index, section: 0)
                    let cell = tagTable.cellForRow(at: iPath) as! EditTabTableViewCell
                    if cell.tagName.text == nil    {
                        continue
                    }
                    let keyExists = ts?[cell.tagName.text!]
                    let success: Bool?
                    if keyExists != nil {
                        let col = cell.tagColor.text?.components(separatedBy: " ")
                        let returnedColor = UIColor(red: CGFloat(Float((col?[1])!)!), green: CGFloat(Float(col![2])!), blue: CGFloat(Float(col![3])!), alpha: CGFloat(Float(col![4])!))
                        success = self.recipeValue?.modTag(tag: cell.tagName.text!, color: returnedColor, category: cell.tagCategory.text)
                        workingKeys.append(cell.tagName.text!)
                    }
                    else  {
                        print("let them eat cake")
                        if cell.tagColor.text == "" && cell.tagCategory.text == ""  {
                            success = self.recipeValue?.addTag(newTag: cell.tagName.text!)
                        }
                        else if cell.tagColor.text != "" && cell.tagCategory.text == ""  {
                            
                            let col = cell.tagColor.text?.components(separatedBy: " ")
                            let returnedColor = UIColor(red: CGFloat(Float((col?[1])!)!), green: CGFloat(Float((col?[2])!)!), blue: CGFloat(Float((col?[3])!)!), alpha: CGFloat(Float((col?[4])!)!))
                            success = self.recipeValue?.addTag(newTag: cell.tagName.text!, newColor: returnedColor)
                        }
                        else if cell.tagColor.text == "" && cell.tagCategory.text != ""  {
                            print("CAKE")
                            success = self.recipeValue?.addTag(newTag: cell.tagName.text!, newCat: cell.tagCategory.text)
                        }
                        else    {
                            let col = cell.tagColor.text?.components(separatedBy: " ")
                            let returnedColor = UIColor(red: CGFloat(Float((col?[1])!)!), green: CGFloat(Float(col![2])!), blue: CGFloat(Float(col![3])!), alpha: CGFloat(Float(col![4])!))
                            success = self.recipeValue?.addTag(newTag: cell.tagName.text!, newColor: returnedColor, newCat: cell.tagCategory.text!)
                        }
                        workingKeys.append(cell.tagName.text!)
                    }
                    if success == false {
                        print("error with editing tags")
                    }

                }
            }
            
            // reload all of the tables
            // change the name of the recipe if necessary
            if self.recipeValue?.name != editRecipeName.text    {
                self.recipeValue?.name = editRecipeName.text!
            }
            self.ingrTable.reloadData()
            self.dirTable.reloadData()
            self.tagTable.reloadData()
        }
        
    }
    

}
