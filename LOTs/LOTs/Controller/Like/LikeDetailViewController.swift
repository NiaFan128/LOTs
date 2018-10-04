//
//  LikeDetailViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/26.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

class LikeDetailViewController: UIViewController {

    @IBOutlet weak var likeDetailTableView: UITableView!
    
    var author: [String] = ["Nia"]
    var articleTitle: [String] = []
    var cuisine: [String] = []
    var likeImage: [UIImage] = []
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        let nib = UINib(nibName: "LikeDetailTableViewCell", bundle: nil)
        likeDetailTableView.register(nib, forCellReuseIdentifier: "LikeDetailCell")

        likeDetailTableView.delegate = self
        likeDetailTableView.dataSource = self
        
        articleTitle = ["大推蝦味超濃日式沾麵", "黑死人不償命 Q 彈墨魚麵", "要減肥了低脂少油餐", "廣西螺師粉", "半筋半肉牛肉麵"]
        cuisine = ["日式料理", "義式料理", "英式料理", "中式料理", "中式料理"]
        likeImage = [UIImage(named: "01"), UIImage(named: "02"),
                     UIImage(named: "03"), UIImage(named: "04"),
                     UIImage(named: "05")] as! [UIImage]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false

    }
    
//    class func likeDetailViewControllerForLike() -> LikeDetailViewController {
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        guard let viewController = storyboard.instantiateViewController(withIdentifier: "LikeViewController") as? LikeDetailViewController else {
//            
//            return LikeDetailViewController()
//            
//        }
//        
//        return viewController
//        
//    }
    

}

extension LikeDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LikeDetailCell", for: indexPath) as? LikeDetailTableViewCell else {

            return UITableViewCell()

        }

        cell.authorLabel.text = "Nia"
        cell.articleImage.image = likeImage[indexPath.item]
        cell.articleTitleLabel.text = articleTitle[indexPath.item]
        cell.cuisineLabel.text = cuisine[indexPath.item]

        return cell

    }
    
}

extension LikeDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let row = indexPath.row

        if row == 0 {

            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController")

//            let detailViewController = DetailViewController.detailViewControllerForArticle()
//            navigationController?.pushViewController(detailViewController, animated: true)
            
            show(detailViewController, sender: nil)

        }

    }


}
