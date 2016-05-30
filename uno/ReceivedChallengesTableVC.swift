//
//  ReceivedChallengesTableVC.swift
//  uno
//
//  Created by Clayton Herendeen on 1/7/16.
//  Copyright © 2016 Clayton Herendeen. All rights reserved.
//
import UIKit
import Foundation

class ReceivedChallengesTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var receivedChallengesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        receivedChallengesTableView.delegate = self
        receivedChallengesTableView.dataSource = self
        let nib = UINib(nibName: "challengeTableCell", bundle: nil)
        receivedChallengesTableView.registerNib(nib, forCellReuseIdentifier: "received-challenges-cell")
        
        UNOUtil.getReceivedChallengesInterval = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("getChallenges"), userInfo: nil, repeats: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UNOUtil.receivedChallenges.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:ChallengeTableCell = self.receivedChallengesTableView.dequeueReusableCellWithIdentifier("received-challenges-cell")! as! ChallengeTableCell
        if(UNOUtil.receivedChallenges.count > 0){
            if let currChallenge:Challenge = UNOUtil.receivedChallenges[indexPath.row]{
                cell.challengeText!.setTitle(currChallenge.displayText, forState: UIControlState.Normal)
                cell.challengeId = currChallenge.id
                cell.startGameButton.hidden = true
                cell.challengeText.tag = indexPath.row
                cell.challengeText.addTarget(self, action: "challengeTapped:", forControlEvents: .TouchUpInside)
                
                cell.statusIndicator.backgroundColor = UNOUtil.getStatusIndicatorColor(currChallenge.status)
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = UNOUtil.receivedChallenges[indexPath.row]
        UNOUtil.currChallengeId = selectedItem.id
        print("selectedItem.status \(selectedItem.status)")
        if( (selectedItem.status == "cancelled") || (selectedItem.status == "declined") ){
            UNOUtil.showAlert("Challenge to " + selectedItem.usersChallenged.joinWithSeparator(", "), msg: "You cannot cancel this challenge because it has already been cancelled or declined by all recipients", vc: self)
        }else{
            if( (selectedItem.status == "ready") || (selectedItem.status == "accepted") ) {
                // allow them to cancel their challenge
                UNOUtil.showChallengeResponseAlert("Challenge to: " + selectedItem.usersChallenged.joinWithSeparator(", "), msg: "Cancel this challenge?", sentChallenge: true);
                
            }else if(selectedItem.status == "pending"){
                UNOUtil.showChallengeResponseAlert("Challenge from" + selectedItem.challenger, msg: "Accept or Decline this challenge", sentChallenge: false);
            }
        }
    }
    
    func challengeTapped(sender: UIButton!){
        let selectedItem = UNOUtil.receivedChallenges[sender.tag]
        UNOUtil.currChallengeId = selectedItem.id
        print("selectedItem.status \(selectedItem.status)")
        if( (selectedItem.status == "cancelled") || (selectedItem.status == "declined") ){
            UNOUtil.showAlert("Challenge to " + selectedItem.usersChallenged.joinWithSeparator(", "), msg: "You cannot cancel this challenge because it has already been cancelled or declined by all recipients", vc: self)
        }else{
            if( (selectedItem.status == "ready") || (selectedItem.status == "accepted") ) {
                // allow them to cancel their challenge
                UNOUtil.showChallengeResponseAlert("Challenge to: " + selectedItem.usersChallenged.joinWithSeparator(", "), msg: "Cancel this challenge?", sentChallenge: true);
                
            }else if(selectedItem.status == "pending"){
                UNOUtil.showChallengeResponseAlert("Challenge from" + selectedItem.challenger, msg: "Accept or Decline this challenge", sentChallenge: false);
            }
        }
    }
    
    func getChallenges(){
        if(UNOUtil.loggedIn){
            UNOUtil.getReceivedChallenges()
            self.receivedChallengesTableView.reloadData()
        }
        
    }
}
