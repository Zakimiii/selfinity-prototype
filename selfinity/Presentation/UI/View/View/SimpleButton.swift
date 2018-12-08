//
//  SimpleButton.swift
//  selfinity
//
//  Created by Apple on 2018/10/17.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class SimpleButton: UIView {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBInspectable var image: UIImage? {
        didSet {
            button?.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
            button?.setImage(image?.withRenderingMode(.alwaysTemplate), for: .highlighted)
            button.tintColor = UIColor.white
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
        guard let view = Bundle(for: type(of: self)).loadNibNamed(R.nib.simpleButton.name, owner: self, options: nil)?.first as? UIView else {
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
        
        view.backgroundColor = UIColor.clear
    }
}
