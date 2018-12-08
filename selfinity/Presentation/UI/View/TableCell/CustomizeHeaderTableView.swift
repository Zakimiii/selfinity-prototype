//
//  CustomizeHeaderTableView.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class CustomizeHeaderTableView: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var customizeButton: CusutomizeButton!
    
    func setFontSize(_ size: Int) {
        titleLabel.font = UIFont(name: Constant.fontMedium, size: CGFloat(size))
    }
    
    func setLightFontSize(_ size: Int) {
        titleLabel.font = UIFont(name: Constant.fontLight, size: CGFloat(size))
    }
}
