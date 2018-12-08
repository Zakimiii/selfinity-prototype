





//
//  SwitchTableViewCell.swift
//  selfinity
//
//  Created by Apple on 2018/10/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected == true {
            self.contentView.clipsToBounds = true
            self.contentView.waveCenter()
        }
    }
}
