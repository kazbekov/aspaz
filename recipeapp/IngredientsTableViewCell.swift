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

class IngredientsTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    var index = Int()
    var indexFood = Int()
    var title = String()
    var categoryphp = String()
    lazy var checkArray = [Bool]()
    lazy var foodsArray = [[String:Any]]()
    lazy var checked = false
    let defaults = UserDefaults.standard
    lazy var ingredientLabel: UILabel = {
        return UILabel().then{
            $0.font = UIFont(name: "Cheque-Regular", size: 15)
            $0.textColor = HexColor("473923")
        }
    }()
    
    lazy var buyButton: UIButton = {
        return UIButton().then {
            $0.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            $0.addTarget(self, action: #selector(buyButtonClicked), for: .touchUpInside)
        }
    }()
    
    lazy var countLabel: UILabel = {
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
        [ingredientLabel, buyButton, countLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setUpConstraints() {
        constrain(ingredientLabel, self, buyButton, countLabel) {
            $0.top == $1.top + 2.5
            $0.left == $1.left + 15
            
            $2.height == 50
            $2.width == 50
            $2.trailing == $1.trailing - 15
            $2.left == $1.right
            $2.centerY == $1.centerY - 5
            
            $3.leading == $1.leading + 15
            $3.top == $0.bottom
            $3.height == 20
        }
    }
}

extension IngredientsTableViewCell {
    
    func getIndex(index: Int?, indexFood: Int?, categoryphp: String?){
        guard let categoryphpp = categoryphp, let indexofFood = indexFood, let indexIng = index else {return}
        self.index = indexIng
        self.indexFood = indexofFood
        self.categoryphp = categoryphpp
        
        if defaults.array(forKey: self.categoryphp) != nil{
            self.foodsArray = defaults.array(forKey: self.categoryphp) as! [[String : Any]]
        }
        
        checkArray = foodsArray[self.indexFood]["ingredients_check"] as! [Bool]
        checked = checkArray[self.index]
        if !checked {
            buyButton.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        } else {
            buyButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        }
    }
    
    func buyButtonClicked(){
        if !checked {
            buyButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            checkArray[index] = true
            foodsArray[self.indexFood]["ingredients_check"] = checkArray
            defaults.set(foodsArray, forKey: categoryphp)
        } else {
            buyButton.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            checkArray[index] = false
            foodsArray[self.indexFood]["ingredients_check"] = checkArray
            defaults.set(foodsArray, forKey: categoryphp)
        }
    }
    
    func dismiss(){
        buyButton.alpha = 0
        buyButton.isUserInteractionEnabled = false
    }
    
}



