//
//  MessageTableViewCell.swift
//  recipeapp
//
//  Created by Damir Kazbekov on 6/4/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Cartography
import KMPlaceholderTextView

class MessageTableViewCell: UITableViewCell {
    
    lazy var titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 14)
        $0.text = "Сообщение"
    }
    
    lazy var textView: KMPlaceholderTextView = {
        return KMPlaceholderTextView().then {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 14)
            $0.placeholder = "..."
            $0.layer.borderColor = UIColor.black.cgColor
            $0.layer.borderWidth = 1
        }
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }
    
    //Don't work
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        [titleLabel, textView].forEach{
            contentView.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        constrain(titleLabel, textView, self) {
            titleLabel, textView, view in
            titleLabel.top == view.top + 23
            titleLabel.left == view.left + 15
            textView.left == view.left + 15
            textView.right == view.right - 15
            textView.top == titleLabel.bottom + 11
            textView.bottom == view.bottom-11
        }
    }
    
}
