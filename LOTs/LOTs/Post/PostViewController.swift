//
//  PostViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/20.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PostInfoCell")
        
        let nib2 = UINib(nibName: "ContentTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "ContentCell")
        
        articleImage.layer.cornerRadius = 8
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        
    }

}

extension PostViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return 2

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostInfoCell", for: indexPath) as? PostTableViewCell else {

                return UITableViewCell()

            }

            return cell

        } else if indexPath.section == 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as? ContentTableViewCell else {
                
                return UITableViewCell()
                
            }
            
            return cell
            
        }

        return UITableViewCell()

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
}

extension PostViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }

}
