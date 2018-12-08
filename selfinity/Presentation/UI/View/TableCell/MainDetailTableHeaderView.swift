//
//  MainDetailTableHeaderView.swift
//  selfinity
//
//  Created by Apple on 2018/10/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class MainDetailTableHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func defaultTextMode() {
        detailLabel.setHelveticaNeueLightFontSize(15)
        detailLabel.textColor = Constant.baseStringColor
    }
    
    func strongTextMode() {
        detailLabel.setHelveticaNeueMediumFontSize(20)
        detailLabel.textColor = Constant.subColor
    }
}
