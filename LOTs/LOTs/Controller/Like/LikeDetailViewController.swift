//
//  LikeDetailViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/26.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Lottie
import Kingfisher
import KeychainSwift

class LikeDetailViewController: UIViewController {

    @IBOutlet weak var likeDetailTableView: UITableView!
    
    var fullScreenSize: CGSize!
    let animationView = LOTAnimationView(name: "lunch_time")
    var animationLabel = UILabel()
    
    var article: Article!
    var articles = [Article]()
    var location: String = ""
    var uid: String = ""
    
    let keychain = KeychainSwift()
    let manager = FirebaseManager()
    var articleManager: LikeManagerProtocol = ArticleManager()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        fullScreenSize = UIScreen.main.bounds.size
        animationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullScreenSize.width, height: 21))
        
        let nib = UINib(nibName: "LikeDetailTableViewCell", bundle: nil)
        likeDetailTableView.register(nib, forCellReuseIdentifier: "LikeDetailCell")

        likeDetailTableView.delegate = self
        likeDetailTableView.dataSource = self
        
        uid = self.keychain.get("uid") ?? ""

        self.navigationItem.title = location
        self.likeArticle(location)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        
    }

    func likeArticle(_ location: String) {
        
        manager.getQueryByType(path: "likes/\(uid)", toValue: location, event: .valueChange, success: { (data) in

            guard let dictionaryData = data as? NSDictionary else { return }

            let articleArray = dictionaryData.allKeys

            for articleID in articleArray {

                self.readArticleData(articleID as! String)

            }

        }, failure: { _ in

        })
        
    }
    
    func readArticleData(_ articleID: String) {
        
        articles = []
        
        articleManager.readLikeArticleData(aritcleID: articleID) { (data) in
            
            self.articles.append(data)
    
            self.likeDetailTableView.reloadData()
            
        }
        
    }
    
    class func likeDetailViewControllerFromLocation(_ location: String) -> LikeDetailViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "LikeDetail") as? LikeDetailViewController else {
            
            return LikeDetailViewController()
            
        }
        
        viewController.location = location
        
        return viewController
        
    }
    
    func showNoDataAnimation() {
        
        animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        animationView.center = CGPoint(x: (fullScreenSize.width * 0.5), y: (fullScreenSize.height * 0.5) - 50)
        
        animationView.contentMode = .scaleAspectFit
        
        view.addSubview(animationView)
        
        animationView.play()
        animationView.loopAnimation = false
        
        animationLabel.center = CGPoint(x: (fullScreenSize.width * 0.5), y: (fullScreenSize.height * 0.5) + 20)
        animationLabel.textAlignment = .center
        animationLabel.text = "There is no related article now."
        animationLabel.textColor = #colorLiteral(red: 0.8274509804, green: 0.3529411765, blue: 0.4, alpha: 1)
        
        view.addSubview(animationLabel)
        
    }
    
    func removeAnimation() {
        
        animationView.removeFromSuperview()
        animationLabel.removeFromSuperview()
        
    }
    
}

extension LikeDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if articles.count != 0 {
            
            self.removeAnimation()
            
        } else {
            
            self.showNoDataAnimation()
            
        }
        
        return articles.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LikeDetailCell", for: indexPath) as? LikeDetailTableViewCell else {

            return UITableViewCell()

        }

        let article = articles[indexPath.row]
        cell.updateCellInfo(LikeCellModel(article))
    
        return cell

    }
    
}

extension LikeDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let article: Article = articles[indexPath.row]
        
        let detailViewController = DetailViewController.detailViewControllerForArticle(article)

        navigationController?.pushViewController(detailViewController, animated: true)
        
    }

}
