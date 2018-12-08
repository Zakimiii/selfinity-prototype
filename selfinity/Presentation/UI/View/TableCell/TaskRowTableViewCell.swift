//
//  TaskRowTableViewCell.swift
//  selfinity
//
//  Created by Apple on 2018/10/09.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class TaskRowTableViewCell: UITableViewCell {

    @IBOutlet weak var detailView: UILabel!
    @IBOutlet weak var gradationView: GradationView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var checkButton: CheckButtonView!
    
    func setFontSize(_ size: Int) {
        titleLabel.font = UIFont(name: Constant.fontMedium, size: CGFloat(size))
    }
    
    func setLightFontSize(_ size: Int) {
        titleLabel.font = UIFont(name: Constant.fontLight, size: CGFloat(size))
    }
}
