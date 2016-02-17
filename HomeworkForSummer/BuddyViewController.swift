//
//  BuddyTableViewController.swift
//  HomeworkForSummer
//
//  Created by Samuli Tamminen on 8.2.2016.
//  Copyright © 2016 Samuli Tamminen. All rights reserved.
//

import UIKit

class BuddyViewController: UITableViewController, UISearchResultsUpdating {
    
    // MARK: Properties
    
    var buddies = [Buddy]()
    var filteredBuddies = [Buddy]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "Search for your buddy"
        searchController.searchBar.searchBarStyle = .Minimal
        
        // Load any saved data
        if let savedBuddies = loadBuddies() {
            buddies += savedBuddies
        }
        
        // For some reason, searchbar doesn't get fully hidden
        // tableView.contentOffset = CGPointMake(0, searchController.searchBar.frame.size.height)

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
        
        if searchController.active && searchController.searchBar.text != "" {
            return filteredBuddies.count
        }
        return buddies.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BuddyCell", forIndexPath: indexPath) as! BuddyCell
        
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let buddy: Buddy
        
        if searchController.active && searchController.searchBar.text != "" {
            buddy = filteredBuddies[indexPath.row]
        } else {
            buddy = buddies[indexPath.row]
        }

        cell.nameLabel.text = buddy.name
        cell.accountLabel.text = buddy.account

        return cell
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredBuddies = buddies.filter { buddy in
            return buddy.name.lowercaseString.containsString(searchController.searchBar.text!.lowercaseString)
        }
        
        tableView.reloadData()

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
            saveBuddies()
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
        
        if segue.identifier == "ShowDetail" {
            let detailViewController = segue.destinationViewController as! DetailBuddyViewController
            
            // Get the cell that generated this segue.
            if let selectedCell = sender as? BuddyCell {
                let indexPath = tableView.indexPathForCell(selectedCell)!
                
                let selectedBuddy: Buddy
                if searchController.active && searchController.searchBar.text != "" {
                    selectedBuddy = filteredBuddies[indexPath.row]
                } else {
                    selectedBuddy = buddies[indexPath.row]
                }

                detailViewController.buddy = selectedBuddy
                detailViewController.index = indexOfBuddy(selectedBuddy)
            }
        }
        else if segue.identifier == "AddItem" {
            // Just logging
            print("Adding new buddy.")
        }
    }
    
    func indexOfBuddy(buddy: Buddy) -> Int? {
        for i in 0..<buddies.count {
            if buddies[i].name == buddy.name && buddies[i].account == buddy.account {
                return i
            }
        }
        return nil
    }
    
    @IBAction func unwindToBuddyViewController(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? DetailBuddyViewController, buddy = sourceViewController.buddy {
            
            if let index = sourceViewController.index {
                // Update an existing buddy
                buddies[index] = buddy
                tableView.reloadData()
            } else {
                // Add a new Buddy
                let newIndexPath = NSIndexPath(forRow: buddies.count, inSection: 0)
                buddies.append(buddy)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
            saveBuddies()
        }
    }
    
    
    // MARK: NSCoding
    
    func saveBuddies() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(buddies, toFile: Buddy.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save!")
        }
    }
    
    func loadBuddies() -> [Buddy]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Buddy.ArchiveURL.path!) as? [Buddy]
    }
    
}
