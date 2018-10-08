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
    var photoWidth: CGFloat!
    
    var ref: DatabaseReference!
    let decoder = JSONDecoder()
    
    var cuisines = [Cuisine]()
    var articles = [Article]()
    var hidingLine: Bool = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fullScreenSize = UIScreen.main.bounds.size
        typeCollectionSet()
        
        let nib2 = UINib(nibName: "ProfileCollectionViewCell", bundle: nil)
        showCollectionView.register(nib2, forCellWithReuseIdentifier: "ProfileBCell")
        
        ref = Database.database().reference()
        
        self.readTypeData()
        self.readEachTypeData(cuisine: "美式料理")
        
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
            
            DispatchQueue.main.async {

                self.typeCollectionView.reloadData()
            
            }
            
        }
        
    }
    
    func readEachTypeData(cuisine: String) {
        
        articles = []
        
        ref.child("posts").queryOrdered(byChild: "cuisine").queryEqual(toValue: cuisine).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else { return }
            
            for key in value.allKeys {
                
                guard let data = value[key] as? NSDictionary else { return }
                guard let user = data["user"] as? NSDictionary else { return }
                guard let articleTitle = data["articleTitle"] as? String else { return }
                guard let articleImage = data["articleImage"] as? String else { return }
                guard let cuisine = data["cuisine"] as? String else { return }
                guard let userName = user["name"] as? String else { return }
                guard let userImage = user["image"] as? String else { return }
                guard let uid = user["uid"] as? String else { return }
                guard let location = data["location"] as? String else { return }
                guard let createdTime = data["createdTime"] as? Int else { return }
                guard let content = data["content"] as? String else { return }
                guard let interestedIn = data["interestedIn"] as? Bool else { return }
                
                let article = Article(articleTitle: articleTitle, articleImage: articleImage, height: 0, width: 0, createdTime: createdTime, location: location, cuisine: cuisine, content: content, user: User(name: userName, image: userImage, uid: uid), instagramPost: true, interestedIn: interestedIn)
                
                self.articles.append(article)
                
            }
            
            self.showCollectionView.reloadData()
            
        }
        
    }
    
//    func showLine() {
//
//        let cell = TypeCollectionViewCell()
//        cell.underlineView.isHidden = true
//
//        hidingLine = false
//        cell.underlineView.isHidden = hidingLine
//
//    }
    
}

extension InspireViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.typeCollectionView {
            
            return cuisines.count
            
        } else {
            
            return articles.count
            
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
//            cell.underlineView.isHidden = hidingLine

            return cell
            
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileBCell", for: indexPath) as? ProfileCollectionViewCell else {
                
                return UICollectionViewCell()
                
            }
            
            let article = articles[indexPath.row]
            
            let url = URL(string: article.articleImage)
            cell.articleImage.kf.setImage(with: url)
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.typeCollectionView {
            
                switch indexPath.item {
                    
                case 0: readEachTypeData(cuisine: "美式料理")
                case 1: readEachTypeData(cuisine: "中式料理")
                case 2: readEachTypeData(cuisine: "義式料理")
                case 3: readEachTypeData(cuisine: "日式料理")
                case 4: readEachTypeData(cuisine: "韓式料理")
                case 5: readEachTypeData(cuisine: "台式料理")
                case 6: readEachTypeData(cuisine: "泰式料理")
                case 7: readEachTypeData(cuisine: "西式料理")
                    
                default: break
                    
                }
            
//                self.typeCollectionView.reloadData()
                self.showCollectionView.reloadData()
            
            }
            
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
