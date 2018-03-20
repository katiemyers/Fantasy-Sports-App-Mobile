//
//  CreateLeagueViewController.swift
//  login_test
//
//  Created by Katherine Myers on 2017-10-25.
//  Copyright © 2017 Katherine Myers. All rights reserved.
//

import UIKit

class CreateLeagueViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var league_name: UITextField!
    @IBOutlet var team_name: UITextField!
    @IBOutlet var league_pass: UITextField!
    @IBOutlet var submit_button: UIButton!
    @IBOutlet weak var make_private: UISwitch!
    @IBOutlet var rules_button: UIButton!
    
    var maxTeams = "0"
    var maxC = "0"
    var maxLW = "0"
    var maxRW = "0"
    var maxD = "0"
    var maxG = "0"
    
    var create_league_url = "https://fantasysportsapp.000webhostapp.com/api/v1/createleague.php"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        rulesList = ["Goals"]
        
        league_name.keyboardAppearance = .dark
        league_name.keyboardType = .default
        league_name.placeholder = "League Name"
        
        team_name.keyboardAppearance = .dark
        team_name.keyboardType = .default
        team_name.placeholder = "Your Team Name"
        
        league_pass.keyboardAppearance = .dark
        league_pass.keyboardType = .default
        league_pass.placeholder = "League Password"
        league_pass.isSecureTextEntry = true
        
        league_name.delegate = self;
        team_name.delegate = self;
        league_pass.delegate = self;
        
        league_name.addDoneButtonToKeyboard(myAction:  #selector(self.league_name.resignFirstResponder))
        team_name.addDoneButtonToKeyboard(myAction:  #selector(self.league_name.resignFirstResponder))
        league_pass.addDoneButtonToKeyboard(myAction:  #selector(self.league_name.resignFirstResponder))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func switchButtonChanged (sender: UISwitch) {
        if sender.isOn {
            self.league_pass.placeholder = "League Password"
            self.league_pass.isUserInteractionEnabled = true
        } else {
            self.league_pass.placeholder = "Public League, No Pass"
            self.league_pass.text = ""
            self.league_pass.isUserInteractionEnabled = false
        }
        
    }
    
    @IBAction func addRulesButton(_ sender: AnyObject) {
        addRules()
    }
    
    func addRules(){
        
        let alert = UIAlertController(title: "Rules Options",
                                      message: "Add Rules",
                                      preferredStyle: .alert)
        
        let sumbit = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            // Get TextFields text
            let maxTeamsTxt = alert.textFields![0].text! as String
            let maxCTxt = alert.textFields![1].text! as String
            let maxLWTxt = alert.textFields![2].text! as String
            let maxRWTxt = alert.textFields![3].text! as String
            let maxDTxt = alert.textFields![4].text! as String
            let maxGTxt = alert.textFields![5].text! as String
            
            if !maxTeamsTxt.isEmpty && !maxCTxt.isEmpty && !maxLWTxt.isEmpty && !maxRWTxt.isEmpty && !maxDTxt.isEmpty && !maxGTxt.isEmpty
            {
                if self.checkInt(number_string:maxTeamsTxt) != 0 && self.checkInt(number_string:maxCTxt) != 0 && self.checkInt(number_string:maxLWTxt) != 0 && self.checkInt(number_string:maxRWTxt) != 0 && self.checkInt(number_string:maxDTxt) != 0 && self.checkInt(number_string:maxGTxt) != 0 {
                    
                    self.maxTeams = maxTeamsTxt
                    self.maxC = maxCTxt
                    self.maxLW = maxLWTxt
                    self.maxRW = maxRWTxt
                    self.maxD = maxDTxt
                    self.maxG = maxGTxt
                    
                    self.rules_button.setTitle("Change Rules",for: .normal)
                } else {
                    self.bad_data_notice(message:"Please only enter valid integers above 0")
                }
            } else {
                self.bad_data_notice(message:"Please ensure that you fill in all fields")
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
        })
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .decimalPad
            textField.placeholder = "Max # Teams in League"
            textField.text = (self.maxTeams=="0" ? "" : self.maxTeams)
            textField.delegate = self;
            textField.addDoneButtonToKeyboard(myAction:  #selector(textField.resignFirstResponder))
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .decimalPad
            textField.placeholder = "Max Centre Players"
            textField.text = (self.maxC=="0" ? "" : self.maxC)
            textField.delegate = self;
            textField.addDoneButtonToKeyboard(myAction:  #selector(textField.resignFirstResponder))
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .decimalPad
            textField.placeholder = "Max Left Wing Players"
            textField.text = (self.maxLW=="0" ? "" : self.maxLW)
            textField.delegate = self;
            textField.addDoneButtonToKeyboard(myAction:  #selector(textField.resignFirstResponder))
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .decimalPad
            textField.placeholder = "Max Right Wing Players"
            textField.text = (self.maxRW=="0" ? "" : self.maxRW)
            textField.delegate = self;
            textField.addDoneButtonToKeyboard(myAction:  #selector(textField.resignFirstResponder))
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .decimalPad
            textField.placeholder = "Max Defence Players"
            textField.text = (self.maxD=="0" ? "" : self.maxD)
            textField.delegate = self;
            textField.addDoneButtonToKeyboard(myAction:  #selector(textField.resignFirstResponder))
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .decimalPad
            textField.placeholder = "Max Goalie Players"
            textField.text = (self.maxG=="0" ? "" : self.maxG)
            textField.delegate = self;
            textField.addDoneButtonToKeyboard(myAction:  #selector(textField.resignFirstResponder))
        }
        
        alert.addAction(sumbit)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitLeague(_ sender: AnyObject) {
        submit_league_info(league_name:league_name.text!, league_pass: league_pass.text!, team_name: team_name.text!)
    }

    func submit_league_info(league_name:String, league_pass:String, team_name:String)
    {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 _-")
        
        print(league_name.isAlphanumeric)
        
        if league_name == "" {
            bad_data_notice(message:"Please enter a league name")
            return
        }
        if league_name.rangeOfCharacter(from: characterset.inverted) != nil {
            bad_data_notice(message:"Invalid league name, please only use alphanumeric characters")
            return
        }
        if team_name == "" {
            bad_data_notice(message:"Please enter a team name")
            return
        }
        if team_name.rangeOfCharacter(from: characterset.inverted) != nil {
            bad_data_notice(message:"Invalid team name, please only use alphanumeric characters")
            return
        }
        if league_pass == "" && self.make_private.isOn{
            bad_data_notice(message:"Empty password, please enter a password for a private league")
            return
        }
        if rulesList == [] {
            bad_data_notice(message:"Please enter rules for the league")
            return
        }
        if checkInt(number_string: self.maxTeams) < 2 || checkInt(number_string: self.maxTeams) > 30 {
            bad_data_notice(message:"Please enter a valid number of teams, between 2 and 30")
            return
        }
                
        create_league(league_name:league_name, league_pass: league_pass, team_name:team_name)
    }
    
    func create_league(league_name:String, league_pass:String, team_name:String)
    {
        let url = URL(string: create_league_url)!
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let statslist = rulesList.joined(separator: [","])
        print (statslist)
        
        // It couldn't do it in one go in a "reasonable" time
        let part1 = "participant_id=" + ParticipantVariables.participantId + "&leagueName=" + league_name
        let part2 = "&leaguePassword=" + league_pass + "&statsList=" + statslist
        let part3 = "&sportID=nhl"
        let part4 = "&teamName=" + team_name + "&maxTeam=" + self.maxTeams
        let part5 = "&maxC=" + self.maxC + "&maxLW=" + self.maxLW
        let part6 = "&maxRW=" + self.maxRW + "&maxD=" + self.maxD
        let part7 = "&maxG=" + self.maxG
        
        let postString = part1 + part2 + part3 + part4 + part5 + part6 + part7
        
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
                    print(json)
                    let responseError = json["error"] as! Bool
                    let message = json["message"] as! String
                    if responseError == true {
                        self.bad_data_notice(message: message)
                    } else {
                        self.success_notice(message: message)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func checkInt(number_string:String) -> Int
    {
        var result = Int()
        guard let int = Int(number_string) else {
            return 0
        }
        result = result + int
        if result < 0 {
            return 0
        }
        return result
    }
    
    func bad_data_notice(message:String)
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func success_notice(message:String)
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success", message: "Successfully added your league team, please return to the league menu to see more details", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
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

extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "^[a-zA-Z0-9_-]*$", options: .regularExpression) == nil
    }
}
