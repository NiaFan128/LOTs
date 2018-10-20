//
//  TermsViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/10/20.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import WebKit

class TermsViewController: UIViewController, WKNavigationDelegate {

    var myWebView: WKWebView!
    var fullScreenSize = UIScreen.main.bounds.size
    var myTextLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.view.backgroundColor = #colorLiteral(red: 0.4470588235, green: 0.4470588235, blue: 0.4470588235, alpha: 0.5)
        
        let goWidth = 100.0
        let actionWidth = ( Double(fullScreenSize.width) - goWidth ) / 4
        
        myWebView = WKWebView(frame: CGRect(x: 0, y: 60 + CGFloat(actionWidth), width: fullScreenSize.width, height: fullScreenSize.height - CGFloat(actionWidth)))
        myWebView.isOpaque = false
        myWebView.backgroundColor = UIColor.clear
        myWebView.scrollView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        myWebView.navigationDelegate = self
        self.view.addSubview(myWebView)
        
        myTextLabel = UILabel(frame: CGRect(x: 0, y: -40, width: fullScreenSize.width, height: 40))
        myTextLabel.text = "Terms & Conditions"
        myTextLabel.textAlignment = .center
        myTextLabel.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.myWebView.addSubview(myTextLabel)
        
        let myCancelBtn = UIButton(frame: CGRect(x: myTextLabel.frame.width - 50, y: 20 + CGFloat(actionWidth), width: 40, height: 40))
        myCancelBtn.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        myCancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        self.view.addSubview(myCancelBtn)
        
        linkToTerms()

    }
    
    @objc func linkToTerms() {
        
        let url = URL(string:"https://termsfeed.com/eula/14a1d7a9ce9cd08da466dd2dfd6d6559")
        let urlRequest = URLRequest(url: url!)
        myWebView.load(urlRequest)

    }
    
    @objc func cancel() {

        self.dismiss(animated: true, completion: nil)

    }
    

}
