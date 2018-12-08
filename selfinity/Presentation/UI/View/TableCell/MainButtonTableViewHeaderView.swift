//
//  MainButtonTableViewHeaderView.swift
//  selfinity
//
//  Created by Apple on 2018/10/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class MainButtonTableViewHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titileLabel: UILabel! {
        didSet {
            titileLabel.text = R.string.localizable.mainTabText1()
        }
    }
    @IBOutlet weak var closeButton: SimpleButton! {
        didSet {
            closeButton.layer.shadowColor = Constant.basePlaceHolderColor.cgColor
            closeButton.layer.shadowOpacity = 0.3
            closeButton.layer.shadowOffset = CGSize.zero
            closeButton.layer.shadowRadius = 15
        }
    }
    @IBOutlet weak var nextButton: SimpleButton! {
        didSet {
            nextButton.transform = CGAffineTransform(scaleX: -1, y: 1)
            nextButton.layer.shadowColor = Constant.basePlaceHolderColor.cgColor
            nextButton.layer.shadowOpacity = 0.3
            nextButton.layer.shadowOffset = CGSize.zero
            nextButton.layer.shadowRadius = 15
        }
    }
    @IBOutlet weak var backButton: SimpleButton! {
        didSet {
            backButton.layer.shadowColor = Constant.basePlaceHolderColor.cgColor
            backButton.layer.shadowOpacity = 0.3
            backButton.layer.shadowOffset = CGSize.zero
            backButton.layer.shadowRadius = 15
        }
    }
    @IBOutlet weak var titleLabelRight: NSLayoutConstraint!
    @IBOutlet weak var closeButtonWidth: NSLayoutConstraint!
    
    func buttonHideMode() {
        self.closeButtonWidth.constant = 30
        self.closeButton.isHidden = true
        self.backButton.isHidden = true
        self.nextButton.isHidden = true
        self.titleLabelRight.constant -= 110
    }
    
    func onlyCloseMode() {
        self.closeButtonWidth.constant = 30
        self.closeButton.isHidden = false
        self.backButton.isHidden = true
        self.nextButton.isHidden = true
        self.titleLabelRight.constant -= 80
    }
    
    func hideCloseMode() {
        self.closeButtonWidth.constant = 0
        self.closeButton.isHidden = true
        self.backButton.isHidden = false
        self.nextButton.isHidden = false
        self.titleLabelRight.constant = 10
    }
}
