//
//  CausalModel.swift
//  selfinity
//
//  Created by Apple on 2018/10/08.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation

struct CausalsModel {
    var repositories: [CausalModel] = []
}

struct CausalModel {
    let uid: String
    let credit: Int
    let result: ThinkModel
    let resultUid: String
    let reason: ThinkModel
    let reasonUid: String
    let relation: Int
    let `private`: Bool
    let createdAt: Date
    let updatedAt: Date
}

