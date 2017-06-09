//
//  DetailTitleTableViewCell.swift
//  recipeapp
//
//  Created by Dias Dosymbaev on 4/18/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Cartography
import ChameleonFramework

class DetailTitleTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    lazy var checked = false
    lazy var titleLabel: UILabel = {
        return UILabel().then{
            $0.font = UIFont(name: "Cheque-Black", size: 20)
            $0.textColor = HexColor("473923")
        }
    }()
    
    lazy var favouriteButton: UIButton = {
        return UIButton().then {
            $0.setImage(#imageLiteral(resourceName: "alarm_clock"), for: .normal)
//            $0.addTarget(self, action: #selector(favouriteButtonClicked), for: .touchUpInside)
        }
    }()
    
    lazy var ingredientsLabel: UILabel = {
        return UILabel().then{
            $0.font = .systemFont(ofSize: 10, weight: 0.5)
            $0.textColor = HexColor("473923")
            $0.text = "ИНГРИДИЕНТЫ"
            $0.alpha = 0.5
        }
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setups
    
    func setUpViews(){
        [titleLabel, ingredientsLabel, favouriteButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setUpConstraints() {
        constrain(titleLabel, self, ingredientsLabel, favouriteButton) {
            $0.top == $1.top
            $0.left == $1.left + 15
            
            $3.height == 50
            $3.width == 50
            $3.trailing == $1.trailing - 15
            $3.centerY == $1.centerY - 5
            
            $2.leading == $1.leading + 15
            $2.top == $0.bottom
            $2.height == 20
        }
    }
    
//    func favouriteButtonClicked(){
//        if !checked {
//            favouriteButton.setImage(#imageLiteral(resourceName: "filled_star"), for: .normal)
//            checked = true
//        } else {
//            favouriteButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
//            checked = false
//        }
//    }
}



