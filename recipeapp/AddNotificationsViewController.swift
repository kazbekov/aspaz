//
//  AddNotificationsViewController.swift
//  recipeapp
//
//  Created by Damir Kazbekov on 6/4/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Sugar
import Cartography
import UserNotifications
import CNPPopupController
import ChameleonFramework

class AddNotificationsViewController: UIViewController {
    
    let titleNames = ["Начало", "Сколько дней"]
    
    var popupController:CNPPopupController?
    var indexPathRow = 0
    var mySelectDateBegin = "Выберите дату"
    var mySelectDateEnd = "Выберите число"
    var mySelectBeginNSDate = NSDate()
    var message: String?
    var muteForPickerData = ["1 day", "2 days", "3 days", "4 days", "5 days", "6 days", "7 days", "8 days", "10 days", "11 days", "12 days", "13 days", "14 days", "15 days"]
    let myPickerView: UIPickerView = UIPickerView()
    var days = 0
    let calendar = Calendar.current
    var isChange = false
    
    private lazy var createNotificationButton: SaveButton = {
        return SaveButton().then{
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
            $0.layer.borderWidth = 2
            $0.layer.cornerRadius = 2
            $0.layer.borderColor = HexColor("302E3D")?.cgColor
            $0.addTarget(self, action: #selector(saveNotification), for: .touchUpInside)
        }
    }()
    
    lazy var myDateFormatter: DateFormatter = {
        return DateFormatter().then{
            $0.dateFormat = "EEEE, dd MMMM, hh:mm a"
            $0.timeZone = NSTimeZone.system
        }
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddNotificationsTableViewCell.self, forCellReuseIdentifier: "AddNotificationsCell")
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageCell")
        tableView.register(SoundTableViewCell.self, forCellReuseIdentifier: "SoundCell")
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private lazy var backButton: UIButton = {
        return UIButton().then {
            $0.setTitle("Back", for: .normal)
            $0.sizeToFit()
            $0.addTarget(self, action: #selector(popView), for: .touchUpInside)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpNavigation()
        setUpConstraints()
    }
    
    //MARK: -Setups
    func setUpNavigation(){
        title = "Add a notification"
        navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func setUpViews() {
        view.backgroundColor = .white
        [tableView, createNotificationButton].forEach{
            view.addSubview($0)
        }
    }
    
    func setUpConstraints() {
        constrain(createNotificationButton, view) { button, view in
            button.left == view.left + 11
            button.right == view.right - 11
            button.bottom == view.bottom - 18
            button.height == 44
        }
    }
    
    func popView() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func saveDatePickerViewButtonPressed(){
        self.popupController?.dismiss(animated: true)
    }
    
    func showPopupWithStyle(_ popupStyle: CNPPopupStyle) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraphStyle.alignment = NSTextAlignment.center
        
        let saveDateButton = SaveButton.init(frame: CGRect(x: 0, y: 0, width: 298, height: 44))
        saveDateButton.backgroundColor = .clear
        saveDateButton.clipsToBounds = true
        saveDateButton.layer.borderWidth = 2
        saveDateButton.layer.cornerRadius = 2
        saveDateButton.layer.borderColor = HexColor("302E3D")?.cgColor
        saveDateButton.textLabel.text = "Сохранить"
        saveDateButton.addTarget(self, action: #selector(saveDatePickerViewButtonPressed), for: .touchUpInside)
        
        
        if indexPathRow == 1{
            let myDatePicker: UIDatePicker = UIDatePicker()
            myDatePicker.width = self.view.width
            myDatePicker.height = 200
            myDatePicker.timeZone = NSTimeZone.local
            myDatePicker.backgroundColor = .white
            myDatePicker.addTarget(self, action: #selector(onDidChangeDate(sender:)), for: .valueChanged)
            let popupController = CNPPopupController(contents:[myDatePicker, saveDateButton])
            popupController.theme = CNPPopupTheme.default()
            popupController.theme.popupStyle = popupStyle
            popupController.delegate = self
            self.popupController = popupController
            popupController.present(animated: true)
        } else if indexPathRow == 2{
            myPickerView.width = self.view.width
            myPickerView.height = 150
            myPickerView.backgroundColor = .white
            myPickerView.delegate = self
            let popupController = CNPPopupController(contents:[myPickerView, saveDateButton])
            popupController.theme = CNPPopupTheme.default()
            popupController.theme.popupStyle = popupStyle
            popupController.delegate = self
            self.popupController = popupController
            popupController.present(animated: true)
        }
    }
    
    
    func saveNotification(){
        let indexPath = NSIndexPath(row: 0, section: 0)
        guard let indetPath = indexPath as? IndexPath else { return }
        let multilineCell = tableView.cellForRow(at: indetPath) as! MessageTableViewCell
        guard let notificationTitle = multilineCell.textView.text else { return }
        if days > 0{
            for i in 0...days {
                let todoItem = NotificationItem(deadline: calendar.date(byAdding: .day, value: i, to: self.mySelectBeginNSDate as Date)!, title: "\(i+1) day: \(notificationTitle)", UUID: UUID().uuidString)
                NotificationList.sharedInstance.addItem(todoItem)
                let _ = self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            let todoItem = NotificationItem(deadline: mySelectBeginNSDate as Date, title: "\(notificationTitle)", UUID: UUID().uuidString)
            NotificationList.sharedInstance.addItem(todoItem)
            let _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension AddNotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        switch indexPath.row {
        case 1:
            self.indexPathRow = 1
            self.showPopupWithStyle(CNPPopupStyle.actionSheet)
        case 2:
            self.indexPathRow = 2
            self.showPopupWithStyle(CNPPopupStyle.actionSheet)
        default: break
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
            if message != "" {
                cell.textView.text = message
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNotificationsCell", for: indexPath) as! AddNotificationsTableViewCell
            cell.titleLabel.text = titleNames[0]
            cell.timeLabel.text = self.mySelectDateBegin
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNotificationsCell", for: indexPath) as! AddNotificationsTableViewCell
            cell.titleLabel.text = titleNames[1]
            if self.days > 0{
                cell.timeLabel.text = "\(self.days+1) days"
            } else {
                cell.timeLabel.text = "\(self.days+1) day"
            }
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNotificationsCell", for: indexPath) as! AddNotificationsTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 137
        } else if indexPath.row == 4{
            return 65
        } else {
            return 80
        }
    }
}

extension AddNotificationsViewController : CNPPopupControllerDelegate, UIPickerViewDelegate {
    
    func popupControllerWillDismiss(_ controller: CNPPopupController) {
        if !isChange{
            self.mySelectDateBegin = myDateFormatter.string(from: Date())
            
        }
        tableView.reloadData()
        print("Popup controller will be dismissed")
    }
    
    func popupControllerDidPresent(_ controller: CNPPopupController) {
        print("Popup controller presented")
    }
    
    func onDidChangeDateByOnStoryboard(sender: UIDatePicker){
        self.onDidChangeDate(sender: sender)
    }
    
    internal func onDidChangeDate(sender: UIDatePicker){
        if indexPathRow == 1{
            self.mySelectDateBegin = (myDateFormatter.string(from: sender.date) as NSString) as String
            self.mySelectBeginNSDate = sender.date as NSDate
            isChange = true
            tableView.reloadData()
        }
    }
    
    func numberOfComponents(in myPickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ myPickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return muteForPickerData.count
    }
    
    func pickerView(_ myPickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return muteForPickerData[row]
    }
    
    func pickerView(_ myPickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        days = row
    }
}

