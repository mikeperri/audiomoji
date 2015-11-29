//
//  EmojiTableViewController.swift
//  Old School Emoji
//
//  Created by Michael Perri on 11/27/15.
//  Copyright © 2015 Michael Perri. All rights reserved.
//

import UIKit

class EmojiTableViewController: UITableViewController, UISearchResultsUpdating {

    var tableData = [Emoji]()
    var filteredTableData = [Emoji]()
    var resultSearchController = UISearchController!()
    var hud: MBProgressHUD = MBProgressHUD()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()

            self.tableView.tableHeaderView = controller.searchBar

            return controller
        })()

        loadSampleEmojis()
        
        self.tableView.reloadData()
    }
    
    func loadSampleEmojis() {
        let path = NSBundle.mainBundle().pathForResource("Emojis", ofType: "plist")!
        let arr = NSArray(contentsOfFile: path)
        
        for el in arr! {
            if el is NSDictionary {
                let dict = el as! NSDictionary
                let emoji = Emoji(name: dict["name"] as! String, text: dict["text"] as! String)
                tableData.append(emoji)
            }
        }
        
        
        filteredTableData = tableData
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
        return filteredTableData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "EmojiTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EmojiTableViewCell
        var emoji: Emoji

        emoji = filteredTableData[indexPath.row]
        
        // Configure the cell...
        cell.emojiTextLabel.text = emoji.text
        cell.nameLabel.text = emoji.name

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let emojiText = filteredTableData[indexPath.row].text
        let progressHUD = MBProgressHUD.showHUDAddedTo(self.view.superview, animated: true)
        progressHUD.customView = UIImageView(image: UIImage(named: "37x-Checkmark.png"))
        progressHUD.mode = MBProgressHUDMode.CustomView
        progressHUD.labelText = "Copied"
        progressHUD.hide(true, afterDelay: 1)
        
        UIPasteboard.generalPasteboard().string = emojiText
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        
        filteredTableData.removeAll(keepCapacity: true)
        
        if (searchText != nil && searchText!.characters.count > 0) {
            filteredTableData = tableData.filter() {
                $0.name.rangeOfString(searchController.searchBar.text!.lowercaseString) != nil
            }
        } else {
            filteredTableData = tableData
        }
        
        self.tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
