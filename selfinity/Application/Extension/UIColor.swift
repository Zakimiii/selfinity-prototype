//
//  UIColor.swift
//  selfinity
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
    class func hexrgb(color: UInt32, alpha: CGFloat = 1.0) -> UIColor {
        let r: CGFloat = CGFloat((color & 0xFF0000) >> 16) / 255.0
        let g: CGFloat = CGFloat((color & 0x00FF00) >> 8) / 255.0
        let b: CGFloat = CGFloat(color & 0x0000FF) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
    static let cellValidationErrorColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.2)
}
