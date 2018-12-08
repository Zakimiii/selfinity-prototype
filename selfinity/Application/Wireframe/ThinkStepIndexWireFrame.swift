

//
//  ThinkStepIndexWireFrame.swift
//  selfinity
//
//  Created by Apple on 2018/10/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct ThinkStepIndexWireframe: WireFrame {
    typealias ViewController = ThinkStepIndexViewController
    
    fileprivate weak var viewController: ThinkStepIndexViewController?
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
}
