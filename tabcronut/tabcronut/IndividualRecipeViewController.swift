//
//  IndividualRecipeViewController.swift
//  tabcronut
//
//  Created by Aditi Nataraj on 10/27/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

import UIKit
import EventKit

class IndividualRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var recipeTitle: String = ""
    var savedEventId : String = ""
    
    @IBOutlet weak var ingrTable: UITableView!
    @IBOutlet weak var dirTable: UITableView!
    
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


   
    @IBOutlet weak var exportRecipe: UIButton!
    @IBOutlet weak var editRecipe: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.ingrTable.delegate = self
        self.ingrTable.dataSource = self
        self.dirTable.delegate = self
        self.dirTable.dataSource = self
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
        var count:Int?
        if tableView == self.ingrTable  {
            return (self.passedValue?.ingredients.count)!
        }
        if tableView == self.dirTable   {
            return (self.passedValue?.directions.count)!
        }
        return count!
    }
    
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
            cell.ingrAmount2.text = String(ingredientValues[row].0)
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
    // accessible
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
                print("Bad things happened")
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
    @IBAction func addEvent(_ sender: UIButton) {
        let eventStore = EKEventStore()
        
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(60 * 60) // One hour
        
        
        
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                self.createEvent(eventStore, title: "Test Event", startDate: startDate, endDate: endDate)
            })
        } else {
            createEvent(eventStore, title: "Test Event", startDate: startDate, endDate: endDate)
        }
        
    }
    
    
    // Responds to button to remove event. This checks that we have permission first, before removing the
    // event
    @IBAction func removeEvent(_ sender: UIButton) {
        let eventStore = EKEventStore()
        
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: { (granted, error) -> Void in
                self.deleteEvent(eventStore, eventIdentifier: self.savedEventId)
            })
        } else {
            deleteEvent(eventStore, eventIdentifier: savedEventId)
        }
        
        let alertController = UIAlertController(title: "Just to let you know", message: "Reminder was removed successfully, yay!", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            print("You've pressed OK button");
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editRecipeSegue" {
            print("H E R E ")
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
    }
    
    
    
    
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
