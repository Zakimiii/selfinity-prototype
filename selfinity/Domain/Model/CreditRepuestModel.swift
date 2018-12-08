//
//  CreditRepuestModel.swift
//  selfinity
//
//  Created by Apple on 2018/10/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation

struct CreditRepuestsModel {
    var repositories: [CreditRepuestModel] = []
}

struct CreditRepuestModel {
    let uid: String
    let text: String
    let credit: Int
    let fromTagUid: String
    let fromTagKind: String
    let toTagUid: String
    let toTagKind: String
    let `private`: Bool
    let createdAt: Date
    let updatedAt: Date
}
