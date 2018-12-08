//
//  MemoFileIndexWireFrame.swift
//  selfinity
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct MemoFileIndexWireframe: WireFrame {
    typealias ViewController = MemoFileIndexViewController
    
    fileprivate weak var viewController: MemoFileIndexViewController?
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
    
    func toShow(row: Int) {
        self.viewController?.index = row
        self.viewController?.performSegue(withIdentifier: R.segue.memoFileIndexViewController.toShow, sender: nil)
    }
}
