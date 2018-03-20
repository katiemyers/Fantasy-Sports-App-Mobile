//
//  PlayerInfoViewController.swift
//  login_test
//
//  Created by Katherine Myers on 2017-10-26.
//  Copyright © 2017 Katherine Myers. All rights reserved.
//

import UIKit

class PlayerInfoViewController: UIViewController {

    @IBOutlet weak var player_name_label: UILabel!
    @IBOutlet weak var add_player_button: UIButton!
    @IBOutlet weak var player_stats_label: UILabel!
    let get_stats_url = "https://fantasysportsapp.000webhostapp.com/api/v1/getplayerstats.php"
    let add_to_roster_url = "https://fantasysportsapp.000webhostapp.com/api/v1/addplayer.php"
    let remove_from_roster_url = "https://fantasysportsapp.000webhostapp.com/api/v1/removeplayer.php"
    let roster_url = "https://fantasysportsapp.000webhostapp.com/api/v1/getroster.php"
    let league_roster_url = "https://fantasysportsapp.000webhostapp.com/api/v1/getleagueroster.php"
    let get_rules_url = "https://fantasysportsapp.000webhostapp.com/api/v1/getleaguerules.php"

    var newPlayerList = [Player]()
    var rosterList = [Player]()
    var position = ""
    var rules_list = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player_stats_label.lineBreakMode = .byWordWrapping
        player_stats_label.numberOfLines = 0
        player_name_label.text = ParticipantVariables.currentPlayer
        
        self.getLeague()
        self.getRules()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if let buttonTitle = sender.title(for: .normal) {
            if buttonTitle == "Add" {
                tryAddToRoster()
            }
            else {
                confirmRemoval()
            }
        }
    }
    
    func tryAddToRoster() {
        let url = URL(string: add_to_roster_url)!
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "player_name=" + ParticipantVariables.currentPlayer + "&participant_id=" + ParticipantVariables.participantId + "&league_name=" + ParticipantVariables.currentLeague + "&sportID=nhl" + "&player_position=" + self.position
        
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
                    let message = json["message"] as! String
                    if responseError == true {
                        self.failed_add(message:message)
                        //error
                    } else {
                        self.successful_add()
                        DispatchQueue.main.async {
                            self.add_player_button.setTitle("Remove",for: .normal)
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
        
    }
    
    func failed_add(message:String)
    {
        print("Bad Add")
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Addition Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func successful_add()
    {
        print("Good Add")
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success!", message: "Please return to the roster to see your addition", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getRules() {
        let url = URL(string: get_rules_url)!
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "leagueName=" + ParticipantVariables.currentLeague
        print(postString)
        
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
                        
                        let rules_array = message.components(separatedBy: "~~~")
                        self.rules_list = rules_array[7].components(separatedBy: ",")
                        
                        DispatchQueue.main.async {
                            
                            self.getStats()
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func getStats() {
        let url = URL(string: get_stats_url)!
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "player_name=" + ParticipantVariables.currentPlayer
        
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
                        var message = json["message"] as! String
                        var display_string = ""
                        
                        if message == "" {
                            display_string = "No Current Stats"
                        } else {
                        
                            let splitted = message.characters.split { [",", "{", "}", "\"", "@", "#", ":"].contains(String($0)) }
                            let trimmed = splitted.map { String($0).trimmingCharacters(in: .whitespaces) }
                            
                            print(trimmed)
                            
                            for i in 0..<trimmed.count {
                                if trimmed[i] == "Position" {
                                    display_string = display_string + "Position: " + trimmed[i+1] + "\n"
                                    self.position = trimmed[i+1]
                                }
                                if trimmed[i] == "Name" {
                                    display_string = display_string + "Team Name: " + trimmed[i+1] + "\n"
                                }
                                for rule in self.rules_list {
                                    if trimmed[i] == rule {
                                        display_string = display_string + rule + " : " + trimmed[i+4] + "\n"
                                    }
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.player_stats_label.text = display_string
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
        
    }
    
    func getTeam() {
        let url = URL(string: roster_url)!
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
                        var already_in_team = false
                        var already_in_league = false
                        
                        for player in player_array{
                            if player != "" {
                                var new_player = Player()
                                new_player.name = player
                                self.newPlayerList.append(new_player)
                                if player == ParticipantVariables.currentPlayer {
                                    already_in_team = true
                                }
                            }
                        }
                        
                        for player in self.rosterList {
                            if player.name == ParticipantVariables.currentPlayer {
                                already_in_league = true
                            }
                        }
                        if already_in_team == true {
                            DispatchQueue.main.async {
                                self.add_player_button.setTitle("Remove",for: .normal)
                                self.add_player_button.isEnabled = true
                            }
                        }
                        else if already_in_league == true {
                            DispatchQueue.main.async {
                                self.add_player_button.setTitle("Another Owner",for: .normal)
                                self.add_player_button.isEnabled = false
                            }
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
        
    }
    
    func getLeague() {
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
                            self.getTeam()
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
        
    }
    
    func tryRemoveFromRoster () {
        let url = URL(string: remove_from_roster_url)!
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "player_name=" + ParticipantVariables.currentPlayer + "&participant_id=" + ParticipantVariables.participantId + "&league_name=" + ParticipantVariables.currentLeague + "&sportID=" + "nhl"
        
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
                    let message = json["message"] as! String
                    if responseError == true {
                        self.failed_remove(message:message)
                        //error
                    } else {
                        self.successful_remove()
                        DispatchQueue.main.async {
                            self.add_player_button.setTitle("Add",for: .normal)
                            self.add_player_button.isEnabled = true
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
        
    }
    
    func failed_remove(message:String)
    {
        print("Bad Remove")
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Removal Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func successful_remove()
    {
        print("Good Remove")
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success!", message: "Please return to the roster to see your removal", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func confirmRemoval() {
        let alert = UIAlertController(title: "Player Removal", message: "Are you sure you want to remove this player?", preferredStyle: .alert)
        let clearAction = UIAlertAction(title: "Remove", style: .default) { (alert: UIAlertAction!) -> Void in
            self.tryRemoveFromRoster()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (alert: UIAlertAction!) -> Void in
            print("cancelled removal")
        }
        
        alert.addAction(clearAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion:nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
