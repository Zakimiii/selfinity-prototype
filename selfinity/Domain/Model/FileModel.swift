//
//  FileModel.swift
//  selfinity
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation

struct FilesModel {
    var repositories: [FileModel] = []
}

struct FileModel {
    let uid: String
    var folderUid: String
    var folderTitle: String
    var text: String
    var title: String
    var html: String
    let owner: PrunedUserModel
    let `private`: Bool
    let createdAt: Date
    let updatedAt: Date
}
