//
//  ThinkStepEditWireFrame.swift
//  selfinity
//
//  Created by Apple on 2018/10/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct ThinkStepEditWireframe: WireFrame {
    typealias ViewController = ThinkStepEditViewController
    
    fileprivate weak var viewController: ThinkStepEditViewController?
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
}
