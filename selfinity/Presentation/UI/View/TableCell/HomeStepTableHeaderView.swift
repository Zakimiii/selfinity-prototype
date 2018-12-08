//
//  HomeStepTableHeaderView.swift
//  selfinity
//
//  Created by Apple on 2018/10/10.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class HomeStepTableHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var gradationView: GradationView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
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
}
