//
//  LikeViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/26.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class LikeViewController: UIViewController {

    @IBOutlet weak var likeCollectionView: UICollectionView!
    
    var fullScreenSize: CGSize!
    var ref: DatabaseReference!
    var locations = [Location]()
    let decoder = JSONDecoder()
    
    var articles = [Article]()

    override func viewDidLoad() {
        
        super.viewDidLoad()

        fullScreenSize = UIScreen.main.bounds.size
        
        ref = Database.database().reference()
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumLineSpacing = 7.5
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: CGFloat((fullScreenSize.width) - 20) / 2, height: CGFloat((fullScreenSize.width) - 20) / 2)
//        layout.itemSize = CGSize(width: CGFloat((fullScreenSize.width) / 2 - 2.5), height: CGFloat((fullScreenSize.width) / 2 - 2.5))
        
        likeCollectionView.collectionViewLayout = layout
        
        let nib = UINib(nibName: "LikeCollectionViewCell", bundle: nil)
        likeCollectionView.register(nib, forCellWithReuseIdentifier: "LikeCell")

        likeCollectionView.delegate = self
        likeCollectionView.dataSource = self

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white

        self.readData()
    }

    
    func readData() {
        
        ref.child("locations").observe(.childAdded) { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else { return }
            
            guard let locationJSONData = try? JSONSerialization.data(withJSONObject: value) else { return }
            
            do {
                
                let locationData = try self.decoder.decode(Location.self, from: locationJSONData)
                self.locations.append(locationData)
                
            } catch {
                
                print(error)
                
            }
            
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
        
        let url = URL(string: location.image)
        cell.articleImage.kf.setImage(with: url)
        cell.areaLabel.text = location.name
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let select: Location = locations[indexPath.row]
        let location = select.name
        
        let detailViewController = LikeDetailViewController.likeDetailViewControllerForLike(location)
        
        navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
}
