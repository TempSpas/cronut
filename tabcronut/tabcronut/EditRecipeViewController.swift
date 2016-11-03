//
//  EditRecipeViewController.swift
//  tabcronut
//
//  Created by Aditi Nataraj on 11/2/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

import UIKit

class EditRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var recipeValue: Recipe?
    var sample: String?
    
    var numIngreds: Int?
    var numDirs: Int?
    
    
    
    @IBOutlet weak var saveEditButton: UIBarButtonItem!
    @IBOutlet weak var dirTable: UITableView!
    @IBOutlet weak var ingrTable: UITableView!
    @IBOutlet weak var editRecipeName: UITextField!
    
    @IBAction func addEmptyIngredientRow(_ sender: AnyObject) {
        
        self.ingrTable.beginUpdates()
        let r = self.ingrTable.numberOfRows(inSection: 0)
        numIngreds? += 1
        ingrTable.insertRows(at: [NSIndexPath(row: r, section: 0) as IndexPath], with: .bottom)
        self.ingrTable.endUpdates()
        
        
    }

    @IBAction func addEmptyDirectionRow(_ sender: AnyObject) {
        
        self.dirTable.beginUpdates()
        let d = self.dirTable.numberOfRows(inSection: 0)
        numDirs? += 1
        dirTable.insertRows(at: [NSIndexPath(row: d, section: 0) as IndexPath], with: .bottom)
        self.dirTable.endUpdates()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(self.sample)
        self.hideKeyboardWhenTappedAround()
        
        self.dirTable.dataSource = self
        self.dirTable.delegate = self
        self.ingrTable.dataSource = self
        self.ingrTable.delegate = self
        
        self.editRecipeName.text = self.recipeValue?.name
        
        //print(self.recipeValue?.name)
        //print(self.recipeValue?.ingredients)

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
        var count: Int?
        if tableView == self.ingrTable {
            print("okokok")
            print(self.recipeValue?.name)
            return (numIngreds)!
            //return (self.recipeValue?.ingredients.count)!
        }
        if tableView == self.dirTable{
            return (numDirs)!
            //return (self.recipeValue?.directions.count)!
        }
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell1: UITableViewCell?
        if tableView == self.ingrTable  {
            let cell = ingrTable.dequeueReusableCell(withIdentifier: "EditIngrCell", for: indexPath) as! EditIngredientTableViewCell
            //recipeValue?.modIngredient(ingredient: cell.ingrName.text!, amount: Float(cell.ingrAmt.text!), measurement: cell.ingrUnit.text)
            let row = indexPath.row
            let ingreds = self.recipeValue?.ingredients
            if numIngreds! > (self.recipeValue?.ingredients.count)!    {
                cell.ingrName.text = ""
                cell.ingrAmt.text = ""
                cell.ingrUnit.text = ""
                return cell
            }
            let ingredientNames = [String](ingreds!.keys)
            let ingredientValues = [(Float, String)](ingreds!.values)
            
            print(ingredientNames[row])
            cell.ingrName.text = String(ingredientNames[row])
            cell.ingrAmt.text = String(ingredientValues[row].0)
            cell.ingrUnit.text = ingredientValues[row].1
            
            return cell
            
        }
        if tableView == self.dirTable   {
            let cell = dirTable.dequeueReusableCell(withIdentifier: "EditDirCell", for: indexPath) as! EditDirectionsTableViewCell
            let row = indexPath.row
            if numDirs! > (self.recipeValue?.directions.count)! {
                cell.editDir.text = ""
                return cell
            }
            let dir = recipeValue?.directions[row]
//            recipeValue?.changeDirection(direction: dir!, newDirection: cell.editDir.text!)
            cell.editDir.text = dir
            return cell
        }
        return cell1!
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if tableView == self.ingrTable    {
                let currentCell = tableView.cellForRow(at: indexPath)! as! EditIngredientTableViewCell
                print(currentCell.ingrName.text)
                self.recipeValue?.removeIngredient(ingredient: currentCell.ingrName.text!)
                //self.recipeValue?.ingredients.removeValue(forKey: currentCell.ingrLabel.text!)
                //print(ingredients(at: indexPath.row))
                //ingredients.remove(at: indexPath.row)
                numIngreds? -= 1
                ingrTable.deleteRows(at: [indexPath], with: .fade)
            }
            if tableView == self.dirTable {
                let currentCell = tableView.cellForRow(at: indexPath)! as! EditDirectionsTableViewCell
                self.recipeValue?.removeDirection(direction: currentCell.editDir.text!)
                //directions.remove(at: indexPath.row)
                numDirs? -= 1
                dirTable.deleteRows(at: [indexPath], with: .fade)
            }
            
            //add code here for when you hit delete
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if saveEditButton === sender as AnyObject?
        {
            let r = ingrTable.numberOfRows(inSection: 0)
            //let r1 = r-1
            //print(r1)
            let ingreds = self.recipeValue?.ingredients
            let ingredientNames = [String](ingreds!.keys)
            var workingKeys: [String] = []
            if r != 0   {
                for index in 0...(r-1)  {
                    let iPath = IndexPath(row: index, section: 0)
                    //print(iPath)
                    //print(ingrTable.cellForRow(at: iPath))
                    let cell = ingrTable.cellForRow(at: iPath) as! EditIngredientTableViewCell
                    if cell.ingrName.text == nil    {
                        continue
                    }
                    let keyExists = ingreds?[cell.ingrName.text!]
                    if keyExists != nil {
                        self.recipeValue?.modIngredient(ingredient: cell.ingrName.text!, amount: Float(cell.ingrAmt.text!), measurement: cell.ingrUnit.text)
                        workingKeys.append(cell.ingrName.text!)
                    }
                    else  {
                        self.recipeValue?.addIngredient(ingredient: cell.ingrName.text!, amount: Float(cell.ingrAmt.text!)!, measurement: cell.ingrUnit.text!)
                        workingKeys.append(cell.ingrName.text!)
                    }
                }
                let allingreds = self.recipeValue?.ingredients
                let allNames = [String](allingreds!.keys)
                print(allNames)
                print(workingKeys)
                for index in 0...(allNames.count-1) {
                    //index = itemList.index(of: item)
                    let keyExists = workingKeys.index(of: allNames[index])
                    if keyExists == nil {
                        self.recipeValue?.removeIngredient(ingredient: allNames[index])
                    }
                }
            }
            
            
            
            let d = dirTable.numberOfRows(inSection: 0)
            let dirs = self.recipeValue?.directions
            if d != 0   {
                for index in 0...(d-1) {
                    let iPath = IndexPath(row: index, section: 0)
                    let cell = dirTable.cellForRow(at: iPath) as! EditDirectionsTableViewCell
                    if index >= (dirs?.count)!-1 {
                        self.recipeValue?.addDirection(direction: cell.editDir.text!)
                        continue
                    }
                    print(index)
                    print(dirs)
                    if dirs?[index] != cell.editDir.text {
                        self.recipeValue?.changeDirection(direction: (dirs?[index])!, newDirection: cell.editDir.text!)
                    }
                }
            }
            
            
            if self.recipeValue?.name != editRecipeName.text    {
                self.recipeValue?.name = editRecipeName.text!
            }
            self.ingrTable.reloadData()
            self.dirTable.reloadData()
        }
        
    }
    

}
