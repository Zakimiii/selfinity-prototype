//
//  MemoFileShowWireFrame.swift
//  selfinity
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct MemoFileShowWireframe: WireFrame {
    typealias ViewController = MemoFileShowViewController
    
    fileprivate weak var viewController: MemoFileShowViewController?
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
}
