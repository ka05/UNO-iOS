//
//  GamePlayerHandCollectionVC.swift
//  uno
//
//  Created by Clayton Herendeen on 1/9/16.
//  Copyright © 2016 Clayton Herendeen. All rights reserved.
//

import UIKit

class GamePlayerHandCollectionVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var gamePlayerHandCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamePlayerHandCV.dataSource = self
        gamePlayerHandCV.delegate = self
        
        gamePlayerHandCV.registerNib(UINib(nibName: "cardCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cardCollectionCell")
        
        var flow:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flow.scrollDirection = UICollectionViewScrollDirection.Horizontal;

        gamePlayerHandCV.reloadData()
        gamePlayerHandCV.collectionViewLayout = flow
        gamePlayerHandCV.backgroundColor = UIColor.clearColor()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UNOUtil.currGame.currPlayer.hand.count
    }
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CardCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCollectionCell", forIndexPath: indexPath) as! CardCollectionCell
        
        if(UNOUtil.currGame.currPlayer.hand.count > 0){
            if let card:Card = UNOUtil.currGame.currPlayer.hand[indexPath.row] as! Card{
                cell.cardImage.image = UIImage(named:card.svgName)
                cell.card = card
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(75, 112)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
}
