//
//  GradationButton.swift
//  selfinity
//
//  Created by Apple on 2018/10/11.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

@objcMembers
class GradationButton: UIView {
    @IBOutlet weak var gradationView: GradationView!
    @IBOutlet weak var button: UIButton!
    @IBInspectable
    var buttonText: String? {
        get {
            return button?.titleLabel?.text
        }
        set {
            button.setTitle(newValue, for: .normal)
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
        guard let view = Bundle(for: type(of: self)).loadNibNamed(R.nib.gradationButton.name, owner: self, options: nil)?.first as? UIView else {
            return
        }
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
    }
}
