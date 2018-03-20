//
//  RulesViewController.swift
//  login_test
//
//  Created by Katherine Myers on 2017-11-09.
//  Copyright © 2017 Katherine Myers. All rights reserved.
//

import UIKit

class RulesViewController: UIViewController {

    @IBOutlet weak var maxTeam: UILabel!
    @IBOutlet weak var maxGoalie: UILabel!
    @IBOutlet weak var maxDefend: UILabel!
    @IBOutlet weak var maxRightWing: UILabel!
    @IBOutlet weak var maxLeftWing: UILabel!
    @IBOutlet weak var maxCentre: UILabel!
    @IBOutlet weak var includedStats: UILabel!
    let get_rules_url = "https://fantasysportsapp.000webhostapp.com/api/v1/getleaguerules.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        includedStats.lineBreakMode = .byWordWrapping
        includedStats.numberOfLines = 0
        
        getRules()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRules() {
        let url = URL(string: get_rules_url)!
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "leagueName=" + ParticipantVariables.currentLeague
        
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
                        let message = json["message"] as! String
                        let rules_array = message.components(separatedBy: "~~~")
                        let stats_array = rules_array[7].components(separatedBy: ",")
                        var stat_display = ""
                        for stat in stats_array {
                            stat_display = stat_display + stat + "\n"
                        }
                        DispatchQueue.main.async {
                            self.maxTeam.text = rules_array[1]
                            self.maxCentre.text = rules_array[2]
                            self.maxLeftWing.text = rules_array[3]
                            self.maxRightWing.text = rules_array[4]
                            self.maxDefend.text = rules_array[5]
                            self.maxGoalie.text = rules_array[6]
                            self.includedStats.text = stat_display
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
        print("Bad Rules")
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Rules Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
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
