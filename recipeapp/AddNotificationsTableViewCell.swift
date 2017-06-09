//
//  AddNotificationsTableViewCell.swift
//  recipeapp
//
//  Created by Damir Kazbekov on 6/4/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Cartography
import KMPlaceholderTextView

class AddNotificationsTableViewCell: UITableViewCell {
    
    lazy var titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 14)
        $0.text = "Начало"
    }
    
    lazy var timeLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 18)
        $0.text = "Суббота, 22 октября"
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
            titleLabel.top == view.top + 23
            titleLabel.left == view.left + 15
            timeLabel.left == view.left + 15
            timeLabel.top == titleLabel.bottom + 11
        }
    }
    
}
