//
//  PagenationButton.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class PagenationButton: UIView {

    @IBOutlet weak var nextButton: GradationButton! {
        didSet {
            nextButton.layer.shadowColor = Constant.basePlaceHolderColor.cgColor
            nextButton.layer.shadowOpacity = 0.3
            nextButton.layer.shadowOffset = CGSize.zero
            nextButton.layer.shadowRadius = 15
            nextButton.layer.shadowPath = UIBezierPath(roundedRect: nextButton.bounds, cornerRadius: 10).cgPath
            nextButton.layer.shouldRasterize = true
            nextButton.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    @IBOutlet weak var backButton: GradationButton! {
        didSet {
            backButton.layer.shadowColor = Constant.basePlaceHolderColor.cgColor
            backButton.layer.shadowOpacity = 0.3
            backButton.layer.shadowOffset = CGSize.zero
            backButton.layer.shadowRadius = 15
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    private func loadNib() {
        guard let view = Bundle(for: type(of: self)).loadNibNamed(R.nib.pagenationButton.name, owner: self, options: nil)?.first as? UIView else {
            return
        }
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        view.backgroundColor = UIColor.clear
    }
}
