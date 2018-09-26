//
//  LikeViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/26.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

class LikeViewController: UIViewController {

    @IBOutlet weak var likeCollectionView: UICollectionView!
    
    var fullScreenSize: CGSize!
    
    var articleImage = [UIImage]()
    var areaLabel = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        fullScreenSize = UIScreen.main.bounds.size
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: CGFloat((fullScreenSize.width) - 16) / 2, height: CGFloat((fullScreenSize.width) - 16) / 2)
//        layout.itemSize = CGSize(width: CGFloat((fullScreenSize.width) / 2 - 2.5), height: CGFloat((fullScreenSize.width) / 2 - 2.5))
        
        likeCollectionView.collectionViewLayout = layout
        
        articleImage = [UIImage(named: "01"), UIImage(named: "02"),
                        UIImage(named: "03"), UIImage(named: "04"),
                        UIImage(named: "05"), UIImage(named: "06"),
                        UIImage(named: "07"), UIImage(named: "08"),
                        UIImage(named: "09"), UIImage(named: "10")] as! [UIImage]
        
        areaLabel = ["中正區", "大同區", "中山區", "松山區", "大安區", "萬華區",
                     "信義區", "士林區", "北投區", "內湖區", "南港區", "文山區"]
        
        let nib = UINib(nibName: "LikeCollectionViewCell", bundle: nil)
        likeCollectionView.register(nib, forCellWithReuseIdentifier: "LikeCell")

        likeCollectionView.delegate = self
        likeCollectionView.dataSource = self

    }

}

extension LikeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeCell", for: indexPath) as? LikeCollectionViewCell else {
            
            return UICollectionViewCell()
            
        }
        
        cell.articleImage?.contentMode = .scaleAspectFill
        cell.articleImage.image = articleImage[indexPath.item]
        cell.areaLabel.text = areaLabel[indexPath.item]
        
        return cell
        
    }
    
}