//
//  CheckButtonView.swift
//  selfinity
//
//  Created by Apple on 2018/10/09.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class CheckButtonView: UIView {

    @IBOutlet weak var baseView: UIView! 
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var otherView: UIView!
    
    var isChecked: Bool {
        get {
            return button?.isSelected ?? false
        }
        set {
            UIView.animate(withDuration: 0, animations: {[unowned self] in
                self.button?.isSelected = newValue
                }, completion: { [unowned self] _ in
                    //newValue ? self.setFilter() : self.clearFilter()
            })
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
        guard let view = Bundle(for: type(of: self)).loadNibNamed(R.nib.checkButtonView.name, owner: self, options: nil)?.first as? UIView else {
            return
        }
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        isChecked = false
        
        baseView.layer.cornerRadius = view.frame.width / 2
        baseView.layer.masksToBounds = true
        baseView.layer.borderWidth = 1
        baseView.layer.borderColor = Constant.borderColor.cgColor
        otherView.layer.shadowColor = Constant.baseStringColor.cgColor
        otherView.layer.shadowOpacity = 0.5
        otherView.layer.shadowOffset = CGSize.zero
        otherView.layer.shadowRadius = view.frame.width / 2
        otherView.layer.shadowPath = UIBezierPath(roundedRect: otherView.bounds, cornerRadius: 10).cgPath
        otherView.layer.shouldRasterize = true
        otherView.layer.rasterizationScale = UIScreen.main.scale
        
        button.layer.cornerRadius = button.frame.width / 2
        button.layer.masksToBounds = true
    }
    
//    private func setFilter() {
//        self.backgroundColor = .clear
//        self.layer.shadowOffset = CGSize(width: 0, height: 2)
//        self.layer.shadowColor = UIColor(red: 0.54, green: 0.62, blue: 1.00, alpha: 0.50).cgColor
//        self.layer.shadowOpacity = 1
//        self.layer.shadowRadius = 4
//        //        gradient?.removeFromSuperlayer()
//        //        gradient = CAGradientLayer()
//        //        self.layer.insertSublayer(gradient!, at: 0)
//
//        layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
//        layer.borderWidth = 0
//        self.button.setTitleColor(mainColor, for: .normal)
//        self.button.tintColor = .white
//    }
//
//    private func clearFilter() {
//        self.backgroundColor = .white
//        self.layer.shadowOffset = CGSize(width: 0, height: 0)
//        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
//        self.layer.shadowOpacity = 0
//        self.layer.shadowRadius = 0
//        //gradient?.removeFromSuperlayer()
//
//        let color = UIColor(red: 0.45, green: 0.62, blue: 0.96, alpha: 1.00)
//        layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
//        layer.borderWidth = 0
//        self.button.setTitleColor(color, for: .normal)
//        self.button.tintColor = .darkGray
//    }
}
