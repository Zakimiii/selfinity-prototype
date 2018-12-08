//
//  SignInWireFrame.swift
//  selfinity
//
//  Created by Apple on 2018/10/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct SignInWireframe: WireFrame {
    typealias ViewController = SignUpViewController
    
    fileprivate weak var viewController: SignUpViewController?
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
}
