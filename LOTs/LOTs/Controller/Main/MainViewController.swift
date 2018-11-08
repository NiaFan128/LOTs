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
import KeychainSwift

class MainViewController: UIViewController {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    private var transition: CardTransition?
    
    var fullScreenSize: CGSize!
    var article: Article!
    var articles = [Article]()
    
    let keychain = KeychainSwift()
    let manager = FirebaseManager()

    var refreshControl: UIRefreshControl!
    let userDefaults = UserDefaults.standard

    let animationView = LOTAnimationView(name: "loading_2")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        
        // Animation to simulate the Internet fetching data
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            
            self.refreshControl.beginRefreshing()
            
            // Loading more data
            self.readData()

            // Stop animation
            self.refreshControl.endRefreshing()
            
        }
        
    }
   
    func readData() {

        articles = []
        
        manager.getQueryOrder(path: "posts", order: "createdTime", event: .childAdded, success: { (data) in
                                        
            guard let articleData = data as? Article else { return }
            
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
            
        },failure: { _ in
            
        })

    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
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
        
        let articleUrl = URL(string: article.articleImage)
        cell.imageView?.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: articleUrl)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let article: Article = articles[indexPath.row]
        
        // Get tapped cell location
        let cell = collectionView.cellForItem(at: indexPath) as! MainCell
        
        // Freeze highlighted state (or else it will bounce back)
        cell.freezeAnimations()
        
        // Get current frame on screen
        let currentCellFrame = cell.layer.presentation()!.frame
        
        // Convert current frame to screen's coordinates
        let cardPresentationFrameOnScreen = cell.superview!.convert(currentCellFrame, to: nil)
        
        // Get card frame without transform in screen's coordinates  (for the dismissing back later to original location)
        let cardFrameWithoutTransform = { () -> CGRect in
            
            let center = cell.center
            let size = cell.bounds.size
            let r = CGRect(
                x: center.x - size.width / 2,
                y: center.y - size.height / 2,
                width: size.width,
                height: size.height
            )
            return cell.superview!.convert(r, to: nil)
        
        }()
        
        let detailViewController = DetailViewController.detailViewControllerForArticle(article, animation: true)

        let params = CardTransition.Params(fromCardFrame: cardPresentationFrameOnScreen,
                                           fromCardFrameWithoutTransform: cardFrameWithoutTransform,
                                           fromCell: cell)
        
        transition = CardTransition(params: params)
        
        detailViewController.transitioningDelegate = transition
//        detailViewController.modalPresentationCapturesStatusBarAppearance = true
        detailViewController.modalPresentationStyle = .custom

//        present(detailViewController, animated: true) {[unowned cell] in
//
//            cell.unfreezeAnimations()
//
//        }
        
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
