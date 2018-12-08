//
//  LogInWireFrame.swift
//  selfinity
//
//  Created by Apple on 2018/10/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct LogInWireframe: WireFrame {
    typealias ViewController = LogInViewController
    
    fileprivate weak var viewController: LogInViewController?
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
}
