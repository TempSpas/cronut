//
//  RecipeTableViewController.swift
//  tabcronut
//
//  Created by Aditi Nataraj on 10/24/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

// This file shows the recipe table view where the user can see all recipes
// after a recipe is added, the user is brought to this page
// where they can see their newly added recipe.

import UIKit
import Foundation

class RecipeTableViewController: UITableViewController {
    
    // MARK: Properties
    @IBOutlet weak var addRecipeButton: UIBarButtonItem!
    @IBOutlet var table: UITableView!
    
    // initialize variables that will be populated
    var recipes = [Recipe]()
    var objects = [AnyObject]()
    var filteredRecipes = [Recipe]()
    var ingredients: [String: (Float, String)] = [:]
    var directions: [String] = []
    var tags: [String: (UIColor, String)] = [:]
    
    // Display search results in the same view controller
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial cronut recipe
        // TODO: Put this in a function.
        ingredients["canola oil"] = (0.0,"")
        ingredients["frozen dough"] = (16.0, "oz")
        ingredients["vanilla pudding"] = (4.0, "oz")
        ingredients["powdered sugar"] = (6.0, "cups")
        ingredients["vanilla extract"] = (1.0, "tsp")
        ingredients["milk"] = (1.0, "cup")
        ingredients["granulated sugar"] = (0.25, "cup")
        ingredients["cinnamon"] = (0.5, "tsp")
        ingredients["lemon juice"] = (0.0,"")
        
        directions.append("1. fill large pot with canola oil; heat over medium")
        directions.append("2. fry the dough in the oil for 45-90s")
        directions.append("3. mix sugar, vanilla, and milk")
        directions.append("4. mix cinnamon and sugar")
        directions.append("5. enjoy")
        
        tags["dessert"] = (UIColor.purple, "pastry")
        tags["unhealthy"] = (UIColor.brown, "nutrition")
        tags["foodporn"] = (UIColor.red, "sex appeal")
        
        let imageName = "OtherBackground.jpg"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        
        let recipe = Recipe(title: "Cronut Recipe")
        recipe.ingredients = ingredients
        recipe.directions = directions
        recipe.tags = tags
        recipe.image = imageView
        recipes.append(recipe)
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        // set delegate and datasource for table
        self.tableView.delegate = self
        self.tableView.dataSource = self
        

        // The following are used in the implementation of search
        // functionality:
        
        // Allows results to update as the user types
        searchController.searchResultsUpdater = self
        
        // Prevent view from dimming as the user searches
        searchController.dimsBackgroundDuringPresentation = false
        
        // ensure that the search bar does not remain on the screen if
        // the user navigates to another view controller while the
        // UISearchController is active
        definesPresentationContext = true
        
        // Finally, you add the searchBar to your table view’s tableHeaderView.
        // Remember that Interface Builder is not yet compatible with
        // UISearchController, making this necessary (?????)
        tableView.tableHeaderView = searchController.searchBar
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        // return 0
        return 1
    }
    
    // Displays the recipes in the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If the user has entered text in the search, display the filtered results.
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredRecipes.count
        }
        return recipes.count
    }
    
    var valueToPass:String!
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Populate the cells with the correct names based on search results.
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableCell", for: indexPath) as! RecipeViewCell
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.recipeLabel.text = filteredRecipes[indexPath.row].name
        } else {
            cell.recipeLabel.text = recipes[indexPath.row].name
        }
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            recipes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Check if recipe names contain the user's search query.
    // Ceate the filtered array to display according to the user's search query.
    // Ceate the filtered array to display according to the user's search query.
    func filterContentForSearchText(searchText: String, scope: String = "All")
    {
        // Search the titles, tags, and ingredients for the string
        // and return relevant results.
        filteredRecipes = recipes.filter { recipe in
            return ((recipe.name.lowercased().range(of: searchText.lowercased()) != nil) ||
                recipe.checkTags(str: searchText) || recipe.checkIngredients(str: searchText))
        }
        
        if searchText != "" {
            let firstChar = searchText[searchText.startIndex]
            let negChar: Character = "-"
            
            // If the user begins the search with the "-" character, this
            // indicates they wish to filter that string out of the results.
            // Search for items without the string following the "-".
            if firstChar == negChar {
                var newSearch = searchText
                newSearch.remove(at: newSearch.startIndex)
                
                filteredRecipes = recipes.filter { recipe in
                    return (!(recipe.name.lowercased().range(of: newSearch.lowercased()) != nil) &&
                        !recipe.checkTags(str: newSearch) && !recipe.checkIngredients(str: newSearch))
                }
            }
        }
        
        tableView.reloadData()
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
        return true
    }
 
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "viewDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {                
                // Ensure that the correct pages are accessed after search
                // filters out irrelevant recipes.
                let recipe: Recipe
                if searchController.isActive && searchController.searchBar.text != "" {
                    recipe = filteredRecipes[indexPath.row]
                } else {
                    recipe = recipes[indexPath.row]
                }
                
                // Show back button programatically.
                let controller = (segue.destination as! IndividualRecipeViewController)
                controller.passedValue = recipe
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.navigationItem.title = "recipe"
                controller.navigationItem.rightBarButtonItem = self.splitViewController?.displayModeButtonItem
                self.table.reloadData()
            }
        }
    }

    // receives values from add recipes view
    @IBAction func unwindToMealList(sender: UIStoryboardSegue)
    {
        if let sourceViewController = sender.source as? AddRecipeViewController, let r = sourceViewController.recipe
        {
            let newIndexPath = NSIndexPath(row: recipes.count, section: 0)
            recipes.append(r)
            
            tableView.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
        }
    }
}

// allows user to tap anywhere but a textfield to hide the keyboard
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

// Allow the class to respond to the search bar
extension RecipeTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
