//
//  ViewController.swift
//  recipeapp
//
//  Created by Dias Dosymbaev on 4/17/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Sugar
import MessageUI
import Cartography
import ChameleonFramework

class CategoriesController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: -Properties
    let titles = ["Выпечка", "Горячее", "Десерты", "Закуски", "На завтрак", "Напитки", "Салаты", "Соусы", "Супы"]
    let images = [#imageLiteral(resourceName: "image-bake"), #imageLiteral(resourceName: "image-hot"), #imageLiteral(resourceName: "image-dessert"), #imageLiteral(resourceName: "image-snack"), #imageLiteral(resourceName: "image-breakfast"), #imageLiteral(resourceName: "image-drinks"), #imageLiteral(resourceName: "image-salad"), #imageLiteral(resourceName: "image-souce"), #imageLiteral(resourceName: "image-soup")]
    var titleText: String?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tableView.register(CategoriesTableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = HexColor("302E3D")
        return tableView
    }()
    
    //MARK: -Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavBar()
        title = "Категорий"
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        
        if let viewControllers = self.navigationController?.viewControllers {
            let previousVC: UIViewController? = viewControllers.count >= 2 ? viewControllers[viewControllers.count - 2] : nil;
            previousVC?.title = ""
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = "Главная"
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
    }
    
    //MARK: -Setups
    
    func setUpViews() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = []
        setUpNavBar()
        
        [tableView].forEach{
            view.addSubview($0)
        }
    }
    func setUpNavBar(){
        title = "Категорий"
        UIApplication.shared.setStatusBarHidden(false, with: .slide)
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : HexColor("F4F3F2")]
                navigationController?.navigationBar.barTintColor = HexColor("DA3C65")
        navigationController?.navigationBar.barTintColor = HexColor("302E3D")
        self.navigationItem.setRightBarButton( (UIBarButtonItem(image:#imageLiteral(resourceName: "star"), style: .plain, target:self, action:#selector(openFav))), animated: false)
        self.navigationItem.setLeftBarButton( (UIBarButtonItem(image:#imageLiteral(resourceName: "alarm_clock"), style: .plain, target:self, action:#selector(openNot))), animated: false)
        navigationController?.navigationBar.tintColor = .white
    }
    
    func setUpConstraints() {
        constrain(tableView, view){ tableView, view in
            tableView.edges == view.edges
        }
    }
    
    func openFav(){
        let destVC = FavViewController()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func openNot(){
        let destVC = NotificationsViewController()
        navigationController?.pushViewController(destVC, animated: true)
    }
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! CategoriesTableViewCell
        let destVC = HomeController()
        destVC.titleText = cell.titleLabel.text!
        destVC.category = indexPath.row
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath as IndexPath) as! CategoriesTableViewCell
        cell.selectionStyle = .none
        cell.titleLabel.text = titles[indexPath.row]
        cell.iconImageView.image = images[indexPath.row]
        return cell
    }
}
