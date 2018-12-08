//
//  UILabel.swift
//  selfinity
//
//  Created by Apple on 2018/10/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

extension UILabel {
    
    open func setHelveticaNeueMediumFontSize(_ size: Int) {
        self.font = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(size))
    }
    
    open func setHelveticaNeueLightFontSize(_ size: Int) {
        self.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(size))
    }
}
