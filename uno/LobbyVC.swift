//
//  ViewController.swift
//  uno-new
//
//  Created by Clayton Herendeen on 12/19/15.
//  Copyright © 2015 Clayton Herendeen. All rights reserved.
//

import UIKit
import Foundation
import Socket_IO_Client_Swift
import SwiftyJSON
import CoreData

class LobbyVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var chatMsgTextField: UITextField!
    @IBOutlet weak var chatMsgsTableView: UITableView!
    @IBOutlet var parentView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        UNOUtil.clearUserDefaults()
        
        UNOUtil.initSocketHandler()
        self.chatMsgsTableView.rowHeight = 25
        self.initChatTableView()
        
        UNOUtil.lobbyVC = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() 
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if(!UNOUtil.checkLoggedIn(self)){
            self.performSegueWithIdentifier("goto-login", sender: self);
        }
    }
    
    @IBAction func screenTappedDismissKeyboard(sender: AnyObject) {
        parentView.endEditing(true)
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UNOUtil.chatMsgArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ChatMsgTableCell = self.chatMsgsTableView.dequeueReusableCellWithIdentifier("cell") as! ChatMsgTableCell
        let chatName:String = UNOUtil.chatMsgArray[indexPath.row].sender
        let chatMsg:String = UNOUtil.chatMsgArray[indexPath.row].message
        let chatTimestamp:String = UNOUtil.chatMsgArray[indexPath.row].timestamp
        
        if(chatName == CurrUser.sharedInstance.username){
            cell.name.textColor = UIColor.orangeColor()
        }
        
        cell.name.text = chatName + ":"
        cell.message.text = chatMsg
        cell.timestamp.text = chatTimestamp
        
        return cell
    }
    
    
    @IBAction func sendMsgTapped(sender: AnyObject) {
        UNOUtil.sendChat(chatMsgTextField.text!, vc:self)
        chatMsgTextField.text = ""
        parentView.endEditing(true)
    }
    @IBAction func sendChallengeTapped(sender: AnyObject) {
        
    }
    
    func initChatTableView(){
        chatMsgsTableView.delegate = self
        chatMsgsTableView.dataSource = self
        chatMsgsTableView.separatorColor = UIColor.clearColor()
        
        // Register custom cell
        let nib = UINib(nibName: "chatMsgTableCell", bundle: nil)
        chatMsgsTableView.registerNib(nib, forCellReuseIdentifier: "cell")
        
        UNOUtil.getChatInterval = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("getChat"), userInfo: nil, repeats: true)
    }
    
    func getChat(){
        if(UNOUtil.loggedIn){
            UNOUtil.getChat("1")
            self.chatMsgsTableView.reloadData()
        }
    }

}

