//
//  DetailViewController.swift
//  recipeapp
//
//  Created by Dias Dosymbaev on 4/18/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Sugar
import Cartography
import MXParallaxHeader
import ChameleonFramework

class DetailController: UIViewController, UITableViewDataSource, UITableViewDelegate, MXParallaxHeaderDelegate {
    
    //MARK: -Properties
    
    var ingredients: [String]?
    var ingredients_details: [String]?
    var instructions: [String]?
    var imagesURL: [String]?
    var titleText: String?
    var backgroundImage: UIImage?
    var timeText: String?
    var caloryText: String?
    var index: Int?
    var categoryphp: String?
    
    private let tableHeaderHeight: CGFloat = 300
    
    private lazy var headerView: DetailHeaderView = {
        return DetailHeaderView(frame: CGRect(x: 0, y: 0,
                                                   width: UIScreen.main.bounds.width, height: self.tableHeaderHeight)).then {
                                                    _ in
        }
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(DetailTitleTableViewCell.self, forCellReuseIdentifier: "TitleCell")
        tableView.register(IngredientsTableViewCell.self, forCellReuseIdentifier: "IngredientsCell")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = HexColor("F4F3F2")
        return tableView
    }()
    
    //MARK: -Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        configHeaderView()
        
        headerView.backroundImageView.image = backgroundImage
        headerView.timeLabel.text = timeText
        headerView.scaleLabel.text = caloryText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavBar()
        title = titleText
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        
        if let viewControllers = self.navigationController?.viewControllers {
            let previousVC: UIViewController? = viewControllers.count >= 2 ? viewControllers[viewControllers.count - 2] : nil;
            previousVC?.title = ""
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : HexColor("F4F3F2")]
        //        navigationController?.navigationBar.barTintColor = HexColor("DA3C65")
        navigationController?.navigationBar.barTintColor = HexColor("302E3D")
    }
    
    func setUpConstraints() {
        constrain(tableView, view){ tableView, view in
            tableView.edges == view.edges
        }
    }
    
    func configHeaderView() {
        tableView.parallaxHeader.view = headerView
        tableView.parallaxHeader.height = 250
        tableView.parallaxHeader.mode = MXParallaxHeaderMode.topFill
        tableView.parallaxHeader.minimumHeight = 0
        tableView.parallaxHeader.delegate = self
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
       
        
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return (ingredients_details?.count)!
        } else {
            return (instructions?.count)! + 1
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func addNot(){
        let destVC = AddNotificationsViewController()
        destVC.message = title!
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsCell", for: indexPath as IndexPath) as! IngredientsTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.ingredientLabel.text = ingredients?[indexPath.row]
            cell.countLabel.text = ingredients_details?[indexPath.row]
            
            cell.getIndex(index: indexPath.row, indexFood: self.index!, categoryphp: categoryphp)
            
            return cell
        } else if indexPath.row == 0 && indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath as IndexPath) as! DetailTitleTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.titleLabel.text = titleText
            cell.favouriteButton.addTarget(self, action: #selector(addNot), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath as IndexPath) as! DetailTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.setupSteps(urlString: imagesURL?[indexPath.row-1], stepText: instructions?[indexPath.row-1], divideStepText:  "\(indexPath.row)")
            return cell
        }
        
    }
}
