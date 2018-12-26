//
//  MainViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/19.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Lottie
import Kingfisher

class MainViewController: UIViewController {

    @IBOutlet weak var mainCollectionView: UICollectionView!
        
    var fullScreenSize: CGSize!
    var article: Article!
    var articles = [Article]()
    
    var refreshControl: UIRefreshControl!
    let animationView = LOTAnimationView(name: "loading_2")
    let networkAnimationView = LOTAnimationView(name: "network")
    
    var articleManager: MainManagerProtocol = ArticleManager()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fullScreenSize = UIScreen.main.bounds.size
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.showsVerticalScrollIndicator = false
        
        refreshControl = UIRefreshControl()
        mainCollectionView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(loadData(_:)), for: UIControl.Event.valueChanged)
        
        if let layout = mainCollectionView?.collectionViewLayout as? MainCollectionViewLayout {
            
            layout.delegate = self
        
        }
                
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateData(notification:)),
                                               name: .RefreshPage,
                                               object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        
        if Reachability.isConnectedToNetwork() == true {
            
            showLoadingAnimation()
            readData()
            
        } else {
            
            showNetworkAnimation()
            
        }
        
    }
    
    func showLoadingAnimation() {
        
        animationView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        animationView.center = CGPoint(x: (fullScreenSize.width * 0.5), y: (fullScreenSize.height * 0.5))
        animationView.contentMode = .scaleAspectFill
            
        view.addSubview(animationView)
        
        animationView.play()
        animationView.loopAnimation = true
        
    }
    
    func showNetworkAnimation() {
        
        networkAnimationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        networkAnimationView.center = CGPoint(x: (fullScreenSize.width * 0.5), y: (fullScreenSize.height * 0.5))
        networkAnimationView.contentMode = .scaleAspectFill
        
        view.addSubview(networkAnimationView)
        
        networkAnimationView.play()
        networkAnimationView.loopAnimation = true
        
    }
    
    func removeLoadingAnimation() {
        
        animationView.layer.opacity = 0.5
        animationView.removeFromSuperview()
        
    }
    
    func removeNetworkAnimation() {
        
        networkAnimationView.removeFromSuperview()
        
    }
    
    @objc func loadData(_ refreshControl: UIRefreshControl) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            
            self.refreshControl.beginRefreshing()
            
            self.readData()

            self.refreshControl.endRefreshing()
            
        }
        
    }
   
    @objc func readData() {

        articles = []
        
        articleManager.getData { (data) in

            self.articles.insert(data, at: 0)

            self.mainCollectionView.reloadData()

            self.removeLoadingAnimation()
            
            self.removeNetworkAnimation()

        }
        
    }
    
    @objc func updateData(notification: Notification) {
        
        readData()
        
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

        cell.updateCellInfo(MainCellModel(model: article))
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let article: Article = articles[indexPath.row]
        print(indexPath.item)
        let detailViewController = DetailViewController.detailViewControllerForArticle(article)
        
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
