//
//  FavViewController.swift
//  recipeapp
//
//  Created by Damir Kazbekov on 6/2/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Sugar
import Cartography
import ChameleonFramework

class FavViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    //MARK: - Properties
    var titleText: String = ""
    var favfoodsArray = [[String:Any]]()
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
    
    private lazy var emptyStateView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var emptyStateIconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = #imageLiteral(resourceName: "pot")
    }
    
    private lazy var emptyStateTitleLabel = UILabel().then {
        $0.text = "You don't have notifications"
        $0.textAlignment = .center
    }
    
    private lazy var emptyStateSubtitleLabel: UILabel = {
        return UILabel().then {
            $0.text = "Seems like you haven't added notifications."
            $0.textColor = HexColor("858585")
            $0.font = .systemFont(ofSize: 14)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
    }()
    
    
    //MARK: -Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        if defaults.array(forKey: "fav") != nil{
            favfoodsArray = defaults.array(forKey: "fav") as! [[String:Any]]
            self.collectionView.reloadData()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavBar()
        emptyOrNot()
        if let viewControllers = self.navigationController?.viewControllers {
            let previousVC: UIViewController? = viewControllers.count >= 2 ? viewControllers[viewControllers.count - 2] : nil;
            previousVC?.title = ""
        }
    }
    
    //MARK: -Setups
    func setUpViews(){
        setUpNavBar()
        view.backgroundColor = HexColor("F4F3F2")
        
        [emptyStateView,collectionView].forEach {
            view.addSubview($0)
        }
        
        [emptyStateIconImageView, emptyStateTitleLabel, emptyStateSubtitleLabel].forEach {
            emptyStateView.addSubview($0)
        }
    }
    func setUpConstraints(){
        constrain(collectionView, emptyStateView, view){
            collection, empty, view in
            collection.edges == view.edges
            empty.edges == view.edges
        }
        
        constrain(emptyStateView, emptyStateIconImageView, emptyStateTitleLabel, emptyStateSubtitleLabel) {
            $1.centerY == $0.centerY - view.height/7
            $1.centerX == $0.centerX
            
            $2.centerX == $0.centerX
            $2.top == $1.bottom + 30
            $2.width == $0.width
            
            $3.centerX == $0.centerX
            $3.top == $2.bottom + 10
            $3.width == $0.width - view.width/5
        }
    }
    func setUpNavBar(){
        title = "Избранные"
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : HexColor("F4F3F2") ?? ""]
        navigationController?.navigationBar.barTintColor = HexColor("302E3D")
        navigationController?.navigationBar.tintColor = .white
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.isTranslucent = false
        
    }
    
    func emptyOrNot() {
        if favfoodsArray.count == 0 {
            collectionView.alpha = 0
            emptyStateView.alpha = 1
        } else {
            collectionView.alpha = 1
            emptyStateView.alpha = 0
        }
        view.layoutIfNeeded()
    }
    
    //MARK: -Actions
}

// MARK: UICollectionViewDataSource

extension FavViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.favfoodsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return (collectionView.dequeueReusableCell(withReuseIdentifier: self.homeCellIdentifier,for: indexPath as IndexPath) as! HomeCollectionViewCell).then {
            $0.layer.cornerRadius = 5
            $0.layer.masksToBounds = true
            guard let url = self.favfoodsArray[indexPath.row]["photo"] as? String, let title = self.favfoodsArray[indexPath.row]["title"] as? String, let time = self.favfoodsArray[indexPath.row]["time"] as? String, let calory = self.favfoodsArray[indexPath.row]["calory"] as? String else {return}
            $0.setupCell(urlString: url, title: title, time: time, calories: calory)
        }
    }
    
}

// MARK: UICollectionViewDelegate

extension FavViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! HomeCollectionViewCell
        let destVC = DetailController()
        guard let instructions = self.favfoodsArray[indexPath.row]["instructions"] as? [String], let imagesUrl = self.favfoodsArray[indexPath.row]["ingredients_photos"] as? [String], let ingredients = self.favfoodsArray[indexPath.row]["ingredients"] as? [String], let ingredients_detail = self.favfoodsArray[indexPath.row]["ingredients_detail"] as? [String] else {return}
        destVC.titleText = cell.titleLabel.text
        destVC.backgroundImage = cell.titleImageView.image
        destVC.caloryText = cell.scaleLabel.text
        destVC.timeText = cell.timeLabel.text
        destVC.imagesURL = imagesUrl
        destVC.instructions = instructions
        destVC.ingredients = ingredients
        destVC.ingredients_details = ingredients_detail
        self.navigationController?.pushViewController(destVC, animated: true)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
