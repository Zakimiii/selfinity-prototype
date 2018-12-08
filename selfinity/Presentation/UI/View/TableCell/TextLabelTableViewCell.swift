//
//  TextLabelTableViewCell.swift
//  selfinity
//
//  Created by Apple on 2018/10/17.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class TextLabelTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var otherView: UIView!
    func setFontSize(_ size: Int) {
        titleLabel.font = UIFont(name: Constant.fontMedium, size: CGFloat(size))
    }
    
    func setLightFontSize(_ size: Int) {
        titleLabel.font = UIFont(name: Constant.fontLight, size: CGFloat(size))
    }
    
    override func awakeFromNib() {
        super.layoutSubviews()
//        baseView.layer.cornerRadius = 15
//        baseView.layer.masksToBounds = true
        baseView.layer.borderWidth = 1
        baseView.layer.borderColor = Constant.borderColor.cgColor
        otherView.layer.shadowColor = Constant.baseStringColor.cgColor
        otherView.layer.shadowOpacity = 0.5
        otherView.layer.shadowOffset = CGSize.zero
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected == true {
            baseView.waveCenter()
        }
    }
}
