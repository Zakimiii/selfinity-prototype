//
//  FolderTableViewCell.swift
//  selfinity
//
//  Created by Apple on 2018/10/11.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class FolderTableViewCell: UITableViewCell {
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.setImage(R.image.back()!.withRenderingMode(.alwaysTemplate), for: .normal)
            backButton.setImage(R.image.back()!.withRenderingMode(.alwaysTemplate), for: .highlighted)
            backButton.tintColor = Constant.basePlaceHolderColor
            backButton.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.textColor = Constant.baseStringColor
    }
}
