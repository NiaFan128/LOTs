//
//  DetailBTableViewCell.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/27.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import KeychainSwift

protocol LikeButton: AnyObject {

    func buttonSelect(_ button: UIButton)

}

class DetailBTableViewCell: UITableViewCell {

    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var cuisineLabel: UILabel!
    
    var ref: DatabaseReference!
    let keychain = KeychainSwift()

    var notinterestedIn = true
    
    weak var buttonDelegate: LikeButton?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        articleImage.corner(corner: 10)
        
        locationImage.image = locationImage.image?.withRenderingMode(.alwaysTemplate)
        locationImage.tintColor = #colorLiteral(red: 0.8274509804, green: 0.3529411765, blue: 0.4, alpha: 1)
        
        likeButton.setImage(#imageLiteral(resourceName: "like_2_w").withRenderingMode(.alwaysTemplate), for: .normal)
        likeButton.tintColor = #colorLiteral(red: 0.9912616611, green: 0.645644784, blue: 0.6528680921, alpha: 1)
        
        ref = Database.database().reference()
        
        likeLabel.isHidden = true

    }
    
    @IBAction func likeAction(_ sender: Any) {
        
        buttonDelegate?.buttonSelect(self.likeButton)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

    }
    
    func updateCellInfo(_ model: DetailCellModel) {
        
        self.locationLabel.text = model.location
        self.cuisineLabel.text = model.cuisine
        self.articleImage?.kf.indicatorType = .activity
        self.articleImage.kf.setImage(with: model.articleImageUrl, placeholder: nil)
        
    }
    
}
