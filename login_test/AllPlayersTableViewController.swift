//
//  AllPlayersTableViewController.swift
//  login_test
//
//  Created by Katherine Myers on 2017-10-26.
//  Copyright © 2017 Katherine Myers. All rights reserved.
//

import UIKit

struct everyPlayer {
    var name : String
    var position: String
    var availability: String
    
    init() {
        name = ""
        position = ""
        availability = "Available"
    }
}

class AllPlayersTableViewController: UITableViewController {

    var players_url = "https://fantasysportsapp.000webhostapp.com/api/v1/getallplayers.php"
    var league_roster_url = "https://fantasysportsapp.000webhostapp.com/api/v1/getleagueroster.php"
    var playerList = [everyPlayer]()
    var rosterList = [Player]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getTeam()
        self.tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ParticipantVariables.currentPlayer = self.playerList[indexPath.row].name
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let player = playerList[indexPath.row]
        cell.textLabel?.text = player.name
        cell.detailTextLabel?.text = "Availability: " + player.availability + ", Position: " + player.position
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
        let url = URL(string: players_url)!
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "sportID=" + "nhl"
        
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
                        let player_array = message.components(separatedBy: "~~~")
                        var mini_array = [String]()
                        
                        for player in player_array{
                            if player != "" {
                                mini_array = player.components(separatedBy: "--")
                                var new_player = everyPlayer()
                                new_player.name = mini_array[0]
                                new_player.position = mini_array[1]
                                for sec_player in self.rosterList {
                                    if sec_player.name == new_player.name {
                                        new_player.availability = "Owned"
                                    }
                                }
                                self.playerList.append(new_player)
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
    
    func getTeam() {
        let url = URL(string: league_roster_url)!
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "participant_id=" + ParticipantVariables.participantId + "&league_name=" + ParticipantVariables.currentLeague
        
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
                        let player_array = message.components(separatedBy: "~~~")
                        
                        for player in player_array{
                            if player != "" {
                                var new_player = Player()
                                new_player.name = player
                                self.rosterList.append(new_player)
                            }
                        }
                        DispatchQueue.main.async {
                            self.downloadData()
                        }
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
