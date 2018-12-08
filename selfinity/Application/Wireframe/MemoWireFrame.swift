//
//  MemoWireFrame.swift
//  selfinity
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 Apple. All rights reserved.
//
import UIKit

struct MemoWireframe: WireFrame {
    typealias ViewController = MemoViewController
    
    fileprivate weak var viewController: MemoViewController?
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
    
    func toFile(row: Int) {
        self.viewController?.index = row
        self.viewController?.performSegue(withIdentifier: R.segue.memoViewController.toFile, sender: nil)
    }
}
