//
//  SuggestViewController.swift
//  
//
//  Created by 乃方 on 2018/9/27.
//

import UIKit
import Lottie
import Firebase
import Kingfisher

class InspireViewController: UIViewController {

    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var showCollectionView: UICollectionView!
    
    var fullScreenSize: CGSize!
    var photoWidth: CGFloat!
    let userDefaults = UserDefaults.standard

    var ref: DatabaseReference!
    let decoder = JSONDecoder()
    let animationView = LOTAnimationView(name: "lunch_time")
    var animationLabel = UILabel()
    
    var cuisines = [Cuisine]()
    var article: Article!
    var articles = [Article]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fullScreenSize = UIScreen.main.bounds.size
        animationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullScreenSize.width, height: 21))
        
        let nib = UINib(nibName: "TypeCollectionViewCell", bundle: nil)
        typeCollectionView.register(nib, forCellWithReuseIdentifier: "TypeCell")

        typeCollectionSet()
        
        let nib2 = UINib(nibName: "ProfileCollectionViewCell", bundle: nil)
        showCollectionView.register(nib2, forCellWithReuseIdentifier: "ProfileBCell")
        
        ref = Database.database().reference()
        
        self.readTypeData()
        self.readEachTypeData(cuisine: "美式料理")
        
        showCollectionView.delegate = self
        showCollectionView.dataSource = self
        showCollectionView.showsVerticalScrollIndicator = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    func showNoDataAnimation() {
        
        animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        animationView.center = CGPoint(x: (fullScreenSize.width * 0.5), y: (fullScreenSize.height * 0.5) - 50)

        animationView.contentMode = .scaleAspectFit
        
        view.addSubview(animationView)
        
        animationView.play()
        animationView.loopAnimation = false
        
        animationLabel.center = CGPoint(x: (fullScreenSize.width * 0.5), y: (fullScreenSize.height * 0.5) + 20)
        animationLabel.textAlignment = .center
        animationLabel.text = "There is no related article now."
        animationLabel.textColor = #colorLiteral(red: 0.8274509804, green: 0.3529411765, blue: 0.4, alpha: 1)
        
        view.addSubview(animationLabel)
        
    }
    
    func removeAnimation() {
        
        animationView.removeFromSuperview()
        animationLabel.removeFromSuperview()
        
    }
    
    
    func typeCollectionSet() {
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = CGFloat(integerLiteral: 10)
        layout.minimumInteritemSpacing = CGFloat(integerLiteral: 10)
        layout.scrollDirection = .horizontal
        
        typeCollectionView.collectionViewLayout = layout
        typeCollectionView.showsHorizontalScrollIndicator = false
        
        typeCollectionView.dataSource = self
        typeCollectionView.delegate = self
    }
    
    func readTypeData() {
        
        ref.child("inspires").observe(.childAdded) { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else { return }
            
            guard let cuisineJSONData = try? JSONSerialization.data(withJSONObject: value) else { return }
            
            do {
                
                let cuisineData = try self.decoder.decode(Cuisine.self, from: cuisineJSONData)
                self.cuisines.append(cuisineData)
                
            } catch {
                
                print(error)
                
            }
            
            self.typeCollectionView.reloadData()
            
        }
        
    }
    
    func readEachTypeData(cuisine: String) {
        
        ref.child("posts").queryOrdered(byChild: "cuisine").queryEqual(toValue: cuisine).observeSingleEvent(of: .value) { (snapshot) in
            
            self.articles = []

            guard let dictionary = snapshot.value as? NSDictionary else { return }

            for value in dictionary.allValues {
                
                guard let articleJSONData = try? JSONSerialization.data(withJSONObject: value) else { return }
                
                do {
                    
                    let articleData = try self.decoder.decode(Article.self, from: articleJSONData)
                    
                    if let blockUsers = self.userDefaults.array(forKey: "block") {
                        
                        for blockUser in blockUsers {
                            
                            self.articles = self.articles.filter { $0.user.uid != blockUser as! String }
                            
                        }
                        
                    }
                    
                    self.articles.append(articleData)
                    self.showCollectionView.reloadData()
                    
                } catch {
                    
                    print(error)
                    
                }
                
            }
            
        }
        
    }
    
}

extension InspireViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.typeCollectionView {

            return cuisines.count

        } else {

            if articles.count != 0 {

                self.removeAnimation()

            } else {

                self.showNoDataAnimation()

            }
            
            return articles.count

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.typeCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeCell", for: indexPath) as? TypeCollectionViewCell else {
                
                return UICollectionViewCell()
                
            }
            
            let cuisine = cuisines[indexPath.row]
            
            let url = URL(string: cuisine.image)
            cell.typeImage.kf.setImage(with: url)
            cell.typeLabel.text = cuisine.name
//            cell.underlineView.isHidden = hidingLine

            return cell
            
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileBCell", for: indexPath) as? ProfileCollectionViewCell else {
                
                return UICollectionViewCell()
                
            }
            
            let article = articles[indexPath.row]
            
            let url = URL(string: article.articleImage)
            cell.articleImage.kf.setImage(with: url)
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.typeCollectionView {
        
            collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            
                switch indexPath.item {
                    
                case 0: readEachTypeData(cuisine: "美式料理")
                case 1: readEachTypeData(cuisine: "中式料理")
                case 2: readEachTypeData(cuisine: "義式料理")
                case 3: readEachTypeData(cuisine: "日式料理")
                case 4: readEachTypeData(cuisine: "韓式料理")
                case 5: readEachTypeData(cuisine: "台式料理")
                case 6: readEachTypeData(cuisine: "泰式料理")
                case 7: readEachTypeData(cuisine: "西式料理")
                    
                default: break
                    
                }
            
                self.showCollectionView.reloadData()
            
        } else {
            
            let article: Article = articles[indexPath.row]
            
            let detailViewController = DetailViewController.detailViewControllerForArticle(article, animation: false)
            navigationController?.pushViewController(detailViewController, animated: true)
            
        }
            
    }
    
}

extension InspireViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == self.showCollectionView {

            let cellWidth = (fullScreenSize.width / 3) - 7.5

            return CGSize(width: cellWidth, height: cellWidth)
            
        }

        return CGSize(width: (self.view.frame.size.width - 30) / 2, height: 80)
    }
    
}
