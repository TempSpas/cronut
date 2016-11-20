//
//  RecipeTableViewController.swift
//  tabcronut
//
//  Created by Aditi Nataraj on 10/24/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

import UIKit
import Foundation

class RecipeTableViewController: UITableViewController {
    
    // MARK: Properties
    @IBOutlet weak var addRecipeButton: UIBarButtonItem!
    @IBOutlet var table: UITableView!
    
    var recipes = [Recipe]()
    var objects = [AnyObject]()
    var filteredRecipes = [Recipe]()
    
    // Display search results in the same view controller
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        /*****/
        // Search code:
        
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
        /*****/
        
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
    
    //    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
    //        print("HERE")
    //        //print("You selected cell #\(indexPath.row)!")
    //
    //        // Get Cell Label
    //        let indexPath = tableView.indexPathForSelectedRow
    //        let currentCell = tableView.cellForRow(at: indexPath!) as UITableViewCell!;
    //
    //        valueToPass = currentCell?.textLabel?.text
    //        performSegue(withIdentifier: "viewDetails", sender: self)
    //
    //    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
         let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableCell", for: indexPath) as! RecipeViewCell
         // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
         
         // Configure the cell...
         let row = indexPath.row
         // cell.recipeLabel.text = attractionNames[row]
         cell.recipeLabel.text = recipes[row].name
         cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
         
         return cell
         */
        
        // Populate the cells with the correct names based on search results.
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableCell", for: indexPath) as! RecipeViewCell
        let recipe: Recipe
        if searchController.isActive && searchController.searchBar.text != "" {
            recipe = filteredRecipes[indexPath.row]
            cell.recipeLabel.text = filteredRecipes[indexPath.row].name
        } else {
            recipe = recipes[indexPath.row]
            cell.recipeLabel.text = recipes[indexPath.row].name
        }
        // cell.recipeLabel.text = recipes[indexPath.row].name
        // cell.detailTextLabel?.text = candy.category
        
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
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
            // ????????????
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
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("here?")
        //print(segue.identifier)
        if segue.identifier == "viewDetails" {
            //print("here!")
            if let indexPath = self.tableView.indexPathForSelectedRow {
                // let recipe = recipes[indexPath.row]
                
                // Ensure that the correct pages are accessed after search
                // filters out irrelevant recipes.
                let recipe: Recipe
                if searchController.isActive && searchController.searchBar.text != "" {
                    recipe = filteredRecipes[indexPath.row]
                } else {
                    recipe = recipes[indexPath.row]
                }
                
                /*****/
                // DEPRECATED CODE:
                //let row = self.table.indexPathForSelectedRow?.row
                //let currentCell = tableView.cellForRow(at: indexPath) as UITableViewCell!;
                //
                //        valueToPass = currentCell?.textLabel?.text
                //let controller = (segue.destination as! UINavigationController).topViewController as! IndividualRecipeViewController
                /*****/
                
                let controller = (segue.destination as! IndividualRecipeViewController)
                controller.passedValue = recipe
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.navigationItem.title = "recipe"
                //controller.navigationItem.rightBarButtonItem = controller.showOptions()
                self.table.reloadData()
            }
        }
    }
    
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //        print("here")
    //        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    //        let recipesViewController = storyboard?.instantiateViewController(withIdentifier: "IndividualRecipeViewController") as! IndividualRecipeViewController
    //        recipesViewController.passedValue = "hi"
    //        navigationController?.pushViewController(recipesViewController, animated: true)
    //
    //
    //    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        // Get the new view controller using segue.destinationViewController.
    //        // Pass the selected object to the new view controller.
    //
    //        if addRecipeButton === sender
    //        {
    //            let user = rec
    //        }
    //    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue)
    {
        if let sourceViewController = sender.source as? AddRecipeViewController, let r = sourceViewController.recipe
        {
            let newIndexPath = NSIndexPath(row: recipes.count, section: 0)
            recipes.append(r)
            
            tableView.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
        }
    }
    
    // MARK: NSCoding
    
    // func saveRecipes()
    // {
    //     let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(user, toFile: User.ArchiveURL.path!)
    
    //     if!isSuccessfulSave {
    //         print("Failed to save recipes...")
    //     }
    // }
    
    // func loadUserData() -> User?
    // {
    //     return NSKeyedUnarchiver.unarchiveObjectWithFile(User.ArchiveURl.path!) as? User
    // }
}

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
