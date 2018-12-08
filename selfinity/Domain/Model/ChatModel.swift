//
//  ChatModel.swift
//  selfinity
//
//  Created by Apple on 2018/10/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation

struct ChatsModel {
    var repositories: [ChatModel] = []
}

struct ChatModel {
    let uid: String
    let credit: Int
    let text: String
    let userType: String
    let ownerUid: String
    let `private`: Bool
    let createdAt: Date
    let updatedAt: Date
}
