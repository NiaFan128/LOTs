//
//  ProfileTableViewCell.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/26.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

protocol LogoutButton: AnyObject {
    
    func buttonSelect(_ button: UIButton)
    
}

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var postsAmountLabel: UILabel!
    
    weak var buttonDelegate: LogoutButton?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()

        profileImage.roundCorner()
        
        logoutButton.setImage(#imageLiteral(resourceName: "exit_1").withRenderingMode(.alwaysTemplate), for: .normal)
        logoutButton.tintColor = #colorLiteral(red: 0.8274509804, green: 0.3529411765, blue: 0.4, alpha: 1)
        
        self.isUserInteractionEnabled = true
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func logOutAction(_ sender: Any) {
        
        buttonDelegate?.buttonSelect(self.logoutButton)
        
    }
}
