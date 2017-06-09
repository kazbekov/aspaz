//
//  HomeCollectionViewCell.swift
//  recipeapp
//
//  Created by Dias Dosymbaev on 4/17/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Sugar
import Cartography
import ChameleonFramework
import Kingfisher

final class HomeCollectionViewCell: UICollectionViewCell {
    //MARK: -Properties
    var index: Int?
    var title: String?
    var categoryKey: String?
    lazy var favfoodsArray = [[String:Any]]()
    lazy var foodsArray = [[String:Any]]()
    lazy var checked = false
    let defaults = UserDefaults.standard
    
    lazy var titleLabel: UILabel = {
        return UILabel().then{
            $0.text = "Тыквенный пирог"
            $0.font = UIFont(name: "Cheque-Black", size: 17)
            $0.textColor = HexColor("473923")
        }
    }()
    
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
   
    lazy var favouriteButton: UIButton = {
        return UIButton().then {
            $0.addTarget(self, action: #selector(favouriteButtonClicked), for: .touchUpInside)
        }
    }()
    
    lazy var titleImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = #imageLiteral(resourceName: "image-snack")
    }
    
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
    
    lazy var shadowView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.shadowColor = HexColor("989898")?.cgColor
        $0.layer.shadowRadius = 5.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowOpacity = 1
        $0.layer.masksToBounds = false
        $0.layer.shouldRasterize = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setUpViews() {
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        
        [shadowView, titleImageView, titleLabel, clockIconImageView, scaleIconImageView, timeLabel, scaleLabel, stageLabel, favouriteButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        constrain(titleLabel, contentView, titleImageView, clockIconImageView, timeLabel) {
            $0.top == $2.bottom + 10
            $0.leading == $1.leading + 10
            
            $2.top == $1.top
            $2.width == $1.width
            $2.centerX == $1.centerX
            $2.height == $1.height * 0.7
            
            $3.top == $0.bottom + 10
            $3.leading == $1.leading + 10
            
            $4.centerY == $3.centerY
            $4.leading == $3.trailing + 5
        }
        constrain( timeLabel, scaleIconImageView, scaleLabel) {
            $1.leading == $0.trailing + 20
            $1.centerY == $0.centerY
            
            $2.centerY == $1.centerY
            $2.leading == $1.trailing + 5
        }
        
        constrain(stageLabel, titleImageView) {
            $0.bottom == $1.bottom - 5
            $0.leading == $1.leading + 5
            $0.height == 20
        }
        
        constrain(favouriteButton, contentView) {
            $0.bottom == $1.bottom - 8
            $0.trailing == $1.trailing - 8
            $0.height == 50
            $0.width == 50
        }
    }
    
}

extension HomeCollectionViewCell {
    
    func setupCell(urlString: String?, title: String?, time: String?, calories: String?) {
        if let url = urlString{
            titleImageView.kf.setImage(with: URL(string: "\(url)"))}
        titleLabel.text = title
        timeLabel.text = time
        scaleLabel.text = calories
    }
    
    func getIndex(index: Int?, title:  String?, categoryKey: String?){
        self.index = index
        self.title = title
        self.categoryKey = categoryKey
    }
    
    func favouriteButtonClicked(){
        guard let index = index, let key = categoryKey else {return}

        foodsArray = defaults.array(forKey: "\(key)") as! [[String:Any]]
        checked = foodsArray[index]["checked"] as! Bool
        if !checked {
            favouriteButton.setImage(#imageLiteral(resourceName: "filled_star"), for: .normal)
            if defaults.array(forKey: "fav") != nil {
                favfoodsArray = defaults.array(forKey: "fav") as! [[String:Any]]
            }
            favfoodsArray.append(foodsArray[index])
            defaults.set(self.favfoodsArray, forKey: "fav")
            print(favfoodsArray.count)
            foodsArray[index]["checked"] = true
            defaults.set(foodsArray, forKey: "\(key)")
            favRefresh()
        } else {
            favouriteButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
            favfoodsArray = defaults.array(forKey: "fav") as! [[String:Any]]
            for i in 0...favfoodsArray.count-1{
                if favfoodsArray[i]["title"] as? String == title {
                    favfoodsArray.remove(at: i)
                    print(favfoodsArray.count)
                }
            }
            defaults.set(self.favfoodsArray, forKey: "fav")
            foodsArray[index]["checked"] = false
            defaults.set(foodsArray, forKey: "\(key)")
            favRefresh()
        }
    }
    
    func favRefresh(){
        guard let index = index, let key = categoryKey else {return}
        
        foodsArray = defaults.array(forKey: "\(key)") as! [[String:Any]]
        checked = foodsArray[index]["checked"] as! Bool
        if !checked {
            favouriteButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
        } else{
            favouriteButton.setImage(#imageLiteral(resourceName: "filled_star"), for: .normal)
        }
    }
}

