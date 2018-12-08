//
//  MainTabBarController.swift
//  selfinity
//
//  Created by Apple on 2018/10/07.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

@objcMembers
class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBar.isTranslucent = false
        UITabBar.appearance().barTintColor = Constant.transparentBaseColor
        self.tabBar.tintColor = Constant.mainColor
        self.tabBar.barTintColor = Constant.transparentBaseColor
        setupTabItem()
        self.customizableViewControllers = nil
        self.extendedLayoutIncludesOpaqueBars = true
        //self.tabBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setAnimation(_:))))
    }
    
    fileprivate func setupTabItem() {
        guard let viewControllers = self.viewControllers else {
            fatalError("couldn't set up TabViewController")
        }
        for viewController in viewControllers.enumerated() {
            //setBackground(viewController.element)
            viewController.element.extendedLayoutIncludesOpaqueBars = true
            viewController.element.tabBarItem = Constant.MainIndex(rawValue: viewController.offset)?.tabbarItem
            viewController.element.tabBarItem.selectedImage = Constant.MainIndex(rawValue: viewController.offset)?.image
            viewController.element.view.backgroundColor = Constant.baseColor
        }
    }
    
    func setAnimation(_ gesture:UITapGestureRecognizer) {
        gesture.cancelsTouchesInView = false
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tabBar.frame.height + 45, height: self.tabBar.frame.height))
        view.center.x = gesture.location(in: self.tabBar).x
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        tabBar.addSubview(view)
        tabBar.sendSubview(toBack: view)
        self.tabBar.clipsToBounds = true
        view.waveCenter()
    }
    
    fileprivate func setBackground(_ viewController: UIViewController) {
        viewController.view.backgroundColor = UIColor.clear
        let imageView = UIImageView(frame: viewController.view.frame)
        imageView.image = R.image.defaultBackground1()
        viewController.view.addSubview(imageView)
        
        let filter = GradationView(frame: viewController.view.frame)
        filter.bottomColor = Constant.transparentBaseColor
        filter.topColor = Constant.transparentBaseColor
        viewController.view.addSubview(filter)
        
        viewController.view.sendSubview(toBack: filter)
        viewController.view.sendSubview(toBack: imageView)
    }
}
