//
//  ThinkModel.swift
//  selfinity
//
//  Created by Apple on 2018/10/08.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation

struct ThinksModel {
    var repositories: [ThinkModel] = []
}

struct ThinkModel {
    let uid: String
    let text: String
    let credit: Int
    let `private`: Bool
    let createdAt: Date
    let updatedAt: Date
}
