//
//  PreGameLobbyVC.swift
//  uno
//
//  Created by Clayton Herendeen on 1/8/16.
//  Copyright © 2016 Clayton Herendeen. All rights reserved.
//

import UIKit

class PreGameLobbyVC: UIViewController {

    @IBOutlet weak var preGameLobbyMsg: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        preGameLobbyMsg.text = UNOUtil.preGameLobbyMsg
        
        // start polling updates for this challenge
        
        // pregame-lobby-game
        if(UNOUtil.currUserIsChallenger){
            UNOUtil.getCurrChallengeInterval = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("getCurrChallenge:"), userInfo: "true", repeats: true)
            UNOUtil.checkPlayersInGameRoomInterval = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("checkPlayersInGameRoom"), userInfo: nil, repeats: true)
        }else{
            UNOUtil.getCurrChallengeInterval = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("getCurrChallenge:"), userInfo: "false", repeats: true)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if(!UNOUtil.inGameOrGameLobby){
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelChallengeTapped(sender: AnyObject) {
        UNOUtil.handleChallenge(0){
            (result: String) in
            if(result == "success"){
                print("Cancelled challenge")
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    print("back to lobby")
                })
            }
        }
    }
    
    func getCurrChallenge(timer: NSTimer){
        var isChallenger:String = timer.userInfo as! String
        var isChallengerNew = (isChallenger == "true") ? true : false
        UNOUtil.getChallenge(self, currUserIsChallenger: isChallengerNew)
    }
    
    func checkPlayersInGameRoom(){
        UNOUtil.checkPlayersInGameRoom(self)
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
