//
//  HomeTableViewCell.swift
//  selfinity
//
//  Created by Apple on 2018/10/09.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var otherView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        baseView.layer.cornerRadius = 15
        baseView.layer.masksToBounds = true
        baseView.layer.borderWidth = 1
        baseView.layer.borderColor = Constant.borderColor.cgColor
        otherView.layer.shadowColor = Constant.baseStringColor.cgColor
        otherView.layer.shadowOpacity = 0.5
        otherView.layer.shadowOffset = CGSize.zero
        otherView.layer.shadowRadius = 15
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected == true {
            baseView.waveCenter()
        }
    }
}
