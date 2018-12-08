//
//  SearchResultTableViewCell.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    
    @IBOutlet weak var creditTitleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.layer.shadowColor = Constant.basePlaceHolderColor.cgColor
            button.layer.shadowOpacity = 0.3
            button.layer.shadowOffset = CGSize.zero
            button.layer.shadowRadius = 10
            button.layer.shadowPath = UIBezierPath(roundedRect: button.bounds, cornerRadius: 10).cgPath
            button.layer.shouldRasterize = true
            button.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var otherView: UIView!
    
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
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected == true {
            baseView.waveCenter()
        }
    }
}
