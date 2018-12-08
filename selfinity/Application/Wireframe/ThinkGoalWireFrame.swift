//
//  ThinkGoalWireFrame.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct ThinkGoalWireframe: WireFrame {
    typealias ViewController = ThinkGoalViewController
    
    fileprivate weak var viewController: ThinkGoalViewController?
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
}
