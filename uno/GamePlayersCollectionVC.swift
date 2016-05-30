//
//  GamePlayersCollectionVC.swift
//  uno
//
//  Created by Clayton Herendeen on 1/9/16.
//  Copyright © 2016 Clayton Herendeen. All rights reserved.
//

import UIKit

class GamePlayersCollectionVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var gamePlayersCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamePlayersCV.dataSource = self
        gamePlayersCV.delegate = self
        
        gamePlayersCV.registerNib(UINib(nibName: "playerCollectionCell", bundle: nil), forCellWithReuseIdentifier: "playerCollectionCell")
        
        var flow:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flow.scrollDirection = UICollectionViewScrollDirection.Horizontal;
        
        gamePlayersCV.reloadData()
        gamePlayersCV.collectionViewLayout = flow
        gamePlayersCV.backgroundColor = UIColor.clearColor()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UNOUtil.currGame.players.count
    }
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:PlayerCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("playerCollectionCell", forIndexPath: indexPath) as! PlayerCollectionCell
        
        if(UNOUtil.currGame.players.count > 0){
            var player:Player = UNOUtil.currGame.players[indexPath.row]
            
            cell.saidUnoLabel.hidden = true
            cell.cardCountLabel.text = player.cardCount
            cell.usernameLabel.text = player.username
            
            if(player.calledUno){
                cell.saidUnoLabel.hidden = false
            }
            
            if(player.isMyTurn){
                cell.usernameLabel.backgroundColor = UIColorFromHex(0x1baf2a,alpha: 1.0)
            }else{
                cell.usernameLabel.backgroundColor = UIColor.blackColor()
            }
            
        }
        
        
        // Configure the cell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(90, 90)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: -5, left: 2, bottom: -5, right: 2)
    }
    
}

