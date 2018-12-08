//
//  Ex.swift
//  selfinity
//
//  Created by Apple on 2018/10/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

public struct TargetedExtension<Base> {
    let base: Base
    init (_ base: Base) {
        self.base = base
    }
}

public protocol TargetedExtensionCompatible {
    associatedtype Compatible
    static var ex: TargetedExtension<Compatible>.Type { get }
    var ex: TargetedExtension<Compatible> { get }
}

public extension TargetedExtensionCompatible {
    public static var ex: TargetedExtension<Self>.Type {
        return TargetedExtension<Self>.self
    }
    
    public var ex: TargetedExtension<Self> {
        return TargetedExtension(self)
    }
}
