
//
//  ThinkTaskCreateWireFrame.swift
//  selfinity
//
//  Created by Apple on 2018/10/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct ThinkTaskCreateWireframe: WireFrame {
    typealias ViewController = ThinkTaskCreateViewController
    
    fileprivate weak var viewController: ThinkTaskCreateViewController?
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
}
