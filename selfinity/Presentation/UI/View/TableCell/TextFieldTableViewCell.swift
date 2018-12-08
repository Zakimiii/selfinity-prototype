




//
//  TextFieldTableViewCell.swift
//  selfinity
//
//  Created by Apple on 2018/10/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected == true {
            self.contentView.clipsToBounds = true
            self.contentView.waveCenter()
        }
    }
    
    func placeholderMode() {
        detailLabel.textColor = Constant.subPlaceHolderColor
        detailLabel.setHelveticaNeueMediumFontSize(22)
    }
    
    func defaultTextMode() {
        titleLabel.textColor = Constant.baseStringColor
        detailLabel.setHelveticaNeueMediumFontSize(22)
    }
}
