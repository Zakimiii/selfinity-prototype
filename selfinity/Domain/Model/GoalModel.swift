//
//  GoalModel.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation

struct GoalsModel {
    var repositories: [GoalModel] = []
}

struct GoalModel {
    let uid: String
    let text: String
    let credit: Int
    var steps: [StepModel]
    var smart: SmartModel
    let owner: PrunedUserModel
    let `private`: Bool
    let createdAt: Date
    let updatedAt: Date
}
