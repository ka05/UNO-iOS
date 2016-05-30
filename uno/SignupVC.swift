//
//  SignupVC.swift
//  uno-new
//
//  Created by Clayton Herendeen on 12/19/15.
//  Copyright © 2015 Clayton Herendeen. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift
import SwiftyJSON

class SignupVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet var parentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func screenTappedDismissKeyboard(sender: AnyObject) {
        parentView.endEditing(true)
    }
    
    
    @IBAction func signupTapped(sender: AnyObject) {
        
        // validate empty fields
        if(self.validateSignup()){
            // make server call to add user
            var userData: [String: String] = ["email":"", "username":"", "password":""]
            userData.updateValue(emailTextField.text!, forKey: "email")
            userData.updateValue(usernameTextField.text!, forKey: "username")
            userData.updateValue(passwordTextField.text!, forKey: "password")
            
            // check logged in
            UNOUtil.socket.emitWithAck("addUser", userData)(timeoutAfter: 0) {data in
                var res = JSON(data[0])
                let msg:JSON = res["msg"]
                print("TEST")
                if(msg == "success"){
                    // valid login
                    var credentials: [String: String] = ["username":"", "password":""]
                    credentials.updateValue(self.usernameTextField.text!, forKey: "username")
                    credentials.updateValue(self.passwordTextField.text!, forKey: "password")
                    
                    UNOUtil.attemptLogin(credentials, vc: self)
                    self.dismissViewControllerAnimated(true, completion: nil) // go back to LobbyVC
                }else{
                    // invalid login
                    UNOUtil.showAlert("Sign Up", msg:"Invalid data", vc: self)
                }
            }
        }else{
            // left some fields empty
            UNOUtil.showAlert("Sign Up", msg:"Please fill in all fields", vc: self)
        }
        
    }

    @IBAction func backToLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func validateSignup() -> Bool{
        return (emailTextField.text != "" &&
            usernameTextField.text != "" &&
            passwordTextField.text != "" &&
            confirmPasswordTextField.text != "" &&
            (passwordTextField.text == confirmPasswordTextField.text) ) ? true : false
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
