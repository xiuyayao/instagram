//
//  LoginViewController.swift
//  Instagram
//
//  Created by Xiuya Yao on 6/27/17.
//  Copyright © 2017 Xiuya Yao. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    let loginAlertController = UIAlertController(title: "Invalid Input", message: "Please valid username AND password", preferredStyle: .alert)
    
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    
    @IBAction func loginUser(_ sender: UIButton) {
        if usernameLabel.text!.isEmpty || passwordLabel.text!.isEmpty {
            self.present(self.loginAlertController, animated: true)
        }
        
        let username = usernameLabel.text ?? ""
        let password = passwordLabel.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
            } else {
                print("User logged in successfully")
                // display view controller that needs to shown after successful login
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        loginAlertController.addAction(OKAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

