//
//  NotificationsTableViewCell.swift
//  recipeapp
//
//  Created by Damir Kazbekov on 6/4/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Cartography

class NotificationsTableViewCell: UITableViewCell {
    
    lazy var titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 18)
        $0.text = "Первый день"
    }
    
    lazy var timeLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 14)
        $0.text = "22 - 23 октября, 0:00"
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        [titleLabel, timeLabel].forEach{
            contentView.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        constrain(titleLabel, timeLabel, self) {
            titleLabel, timeLabel, view in
            titleLabel.top == view.top + 20
            titleLabel.left == view.left + 11
            timeLabel.left == view.left + 11
            timeLabel.top == titleLabel.bottom + 8
        }
    }
    
}
