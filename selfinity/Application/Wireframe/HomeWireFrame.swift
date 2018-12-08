//
//  HomeWireFrame.swift
//  selfinity
//
//  Created by Apple on 2018/10/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct HomeWireframe: WireFrame {
    typealias ViewController = HomeViewController
    
    fileprivate weak var viewController: HomeViewController?
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
}
