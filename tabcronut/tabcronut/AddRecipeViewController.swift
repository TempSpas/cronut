//
//  AddRecipeViewController.swift
//  tabcronut
//
//  Created by Nico Verbeek on 10/23/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    
    @IBOutlet weak var recipeTitle: UITextField!
    @IBOutlet weak var saveRecipeButton: UIBarButtonItem!
    
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTitle.delegate = self
        //checkValidRecipeName()
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
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
            recipeTitle.text=""
        }
    }
}
