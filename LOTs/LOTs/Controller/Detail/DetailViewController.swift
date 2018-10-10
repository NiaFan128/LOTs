//
//  DetailViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/27.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import KeychainSwift


class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var article: Article!
    var ref: DatabaseReference!
    var refreshControl: UIRefreshControl!
    let keychain = KeychainSwift()

    override func viewDidLoad() {
        
        super.viewDidLoad()

        ref = Database.database().reference()
//        guard let uid = self.keychain.get("uid") else { return }

        let nib = UINib(nibName: "DetailATableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DetailACell")
        
        let nib2 = UINib(nibName: "DetailBTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "DetailBCell")
        
        let nib3 = UINib(nibName: "DetailCTableViewCell", bundle: nil)
        tableView.register(nib3, forCellReuseIdentifier: "DetailCCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadData), for: UIControl.Event.valueChanged)

        self.navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.post(name: Notification.Name("Update"), object: article)

        tableView.estimatedRowHeight = 44.0

    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        self.navigationController?.isNavigationBarHidden = true
    
    }
    
    @objc func loadData() {
        
        // Animation to simulate the Internet fetching data
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            
            // Stop animation
            self.refreshControl.endRefreshing()
            
            // Loading more data
//            self.readData()
            
            // Scroll to the latest
//            self.mainCollectionView.scrollToItem(at: [0, 0], at: UICollectionView.ScrollPosition.top, animated: true)
            
        }
        
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
    
    @objc func editArticle() {
        
        let articleID = article.articleID
        
        let userID = article.user.uid
        let uid = self.keychain.get("uid")
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { (_) in
            
            if userID == uid {
                
                // Convert the data
                let editViewController = PostViewController.editForArticle(self.article)
                
                editViewController.hidesBottomBarWhenPushed = true
                
                self.show(editViewController, sender: nil)
            
            } else {
                
                self.userHandler("edit")
                print("You can't edit this article.")
                
            }
            
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { (_) in

            if userID == uid {
                
                print("delete \(articleID)")
                
                self.ref.child("posts").child(articleID).removeValue()
                
                self.navigationController?.popViewController(animated: true)
                
            } else {
                
                self.userHandler("delete")
                print("You can't delete this article.")
                
            }
            
        })
        
        let reportAction = UIAlertAction(title: "Report", style: .destructive) { (_) in
            
            if userID != uid {
                
                print("report")
                self.reportAction()

            } else {
                
                self.userHandler("report")
                
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
            print("cancel")
            
        })

        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        alertController.addAction(reportAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)

    }
    
    func userHandler(_ action: String) {
        
        let alertController = UIAlertController(title: "Warning", message: "You can't \(action) this article.", preferredStyle: .alert)
        
        // 建立[確認]按鈕
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
            
            self.navigationController?.popViewController(animated: true)
            
        })
        
        alertController.addAction(okAction)
        
        // 顯示提示框
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
            cell.moreButton.addTarget(self, action: #selector(DetailViewController.editArticle), for: .touchUpInside)
            
            return cell
            
            
        } else if indexPath.section == 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailBCell", for: indexPath) as? DetailBTableViewCell else {
                
                return UITableViewCell()
                
            }
            
            let articleUrl = URL(string: article.articleImage)
            cell.articleImage.kf.setImage(with: articleUrl)
            cell.locationLabel.text = article.location
            cell.cuisineLabel.text = article.cuisine
            
            // like or not
            // like function
            
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
