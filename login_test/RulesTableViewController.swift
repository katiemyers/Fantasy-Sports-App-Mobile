//
//  RulesTableViewController.swift
//  login_test
//
//  Created by Katherine Myers on 2017-11-30.
//  Copyright © 2017 Katherine Myers. All rights reserved.
//

import UIKit

class RulesTableViewController: UITableViewController {

    let all_rules = ["GamesPlayed","Goals","Assists","Points","HatTricks","Penalties","PenaltyMinutes","PowerplayGoals","PowerplayAssists","PowerplayPoints","ShorthandedGoals","ShorthandedAssists","ShorthandedPoints","GameWinningGoals","GameTyingGoals","PlusMinus","Shots","ShotPercentage","Hits","Faceoffs","FaceoffWins","FaceoffLosses","FaceoffPercent","Wins","Losses","OvertimeWins","OvertimeLosses","GoalsAgainst","ShotsAgainst","Saves","GoalsAgainstAverage","SavePercentage","Shutouts","GamesStarted","CreditForGame","MinutesPlayed"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if rulesList.contains(all_rules[indexPath.row]) {
            if let index = rulesList.index(of: all_rules[indexPath.row]) {
                rulesList.remove(at: index)
            }
        } else {
            rulesList.append(all_rules[indexPath.row])
        }
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return all_rules.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = all_rules[indexPath.row]
        let accessory: UITableViewCellAccessoryType = rulesList.contains(all_rules[indexPath.row]) ? .checkmark : .none
        cell.accessoryType = accessory
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

}
