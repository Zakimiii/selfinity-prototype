//
//  MemoModel.swift
//  selfinity
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation

struct MemosModel {
    var items: [MemoModel] = []
}

struct MemoModel {
//    let uid: String
    //For TableView variable
    var folders: [FolderModel]
    var files: [[FileModel]]
}
