//
//  ThinkNewWireFrame.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct ThinkNewWireframe: WireFrame {
    typealias ViewController = ThinkNewViewController
    
    fileprivate weak var viewController: ThinkNewViewController?
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
}
