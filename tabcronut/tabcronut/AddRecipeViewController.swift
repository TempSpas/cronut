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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func saveRecipeButton(_ sender: UIButton) {
        let r = Recipe()

        r.name = recipeTitle.text
        print(r.name)
    }
    
    
    
    /*

    // In a storyboard-based application, you will often want to do a little preparation before
    navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
