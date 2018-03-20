//
//  AllLeaguesTableViewController.swift
//  login_test
//
//  Created by Katherine Myers on 2017-11-15.
//  Copyright © 2017 Katherine Myers. All rights reserved.
//

import UIKit

class AllLeaguesTableViewController: UITableViewController {

    var all_leagues_url = "https://fantasysportsapp.000webhostapp.com/api/v1/getallleagues.php"
    var NewLeagueData = [League]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewDidAppear(_ animated: Bool) {
        self.downloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewLeagueData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let league = NewLeagueData[indexPath.row]
        cell.textLabel?.text = league.title
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ParticipantVariables.currentLeague = self.NewLeagueData[indexPath.row].title
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func downloadData() {
        NewLeagueData = [League]()
        let url = URL(string: all_leagues_url)!
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
                        let league_array = message.components(separatedBy: "~~~")
                        
                        for league in league_array{
                            if league != "" {
                                var new_league = League()
                                new_league.title = league
                                self.NewLeagueData.append(new_league)
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
}
