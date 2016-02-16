//
//  BuddyTableViewController.swift
//  HomeworkForSummer
//
//  Created by Samuli Tamminen on 8.2.2016.
//  Copyright © 2016 Samuli Tamminen. All rights reserved.
//

import UIKit

class BuddyViewController: UITableViewController {
    
    // Get data from whatever storage we are using
    var buddies = BuddyApi.getBuddies()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buddies.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BuddyCell", forIndexPath: indexPath) as! BuddyCell
        
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension

        let buddy = buddies[indexPath.row]
        cell.nameLabel.text = buddy.name
        cell.accountLabel.text = buddy.account

        return cell
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            print(indexPath.row)
            buddies.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let movedObject = buddies.removeAtIndex(fromIndexPath.row)
        buddies.insert(movedObject, atIndex: toIndexPath.row)
        // print("\(fromIndexPath.row) => \(toIndexPath.row) \(buddies)")
        // self.tableView.reloadData()
    }



    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowDetail" {
            let detailViewController = segue.destinationViewController as! DetailBuddyViewController
            
            // Get the cell that generated this segue.
            if let selectedCell = sender as? BuddyCell {
                let indexPath = tableView.indexPathForCell(selectedCell)!
                let selectedBuddy = buddies[indexPath.row]
                detailViewController.buddy = selectedBuddy
            }
        }
        else if segue.identifier == "AddItem" {
            // Just logging
            print("Adding new buddy.")
        }
    }
    
    
    @IBAction func unwindToBuddyViewController(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? DetailBuddyViewController, buddy = sourceViewController.buddy {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing buddy
                buddies[selectedIndexPath.row] = buddy
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                // Add a new Buddy
                let newIndexPath = NSIndexPath(forRow: buddies.count, inSection: 0)
                buddies.append(buddy)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
        }
    }
    

}
