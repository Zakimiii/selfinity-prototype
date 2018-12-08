//
//  ReminderEditWireFrame.swift
//  selfinity
//
//  Created by Apple on 2018/10/21.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct ReminderEditWireframe: WireFrame {
    typealias ViewController = ReminderEditViewController
    
    fileprivate weak var viewController: ReminderEditViewController?
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
}
