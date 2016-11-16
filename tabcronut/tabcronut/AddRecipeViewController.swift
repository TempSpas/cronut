//
//  AddRecipeViewController.swift
//  tabcronut
//
//  Created by Nico Verbeek on 10/23/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

import UIKit

class AddRecipeViewController: //UITableViewController, UITextFieldDelegate {
UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    var numRows = 1
//    @available(iOS 2.0, *)
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
//        return cell
//    }
//
//    @available(iOS 2.0, *)
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }


    // MARK: Properties
    
    var pre_title: String?
    var pre_ingredients: [String: (Float, String)]?
    var pre_directions: [String]?
    var numIngrs: Int?
    
    var ingredients: [String: (Float, String)] = [:]
    var directions: [String] = []
    var test: [String] = []
    var temp_ingredient: String = ""
    var temp_amount: Float = 0.0
    var temp_unit: String = ""
    
    
    @IBOutlet weak var ingrName: UITextField!
    @IBOutlet weak var ingrAmt: UITextField!
    @IBOutlet weak var ingrUnit: UITextField!
    
    @IBOutlet weak var recipeTitle: UITextField!
    @IBOutlet weak var saveRecipeButton: UIBarButtonItem!
    
    @IBOutlet weak var ingredientTable: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var direction: UITextField!
    
    @IBOutlet weak var directionTable: UITableView!
    
    
//    @IBOutlet var ingredientTable: UITableView!
    
    
    @IBAction func addIngrs(_ sender: AnyObject) {
        self.ingredientTable.beginUpdates()
        print(ingrName.text)
        print(ingrAmt.text)
        print(ingrUnit.text)
        if let tester = ingredients[ingrName.text!]  {
            ingrName.text=""
            ingrAmt.text=""
            ingrUnit.text=""
            print("Please enter an ingredient that doesn't exist...")
            self.ingredientTable.endUpdates()
            return
        }
        if let isfloat = Float(ingrAmt.text!)    {
            print("got float")
        }
        else    {
//            let alertController = UIAlertController(title: "Error", message:
//                "Please enter float amount", preferredStyle: UIAlertControllerStyle.alert)
            let alertController = UIAlertController(title: "Error", message: "PLEASE enter a FLOAT value for AMOUNT you IDIOT", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion:nil)

            ingrAmt.text=""
            self.ingredientTable.endUpdates()
            return
        }
        //test.append(ingrName.text!)
//        ingredients[ingrName.text!] = (Float(ingrAmt.text!)!, ingrUnit.text!)
        let emptyThings = (ingrAmt.text == nil || ingrAmt.text == "" || ingrUnit.text == nil || ingrUnit.text == "")
        let badThings = (ingrAmt.text == "" && ingrUnit.text != "")
        let someFilled = (ingrAmt.text != "" && ingrUnit.text == "")
        if emptyThings  {
            if badThings    {
                ingrName.text=""
                ingrAmt.text=""
                ingrUnit.text=""
                self.ingredientTable.endUpdates()
                return
            }
            if someFilled   {
                ingredients[ingrName.text!] = (Float(ingrAmt.text!)!, "")
            }
            else    {
                ingredients[ingrName.text!] = (Float(0), "")
            }
        }
        else    {
            ingredients[ingrName.text!] = (Float(ingrAmt.text!)!, ingrUnit.text!)
        }
        //ingredientTable.beginUpdates()
        ingredientTable.insertRows(at: [
            NSIndexPath(row: ingredients.count-1, section: 0) as IndexPath
            ], with: .bottom)
        
        print(ingredients)
        temp_ingredient = ingrName.text!
        temp_amount = Float(ingrAmt.text!)!
        temp_unit = ingrUnit.text!
        if emptyThings != true {
            temp_amount = Float(ingrAmt.text!)!
            temp_unit = ingrUnit.text!
        }
        if someFilled == true   {
            temp_amount = Float(ingrAmt.text!)!
        }
        ingrName.text=""
        ingrAmt.text=""
        ingrUnit.text=""
        self.ingredientTable.endUpdates()
    }
    
    
    @IBAction func addDirection(_ sender: AnyObject) {
        self.directionTable.beginUpdates()
        var dirtext = String(directions.count+1) + ". " +  direction.text!
        directions.append(dirtext)
        print(direction.text)
        //directions.append()
        //print(ingrName.text)
        //test.append(ingrName.text!)
        //direction[ingrName.text!] = (Float(ingrAmt.text!)!, ingrUnit.text!)
        //ingredientTable.beginUpdates()
        directionTable.insertRows(at: [
            NSIndexPath(row: directions.count-1, section: 0) as IndexPath
            ], with: .bottom)
        direction.text=""
        self.directionTable.endUpdates()
    }


    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize.height = 1000
        self.hideKeyboardWhenTappedAround()
        
        if pre_ingredients != nil   {
            ingredients = pre_ingredients!
        }
        if pre_directions != nil    {
            directions = pre_directions!
        }
        
        recipeTitle.delegate = self
        
        if pre_title != nil {
            self.recipeTitle.text = pre_title!
        }
        
        self.ingredientTable.delegate = self
        self.ingredientTable.dataSource = self
        self.directionTable.delegate = self
        self.directionTable.dataSource = self
        //self.ingredientTable.delegate = self
        //self.ingredientTable.datasource = self
        //checkValidRecipeName()
        // Do any additional setup after loading the view.
    }
    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        if tableView == self.ingredientTable {
            return ingredients.count
        }
        if tableView == self.directionTable{
            return directions.count
        }
        return count!
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell1: UITableViewCell?
        
        if tableView == self.ingredientTable    {
            let cell = ingredientTable.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientTableViewCell
            
            print(indexPath)
            let row = indexPath.row
            let ingredientNames = [String](ingredients.keys)
            let ingredientValues = [(Float, String)](ingredients.values)
            
            print(ingredientNames[row])
            if numIngrs != nil && numIngrs == ingredients.count {
                cell.ingrLabel.text = String(ingredientNames[row])
//                cell.ingrAmount.text = String(ingredientValues[row].0)
                if String(ingredientValues[row].0) != "0.0" {
                    cell.ingrAmount.text = String(ingredientValues[row].0)
                }
                cell.ingrUnit.text = ingredientValues[row].1
                return cell
            }
            
            
            cell.ingrLabel.text = temp_ingredient
//            cell.ingrAmount.text = String(temp_amount)
            print(String(temp_amount))
            if String(temp_amount) != "0.0" {
                cell.ingrAmount.text = String(temp_amount)
            }
            else    {
                cell.ingrAmount.text = ""
            }
            cell.ingrUnit.text = temp_unit
            
            temp_ingredient = ""
            temp_amount = 0.0
            temp_unit = ""
            return cell
        }
        if tableView == self.directionTable    {
            let cell = directionTable.dequeueReusableCell(withIdentifier: "DirCell", for: indexPath) as! DirectionTableViewCell
            let row = indexPath.row
            cell.directionName.text = directions[row]
            return cell
        }
        return cell1!
        
        
//        cell.ingrLabel.text = ingredientNames[row]
//        cell.ingrAmount.text = String(ingredientValues[row].0)
//        cell.ingrUnit.text = ingredientValues[row].1
        
        
        //let ingredient = ingredients[row]
        
//        print(test[row])
//        let label = cell.ingrLabel
//        label!.text = test[row]
        
        //cell.ingrLabel.text = ingredient[row][
        
        
//        if let label = cell.ingrLabel   {
//            label.text = test[row]
//            print(label.text)
//        }
//        print(cell.ingrLabel.text)
       // cell.ingrLabel.text = test[row]
//        print(cell.ingrLabel.text)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if tableView == self.ingredientTable    {
                let currentCell = tableView.cellForRow(at: indexPath)! as! IngredientTableViewCell
                print(currentCell.ingrLabel.text)
                ingredients.removeValue(forKey: currentCell.ingrLabel.text!)
                //print(ingredients(at: indexPath.row))
                //ingredients.remove(at: indexPath.row)
                ingredientTable.deleteRows(at: [indexPath], with: .fade)
            }
            if tableView == self.directionTable {
                directions.remove(at: indexPath.row)
                directionTable.deleteRows(at: [indexPath], with: .fade)
            }
            
            //add code here for when you hit delete
        }
    }
    
//    func textFieldDidEndEditing(textField: UITextField) {
//        checkValidRecipeName()
//        print(saveRecipeButton.isEnabled)
//        navigationItem.title = recipeTitle.text
//    }
//    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        // Disable the Save button while editing.
//        saveRecipeButton.isEnabled = false
//    }
//    
//    func checkValidRecipeName() {
//        // Disable the Save button if the text field is empty.
//        let text = recipeTitle.text ?? ""
//        saveRecipeButton.isEnabled = !text.isEmpty
//    }
    
    

    
    // MARK: Navigation
    
    @IBAction func cancelRecipe(_ sender: UIBarButtonItem) {
        recipeTitle.text = ""
        ingrName.text = ""
        ingrAmt.text = ""
        ingrUnit.text = ""
        direction.text = ""
        ingredients.removeAll()
        directions.removeAll()
        self.ingredientTable.reloadData()
        self.directionTable.reloadData()
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RecipeTableViewController") as! RecipeTableViewController
//        self.present(nextViewController, animated:true, completion:nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if saveRecipeButton === sender as AnyObject?
        {
            let title = recipeTitle.text
            recipe = Recipe(title: title!)
            recipe?.ingredients = ingredients
            recipe?.directions = directions
            recipeTitle.text=""
            ingredients.removeAll()
            directions.removeAll()
            self.ingredientTable.reloadData()
            self.directionTable.reloadData()
        }
        
    }
}
