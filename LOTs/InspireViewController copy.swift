//
//  SuggestViewController.swift
//  
//
//  Created by 乃方 on 2018/9/27.
//

import UIKit
import Firebase
import Kingfisher

class InspireViewController: UIViewController {

    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var showCollectionView: UICollectionView!
    
    var fullScreenSize: CGSize!
    var articleImage = [UIImage]()
    var photoWidth: CGFloat!
    
    var ref: DatabaseReference!
    let decoder = JSONDecoder()
    var cuisines = [Cuisine]()
    
    var cuisine = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fullScreenSize = UIScreen.main.bounds.size
        typeCollectionSet()
        
        let nib2 = UINib(nibName: "ProfileCollectionViewCell", bundle: nil)
        showCollectionView.register(nib2, forCellWithReuseIdentifier: "ProfileBCell")
    
        articleImage = [UIImage(named: "01"), UIImage(named: "02"),
                        UIImage(named: "03"), UIImage(named: "04"),
                        UIImage(named: "05"), UIImage(named: "06"),
                        UIImage(named: "07"), UIImage(named: "08"),
                        UIImage(named: "09"), UIImage(named: "10"),
                        UIImage(named: "01"), UIImage(named: "02"),
                        UIImage(named: "03"), UIImage(named: "04"),
                        UIImage(named: "05"), UIImage(named: "06"),
                        UIImage(named: "07"), UIImage(named: "08")] as! [UIImage]
//
//        cuisine = ["中式料理","日式料理","美式料理","義式料理","韓式料理",
//                   "中式料理","日式料理","美式料理","義式料理","韓式料理"]
        
        ref = Database.database().reference()
        
        self.readTypeData()
        
        showCollectionView.delegate = self
        showCollectionView.dataSource = self
        
    }
    
    func typeCollectionSet() {
     
        let nib = UINib(nibName: "TypeCollectionViewCell", bundle: nil)
        typeCollectionView.register(nib, forCellWithReuseIdentifier: "TypeCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
//        layout.itemSize = CGSize(width: (self.view.frame.size.width - 30) / 2, height: 80)
        layout.minimumLineSpacing = CGFloat(integerLiteral: 10)
        layout.minimumInteritemSpacing = CGFloat(integerLiteral: 10)
        layout.scrollDirection = .horizontal
        typeCollectionView.collectionViewLayout = layout
        typeCollectionView.showsHorizontalScrollIndicator = false
        
        typeCollectionView.dataSource = self
        typeCollectionView.delegate = self
    }
    
    func readTypeData() {
        
        ref.child("inspires").observe(.childAdded) { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else { return }
            
            guard let cuisineJSONData = try? JSONSerialization.data(withJSONObject: value) else { return }
            
            do {
                
                let cuisineData = try self.decoder.decode(Cuisine.self, from: cuisineJSONData)
                self.cuisines.append(cuisineData)
                
            } catch {
                
                print(error)
                
            }
            
            self.typeCollectionView.reloadData()
            
        }
        
    }
    
    
}

extension InspireViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.typeCollectionView {
            
            return cuisines.count
            
        } else {
            
            return 18
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.typeCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeCell", for: indexPath) as? TypeCollectionViewCell else {
                
                return UICollectionViewCell()
                
            }
            
            let cuisine = cuisines[indexPath.row]
            
            let url = URL(string: cuisine.image)
            cell.typeImage.kf.setImage(with: url)
            cell.typeLabel.text = cuisine.name
            
//            cell.typeLabel.text = cuisine[indexPath.item]
//            cell.typeImage.image = articleImage[indexPath.item]
            
            return cell
            
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileBCell", for: indexPath) as? ProfileCollectionViewCell else {
                
                return UICollectionViewCell()
                
            }
            
            cell.articleImage.image = articleImage[indexPath.item]
            
            return cell
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.item)
        
    }
    
}

extension InspireViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == self.showCollectionView {

            let cellWidth = (fullScreenSize.width / 3) - 7.5

            return CGSize(width: cellWidth, height: cellWidth)
            
        }

        return CGSize(width: (self.view.frame.size.width - 30) / 2, height: 80)
    }

}
