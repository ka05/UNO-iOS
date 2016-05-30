//
//  LoginVC.swift
//  uno-new
//
//  Created by Clayton Herendeen on 12/19/15.
//  Copyright © 2015 Clayton Herendeen. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift
import SwiftyJSON
import CoreData

class LoginVC: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var parentView: UIView!
    
    @IBAction func screenTappedDismissKeyboard(sender: AnyObject) {
        parentView.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

    }
    
    override func viewDidAppear(animated: Bool) {
        if(UNOUtil.loggedIn){
            self.dismissViewControllerAnimated(true, completion: nil) // go back to LobbyVC
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginTapped(sender: AnyObject) {
        // ensure fields are filled in
        if(usernameTextField.text != "" && passwordTextField.text != ""){
            //        let credentials: [String: String] = ["username":"nate", "password":"qwerty"]
            var credentials: [String: String] = ["username":"", "password":""]
            credentials.updateValue(usernameTextField.text!, forKey: "username")
            credentials.updateValue(passwordTextField.text!, forKey: "password")
            
            UNOUtil.attemptLogin(credentials, vc: self)
        }else{
            UNOUtil.showAlert("Login", msg:"Please fill in all fields!", vc: self)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
