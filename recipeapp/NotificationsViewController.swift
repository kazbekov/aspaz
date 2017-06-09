//
//  NotificationsViewController.swift
//  recipeapp
//
//  Created by Damir Kazbekov on 6/4/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Cartography
import ChameleonFramework

class NotificationsViewController: UIViewController {
    //MARK: -Parameters
    var notifications: [NotificationItem] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotificationsTableViewCell.self, forCellReuseIdentifier: "NotificationsCell")
        tableView.tableFooterView = UIView()
        return tableView
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
    
    private lazy var addNotificationButton: UIButton = {
        return UIButton().then {
            $0.setTitle("Add a notification", for: .normal)
            $0.backgroundColor = HexColor("302E3D")
            $0.layer.cornerRadius = 3
            $0.addTarget(self, action: #selector(addFunc), for: .touchUpInside)
        }
    }()
    
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
        setUpNavigation()
        setUpViews()
        setUpConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationsViewController.refreshList), name: NSNotification.Name(rawValue: "TodoListShouldRefresh"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func refreshList() {
        notifications = NotificationList.sharedInstance.allItems()
        if (notifications.count >= 64) {
            self.navigationItem.rightBarButtonItem!.isEnabled = false // disable 'add' button
        }
        emptyOrNot()
        tableView.reloadData()
    }
    
    //MARK: -Setups
    func setUpNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFunc))
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        title = "Уведомления"
        navigationController?.navigationBar.barTintColor = HexColor("302E3D")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
    }
    
    
    func setUpViews() {
        view.backgroundColor = HexColor("F4F3F2")
        [emptyStateView, tableView].forEach {
            view.addSubview($0)
        }
        [emptyStateIconImageView, emptyStateTitleLabel, emptyStateSubtitleLabel, addNotificationButton].forEach {
            emptyStateView.addSubview($0)
        }
        UIApplication.shared.statusBarStyle = .default
    }
    
    func setUpConstraints() {
        constrain(emptyStateView, tableView, view) {empty, table, view in
            table.edges == view.edges
            
            empty.edges == view.edges
        }
        
        constrain(emptyStateView, emptyStateIconImageView, emptyStateTitleLabel, emptyStateSubtitleLabel, addNotificationButton) {
            $1.centerY == $0.centerY - view.height/5
            $1.centerX == $0.centerX
            
            $2.centerX == $0.centerX
            $2.top == $1.bottom + 30
            $2.width == $0.width
            
            $3.centerX == $0.centerX
            $3.top == $2.bottom + 10
            $3.width == $0.width - view.width/5
            
            $4.centerX == $0.centerX
            $4.bottom == $0.bottom - 10
            $4.width == $0.width - view.width/5
            $4.height == 50
        }
    }
    
    //MARK: -Actions
    func setText(){
        title = "Notifications"
    }
    
    func addFunc(){
        navigationController?.pushViewController(AddNotificationsViewController(), animated: true)
    }
    
    func emptyOrNot() {
        if notifications.count == 0 {
            tableView.alpha = 0
            emptyStateView.alpha = 1
        } else {
            tableView.alpha = 1
            emptyStateView.alpha = 0
        }
        view.layoutIfNeeded()
    }
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        //        navigationController?.pushViewController(EditNotificationsViewController(), animated: true)
    }
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell", for: indexPath) as! NotificationsTableViewCell
        let notification = notifications[(indexPath as NSIndexPath).row] as NotificationItem
        
        cell.titleLabel.text = notification.title as String!
        if (notification.isOverdue) {
            cell.timeLabel.textColor = UIColor.red
        } else {
            cell.timeLabel.textColor = UIColor.black
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "'Due' MMM dd 'at' h:mm a" // example: "Due Jan 01 at 12:00 PM"
        cell.timeLabel.text = dateFormatter.string(from: notification.deadline as Date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = notifications.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            NotificationList.sharedInstance.removeItem(item)
            emptyOrNot()
            self.navigationItem.rightBarButtonItem!.isEnabled = true
        }
    }
}
