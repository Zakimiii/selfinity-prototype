//
//  ScheduleWireFrame.swift
//  selfinity
//
//  Created by Apple on 2018/10/21.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct ScheduleWireframe: WireFrame {
    typealias ViewController = ScheduleViewController
    
    fileprivate weak var viewController: ScheduleViewController?
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
    
    func toCreate() {
        self.viewController?.performSegue(withIdentifier: R.segue.scheduleViewController.toCreate.identifier, sender: nil)
    }
    
    func toEdit() {
        self.viewController?.performSegue(withIdentifier: R.segue.scheduleViewController.toEdit.identifier, sender: nil)
    }
}
