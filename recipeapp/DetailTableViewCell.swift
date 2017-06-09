//
//  DetailTableViewCell.swift
//  recipeapp
//
//  Created by Dias Dosymbaev on 4/18/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Cartography
import ChameleonFramework

class DetailTableViewCell: UITableViewCell {
    //MARK: - Properties
    
    lazy var stepLabel: UILabel = {
        return UILabel().then{
            $0.textColor = HexColor("473923")
            $0.numberOfLines = 0
            $0.font = .systemFont(ofSize: 15)
            $0.text = "Перетерите все ингредиенты для теста в блендере. Тесто оберните бумажным полотенцем и отправьте на 30 минут в холодильник."
        }
    }()
    
    lazy var stepImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = #imageLiteral(resourceName: "placeholder1")
    }
    
    lazy var dividerView = UIView().then {
        $0.backgroundColor = HexColor("473923")
        $0.layer.cornerRadius = 19
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = HexColor("F4F3F2")?.cgColor
    }
    
    lazy var dividerLabel: UILabel = {
        return UILabel().then{
            $0.textColor = HexColor("F4F3F2")
            $0.font = UIFont(name: "Cheque-Black", size: 17)
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
        [stepImageView, stepLabel, dividerView, dividerLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setUpConstraints() {
        constrain(stepImageView, stepLabel, contentView, dividerView, dividerLabel) {
            $0.top == $2.top
            $0.width == $2.width
            $0.centerX == $2.centerX
            $0.height == 200
            
            $1.top == $0.bottom + 20
            $1.bottom == $2.bottom - 15
            $1.width == $2.width - 20
            $1.centerX == $2.centerX
            
            $3.width == 38
            $3.height == 38
            $3.centerY == $0.bottom
            $3.centerX == $2.centerX
            
            $4.center == $3.center
        }
    }
}

extension DetailTableViewCell {
    
    func setupSteps(urlString: String?, stepText: String?, divideStepText: String?) {
        if let url = urlString{
            stepImageView.kf.setImage(with: URL(string: "\(url)"))}
        stepLabel.text = stepText
        dividerLabel.text = divideStepText
    }
}


