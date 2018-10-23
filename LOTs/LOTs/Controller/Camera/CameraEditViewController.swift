//
//  CameraEditViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/10/19.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Photos

protocol SendCameraPhotoProtocol: AnyObject {
    
    func sendPhotoImage(_ photo: UIImage)
    
}

class CameraEditViewController: UIViewController {

    var photo: UIImage?

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var saveBGButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var completionHandler: ((_ data: UIImage) -> Void)?
    
    weak var sendDelegate: SendCameraPhotoProtocol?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        photoView.image = photo
        styleCaptureButton()
        
        buttonColor(backButton)
        buttonColor(nextButton)
        buttonColor(saveButton)
        
    }
    
    func styleCaptureButton() {

        saveBGButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        saveBGButton.layer.borderWidth = 2
        saveBGButton.layer.cornerRadius = min(saveBGButton.frame.width, saveBGButton.frame.height) / 2
        
    }
    
    func buttonColor(_ button: UIButton) {
        
        button.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
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
    
    @IBAction func backToCamera(_ sender: UIButton) {
    
        presentDetailFromeLeftToRight()
        
    }
    
    
    @IBAction func saveToPost(_ sender: UIButton) {
        
        guard let photo = photo else { return }
        
        sendDelegate?.sendPhotoImage(photo)
        
        let tabController = self.view.window!.rootViewController as? UITabBarController
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        tabController?.selectedIndex = 2

    }
    
    class func editForCameraPhoto(_ photo: UIImage) -> CameraEditViewController {

        let storyboard = UIStoryboard(name: "Camera", bundle: nil)

        guard let editViewController = storyboard.instantiateViewController(withIdentifier: "CameraEdit") as? CameraEditViewController else {

            return CameraEditViewController()

        }

        editViewController.photo = photo

        return editViewController

    }
    
    // 由左到右
    func presentDetailFromeLeftToRight() {
        
        let animation = CATransition()
        animation.duration = 0.3
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromLeft
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        self.view.window?.layer.add(animation, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)

    }
    
    func dismissDetailFromeRightToLeft(_ viewControllerToPresent: UIViewController){
        
        let animation = CATransition()
        animation.duration = 0.2
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(animation, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false, completion: nil)

    }
    
}


