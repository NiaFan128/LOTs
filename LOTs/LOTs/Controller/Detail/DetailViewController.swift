//
//  DetailViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/27.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Lottie
import Firebase
import Kingfisher
import KeychainSwift

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animationBGView: UIView!
    
    var fullScreenSize: CGSize!
    var article: Article!
    var ref: DatabaseReference!
    let keychain = KeychainSwift()
    let animationView = LOTAnimationView(name: "loading_2")
    
    var notinterestedIn = true
    var interestedIn: Bool = false
    var uid: String?
        
    override func viewDidLoad() {
        
        super.viewDidLoad()

        ref = Database.database().reference()
        fullScreenSize = UIScreen.main.bounds.size

        let nib = UINib(nibName: "DetailATableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DetailACell")
        
        let nib2 = UINib(nibName: "DetailBTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "DetailBCell")
        
        let nib3 = UINib(nibName: "DetailCTableViewCell", bundle: nil)
        tableView.register(nib3, forCellReuseIdentifier: "DetailCCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        uid = self.keychain.get("uid")
        
        self.navigationController?.isNavigationBarHidden = true

        readInterestedIn()
        animationBGView.isHidden = true
        
        //        fetchInterestNumber()
        
        tableView.estimatedRowHeight = 44.0

    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        self.navigationController?.isNavigationBarHidden = true
    
        readInterestedIn()
        
    }
    
    class func detailViewControllerForArticle(_ article: Article) -> DetailViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            
            return DetailViewController()
            
        }
        
        viewController.article = article
                
        return viewController
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
    
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func moreAction() {
        
        let userID = article.user.uid
        let uid = self.keychain.get("uid")
        
        if userID == uid {
            
            editAction()
            
        } else {
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            let reportAction = UIAlertAction(title: "Report User", style: .destructive) { (_) in
                
                self.reportAction()
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                
                print("cancel")
                
            })
            
            alertController.addAction(reportAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    func editAction() {
        
        let articleID = article.articleID
        let location = article.location
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { (_) in
            
            // Convert the data
            let editViewController = PostViewController.editForArticle(self.article)
            
            editViewController.hidesBottomBarWhenPushed = true
            
            editViewController.delegate = self
            
            self.show(editViewController, sender: nil)
            
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { (_) in
            
            print("delete \(articleID)")
            
            self.deleteAlertRemind(articleID)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
            print("cancel")
            
        })
        
        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func deleteAlertRemind(_ articleID: String) {
        
        let articleID = article.articleID
        let location = article.location

        let alertController = UIAlertController(title: "Oops!", message: "Are you sure to delete this item ?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Confirm", style: .default, handler: { (_) in
            
            self.ref.child("posts").child(articleID).removeValue()
            
            NotificationCenter.default.post(name: Notification.Name("Remove"),
                                            object: nil,
                                            userInfo: ["articleID": articleID,
                                                       "location": location])
            
            self.navigationController?.popViewController(animated: true)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
        })
        
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func reportAction() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let spamAction = UIAlertAction(title: "It's spam", style: .destructive, handler: { (_) in
            
            print("It's spam.")
            
        })
        
        let inappropriateAction = UIAlertAction(title: "It's inappropriate", style: .destructive, handler: { (_) in
            
            print("It's inappropriate.")
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
            print("cancel")
            
        })

        alertController.addAction(spamAction)
        alertController.addAction(inappropriateAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    
    }
    
    // like function
    func interstedIn() {
        
//        guard let uid = keychain.get("uid") else { return }
        
        if uid == nil {
            
            alertRemind()
            
        } else {
            
            guard let uid = self.keychain.get("uid") as? String else { return }
            guard let location = article.location else { return }
            let articleID = article.articleID
            
            ref.child("likes/\(uid)").child("\(location)").updateChildValues(["\(articleID)": true])

        }

    }
    
    // dislike function
    func notInterstedIn() {
        
        if uid == nil {
            
            alertRemind()
            
        } else {
            
            guard let uid = keychain.get("uid") else { return }
            guard let location = article.location else { return }
            let articleID = article.articleID
            
            ref.child("likes/\(uid)").child("\(location)").child(articleID).removeValue()
            
        }

    }
    
    // Visitor Alert
    func alertRemind() {
        
        let alertController = UIAlertController(title: "Oops!", message: "Please login with Facebook \n to explore more features.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func readInterestedIn() {
        
        DispatchQueue.main.async {
            
            guard let uid = self.keychain.get("uid") else { return }
            guard let location = self.article.location else { return }
            let articleID = self.article.articleID
            
            self.ref.child("likes/\(uid)/\(location)").queryOrderedByKey().observe(.value) { (snapshot) in
                
                guard let value = snapshot.value as? NSDictionary else { return }
                
                guard let thisArticleID = value["\(articleID)"] as? Bool else {
                    return
                }
                
                if thisArticleID == true {
                    
                    self.interestedIn = true
                    
                } else {
                    
                    self.interestedIn = false
                    
                }
                
                self.tableView.reloadData()
                
            }
            
        }
        
    }
    
    func reloadUpdateData(_ articleID: String) {
        
        showLoadingAnimation()
        
        ref.child("posts").queryOrderedByKey().queryEqual(toValue: articleID).observe(.value, with: { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else { return }
            guard let data = value[articleID] as? NSDictionary else { return }
            
            guard let user = data["user"] as? NSDictionary else { return }
            guard let userName = user["name"] as? String else { return }
            guard let userImage = user["image"] as? String else { return }
            guard let uid = user["uid"] as? String else { return }
            
            guard let location = data["location"] as? String else { return }
            guard let articleTitle = data["articleTitle"] as? String else { return }
            guard let articleImage = data["articleImage"] as? String else { return }
            guard let cuisine = data["cuisine"] as? String else { return }
            guard let createdTime = data["createdTime"] as? Int else { return }
            guard let content = data["content"] as? String else { return }
            guard let interestedIn = data["interestedIn"] as? Bool else { return }

            let updateArticle = Article(articleID: articleID, articleTitle: articleTitle, articleImage: articleImage, height: 0, width: 0, createdTime: createdTime, location: location, cuisine: cuisine, content: content, user: User(name: userName, image: userImage, uid: uid), instagramPost: false, interestedIn: interestedIn)

            self.article = updateArticle
            
            self.tableView.reloadData()
            
            DispatchQueue.main.async {

                self.removeLoadingAnimation()
            
            }
                
        })
    
    }
    
    // Loading Animation
    func showLoadingAnimation() {
        
        animationBGView.isHidden = false
        
        animationView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        animationView.center = CGPoint(x: (animationBGView.frame.width * 0.5), y: (animationBGView.frame.height * 0.5))
        animationView.contentMode = .scaleAspectFill
        animationBGView.addSubview(animationView)
        
        animationView.play()
        animationView.loopAnimation = true
        
    }
    
    func removeLoadingAnimation() {

//        animationView.layer.opacity = 0.5
//        animationView.removeFromSuperview()
        animationBGView.isHidden = true

    }
        
    // TBC
    func fetchInterestNumber() {
        
        let articleID = self.article.articleID
        guard let location = self.article.location else { return }

        ref.child("likes").queryOrderedByValue().queryEqual(toValue: articleID).observe(.value) { (snapshot) in
            
            print(snapshot)
            
        }
    
    }
    
}

extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailACell", for: indexPath) as? DetailATableViewCell else {
                
                return UITableViewCell()
                
            }
            
            let url = URL(string: article.user.image)
            cell.profileImage.kf.setImage(with: url)
            cell.authorLabel.text = article.user.name
            cell.titleLabel.text = article.articleTitle
            
            let timeData = NSDate(timeIntervalSince1970: TimeInterval(article.createdTime ?? 0))
            let dateFormat: DateFormatter = DateFormatter()
            dateFormat.dateFormat = "MMMM / dd / yyyy"
            let stringDate = dateFormat.string(from: timeData as Date)
            cell.createdTimeLabel.text = stringDate
            
            // Edit function
            cell.moreButton.addTarget(self, action: #selector(DetailViewController.moreAction), for: .touchUpInside)
            
            return cell
            
            
        } else if indexPath.section == 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailBCell", for: indexPath) as? DetailBTableViewCell else {
                
                return UITableViewCell()
                
            }
            
            DispatchQueue.main.async {

                let articleUrl = URL(string: self.article.articleImage)
                cell.articleImage?.kf.indicatorType = .activity
                cell.articleImage.kf.setImage(with: articleUrl)

            }
            
            cell.locationLabel.text = article.location
            cell.cuisineLabel.text = article.cuisine
            
            // like function
            cell.buttonDelegate = self
            
            if interestedIn == true {
                
                cell.likeButton.setImage(#imageLiteral(resourceName: "like").withRenderingMode(.alwaysTemplate), for: .normal)
                cell.likeButton.tintColor = #colorLiteral(red: 0.9912616611, green: 0.645644784, blue: 0.6528680921, alpha: 1)
                
            } else {
                
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_2_w").withRenderingMode(.alwaysTemplate), for: .normal)
                cell.likeButton.tintColor = #colorLiteral(red: 0.9912616611, green: 0.645644784, blue: 0.6528680921, alpha: 1)
                
            }
            
            return cell
            
        } else if indexPath.section == 2 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCCell", for: indexPath) as? DetailCTableViewCell else {
                
                return UITableViewCell()
                
            }
            
            cell.contentTextView.text = article.content
            
            return cell
            
        }
        
        return UITableViewCell()
        
    }
    
    
}

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
}

extension DetailViewController: LikeButton {
    
    func buttonSelect(_ button: UIButton) {
        
        if uid == nil {
            
            alertRemind()
            
        } else {
            
            let interestedIn = !notinterestedIn
            notinterestedIn = interestedIn
            
            if notinterestedIn {
                
                // not interest
                button.setImage(#imageLiteral(resourceName: "like_2_w").withRenderingMode(.alwaysTemplate), for: .normal)
                button.tintColor = #colorLiteral(red: 0.9912616611, green: 0.645644784, blue: 0.6528680921, alpha: 1)
                notInterstedIn()
                
            } else {
                
                // interest
                button.setImage(#imageLiteral(resourceName: "like").withRenderingMode(.alwaysTemplate), for: .normal)
                button.tintColor = #colorLiteral(red: 0.9912616611, green: 0.645644784, blue: 0.6528680921, alpha: 1)
                interstedIn()
                
            }
            
        }

    }
    
}

extension DetailViewController: EditUpdate {
    
    func readUpdateData() {
        
        self.reloadUpdateData(article.articleID)
        
//        self.removeLoadingAnimation()
        
    }
    
}
