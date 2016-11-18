//
//  InventoryTableViewController.swift
//  tabcronut
//
//  Created by Aditi Nataraj on 11/17/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

import UIKit

class InventoryTableViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {

    var total_ingreds: [String] = []
    var ingreds: [String]?
    
    
    @IBOutlet weak var invTable: UITableView!
    
    //@IBOutlet var invTable: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.invTable.dataSource = self
        self.invTable.delegate = self
        self.title = "Inventory List"

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
            //let newIndexPath = NSIndexPath(row: recipes.count, section: 0)
            //recipes.append(r)
            //self.title = r.name
            //tableView.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
            
        }
    }

}

class InventoryActualTableViewController    {
    
}


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


