//
//  HomeIndexModel.swift
//  selfinity
//
//  Created by Apple on 2018/10/08.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation

struct HomeIndexesModel {
    var items: [HomeIndexModel] = []
}

struct HomeIndexModel {
    let uid: String
    let goal: GoalModel
    let steps: [StepModel]
    let tasks: [[TaskModel]]
//    let ownerName: String
    let `private`: Bool
    let createdAt: Date
    let updatedAt: Date
}
