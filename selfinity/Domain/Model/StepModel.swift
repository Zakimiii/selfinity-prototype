//
//  StepModel.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation

struct StepsModel {
    var repositories: [StepModel] = []
}

struct StepModel {
    let uid: String
    var text: String
    let credit: Int
    var smart: SmartModel
    var tasks: [TaskModel]
    let owner: PrunedUserModel
    let `private`: Bool
    let createdAt: Date
    let updatedAt: Date
}
