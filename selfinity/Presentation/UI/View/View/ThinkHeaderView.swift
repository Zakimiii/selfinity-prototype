//
//  ThinkHeaderView.swift
//  selfinity
//
//  Created by Apple on 2018/10/11.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class ThinkHeaderView: UIView {
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
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    private func loadNib() {
        guard let view = Bundle(for: type(of: self)).loadNibNamed(R.nib.thinkHeaderView.name, owner: self, options: nil)?.first as? UIView else {
            return
        }
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func buttonHideMode() {
        self.closeButton.isHidden = true
        self.backButton.isHidden = true
        self.nextButton.isHidden = true
        self.titleLabelRight.constant -= 110
    }
    
    func onlyCloseMode() {
        self.closeButton.isHidden = false
        self.backButton.isHidden = true
        self.nextButton.isHidden = true
        self.titleLabelRight.constant -= 80
    }
}
