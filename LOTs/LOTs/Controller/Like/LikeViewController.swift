//
//  LikeViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/26.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Kingfisher
import KeychainSwift

class LikeViewController: UIViewController {

    @IBOutlet weak var likeCollectionView: UICollectionView!
    @IBOutlet weak var loginView: UIView!
    
    var fullScreenSize: CGSize!
    var locations = [Location]()
    let manager = FirebaseManager()
    let articleManager: LikeManagerProtocol = ArticleManager()
    
    var articles = [Article]()
    let keychain = KeychainSwift()
    var uid: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        fullScreenSize = UIScreen.main.bounds.size
        
        let nib = UINib(nibName: "LikeCollectionViewCell", bundle: nil)
        likeCollectionView.register(nib, forCellWithReuseIdentifier: "LikeCell")

        likeCollectionView.delegate = self
        likeCollectionView.dataSource = self

        uid = self.keychain.get("uid")

        if uid == nil {
            
            loginView.isHidden = false
            
        } else {
            
            loginView.isHidden = true
            
        }
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white

        layoutSetUp()
        readData()
    }

    func layoutSetUp() {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumLineSpacing = 7.5
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: CGFloat((fullScreenSize.width) - 20) / 2, height: CGFloat((fullScreenSize.width) - 20) / 2)
        
        likeCollectionView.collectionViewLayout = layout

        
    }
    
    func readData() {
        
        articleManager.readLocation { (locationData) in
            
            self.locations.append(locationData)
            self.likeCollectionView.reloadData()
            
        }
        
    }
    
}

extension LikeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return locations.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeCell", for: indexPath) as? LikeCollectionViewCell else {
            
            return UICollectionViewCell()
            
        }

        let location = locations[indexPath.row]
        
        cell.updateCellInfo(area: location.name, image: location.image)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let select: Location = locations[indexPath.row]
        let location = select.name
        
        let detailViewController = LikeDetailViewController.likeDetailViewControllerFromLocation(location)
        
        navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
}
