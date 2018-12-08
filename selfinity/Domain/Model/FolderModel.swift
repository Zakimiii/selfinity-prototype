//
//  FolderModel.swift
//  selfinity
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation

struct FoldersModel {
    var repositories: [FolderModel] = []
}

struct FolderModel {
    let uid: String
    var files: [FileModel]
    let title: String
    let owner: PrunedUserModel
    let `private`: Bool
    let createdAt: Date
    let updatedAt: Date
}
