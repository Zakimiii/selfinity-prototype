//
//  StepListTableViewHeaderView.swift
//  selfinity
//
//  Created by Apple on 2018/10/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class StepListTableViewHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var newButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var newButton: GradationButton!
    
    @IBOutlet weak var editButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var editButton: GradationButton!
    
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
    
    func defaultMode() {
        self.detailLabel.isHidden = true
        self.detailLabelHeight.constant = 0
        self.editButtonHeight.constant = 0
        self.editButton.isHidden = true
        self.newButtonHeight.constant = 0
        self.newButton.isHidden = true
    }
}
