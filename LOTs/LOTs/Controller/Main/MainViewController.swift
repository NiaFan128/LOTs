//
//  MainViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/19.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class MainViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mainCollectionView: UICollectionView!

    var oldArticles = [oldArticle]()
    
    var articles = [Article]()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        searchBar.backgroundImage = UIImage()
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        refreshControl = UIRefreshControl()
        mainCollectionView.addSubview(refreshControl)
        
        readData()
        
        refreshControl.addTarget(self, action: #selector(loadData), for: UIControl.Event.valueChanged)
        
        // Set the PinterestLayout delegate
        if let layout = mainCollectionView?.collectionViewLayout as? MainLayout {
            layout.delegate = self
        }
        
    }
    
    @objc func loadData() {
        
        // Animation to simulate the Internet fetching data
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            
            // Stop animation
            self.refreshControl.endRefreshing()
            
            // Loading more data
            self.readData()
            
            
            // Scroll to the latest
            self.mainCollectionView.scrollToItem(at: [0, 0], at: UICollectionView.ScrollPosition.top, animated: true)
            
        }
        
    }
   
    func readData() {
        
        articles = []
        
        Database.database().reference().child("posts").queryOrdered(byChild: "createdTime").observeSingleEvent(of: .value) { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else {
                return
            }
        
            print(value)
            
            for key in value.allKeys {
             
                print(key)
                
                guard let data = value[key] as? NSDictionary else { return }
                guard let user = data["user"] as? NSDictionary else { return }
                guard let articleTitle = data["articleTitle"] as? String else { return }
                guard let articleImage = data["articleImage"] as? String else { return }
                guard let userName = user["name"] as? String else { return }
                guard let userImage = user["image"] as? String else { return }
                
                let article = Article(articleTitle: articleTitle, articleImage: articleImage, height: 0, width: 0, createdTime: 0, location: "", cuisine: "", content: "", user: User(name: userName, image: userImage), instagramPost: false)
                
                self.articles.append(article)
                
            }
            
            self.mainCollectionView.reloadData()

        }
        
    }
    
    func databaseUpdate() {
        
        // Use the observation, however, can't update
        Database.database().reference().child("posts").queryOrdered(byChild: "createdTime").observeSingleEvent(of: .childAdded, with: { (snapshot) in

            if let dictionary = snapshot.value as? [String: AnyObject] {

                let article = oldArticle(dictionary: dictionary)

                DispatchQueue.main.async(execute: {

                    // why always update the first article
                    self.oldArticles.insert(article, at: 0)
//                    self.mainCollectionView.reloadData()

                })

            }

        })
        
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
        
        let url = URL(string: article.user.image)
        cell.profileImageView.kf.setImage(with: url)
        
        let articleImageUrl = article.articleImage
            
        if let url = URL(string: articleImageUrl) {
                
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    
                    // download hit an error so lets return out
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        
                        guard let image: UIImage = UIImage(data: data!) else {
                            return
                        }
                        
                        cell.imageView?.image = image
                        
                    }
                    
                    }.resume()
                
            }
        
        return cell
        
    }
    
}

extension MainViewController: LayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        
//        return articles[indexPath.item].height
        
        if indexPath.item % 3 == 0 {

            return 200

        } else {

            return 300
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, widthForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {

//        return articles[indexPath.item].width
        return 200
        
    }

    
}
