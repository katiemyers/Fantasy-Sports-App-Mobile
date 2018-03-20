//
//  HomeViewController.swift
//  login_test
//
//  Created by Katherine Myers on 2017-10-19.
//  Copyright © 2017 Katherine Myers. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var NBA_button: UIButton!
    @IBOutlet var NHL_button: UIButton!
    @IBOutlet var MLB_button: UIButton!
    @IBOutlet var NFL_button: UIButton!

    let login_url = "https://fantasysportsapp.000webhostapp.com/api/v1/loginuser.php"
    let register_url = "https://fantasysportsapp.000webhostapp.com/api/v1/createuser.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login_user()
        
        print(ParticipantVariables.participantId)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setNBA(_ sender: AnyObject) {
        ParticipantVariables.leagueType = "NBA"
    }
    
    @IBAction func setNHL(_ sender: AnyObject) {
        ParticipantVariables.leagueType = "NHL"
    }
    
    @IBAction func setMLB(_ sender: AnyObject) {
        ParticipantVariables.leagueType = "MLB"
    }
    
    @IBAction func setNFL(_ sender: AnyObject) {
        ParticipantVariables.leagueType = "NFL"
    }
    
    @IBAction func logout(_ sender: AnyObject) {
        ParticipantVariables.participantId = ""
        ParticipantVariables.leagueType = ""
        ParticipantVariables.currentLeague = ""
        ParticipantVariables.currentPlayer = ""
        user_cookie = false
        
        self.login_user()
    }
    
    func printText(username:String, password:String) {
        print(username)
        print(password)
    }
    
    func login_user(){
        if user_cookie == true {
            return
        }
        
        let alert = UIAlertController(title: "Please login",
                                      message: "Insert username and password",
                                      preferredStyle: .alert)
        
        let loginAction = UIAlertAction(title: "Login", style: .default, handler: { (action) -> Void in
            // Get TextFields text
            let usernameTxt = alert.textFields![0].text! as String
            let passwordTxt = alert.textFields![1].text! as String
            
            if !usernameTxt.isEmpty && !passwordTxt.isEmpty
            {
                self.login_now(username: usernameTxt, password: passwordTxt)
            } else {
                self.failed_login()
            }
        })
        
        let signupAction = UIAlertAction(title: "Signup", style: .default, handler: { (action) -> Void in
            self.registerUser()
        })
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Type your username"
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.placeholder = "Type your password"
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(loginAction)
        alert.addAction(signupAction)
        present(alert, animated: true, completion: nil)
    }
    
    func registerUser(){
        let alert = UIAlertController(title: "Please register",
                                      message: "Insert username and password",
                                      preferredStyle: .alert)
        
        let loginAction = UIAlertAction(title: "Signup", style: .default, handler: { (action) -> Void in
            // Get TextFields text
            let usernameTxt = alert.textFields![0].text! as String
            let passwordTxt = alert.textFields![1].text! as String
            let passwordTxt2 = alert.textFields![2].text! as String
            
            if !usernameTxt.isEmpty && !passwordTxt.isEmpty && !passwordTxt2.isEmpty
            {
                if passwordTxt != passwordTxt2 {
                    self.failed_register()
                }
                else
                {
                    self.try_register(username: usernameTxt, password: passwordTxt)
                }
            } else {
                self.failed_register()
            }
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
            self.login_user()
        })
        
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Type your username"
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.placeholder = "Type your password"
            textField.isSecureTextEntry = true
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.placeholder = "Type your password again"
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(loginAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func login_now(username:String, password:String)
    {
        let url = URL(string: login_url)!
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "username=" + username + "&password=" + password
        
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
                        self.failed_login()
                    } else {
                        ParticipantVariables.participantId = json["participant_id"] as! String
                        self.successful_login()
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func successful_login()
    {
        print("Good Login")
    }
    
    func failed_login()
    {
        print("Bad Login")
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Login Error", message: "Incorrect username or password", preferredStyle: UIAlertControllerStyle.alert)
            let retry = UIAlertAction(title: "Retry", style: .destructive, handler: { (action) -> Void in
                self.login_user()
            })
            alert.addAction(retry)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func failed_register()
    {
        print("Bad Register")
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Register Error", message: "Incorrect username or non-matching passwords", preferredStyle: UIAlertControllerStyle.alert)
            let retry = UIAlertAction(title: "Retry", style: .destructive, handler: { (action) -> Void in
                self.registerUser()
            })
            alert.addAction(retry)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func try_register(username:String, password:String)
    {
        let url = URL(string: register_url)!
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "username=" + username + "&password=" + password
        
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
                        self.failed_register()
                    } else {
                        self.successful_register()
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func successful_register()
    {
        print("Good Register")
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Successful Register", message: "Please login to your new account now", preferredStyle: UIAlertControllerStyle.alert)
            let login = UIAlertAction(title: "Login", style: .default, handler: { (action) -> Void in
                self.login_user()
            })
            alert.addAction(login)
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
