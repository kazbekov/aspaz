//
//  CategoriesTableViewCell.swift
//  recipeapp
//
//  Created by Dias Dosymbaev on 4/17/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Cartography
import ChameleonFramework

class CategoriesTableViewCell: UITableViewCell {
    //MARK: - Properties
    
    lazy var titleLabel: UILabel = {
        return UILabel().then{
            $0.font = UIFont(name: "Cheque-Black", size: 20)
            $0.textColor = HexColor("F4F3F2")
        }
    }()
    
    lazy var iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    lazy var dimView = UIView().then {
        $0.backgroundColor = HexColor("302E3D")
        $0.alpha = 0.7
    }
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [iconImageView, dimView, titleLabel].forEach {
            contentView.addSubview($0)
        }
        
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setups
    
    func setUpViews(){
        
    }
    
    func setUpConstraints() {
        constrain(titleLabel, contentView, iconImageView, dimView){
            $2.edges == $1.edges
            
            $0.center == $1.center
            
            $3.center == $1.center
            $3.width == $1.width
            $3.height == $1.height + 1
        }
    }
}

