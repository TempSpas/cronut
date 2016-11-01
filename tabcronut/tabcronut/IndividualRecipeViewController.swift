//
//  IndividualRecipeViewController.swift
//  tabcronut
//
//  Created by Aditi Nataraj on 10/27/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

import UIKit

class IndividualRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var recipeTitle: String = ""
    
    @IBOutlet weak var ingrTable: UITableView!
    
    var passedValue: Recipe?
    
//    var detailItem: AnyObject? {
//        didSet {
//            // Update the view.
//            self.configureView()
//        }
//    }
//    
//    func configureView() {
//        // Update the user interface for the detail item.
//        if let detail = self.detailItem {
//            if let label = self.detailDescriptionLabel {
//                label.text = detail.description
//            }
//        }
//    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.ingrTable.delegate = self
        self.ingrTable.dataSource = self
        title = self.passedValue?.name
        print(self.passedValue?.name)
        print(self.passedValue?.ingredients)

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
        return (self.passedValue?.ingredients.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ingrTable.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientTableViewCell
        
        let row = indexPath.row
        let ingreds = self.passedValue?.ingredients
        let ingredientNames = [String](ingreds!.keys)
        let ingredientValues = [(Float, String)](ingreds!.values)
        
        print(ingredientNames[row])
        cell.ingrLabel2.text = String(ingredientNames[row])
        cell.ingrAmount2.text = String(ingredientValues[row].0)
        cell.ingrUnit2.text = ingredientValues[row].1
        return cell
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
