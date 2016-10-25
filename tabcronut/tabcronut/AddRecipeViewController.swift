//
//  AddRecipeViewController.swift
//  tabcronut
//
//  Created by Nico Verbeek on 10/23/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var recipeTitle: UITextField!
    @IBOutlet weak var saveRecipeButton: UIBarButtonItem!
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
//    @IBAction func saveRecipeButton(_ sender: UIButton) {
//        var r = Recipe(title: recipeTitle.text!)
//        let u = User(user: "generic")
//        u.recipes.append(&r)
//        //
//        print(r.name)
//    }
    
    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if saveRecipeButton === sender as AnyObject?
        {
            recipe = Recipe(title: recipeTitle.text!)
            
        }
    }
}
