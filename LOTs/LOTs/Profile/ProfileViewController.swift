//
//  ProfileViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/26.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fullScreenSize: CGSize!
    var articleImage = [UIImage]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        fullScreenSize = UIScreen.main.bounds.size
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 7.5, left: 5, bottom: 7.5, right: 5)
        layout.minimumLineSpacing = 7.5
        layout.minimumInteritemSpacing = 7.5

//        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: CGFloat(fullScreenSize.width) / 3 - 10, height: CGFloat(fullScreenSize.width) / 3 - 10)
        
        collectionView.collectionViewLayout = layout
        
        articleImage = [UIImage(named: "01"), UIImage(named: "02"),
                        UIImage(named: "03"), UIImage(named: "04"),
                        UIImage(named: "05"), UIImage(named: "06"),
                        UIImage(named: "07"), UIImage(named: "08"),
                        UIImage(named: "09"), UIImage(named: "10"),
                        UIImage(named: "01"), UIImage(named: "02"),
                        UIImage(named: "03"), UIImage(named: "04"),
                        UIImage(named: "05"), UIImage(named: "06"),
                        UIImage(named: "07"), UIImage(named: "08")] as! [UIImage]
        
        let nib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProfileACell")
        
        let nib2 = UINib(nibName: "ProfileCollectionViewCell", bundle: nil)
        collectionView.register(nib2, forCellWithReuseIdentifier: "ProfileBCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self

        
    }
    
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileACell", for: indexPath) as? ProfileTableViewCell else {
            
            return UITableViewCell()
            
        }
        
        cell.authorLabel.text = "Nia"
        
        return cell
        
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 140

//        return UITableView.automaticDimension
        
    }
    
}

extension ProfileViewController: UICollectionViewDelegate {
    
    
}

extension ProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 18
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileBCell", for: indexPath) as? ProfileCollectionViewCell else {
            
            return UICollectionViewCell()
            
        }
        
        cell.articleImage.image = articleImage[indexPath.item]
        
        return cell
        
    }
    
    
    
}
