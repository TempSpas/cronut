//
//  IndividualRecipeViewController.swift
//  tabcronut
// 
//  This file represents the detail view of the screen
//  when the user taps one of their recipes. The code displays
//  thhe ingredients and directions.
//
//  Created by Aditi Nataraj on 10/27/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

// individual recipe view controller
// manages the view for each individual recipe
// allows the user to modify the recipe with the press of a button

import UIKit
import EventKit
import MobileCoreServices



class IndividualRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // saves variables
    var recipeTitle: String = ""
    var savedEventId : String = ""
    var newMedia: Bool?
    
    
    // connects outlets to the storyboard
    @IBOutlet weak var ingrTable: UITableView!
    @IBOutlet weak var dirTable: UITableView!
    @IBOutlet weak var tagTable: UITableView!
    
    
    @IBOutlet weak var imageView: UIImageView!

    
    var passedValue: Recipe?
    
    // menu button to show all the options for the user
    @IBAction func showOptions(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Hey man", message: "What do you want to do?", preferredStyle: .actionSheet)
        
        let defaultAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        // add recipe segue
        let dupRecipe = UIAlertAction(title: "Duplicate", style: .default) { (action:UIAlertAction) in
            self.performSegue(withIdentifier: "addRecipeSegue", sender: self)
        }
        
        // edit recipe segue
        let edRecipe = UIAlertAction(title: "Edit", style: .default)    { (action:UIAlertAction) in
            self.performSegue(withIdentifier: "editRecipeSegue", sender: self)
        }
        
        // scale recipe segue
        let modRecipe = UIAlertAction(title: "Scale", style: .default) { (action:UIAlertAction) in
            let alertController = UIAlertController(title: "Scale Recipe", message: "Write the factor by which you want to scale this recipe", preferredStyle: .alert)
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
                //This is called when the user presses the cancel button.
                print("You've pressed the cancel button");
            }
            let actionOK = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                //This is called when the user presses the login button.
                let textTitle = alertController.textFields![0] as UITextField;
                //print(textTitle.text);
                if textTitle.text != "" && Float(textTitle.text!)! > Float(0) {
                    self.changeRecipe(factor: Float(textTitle.text!)!);
                }
            }
            alertController.addTextField { (textField) -> Void in
                //Configure the attributes of the first text box.
                textField.placeholder = "1.5"
            }
            //Add the buttons
            alertController.addAction(actionCancel)
            alertController.addAction(actionOK)
            
            //Present the alert controller
            self.present(alertController, animated: true, completion:nil)
        }
        
        // add inventory segue
        let addToInventoryList = UIAlertAction(title: "Add Ingredients to Inventory", style: .default)  { (action:UIAlertAction) in
            self.performSegue(withIdentifier: "addToInventory", sender:self)
        }
        
        // add event
        let addEvent = UIAlertAction(title: "Add Calendar Event", style: .default)  { (action:UIAlertAction) in
            let eventStore = EKEventStore()
            
            let startDate = Date()
            let endDate = startDate.addingTimeInterval(60 * 60) // One hour
            
            // Checks for user permission to access iOS calendar.
            if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
                eventStore.requestAccess(to: .event, completion: {
                    granted, error in
                    self.createEvent(eventStore, title: "Test Event", startDate: startDate, endDate: endDate)
                })
            } else {
                self.createEvent(eventStore, title: "Test Event", startDate: startDate, endDate: endDate)
            }
        }
        
        // remove event
        let remEvent = UIAlertAction(title: "Remove Calendar Event", style: .default)   { (action:UIAlertAction) in
            let eventStore = EKEventStore()
            
            if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
                eventStore.requestAccess(to: .event, completion: { (granted, error) -> Void in
                    self.deleteEvent(eventStore, eventIdentifier: self.savedEventId)
                })
            } else {
                self.deleteEvent(eventStore, eventIdentifier: self.savedEventId)
            }
            
            let alertController = UIAlertController(title: "Just to let you know", message: "Reminder was removed successfully, yay!", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                print("You've pressed OK button");
            }
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        }
        
        // add all of these actions to the action sheet
        alertController.addAction(dupRecipe)
        alertController.addAction(edRecipe)
        alertController.addAction(modRecipe)
        alertController.addAction(addToInventoryList)
        alertController.addAction(addEvent)
        alertController.addAction(remEvent)
        alertController.addAction(defaultAction)
        
        // present the action view
        present(alertController, animated: true, completion: nil)
    }
    
    // helper recipe to change the recipe
    func changeRecipe(factor: Float) {
        if (self.passedValue?.ingredients.count)! > 0   {
            let ingreds = self.passedValue?.ingredients
            let ingr_list = [String](ingreds!.keys)
            for index in 0...(ingr_list.count-1)   {
                let curr = ingr_list[index]
                self.passedValue?.ingredients[curr]?.0 = factor*(self.passedValue?.ingredients[curr]?.0)!
                ingrTable.reloadData()
            }
            
        }
    }

    @IBOutlet weak var exportRecipe: UIButton!
    @IBOutlet weak var editRecipe: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // Loads view controller
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // set delegate and data source
        self.ingrTable.delegate = self
        self.ingrTable.dataSource = self
        self.dirTable.delegate = self
        self.dirTable.dataSource = self
        self.tagTable.delegate = self
        self.tagTable.dataSource = self
        navigationItem.title = "recipe"
        title = self.passedValue?.name
        self.imageView.image = self.passedValue?.image?.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Loads correct number of rows in each table based on number of ingredients
    // and directions in the recipe.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count:Int = 0
        if tableView == self.ingrTable  {
            return (self.passedValue?.ingredients.count)!
        }
        if tableView == self.dirTable   {
            return (self.passedValue?.directions.count)!
        }
        if tableView == self.tagTable   {
            return (self.passedValue?.tags.count)!
        }
        return count
    }
    
    // Sets up cell values for ingredient and direction tables
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell1: UITableViewCell?
        
        // ingredient table view
        if tableView == self.ingrTable  {
            let cell = ingrTable.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientTableViewCell
            
            let row = indexPath.row
            let ingreds = self.passedValue?.ingredients
            let ingredientNames = [String](ingreds!.keys)
            let ingredientValues = [(Float, String)](ingreds!.values)
            
            print(ingredientNames[row])
            cell.ingrLabel2.text = String(ingredientNames[row])
            if String(ingredientValues[row].0) != "0.0" {
                cell.ingrAmount2.text = String(ingredientValues[row].0)
            }
            else    {
                cell.ingrAmount2.text = ""
            }
            cell.ingrUnit2.text = ingredientValues[row].1
            return cell
        }
        
        // direction table view
        if tableView == self.dirTable   {
            let cell = dirTable.dequeueReusableCell(withIdentifier: "DirCell", for: indexPath) as! DirectionTableViewCell
            let row = indexPath.row
            let dirs = self.passedValue?.directions
            cell.directionName2.text = dirs![row]
            return cell
        }
        
        // tag table view
        if tableView == self.tagTable   {
            let cell = tagTable.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath) as! TagCellTableViewCell
            
            let row = indexPath.row
            let tags = self.passedValue?.tags
            let tagNames = [String](tags!.keys)
            let tagVals = [(UIColor, String)](tags!.values)
            
            cell.tagName2.text = String(tagNames[row])
            cell.tagCategory2.text = tagVals[row].1
            cell.tagName2.textColor = tagVals[row].0
            cell.tagCategory2.textColor = tagVals[row].0
            return cell
        }
        return cell1!
    }
    
    
    // Creates an event in the EKEventStore. The method assumes the eventStore is created and
    // accessible.
    func createEvent(_ eventStore: EKEventStore, title: String, startDate: Date, endDate: Date) {
        
        let alertController = UIAlertController(title: "Add Reminder", message: "Fill the form and take a seat! Next!", preferredStyle: .alert)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            //This is called when the user presses the cancel button.
            print("You've pressed the cancel button");
        }
        
        let actionOK = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            //This is called when the user presses the login button.
            let textTitle = alertController.textFields![0] as UITextField;
            let textStart = alertController.textFields![1] as UITextField;
            let textEnd = alertController.textFields![2] as UITextField;
            
            
            let event = EKEvent(eventStore: eventStore)
            event.title = textTitle.text!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
            
            //print(dateFormatter.string(from: dateFormatter.date( from: "11/02/2016 13:00" )!))
            
            //event.startDate = startDate
            //event.endDate = endDate
            event.startDate = dateFormatter.date( from: textStart.text! )!
            event.endDate = dateFormatter.date( from: textEnd.text! )!
            event.calendar = eventStore.defaultCalendarForNewEvents
            do {
                try eventStore.save(event, span: .thisEvent)
                self.savedEventId = event.eventIdentifier
            } catch {
                print("Bad things happened") // You bethca!
            }
            
            let alertController = UIAlertController(title: "Just to let you know", message: "Reminder was added successfully, yay!", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                print("You've pressed OK button");
            }
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            
            //print("The user entered:%@ & %@",textUser.text!,textPW.text!);
        }
        
        alertController.addTextField { (textField) -> Void in
            //Configure the attributes of the first text box.
            textField.placeholder = "Event Title"
        }
        
        alertController.addTextField { (textField) -> Void in
            //Configure the attributes of the second text box.
            textField.placeholder = "MM/dd/yyyy hh:mm AM(PM)"
        }
        
        alertController.addTextField { (textField) -> Void in
            //Configure the attributes of the third text box.
            textField.placeholder = "MM/dd/yyyy hh:mm AM(PM)"
        }
        
        //Add the buttons
        alertController.addAction(actionCancel)
        alertController.addAction(actionOK)
        
        //Present the alert controller
        self.present(alertController, animated: true, completion:nil)
    }
    
    // Removes an event from the EKEventStore. The method assumes the eventStore is created and
    // accessible
    func deleteEvent(_ eventStore: EKEventStore, eventIdentifier: String) {
        let eventToRemove = eventStore.event(withIdentifier: eventIdentifier)
        if (eventToRemove != nil) {
            do {
                try eventStore.remove(eventToRemove!, span: .thisEvent)
            } catch {
                print("Bad things happened")
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editRecipeSegue" {
            let controller = (segue.destination as! EditRecipeViewController)
            let recipe = passedValue
            controller.recipeValue = recipe
            controller.numIngreds = recipe?.ingredients.count
            controller.numDirs = recipe?.directions.count
            controller.numTags = recipe?.tags.count
        
        }
        if segue.identifier == "addRecipeSegue"  {
            let controller = (segue.destination as! AddRecipeViewController)
            let recipe = passedValue
            controller.pre_title = (recipe?.name)! + " copy"
            controller.pre_ingredients = recipe?.ingredients
            controller.pre_directions = recipe?.directions
            controller.numIngrs = recipe?.ingredients.count
            
        }
        if segue.identifier == "addToInventory" {
            let controller = (segue.destination as! AddInventoryViewController)
            let recipe = passedValue
            controller.recipeValue = recipe
            controller.numIngreds = recipe?.ingredients.count
        }
    }
    
    // Receives values after the user edits the recipes.
    @IBAction func unwindToIndividualRecipe(sender: UIStoryboardSegue)
    {
        if let sourceViewController = sender.source as? EditRecipeViewController, let r = sourceViewController.recipeValue
        {
            passedValue = r
            ingrTable.reloadData()
            dirTable.reloadData()
            tagTable.reloadData()
            self.title = r.name
            
        }
    }
}

