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
    @IBOutlet weak var statusbarView: UIView!
    
    var fullScreenSize: CGSize!
    var article: Article!
    var blockUsers: [String] = []
    var ref: DatabaseReference!
    let manager = FirebaseManager()
    
    let keychain = KeychainSwift()
    let animationView = LOTAnimationView(name: "loading_2")
    
    private let dateFormatter = LOTsDateFormatter()

    var notinterestedIn = true
    var interestedIn: Bool = false
    var uid: String?
    var animation: Bool?

    let dispatchGroup = DispatchGroup()
    let userDefaults = UserDefaults.standard
    let transition = CATransition()

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
        
        view.backgroundColor = .white
        
        uid = self.keychain.get("uid")
        
        readInterestedIn()
        animationBGView.isHidden = true
        statusbarView.isHidden = false
        
        loadViewIfNeeded()
    
        tableView.showsVerticalScrollIndicator = false
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeOut(recognizer:)))
        swipeLeft.direction = .right
        
        self.view.addGestureRecognizer(swipeLeft)
        
    }
    
    @objc func swipeOut(recognizer:UISwipeGestureRecognizer) {
        
        transition.duration = 0.6
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        self.navigationController?.popViewController(animated: true)
        
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
        let userName = article.user.name
        
        guard uid != nil else {
            
            visitorAlertRemind()
            return
        
        }
        
        if userID == uid {
            
            editAction()
            
        } else {
            
            AlertView.otherSheetAlert(self, title: nil, message: nil, firstHandler: { (_) in
                                        
                                        self.blockUser(userName)}, secondHandler: { (_) in
                                        
                                        self.reportArticle()})
            
        }
        
    }
    
    func editAction() {
        
        let articleID = article.articleID
        
        AlertView.editSheetAlert(self, title: nil, message: nil, firstHandler: { (_) in
                                    
                                    let editViewController = PostViewController.editForArticle(self.article)
                                    
                                    editViewController.hidesBottomBarWhenPushed = true
                                    
                                    editViewController.delegate = self
                                    
                                    self.show(editViewController, sender: nil)
        },
                                 secondHandler: { (_) in
                                    
                                    self.deleteAlertRemind(articleID)
                                    
        })
        
    }
    
    func deleteAlertRemind(_ articleID: String) {
        
        let articleID = article.articleID
        let location = article.location

        AlertView.interactionAlert(view: self, title: "Oops!",
                                   message: "Are you sure to delete this item ?") { (_) in
                                    
                                    self.ref.child("posts").child(articleID).removeValue()
                                    
                                    NotificationCenter.default.post(name: Notification.Name("Remove"),
                                                                    object: nil,
                                                                    userInfo: ["articleID": articleID,
                                                                               "location": location])
                                    
                                    self.navigationController?.popViewController(animated: true)
                                    
        }
        
    }
    
    func reportArticle() {
        
        AlertView.sheetAlert(view: self, title: nil, message: nil, firstHandler: { (_) in
                                
                                self.reportConfirmation("spam")}, secondHandler: { (_) in
                                
                                self.reportConfirmation("inappropriate")
                                
        })
        
    }
    
    func reportConfirmation(_ message: String) {

        AlertView.interactionAlert(view: self, title: "",
                                   message: "Do you think it is \(message)? \n We will proceed accordingly soon! ") { (_) in
                                    
                                    self.receiveMessage()
                                    
        }
        
    }
    
    func blockUser(_ user: String) {

        AlertView.interactionAlert(view: self, title: "",
                                   message: "Are you sure to block this user, \n \(user) ?") { (_) in
                                    
                                    self.blockMessage(user)
                                    self.blockUserAction()
        
        }
        
    }
    
    func blockUserAction() {
        
        if let value = userDefaults.value(forKey: "block") as? NSArray {

            blockUsers = value as! [String]

        }
        
        blockUsers.append(article.user.uid)
        userDefaults.set(blockUsers, forKey: "block")
        
    }
    
    func receiveMessage() {
        
        AlertView.showAlert(view: self, title: "Thank you", message: "We will proceed your feedback soon.")
        
    }
    
    func blockMessage(_ user: String) {
        
        AlertView.showAlert(view: self, title: "", message: "You won't see \(user)'s article from now on.")
        
    }
    
    func interstedIn() {
        
        if uid == nil {
            
            visitorAlertRemind()
            
        } else {
            
            guard let uid = self.keychain.get("uid") else { return }
            let location = article.location
            let articleID = article.articleID
            
            ref.child("likes/\(uid)").child("\(location)").updateChildValues(["\(articleID)": true])

        }

    }
    
    func notInterstedIn() {
        
        if uid == nil {
            
            visitorAlertRemind()
            
        } else {
            
            guard let uid = keychain.get("uid") else { return }
            let location = article.location
            let articleID = article.articleID
            
            ref.child("likes/\(uid)").child("\(location)").child(articleID).removeValue()
            
        }

    }
    
    func visitorAlertRemind() {
        
        AlertView.showAlert(view: self, title: "Oops!", message: "Please login with Facebook \n to explore more features.")
        
    }
    
    func readInterestedIn() {
        
        DispatchQueue.main.async {
            
            guard let uid = self.keychain.get("uid") else { return }
            let location = self.article.location
            let articleID = self.article.articleID
            
            self.ref.child("likes/\(uid)/\(location)").queryOrderedByKey().observe(.value) { (snapshot) in
                
                guard let value = snapshot.value as? NSDictionary else { return }
                
                guard let thisArticleID = value["\(articleID)"] as? Bool else { return }
                
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
        
        manager.getQueryBySingle(path: "posts", toValue: articleID, event: .valueChange, success: { (data) in
            
            guard let updateArticle = data as? Article else { return }

            self.article = updateArticle
            
            self.tableView.reloadData()
            
            self.removeLoadingAnimation()
            
        }, failure: { _ in
            
        })
        
    }
    
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

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            
            self.animationBGView.isHidden = true
            
        })

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
        
        switch indexPath.section {
            
            case 0:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailACell", for: indexPath) as? DetailATableViewCell else {
                    
                    return UITableViewCell()
                    
                }
                
                cell.updateCellInfo(DetailCellModel(article))
                cell.moreButton.addTarget(self, action: #selector(DetailViewController.moreAction), for: .touchUpInside)
                
                return cell
            
            case 1:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailBCell", for: indexPath) as? DetailBTableViewCell else {
                    
                    return UITableViewCell()
                    
                }
                
                cell.articleImage.image = nil
                cell.updateCellInfo(DetailCellModel(article))
                cell.buttonDelegate = self
                
                if interestedIn == true {
                    
                    cell.likeButton.setImage(#imageLiteral(resourceName: "like").withRenderingMode(.alwaysTemplate), for: .normal)
                    cell.likeButton.tintColor = #colorLiteral(red: 0.9912616611, green: 0.645644784, blue: 0.6528680921, alpha: 1)
                    
                } else {
                    
                    cell.likeButton.setImage(#imageLiteral(resourceName: "like_2_w").withRenderingMode(.alwaysTemplate), for: .normal)
                    cell.likeButton.tintColor = #colorLiteral(red: 0.9912616611, green: 0.645644784, blue: 0.6528680921, alpha: 1)
                    
                }
                
                return cell
            
            case 2:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCCell", for: indexPath) as? DetailCTableViewCell else {
                    
                    return UITableViewCell()
                    
                }
                
                cell.contentTextView.text = article.content
                
                return cell
            
            default: return UITableViewCell()
            
        }
        
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
            
            visitorAlertRemind()
            
        } else {
            
            let interestedIn = !notinterestedIn
            notinterestedIn = interestedIn
            
            if notinterestedIn {
                
                button.setImage(#imageLiteral(resourceName: "like_2_w").withRenderingMode(.alwaysTemplate), for: .normal)
                button.tintColor = #colorLiteral(red: 0.9912616611, green: 0.645644784, blue: 0.6528680921, alpha: 1)
                notInterstedIn()
                
            } else {
                
                button.setImage(#imageLiteral(resourceName: "like").withRenderingMode(.alwaysTemplate), for: .normal)
                button.tintColor = #colorLiteral(red: 0.9912616611, green: 0.645644784, blue: 0.6528680921, alpha: 1)
                interstedIn()
                
            }
            
        }

    }
    
}

extension DetailViewController: EditUpdateProtocol {
    
    func readUpdateData() {
        
        self.reloadUpdateData(article.articleID)
        
        self.article = Article.init(articleID: "", articleTitle: "", articleImage: "", height: 0, width: 0, createdTime: 0, location: "", cuisine: "", content: "", user: User.init(name: "", image: "", uid: ""), instagramPost: false, interestedIn: true)
        
        self.tableView.reloadData()
        
    }
    
}
