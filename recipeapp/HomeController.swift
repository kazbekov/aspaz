//
//  HomeController.swift
//  recipeapp
//
//  Created by Dias Dosymbaev on 4/17/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Sugar
import Cartography
import ChameleonFramework
import SVProgressHUD

class HomeController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    //MARK: - Properties
    var category: Int?
    lazy var categoriesphp = ["category1.php", "category2.php", "category3.php", "category4.php", "category5.php", "category6.php", "category7.php", "category8.php", "category9.php"]
    lazy var titleText: String = ""
    lazy var foodsArray = [[String:Any]]()
    lazy var favfoodsArray = [[String:Any]]()
    
    let defaults = UserDefaults.standard
    let homeCellIdentifier = "homeCellIdentifier"
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout().then {
            $0.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            $0.minimumInteritemSpacing = 10
            $0.minimumLineSpacing = 10
            $0.itemSize = CGSize(width: self.view.frame.width - 20, height: 216)
        }
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = HexColor("ECEEF1")
            $0.delegate = self
            $0.dataSource = self
            $0.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: self.homeCellIdentifier)
        }
    }()
    
    //MARK: -Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        guard let category = self.category else {return}
        if self.defaults.array(forKey: "\(self.categoriesphp[category])") != nil {
            self.foodsArray = self.defaults.array(forKey: "\(self.categoriesphp[category])") as! [[String:Any]]
        } else{
            urlRequest()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavBar()
        if let viewControllers = self.navigationController?.viewControllers {
            let previousVC: UIViewController? = viewControllers.count >= 2 ? viewControllers[viewControllers.count - 2] : nil;
            previousVC?.title = ""
        }
    }
    
    //MARK: -Setups
    func setUpViews(){
        setUpNavBar()
        SVProgressHUD.setBackgroundColor(.white)
        SVProgressHUD.setForegroundColor(HexColor("302E3D"))
        view.backgroundColor = HexColor("F4F3F2")
        
        [collectionView].forEach {
            view.addSubview($0)
        }
    }
    func setUpConstraints(){
        constrain(collectionView, view){
            collection, view in
            collection.edges == view.edges
        }
    }
    func setUpNavBar(){
        title = titleText
        navigationController?.navigationBar.topItem?.title = "Главная"
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : HexColor("F4F3F2") ?? ""]
        navigationController?.navigationBar.barTintColor = HexColor("302E3D")
        navigationController?.navigationBar.tintColor = .white
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.isTranslucent = false
        
    }
    
    //MARK: -Actions
    func urlRequest(){
        SVProgressHUD.show()
        guard let category = category else {return}
        let urlString = "http://localhost/altay/\(categoriesphp[category])"
        print(urlString)
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
//                SVProgressHUD.dismiss()
                print(error ?? "")
            } else {
                do {
                    guard let category = self.category else {return}
                    self.foodsArray = try JSONSerialization.jsonObject(with: data!, options: []) as! [[String:Any]]
                    self.defaults.set(self.foodsArray, forKey: "\(self.categoriesphp[category])")
                    
                    self.collectionView.reloadData()                } catch let error as NSError {
//                    SVProgressHUD.dismiss()
                    print(error)
                }
            }}.resume()
    }
}

// MARK: UICollectionViewDataSource

extension HomeController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.foodsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return (collectionView.dequeueReusableCell(withReuseIdentifier: self.homeCellIdentifier,for: indexPath as IndexPath) as! HomeCollectionViewCell).then {
            $0.layer.cornerRadius = 5
            $0.layer.masksToBounds = true
            
            guard let url = self.foodsArray[indexPath.row]["photo"] as? String, let title = self.foodsArray[indexPath.row]["title"] as? String, let time = self.foodsArray[indexPath.row]["time"] as? String, let calory = self.foodsArray[indexPath.row]["calory"] as? String, let category = self.category else {return}
            
            $0.getIndex(index: indexPath.row, title: title, categoryKey: self.categoriesphp[category])
            $0.setupCell(urlString: url, title: title, time: time, calories: calory)
            $0.favRefresh()
            SVProgressHUD.dismiss()
        }
    }
    
}

// MARK: UICollectionViewDelegate

extension HomeController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! HomeCollectionViewCell
        let destVC = DetailController()
        guard let instructions = self.foodsArray[indexPath.row]["instructions"] as? [String], let imagesUrl = self.foodsArray[indexPath.row]["ingredients_photos"] as? [String], let ingredients = self.foodsArray[indexPath.row]["ingredients"] as? [String], let ingredients_detail = self.foodsArray[indexPath.row]["ingredients_detail"] as? [String], let category = self.category else {return}
        destVC.titleText = cell.titleLabel.text
        destVC.backgroundImage = cell.titleImageView.image
        destVC.caloryText = cell.scaleLabel.text
        destVC.timeText = cell.timeLabel.text
        destVC.imagesURL = imagesUrl
        destVC.instructions = instructions
        destVC.ingredients = ingredients
        destVC.ingredients_details = ingredients_detail
        destVC.index = indexPath.row
        destVC.categoryphp = self.categoriesphp[category]
        self.navigationController?.pushViewController(destVC, animated: true)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.frame.size
    }
}


