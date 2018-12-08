//
//  UserModel.swift
//  selfinity
//
//  Created by Apple on 2018/10/08.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation

struct UsersModel {
    var items: [UserModel] = []
}

struct UserModel {
    let providerID: String
    let uid: String
    let email: String
    let displayName: String
    let phoneNumber: String
    let photoURL: NSURL
}
