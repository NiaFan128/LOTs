//
//  CameraEditViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/10/19.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Photos

class CameraEditViewController: UIViewController {

    var photo: UIImage?

    @IBOutlet weak var photoView: UIImageView!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        photoView.image = photo
        
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func saveToPhone(_ sender: UIButton) {
        
        guard let image = photo else {
            print("no image")
            return
        }
        
        // Save photos into cellphone
        try? PHPhotoLibrary.shared().performChangesAndWait {
            
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        
        }
        
    }
    


}
