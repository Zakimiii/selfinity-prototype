
//
//  LabelModel.swift
//  selfinity
//
//  Created by Apple on 2018/10/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation

struct LabelsModel {
    var repositories: [LabelModel] = []
}

struct LabelModel {
    let uid: String
    let title: String
    let tagUid: String
    let tagkind: String
    let owner = PrunedUserEntity()
    let `private` = false
    let createdAt = Date.CurrentDate()
    let updatedAt = Date.CurrentDate()
}
