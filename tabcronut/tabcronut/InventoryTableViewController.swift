//
//  InventoryTableViewController.swift
//  tabcronut
//
//  Created by Aditi Nataraj on 11/17/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

// inventory table view file
// ingredients that have been added to the inventory table

import UIKit
import EventKit

class InventoryTableViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    // initialize variables
    var total_ingreds: [String] = []
    var ingreds: [String]?
    
    var eventStore = EKEventStore()
    
    // connect outlets to the storyboard
    @IBOutlet weak var invTable: UITableView!
    
    //@IBOutlet var invTable: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.invTable.dataSource = self
        self.invTable.delegate = self
        //self.title = "Inventory List"

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

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return total_ingreds.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = invTable.dequeueReusableCell(withIdentifier: "invCell", for: indexPath) as! InventoryTableViewCell
        let row = indexPath.row
        cell.inventoryItem.text = total_ingreds[row]
        // Configure the cell...

        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // add shopping list to the reminders app
    @IBAction func addReminder(_ sender: Any) {
        self.eventStore.requestAccess(to: EKEntityType.reminder, completion:
            {(granted, error) in
                if !granted {
                    print("Access to store not granted")
                }
        })
        let reminder = EKReminder(eventStore: self.eventStore)
        reminder.title = "Shopping List"
        reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
        var ls = ""
        for i in 1...self.total_ingreds.count {
            ls += self.total_ingreds[i-1] + "\n"
        }
        reminder.notes = ls
        
        let location = EKStructuredLocation(title: "Walmart")
        location.geoLocation = CLLocation(latitude: 42.745602, longitude: -73.638805)
        let alarm = EKAlarm()
        alarm.structuredLocation = location
        alarm.proximity = EKAlarmProximity.enter
        
        reminder.addAlarm(alarm)
        
        do {
            try self.eventStore.save(reminder,
                                     commit: true)
        } catch let error {
            print("Reminder failed with error \(error.localizedDescription)")
        }
        
        
        let alertController = UIAlertController(title: "Just to let you know", message: "Reminder was added successfully, yay!", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            print("You've pressed OK button");
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }

    // receive values from the inventory list
    @IBAction func unwindToInventoryList(sender: UIStoryboardSegue)
    {
        if let sourceViewController = sender.source as? AddInventoryViewController
        {
            let n = sourceViewController.selected_ingredients
            print(self.total_ingreds.count)
            if n.count > 0  {
                for i in 0...(n.count-1) {
                    if self.total_ingreds.count == 0 || self.total_ingreds.index(of: n[i]) == nil {
                        self.total_ingreds.append(n[i])
                    }
                }
            }
            print(self.total_ingreds)
            self.invTable.reloadData()
            
        }
    }

}

// inventory table view cell
class InventoryTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var inventoryItem: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


