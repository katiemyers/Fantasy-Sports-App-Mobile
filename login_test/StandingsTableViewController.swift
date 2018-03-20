//
//  StandingsTableViewController.swift
//  login_test
//
//  Created by Katherine Myers on 2017-11-22.
//  Copyright © 2017 Katherine Myers. All rights reserved.
//

import UIKit

struct Team {
    var name : String
    var points : String
    var standing : String
    
    init() {
        name = ""
        points = "0"
        standing = "0"
    }
}

class StandingsTableViewController: UITableViewController {
    
    var standings_url = "https://fantasysportsapp.000webhostapp.com/api/v1/getstandings.php"
    var teamList = [Team]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let team = teamList[indexPath.row]
        if team.standing == "1" || team.standing == "21" || team.standing == "31" {
            cell.textLabel?.text = team.standing + "st - " + team.name
        } else if (team.standing == "2" || team.standing == "22" || team.standing == "32") {
            cell.textLabel?.text = team.standing + "nd - " + team.name
        } else if (team.standing == "3" || team.standing == "23" || team.standing == "33") {
            cell.textLabel?.text = team.standing + "rd - " + team.name
        } else {
            cell.textLabel?.text = team.standing + "th - " + team.name
        }
        cell.detailTextLabel?.text = "Points: " + team.points
        
        return cell
    }
    /*
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     DispatchQueue.main.async {
     let storyboard = UIStoryboard(name: "Main", bundle: nil)
     let vc = storyboard.instantiateViewController(withIdentifier: "TeamTableViewController") as! TeamTableViewController
     vc.league_name = self.leagueData[indexPath.row].title
     self.present(vc, animated: true, completion: nil)
     }
     }
     */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func downloadData() {
        let url = URL(string: standings_url)!
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "league_name=" + ParticipantVariables.currentLeague
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    //print(json)
                    let responseError = json["error"] as! Bool
                    if responseError == true {
                        print("error?")
                        //error
                    } else {
                        let message = json["message"] as! String
                        let team_array = message.components(separatedBy: "~~~")
                        
                        for team in team_array{
                            if team != "" {
                                var specific_array = team.components(separatedBy: "--")
                                var new_team = Team()
                                new_team.name = specific_array[0]
                                new_team.points = specific_array[1]
                                new_team.standing = specific_array[2]
                                self.teamList.append(new_team)
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
        
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
