//
//  UserEntity.swift
//  selfinity
//
//  Created by Apple on 2018/10/07.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import Firebase

struct UsersEntity {
    var items: [UserEntity] = []
    
    init() { }
}


struct UserEntity {
    public var providerID = ""
    public var uid = NSUUID().uuidString
    public var displayName = ""
    public var phoneNumber = ""
    public var photoURL = NSURL()
    public var email = ""
    
    init() { }
}
