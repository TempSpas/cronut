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

import UIKit
import EventKit

//@objc
//protocol IndividualRecipeViewControllerDelegate {
//    @objc optional func toggleLeftPanel()
//    @objc optional func collapseSidePanels()
//}


class IndividualRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var recipeTitle: String = ""
    var savedEventId : String = ""
    
    @IBOutlet weak var ingrTable: UITableView!
    @IBOutlet weak var dirTable: UITableView!
    
    
    
//    var delegate: IndividualRecipeViewControllerDelegate?
//
//    @IBAction func revealMenu(_ sender: AnyObject) {
//        print("HERE!")
//        print(delegate)
//        delegate?.toggleLeftPanel?()
//    }
    
    var passedValue: Recipe?
    
    @IBAction func showOptions(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Hey man", message: "What do you want to do?", preferredStyle: .actionSheet)
        
        let defaultAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        //let dupRecipe = UIAlertAction(title: "Duplicate", style: .default, handler: nil)
        let dupRecipe = UIAlertAction(title: "Duplicate", style: .default) { (action:UIAlertAction) in
            self.performSegue(withIdentifier: "addRecipeSegue", sender: self)
        }
        let edRecipe = UIAlertAction(title: "Edit", style: .default)    { (action:UIAlertAction) in
            self.performSegue(withIdentifier: "editRecipeSegue", sender: self)
        }
        let modRecipe = UIAlertAction(title: "Mod", style: .default) { (action:UIAlertAction) in
            let alertController = UIAlertController(title: "Mod Recipe", message: "Write the factor by which you want to modify this recipe", preferredStyle: .alert)
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
                //This is called when the user presses the cancel button.
                print("You've pressed the cancel button");
            }
            let actionOK = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                //This is called when the user presses the login button.
                let textTitle = alertController.textFields![0] as UITextField;
                //print(textTitle.text);
                if textTitle.text != "" {
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
        let addToInventoryList = UIAlertAction(title: "Add Ingredients to Inventory", style: .default)  { (action:UIAlertAction) in
            self.performSegue(withIdentifier: "addToInventory", sender:self)
        }
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
        alertController.addAction(dupRecipe)
        alertController.addAction(edRecipe)
        alertController.addAction(modRecipe)
        alertController.addAction(addToInventoryList)
        alertController.addAction(addEvent)
        alertController.addAction(remEvent)
        alertController.addAction(defaultAction)
        
        
        present(alertController, animated: true, completion: nil)
    }
    
    func changeRecipe(factor: Float) {
        if (self.passedValue?.ingredients.count)! > 0   {
            let ingreds = self.passedValue?.ingredients
            let ingr_list = [String](ingreds!.keys)
            for index in 0...(ingr_list.count-1)   {
                print("here");
                let curr = ingr_list[index]
                self.passedValue?.ingredients[curr]?.0 = factor*(self.passedValue?.ingredients[curr]?.0)!
                ingrTable.reloadData()
            }
            
        }
    }
    
    
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

    @IBOutlet weak var exportRecipe: UIButton!
    @IBOutlet weak var editRecipe: UIButton!
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // Loads view controller
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.ingrTable.delegate = self
        self.ingrTable.dataSource = self
        self.dirTable.delegate = self
        self.dirTable.dataSource = self
        title = self.passedValue?.name
        print(self.passedValue?.name)
        print(self.passedValue?.ingredients)
        print(self.passedValue?.tags)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Loads correct number of rows in each table based on number of ingredients
    // and directions in the recipe.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        if tableView == self.ingrTable  {
            return (self.passedValue?.ingredients.count)!
        }
        if tableView == self.dirTable   {
            return (self.passedValue?.directions.count)!
        }
        return count!
    }
    
    // Sets up cell values for ingredient and direction tables
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell1: UITableViewCell?
        if tableView == self.ingrTable  {
            let cell = ingrTable.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientTableViewCell
            
            let row = indexPath.row
            let ingreds = self.passedValue?.ingredients
            let ingredientNames = [String](ingreds!.keys)
            let ingredientValues = [(Float, String)](ingreds!.values)
            
            print(ingredientNames[row])
            cell.ingrLabel2.text = String(ingredientNames[row])
//            cell.ingrAmount2.text = String(ingredientValues[row].0)
            if String(ingredientValues[row].0) != "0.0" {
                cell.ingrAmount2.text = String(ingredientValues[row].0)
            }
            else    {
                cell.ingrAmount2.text = ""
            }
            cell.ingrUnit2.text = ingredientValues[row].1
            return cell
        }
        if tableView == self.dirTable   {
            let cell = dirTable.dequeueReusableCell(withIdentifier: "DirCell", for: indexPath) as! DirectionTableViewCell
            let row = indexPath.row
            let dirs = self.passedValue?.directions
            cell.directionName2.text = dirs![row]
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
    
    // Responds to button to add event. This checks that we have permission first, before adding the
    // event
//    @IBAction func addEvent(_ sender: UIButton) {
//        let eventStore = EKEventStore()
//        
//        let startDate = Date()
//        let endDate = startDate.addingTimeInterval(60 * 60) // One hour
//        
//        // Checks for user permission to access iOS calendar.
//        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
//            eventStore.requestAccess(to: .event, completion: {
//                granted, error in
//                self.createEvent(eventStore, title: "Test Event", startDate: startDate, endDate: endDate)
//            })
//        } else {
//            createEvent(eventStore, title: "Test Event", startDate: startDate, endDate: endDate)
//        }
//        
//    }
    
    
    // Responds to button to remove event. This checks that we have permission first, before removing the
    // event
//    @IBAction func removeEvent(_ sender: UIButton) {
//        let eventStore = EKEventStore()
//        
//        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
//            eventStore.requestAccess(to: .event, completion: { (granted, error) -> Void in
//                self.deleteEvent(eventStore, eventIdentifier: self.savedEventId)
//            })
//        } else {
//            deleteEvent(eventStore, eventIdentifier: savedEventId)
//        }
//        
//        let alertController = UIAlertController(title: "Just to let you know", message: "Reminder was removed successfully, yay!", preferredStyle: .alert)
//        
//        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
//            print("You've pressed OK button");
//        }
//        
//        alertController.addAction(OKAction)
//        self.present(alertController, animated: true, completion:nil)
//        
//    }
    
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
//            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
//            controller.navigationItem.leftItemsSupplementBackButton = true
        
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
            //let newIndexPath = NSIndexPath(row: recipes.count, section: 0)
            //recipes.append(r)
            passedValue = r
            ingrTable.reloadData()
            dirTable.reloadData()
            self.title = r.name
            //tableView.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
            
        }
    }
}
