//
//  ThinkWireFrame.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct ThinkWireframe: WireFrame {
    typealias ViewController = ThinkViewController
    
    fileprivate weak var viewController: ThinkViewController?
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
    
    func toNew() {
        self.viewController?.performSegue(withIdentifier: R.segue.thinkViewController.toNew, sender: nil)
    }
    
    func toGoal() {
        self.viewController?.performSegue(withIdentifier: R.segue.thinkViewController.toGoal, sender: nil)
    }
    
    func toStep() {
        self.viewController?.performSegue(withIdentifier: R.segue.thinkViewController.toStep, sender: nil)
    }
    
    func toSearch() {
        self.viewController?.performSegue(withIdentifier: R.segue.thinkViewController.toSearch, sender: nil)
    }
}
