//
//  SoundTableViewCell.swift
//  recipeapp
//
//  Created by Damir Kazbekov on 6/4/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Cartography

class SoundTableViewCell: UITableViewCell {
    
    lazy var titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 18)
        $0.text = "Звук"
    }
    
    let switchIndicator = UISwitch()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        [titleLabel, switchIndicator].forEach{
            contentView.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        constrain(titleLabel, switchIndicator, self) {
            titleLabel, switchIndicator, view in
            titleLabel.top == view.top
            titleLabel.bottom == view.bottom
            titleLabel.left == view.left + 15
            switchIndicator.right == view.right - 15
            switchIndicator.top == view.top + 16        }
    }
    
}
