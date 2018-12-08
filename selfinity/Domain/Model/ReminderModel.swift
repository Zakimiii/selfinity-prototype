
//
//  ReminderModel.swift
//  selfinity
//
//  Created by Apple on 2018/10/20.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation

struct RemindersModel {
    var repositories: [ReminderModel] = []
}

struct ReminderModel {
    let uid: String
    var title: String
    var text: String
    var time : Date
    var span : Int
    var `repeat`: Int
    var notification: Bool
    var longitude: CGFloat
    var latitude: CGFloat
    var address: String
    var tagUid: String
    var tagKind: String
    var place: Place
    let owner: PrunedUserModel
    let `private`: Bool
    let createdAt: Date
    let updatedAt: Date
}
