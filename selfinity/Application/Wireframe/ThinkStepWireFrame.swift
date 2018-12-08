//
//  ThinkStepWireFrame.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct ThinkStepWireframe: WireFrame {
    typealias ViewController = ThinkStepViewController
    
    fileprivate weak var viewController: ThinkStepViewController?
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
    
    func toEdit() {
        self.viewController?.performSegue(withIdentifier: R.segue.thinkStepViewController.toEdit, sender: nil)
    }
}
