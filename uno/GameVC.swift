//
//  GameVC.swift
//  uno
//
//  Created by Clayton Herendeen on 1/8/16.
//  Copyright © 2016 Clayton Herendeen. All rights reserved.
//

import UIKit

class GameVC: UIViewController {

    @IBOutlet weak var currGameCard: UIImageView!
    @IBOutlet weak var prevGameCard: UIImageView!
    @IBOutlet weak var deck: UIImageView!
    
    @IBOutlet weak var playerNameLabel: UILabel!
    
    var playerHandCV:GamePlayerHandCollectionVC?
    var playersCV:GamePlayersCollectionVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("deckTapped:"))
        deck.userInteractionEnabled = true
        deck.addGestureRecognizer(tapGestureRecognizer)
        
        UNOUtil.gameVC = self
        playerHandCV = self.childViewControllers[0] as! GamePlayerHandCollectionVC
        playersCV = self.childViewControllers[1] as! GamePlayersCollectionVC
        
        setUpIntervals()
        refreshView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpIntervals(){
        if(UNOUtil.inGameOrGameLobby){
            UNOUtil.getCurrGameInterval = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("getCurrGame"), userInfo: nil, repeats: true)
            UNOUtil.getCurrGameChatInterval = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("getCurrGameChat"), userInfo: nil, repeats: true)
        }
    }
    
    func getCurrGame(){
        UNOUtil.getCurrGame()
    }
    func getCurrGameChat(){
        UNOUtil.getCurrGameChat()
    }
    
    func refreshView(){
        playersCV!.gamePlayersCV.reloadData()
        playerHandCV!.gamePlayerHandCV.reloadData()
        
        var discardPile = UNOUtil.currGame.discardPile
        if(discardPile.count > 0){
            currGameCard.image = UIImage(named:discardPile[discardPile.count - 1].svgName)
            
            if(discardPile.count > 1){
                // we have at least two cards
                prevGameCard.image = UIImage(named:discardPile[discardPile.count - 2].svgName)
            }
        }
        
        if(UNOUtil.currGame.currPlayer.hand.count == 1){
            UNOUtil.canSayUno = true
        }else{
            UNOUtil.canSayUno = false
        }
        
        playerNameLabel.text = UNOUtil.currGame.currPlayer.username
        playerNameLabel.textColor = UIColor.whiteColor()
        
        if(UNOUtil.currGame.currPlayer.isMyTurn){
            playerNameLabel.backgroundColor = UIColorFromHex(0x1baf2a,alpha: 1.0)
        }else{
            playerNameLabel.backgroundColor = UIColor.blackColor()
        }
    }
    
    
    func deckTapped(img: AnyObject){
        // draw card - check if its okay to do so first
        UNOUtil.drawCard()
    }
    
    @IBAction func showChatTapped(sender: AnyObject) {
        // display chat window
        print("open in game chat tapped")
    }
    
    @IBAction func sayUnoTapped(sender: AnyObject) {
        UNOUtil.sayUno()
    }
    
    @IBAction func challengeUnoTapped(sender: AnyObject) {
        UNOUtil.challengeUno()
    }
    
    @IBAction func quitGameTapped(sender: AnyObject) {
        UNOUtil.showExitGameModal(self)
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