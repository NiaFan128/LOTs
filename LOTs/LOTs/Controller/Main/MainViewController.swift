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

//    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    private var transition: CardTransition?
    
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
                
//        searchBar.backgroundImage = UIImage()
        ref = Database.database().reference()
        fullScreenSize = UIScreen.main.bounds.size
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        refreshControl = UIRefreshControl()
        mainCollectionView.addSubview(refreshControl)
        
        showLoadingAnimation()
        readData()
        
        refreshControl.addTarget(self, action: #selector(loadData(_:)), for: UIControl.Event.valueChanged)
        
        // Set the PinterestLayout delegate
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
            
            // Scroll to the latest
//            self.mainCollectionView.scrollToItem(at: [0, 0], at: UICollectionView.ScrollPosition.top, animated: true)
            
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
        
        Database.database().reference().child("posts").queryOrdered(byChild: "createdTime").observeSingleEvent(of: .value) { (snapshot) in

            self.articles = []

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
            
            if let blockUsers = self.userDefaults.array(forKey: "block") {
                
                for blockUser in blockUsers {
                    
                    self.articles = self.articles.filter { $0.user.uid != blockUser as! String }
                    
                    print(self.articles)
                    
                }

            }

            self.removeLoadingAnimation()
            self.mainCollectionView.reloadData()

        }

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

        present(detailViewController, animated: true) {[unowned cell] in

            cell.unfreezeAnimations()

        }
        
//        navigationController?.pushViewController(detailViewController, animated: true)
        
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

//extension MainViewController: UIViewControllerTransitioningDelegate {
//    
//    
//    
//}
