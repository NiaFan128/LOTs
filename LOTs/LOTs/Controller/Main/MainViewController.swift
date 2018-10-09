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
import KeychainSwift

class MainViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var article: Article!
    var articles = [Article]()
    
    var refreshControl: UIRefreshControl!
    var ref: DatabaseReference!
    let decoder = JSONDecoder()
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        searchBar.backgroundImage = UIImage()
        ref = Database.database().reference()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        
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
   
//    func readData() {
//
//        articles = []
//
//        ref.child("posts").queryOrdered(byChild: "createdTime").observe(.childAdded) { (snapshot) in
//
//            guard let value = snapshot.value as? NSDictionary else { return }
//
//            guard let articleJSONData = try? JSONSerialization.data(withJSONObject: value) else { return }
//
//            do {
//
//                let articleData = try self.decoder.decode(Article.self, from: articleJSONData)
//                self.articles.append(articleData)
//
//            } catch {
//
//              print(error)
//
//            }
//
//            self.mainCollectionView.reloadData()
//
//        }
//
//    }

    func readData() {

        articles = []

        Database.database().reference().child("posts").queryOrdered(byChild: "createdTime").observeSingleEvent(of: .value) { (snapshot) in

            guard let value = snapshot.value as? NSDictionary else {
                return
            }

            for key in value.allKeys {

                guard let data = value[key] as? NSDictionary else { return }
                guard let user = data["user"] as? NSDictionary else { return }
                guard let articleID = data["articleID"] as? String else { return }
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
                
                let article = Article(articleID: articleID, articleTitle: articleTitle, articleImage: articleImage, height: 0, width: 0, createdTime: createdTime, location: location, cuisine: cuisine, content: content, user: User(name: userName, image: userImage, uid: uid), instagramPost: false, interestedIn: interestedIn)
                
                self.articles.append(article)

            }

            self.mainCollectionView.reloadData()

        }

    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        collectionView.collectionViewLayout.invalidateLayout()
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let article: Article = articles[indexPath.row]
        
        let detailViewController = DetailViewController.detailViewControllerForArticle(article)
        navigationController?.pushViewController(detailViewController, animated: true)
        
        
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
