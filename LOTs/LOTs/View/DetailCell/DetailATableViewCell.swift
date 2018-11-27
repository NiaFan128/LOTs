//
//  DetailATableViewCell.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/27.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

class DetailATableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    private let dateFormatter = LOTsDateFormatter()
    
    override func awakeFromNib() {

        super.awakeFromNib()
        
        profileImage.roundCorner()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func updateCellInfo(_ model: DetailCellModel) {
        
        self.authorLabel.text = model.userName
        self.titleLabel.text = model.articleTitle
        self.createdTimeLabel.text = model.createdTimeString
        self.profileImage.kf.setImage(with: model.userImageUrl)
        
    }
    
}
