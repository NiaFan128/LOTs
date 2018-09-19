//
//  MainViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/19.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mainCollectionView: UICollectionView!

    var foods = Food.allFood()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.backgroundImage = UIImage()
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        // Set the PinterestLayout delegate
        if let layout = mainCollectionView?.collectionViewLayout as? Layout {
            layout.delegate = self
        }
        
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return foods.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainFoodCell", for: indexPath as IndexPath) as! MainFoodCell
        
        cell.food = foods[indexPath.item]
//        cell.backgroundColor = color[indexPath.item]
        
        return cell
        
    }
    
}

extension MainViewController: LayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return foods[indexPath.item].image.size.height
        
    }
    
    func collectionView(_ collectionView: UICollectionView, widthForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return foods[indexPath.item].image.size.width
        
    }

    
}

//extension MainViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
//
//        return CGSize(width: itemSize, height: itemSize)
//
//    }
//
//}
