//
//  TaskModel.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation

struct TasksModel {
    var repositories: [TaskModel] = []
}

struct TaskModel {
    let uid: String
    let text: String
    let credit: Int
    let smart: SmartModel
    let owner: PrunedUserModel
    let `private`: Bool
    let createdAt: Date
    let updatedAt: Date
}
