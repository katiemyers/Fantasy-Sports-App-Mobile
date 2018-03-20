//
//  JoinLeagueViewController.swift
//  login_test
//
//  Created by Katherine Myers on 2017-11-01.
//  Copyright © 2017 Katherine Myers. All rights reserved.
//

import UIKit

class JoinLeagueViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var league_name: UILabel!
    @IBOutlet var team_name: UITextField!
    @IBOutlet var league_password: UITextField!
    @IBOutlet var join_button: UIButton!
    @IBOutlet weak var pass_label: UILabel!
    
    let register_league_url = "https://fantasysportsapp.000webhostapp.com/api/v1/joinleague.php"
    let get_league_info_url = "https://fantasysportsapp.000webhostapp.com/api/v1/getleagueinfo.php"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        league_name.lineBreakMode = .byWordWrapping
        league_name.numberOfLines = 0
        league_name.text = "Join League: " + ParticipantVariables.currentLeague
        team_name.placeholder = "Your team name"
        league_password.placeholder = "League password"
        get_league_info()
        // Do any additional setup after loading the view.
        team_name.delegate = self;
        league_password.delegate = self;
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitLeague(_ sender: AnyObject) {
        if self.league_password.isHidden {
            try_join(leaguePassword: "", teamName: team_name.text!)
        } else {
            try_join(leaguePassword: league_password.text!, teamName: team_name.text!)
        }
    }
    
    func get_league_info() {
        let url = URL(string: get_league_info_url)!
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "league_name=" + ParticipantVariables.currentLeague
        
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
                    let message = json["message"] as! String
                    if responseError == true {
                        self.failed_to_get_team_info(message:message)
                    } else {
                        if message == "0" {
                            DispatchQueue.main.async {
                                self.league_password.isHidden = true
                                self.pass_label.isHidden = true
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
    
    func try_join(leaguePassword:String, teamName:String)
    {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 _-")
        
        if teamName == "" {
            bad_data_notice(message:"Please enter a team name")
            return
        }
        if teamName.rangeOfCharacter(from: characterset.inverted) != nil {
            bad_data_notice(message:"Invalid team name, please only use alphanumeric characters")
            return
        }
        
        
        let url = URL(string: register_league_url)!
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "participant_id=" + ParticipantVariables.participantId + "&leagueName=" + ParticipantVariables.currentLeague + "&leaguePassword=" + leaguePassword + "&teamName=" + teamName
        
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
                        self.failed_join(message:message)
                    } else {
                        self.successful_join()
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func successful_join()
    {
        print("Good Join")
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success!", message: "Please return to the league table to see your new league", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func failed_join(message:String)
    {
        print("Bad Join")
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Failed to join", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func failed_to_get_team_info(message:String)
    {
        print("Bad Get Info")
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Failed to get league info", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func bad_data_notice(message:String)
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
