//
//  SendChallengeModalVC.swift
//  uno
//
//  Created by Clayton Herendeen on 12/29/15.
//  Copyright © 2015 Clayton Herendeen. All rights reserved.
//

import UIKit

class SendChallengeModalVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var onlineUsersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        onlineUsersTableView.delegate = self
        onlineUsersTableView.dataSource = self
        
        let nib = UINib(nibName: "onlineUserTableCell", bundle: nil)
        onlineUsersTableView.registerNib(nib, forCellReuseIdentifier: "onlinePlayerCell")
        
        // start interval for fetching users
        UNOUtil.getOnlineUsersInterval = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("getOnlineUsers"), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UNOUtil.activeUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:OnlineUserTableCell = self.onlineUsersTableView.dequeueReusableCellWithIdentifier("onlinePlayerCell") as! OnlineUserTableCell
        
        let username:String = (UNOUtil.activeUsers[indexPath.row]["username"].stringValue as AnyObject? as? String)!
        let inGame:String = (UNOUtil.activeUsers[indexPath.row]["inAGame"].stringValue as AnyObject? as? String)!
        let uid:String = (UNOUtil.activeUsers[indexPath.row]["id"].stringValue as AnyObject? as? String)!
        
        cell.inGameIndicator.hidden = true
        
        // if they are in a game ...
        if(inGame == "true"){
            cell.inGameIndicator.hidden = false
        }
        
        cell.username.text = username
        cell.uid = uid
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:OnlineUserTableCell = self.onlineUsersTableView.cellForRowAtIndexPath(indexPath) as! OnlineUserTableCell
        
        // if inGameIndicator is showing then they are in game
        // if they are in a game they cant add them
        if(!cell.inGameIndicator.hidden){
            // show alert
            UNOUtil.showAlert("Cant challenge " + cell.username.text!, msg: cell.username.text! + " is in a game at the moment. You cannot challenge them until they are done.", vc: self)
        }else{
            if(cell.accessoryType != UITableViewCellAccessoryType.Checkmark){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                // save this uid in list of usernames sent to the server
                if(!UNOUtil.usersToChallenge.contains(cell.uid)){
                    UNOUtil.usersToChallenge.append(cell.uid)
                }
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.None
                // check if its in the list of usernames and remove it
                if(UNOUtil.usersToChallenge.contains(cell.uid)){
                    UNOUtil.usersToChallenge.removeAtIndex(UNOUtil.usersToChallenge.indexOf(cell.uid)!)
                }
            }
        }
    }
    
    @IBAction func cancelChallenge(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil) // go back to LobbyVC
    }
    
    @IBAction func sendChallengeTapped(sender: AnyObject) {
        var usernames:[String] = []
        
        // if usersToChallenge Array has at least one value then send the challenge
        if(!UNOUtil.usersToChallenge.isEmpty){
            UNOUtil.sendChallenge()
            self.dismissViewControllerAnimated(true, completion: nil) // go back to LobbyVC
        }else{
            UNOUtil.showAlert("Send Challenge", msg: "You must select at least one person to challenge", vc: self)
        }
    }
    
    func getOnlineUsers(){
        UNOUtil.getOnlineUsers()
        self.onlineUsersTableView.reloadData()
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
