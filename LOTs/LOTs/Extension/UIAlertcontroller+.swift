//
//  UIAlertcontroller+.swift
//  LOTs
//
//  Created by 乃方 on 2018/10/30.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Foundation

class AlertView: NSObject {
    
    // Only OK
    class func showAlert(view: UIViewController, title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        view.present(alert, animated: true, completion: nil)
    
    }
    
    // Function and Cancel
    class func interactionAlert(view: UIViewController, title: String, message: String,
                                handle: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Confirm", style: .default, handler: handle)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        view.present(alert, animated: true, completion: nil)
        
    }
    
    // Sheet Action - Others
    class func otherSheetAlert(_ view: UIViewController, title: String?, message: String?,
                              firstHandler: ((UIAlertAction) -> Void)?,
                              secondHandler: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let firstAction = UIAlertAction(title: "Block User", style: .destructive, handler: firstHandler)
        let secondAction = UIAlertAction(title: "Report Article", style: .destructive, handler: secondHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        alert.addAction(cancelAction)
        
        view.present(alert, animated: true, completion: nil)
        
    }
    
    // Sheet Action - Report
    class func sheetAlert(view: UIViewController, title: String?, message: String?,
                          firstHandler: ((UIAlertAction) -> Void)?,
                          secondHandler: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        let firstAction = UIAlertAction(title: "It's a spam", style: .destructive, handler: firstHandler)
        let secondAction = UIAlertAction(title: "It's inappropriate", style: .destructive, handler: secondHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(firstAction)
        alert.addAction(secondAction)
        alert.addAction(cancelAction)

        view.present(alert, animated: true, completion: nil)

    }

    // Sheet Action - Edit
    class func editSheetAlert(_ view: UIViewController, title: String?, message: String?,
                          firstHandler: ((UIAlertAction) -> Void)?,
                          secondHandler: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let firstAction = UIAlertAction(title: "Edit", style: .default, handler: firstHandler)
        let secondAction = UIAlertAction(title: "Delete", style: .default, handler: secondHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        alert.addAction(cancelAction)
        
        view.present(alert, animated: true, completion: nil)
        
    }
    
    // Sheet Action - Image
    
    class func uploadImage(_ view: UIViewController, title: String?, message: String?,
                              firstHandler: ((UIAlertAction) -> Void)?,
                              secondHandler: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let firstAction = UIAlertAction(title: "Take a Photo", style: .default, handler: firstHandler)
        let secondAction = UIAlertAction(title: "Select from Camera Roll", style: .default, handler: secondHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        alert.addAction(cancelAction)
        
        view.present(alert, animated: true, completion: nil)
        
    }
    
}
