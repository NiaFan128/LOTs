//
//  MainViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/19.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Lottie
import Firebase
import Kingfisher
import KeychainSwift

class MainViewController: UIViewController {

    @IBOutlet weak var mainCollectionView: UICollectionView!
        
    var fullScreenSize: CGSize!
    var article: Article!
    var articles = [Article]()
    let keychain = KeychainSwift()
    
    var refreshControl: UIRefreshControl!
    var ref: DatabaseReference!
    let decoder = JSONDecoder()
    
    let userDefaults = UserDefaults.standard

    let animationView = LOTAnimationView(name: "loading_2")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ref = Database.database().reference()
        fullScreenSize = UIScreen.main.bounds.size
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.showsVerticalScrollIndicator = false
        
        refreshControl = UIRefreshControl()
        mainCollectionView.addSubview(refreshControl)
        
        showLoadingAnimation()
        readData()
        
        refreshControl.addTarget(self, action: #selector(loadData(_:)), for: UIControl.Event.valueChanged)
        
        if let layout = mainCollectionView?.collectionViewLayout as? MainLayout {
            
            layout.delegate = self
        
        }
        
        userDefaults.removeObject(forKey: "block")
        
    }
    
    func showLoadingAnimation() {
        
        animationView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        animationView.center = CGPoint(x: (fullScreenSize.width * 0.5), y: (fullScreenSize.height * 0.5))
        animationView.contentMode = .scaleAspectFill
            
        view.addSubview(animationView)
        
        animationView.play()
        animationView.loopAnimation = true
        
    }
    
    func removeLoadingAnimation() {
        
        animationView.layer.opacity = 0.5
        animationView.removeFromSuperview()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    @objc func loadData(_ refreshControl: UIRefreshControl) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            
            self.refreshControl.beginRefreshing()
            
            self.readData()

            self.refreshControl.endRefreshing()
            
        }
        
    }
   
    func readData() {

        articles = []
        
        ref.child("posts").queryOrdered(byChild: "createdTime").observe(.childAdded) { (snapshot) in
                        
            guard let value = snapshot.value as? NSDictionary else { return }
            
            guard let articleJSONData = try? JSONSerialization.data(withJSONObject: value) else { return }
            
            do {
                
                let articleData = try self.decoder.decode(Article.self, from: articleJSONData)
                
                if let blockUsers = self.userDefaults.array(forKey: "block") {
                    
                    for blockUser in blockUsers {
                        
                        self.articles = self.articles.filter { $0.user.uid != blockUser as! String }
                        
                    }
                    
                }
                
                if articleData.articleID != self.articles.first?.articleID {
                    
                    self.articles.insert(articleData, at: 0)
                
                }
                
                self.removeLoadingAnimation()
                self.mainCollectionView.reloadData()
                
            } catch {
                
                print(error)
                
            }
            
        }

    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return articles.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainFoodCell", for: indexPath as IndexPath) as! MainCell

        let article = articles[indexPath.row]
        
        cell.titleLabel?.text = article.articleTitle
        
        let url = URL(string: article.user.image)
        cell.profileImageView.kf.setImage(with: url)
        
        let articleUrl = URL(string: article.articleImage)
        cell.imageView?.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: articleUrl)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let article: Article = articles[indexPath.row]
        
        let detailViewController = DetailViewController.detailViewControllerForArticle(article, animation: true)
        
        navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
}

extension MainViewController: LayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        if indexPath.item % 3 == 0 {

            return 200

        } else {

            return 300
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, widthForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {

        return 200
        
    }
    
}
