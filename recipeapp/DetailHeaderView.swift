//
//  DetailHeaderView.swift
//  recipeapp
//
//  Created by Dias Dosymbaev on 4/18/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Sugar
import Cartography
import ChameleonFramework

protocol DetailHeaderViewDelegate {
    //    func didSaveProfile()
}

final class DetailHeaderView: UIView {
    
    var delegate: DetailHeaderViewDelegate?
    
    lazy var backroundImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "image-snack")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
    }
    
    lazy var timeLabel: UILabel = {
        return UILabel().then{
            $0.text = "45 минут"
            $0.font = .systemFont(ofSize: 12)
            $0.textColor = HexColor("473923")
        }
    }()
    
    lazy var scaleLabel: UILabel = {
        return UILabel().then{
            $0.text = "264 ккал"
            $0.font = .systemFont(ofSize: 12)
            $0.textColor = HexColor("473923")
        }
    }()
    
    lazy var stageLabel: UILabel = {
        return UILabel().then{
            $0.text = " ПРОСТО "
            $0.font = .systemFont(ofSize: 12)
            $0.textColor = HexColor("FFFFFF")
            $0.backgroundColor = HexColor("5AD25D")
            $0.layer.cornerRadius = 3
            $0.layer.masksToBounds = true
        }
    }()
    
    lazy var clockIconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = #imageLiteral(resourceName: "clock")
    }
    
    lazy var scaleIconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = #imageLiteral(resourceName: "scales")
    }

    lazy var lineView = UIView().then {
        $0.backgroundColor = HexColor("473923")
        $0.alpha = 0.3
    }
    
    lazy var fatLabel: UILabel = {
        return UILabel().then{
            $0.text = "Жиры"
            $0.font = UIFont(name: "Cheque-Black", size: 14)
            $0.textColor = HexColor("473923")
        }
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        self.backgroundColor = HexColor("F4F3F2")
        [backroundImageView, stageLabel, timeLabel, clockIconImageView, scaleLabel, scaleIconImageView, lineView].forEach {
            self.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        constrain(backroundImageView, self , clockIconImageView) {
            
            $0.leading == $1.leading + 15
            $0.trailing == $1.trailing - 15
            $0.height == 180
            $0.bottom == $2.top - 20
            
            $2.leading == $1.leading + 15
            $2.bottom == $1.bottom - 20
        }
        constrain(clockIconImageView, timeLabel, scaleIconImageView, scaleLabel, self) {
            $1.centerY == $0.centerY
            $1.leading == $0.trailing + 5
            
            $2.centerX == $4.centerX - 15
            $2.centerY == $1.centerY
            
            $3.centerY == $2.centerY
            $3.leading == $2.trailing + 5
        }
        constrain(self, stageLabel, scaleLabel) {
            $1.trailing == $0.trailing - 15
            $1.centerY == $2.centerY
            $1.height == 20
        }
        constrain( lineView, clockIconImageView, self ) {
            $0.height == 0.5
            $0.leading == $2.leading + 15
            $0.trailing == $2.trailing - 15
            $0.bottom == $0.bottom - 1
            $0.top == $1.bottom + 15
        }
        
    }
    
}

