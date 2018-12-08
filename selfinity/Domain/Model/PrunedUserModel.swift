//
//  PrunedUserModel.swift
//  selfinity
//
//  Created by Apple on 2018/10/08.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation

struct PrunedUsersModel {
    var repositories: [PrunedUserModel] = []
}

struct PrunedUserModel {
    let uid: String
    let credit: Int
    let sumCredit: Int
    let displayName: String
    let profileImage: NSURL
    let backgroundImage: NSURL
    let registrationConfirmed: Bool
    let permissions: Bool
    let `private`: Bool
    let createdAt: Date
    let updatedAt: Date
}
