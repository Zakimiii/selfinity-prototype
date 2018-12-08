//
//  MainTableViewHeaderView.swift
//  selfinity
//
//  Created by Apple on 2018/10/08.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class MainTableViewHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    
    func setFontSize(_ size: Int) {
        titleLabel.font = UIFont(name: Constant.fontMedium, size: CGFloat(size))
    }
    
    func setLightFontSize(_ size: Int) {
        titleLabel.font = UIFont(name: Constant.fontLight, size: CGFloat(size))
    }
}
