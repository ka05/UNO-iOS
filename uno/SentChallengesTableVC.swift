//
//  SentChallengesTableVC.swift
//  uno
//
//  Created by Clayton Herendeen on 1/7/16.
//  Copyright © 2016 Clayton Herendeen. All rights reserved.
//
import UIKit
import Foundation

class SentChallengesTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var sentChallengesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sentChallengesTableView.delegate = self
        sentChallengesTableView.dataSource = self
        let nib = UINib(nibName: "challengeTableCell", bundle: nil)
        sentChallengesTableView.registerNib(nib, forCellReuseIdentifier: "sent-challenges-cell")
        
        UNOUtil.getSentChallengesInterval = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("getChallenges"), userInfo: nil, repeats: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UNOUtil.sentChallenges.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ChallengeTableCell = self.sentChallengesTableView.dequeueReusableCellWithIdentifier("sent-challenges-cell") as! ChallengeTableCell
        let currChallenge = UNOUtil.sentChallenges[indexPath.row]
        cell.challengeText!.setTitle(currChallenge.displayText, forState: UIControlState.Normal)
        cell.challengeId = currChallenge.id
        cell.startGameButton.hidden = true
        
        cell.challengeText.tag = indexPath.row
        cell.challengeText.addTarget(self, action: "challengeTapped:", forControlEvents: .TouchUpInside)
        
        cell.statusIndicator.backgroundColor = UNOUtil.getStatusIndicatorColor(currChallenge.status)
        
        if(currChallenge.status == "all responded"){
            cell.startGameButton.hidden = false
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = UNOUtil.sentChallenges[indexPath.row]
        UNOUtil.currChallengeId = selectedItem.id
        print("UNOUtil.currChallengeId \(UNOUtil.currChallengeId = selectedItem.id)")
        
        if( (selectedItem.status == "cancelled") || (selectedItem.status == "declined") ){
            UNOUtil.showAlert("Challenge to " + selectedItem.usersChallenged.joinWithSeparator(", "), msg: "This challenge is " + selectedItem.status + "You cannot cancel it.", vc: self)
        }else{
            // if status is accepted / ready then go start game
            if(selectedItem.status == "all responded"){
                
            }
            
            UNOUtil.showChallengeResponseAlert("Challenge to: " + selectedItem.usersChallenged.joinWithSeparator(", "), msg: "Cancel this challenge?", sentChallenge: true);
            
        }
    }
    
    func challengeTapped(sender:UIButton!){
        let selectedItem = UNOUtil.sentChallenges[sender.tag]
        UNOUtil.currChallengeId = selectedItem.id
        print("UNOUtil.currChallengeId \(UNOUtil.currChallengeId = selectedItem.id)")
        
        if( (selectedItem.status == "cancelled") || (selectedItem.status == "declined") ){
            UNOUtil.showAlert("Challenge to " + selectedItem.usersChallenged.joinWithSeparator(", "), msg: "This challenge is " + selectedItem.status + "You cannot cancel it.", vc: self)
        }else{
            // if status is accepted / ready then go start game
            if(selectedItem.status == "all responded"){
                
            }
            
            UNOUtil.showChallengeResponseAlert("Challenge to: " + selectedItem.usersChallenged.joinWithSeparator(", "), msg: "Cancel this challenge?", sentChallenge: true);
            
        }
    }
    
    func getChallenges(){
        if(UNOUtil.loggedIn){
            UNOUtil.getSentChallenges()
            sentChallengesTableView.reloadData()
        }
        
    }
    
}
