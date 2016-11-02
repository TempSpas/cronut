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
    
    var ingredients: [String: (Float, String)] = [:]
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
    
//    @IBOutlet var ingredientTable: UITableView!
    
    
    @IBAction func addIngrs(_ sender: AnyObject) {
        self.ingredientTable.beginUpdates()
        print(ingrName.text)
        //test.append(ingrName.text!)
        ingredients[ingrName.text!] = (Float(ingrAmt.text!)!, ingrUnit.text!)
        //ingredientTable.beginUpdates()
        ingredientTable.insertRows(at: [
            NSIndexPath(row: ingredients.count-1, section: 0) as IndexPath
            ], with: .bottom)
        
        print(ingredients)
        //
        //ingredientTable.endUpdates()
        //let newIndexPath = NSIndexPath(row: test.count, section: 0)
        //self.ingredientTable.insertRows(at: [newIndexPath as IndexPath], with: .automatic)
//        DispatchQueue.main.async {
//            self.ingredientTable.reloadData()
//        }
        temp_ingredient = ingrName.text!
        temp_amount = Float(ingrAmt.text!)!
        temp_unit = ingrUnit.text!
        ingrName.text=""
        ingrAmt.text=""
        ingrUnit.text=""
        self.ingredientTable.endUpdates()
    }


    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.black
        recipeTitle.delegate = self
        self.ingredientTable.delegate = self
        self.ingredientTable.dataSource = self
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
        return ingredients.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = ingredientTable.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientTableViewCell
            
        print(indexPath)
        let row = indexPath.row
        let ingredientNames = [String](ingredients.keys)
        let ingredientValues = [(Float, String)](ingredients.values)
        
        print(ingredientNames[row])
        
        cell.ingrLabel.text = temp_ingredient
        cell.ingrAmount.text = String(temp_amount)
        cell.ingrUnit.text = temp_unit
        
        temp_ingredient = ""
        temp_amount = 0.0
        temp_unit = ""
        
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
        return cell
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
            recipeTitle.text=""
            ingredients.removeAll()
            self.ingredientTable.reloadData()
        }
        
    }
}
