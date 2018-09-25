//
//  MainViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/19.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class MainViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mainCollectionView: UICollectionView!

    var articles = [Article]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        searchBar.backgroundImage = UIImage()
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        readData()
        
        // Set the PinterestLayout delegate
        if let layout = mainCollectionView?.collectionViewLayout as? Layout {
            layout.delegate = self
        }
        
    }
    
    func readData(){
        
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot) in

            print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject] {

                print(dictionary)
                
                let article = Article(dictionary: dictionary)
                print(article)

                self.articles.append(article)

                DispatchQueue.main.async(execute: {
                    self.mainCollectionView.reloadData()
                })

            }
            
        }
        
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return articles.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainFoodCell", for: indexPath as IndexPath) as! MainCell

        let article = articles[indexPath.row]
        
        cell.titleLabel?.text = article.articleTitle
        // Will change the profile image after login
        cell.profileImageView.image = UIImage(named: "profile_1")
        
        cell.imageView?.contentMode = .scaleAspectFill
        
        if let articleImageUrl = article.articleImage {
            
            let url = URL(string: articleImageUrl)
            
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                
                // download hit an error so lets return out
                if error != nil {
                    print(error)
                    return
                }
                
                DispatchQueue.main.async {
                    
                    cell.imageView?.image = UIImage(data: data!)

                }
                
            }.resume()
            
        }
        
        return cell
        
    }
    
}

extension MainViewController: LayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {

        return 200
//        return mains[indexPath.item].articleImage.size.height
//        return foods[indexPath.item].image.size.height
        
        // need to update the size
        
    }
    
    func collectionView(_ collectionView: UICollectionView, widthForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {

        return 200
//        return mains[indexPath.item].articleImage.size.width
//        return foods[indexPath.item].image.size.width
        
        // need to update the size
        
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
