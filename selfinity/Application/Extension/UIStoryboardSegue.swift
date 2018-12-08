//
//  UIStoryboardSegue.swift
//  selfinity
//
//  Created by Apple on 2018/10/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class PushFadeSegue: UIStoryboardSegue {
    
    override func perform() {
        DispatchQueue.main.async {
            UIView.transition(
                with: (self.source.navigationController?.view)!,
                duration: 0.5,
                options: .transitionCrossDissolve,
                animations: {
                    () -> Void in
                    self.source.navigationController?.pushViewController(self.destination, animated: false)
            },
                completion: nil)
        }
    }
    
}

class PopFadeSegue: UIStoryboardSegue {
    
    override func perform() {
        DispatchQueue.main.async {
            UIView.transition(
                with: (self.source.navigationController?.view)!,
                duration: 0.5,
                options: .transitionCrossDissolve,
                animations: {
                    () -> Void in
                    self.source.navigationController?.popViewController(animated: false)
            },
                completion: nil)
        }
    }
    
}
