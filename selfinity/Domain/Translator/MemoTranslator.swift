//
//  MemoTranslator.swift
//  selfinity
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import Firebase

//final class MemosTranslator: Translator {
//    typealias Input  = FoldersEntity
//    typealias Output = MemosModel
//
//    static func translate(_ entity: Input) -> Output {
//        let repositories: [MemosModel] = MemoTranslator.translate(entity)
//        return MemosModel(items: repositories)
//    }
//}

final class MemoTranslator: Translator {
    typealias Input  = FoldersEntity
    typealias Output = MemoModel
    
    static func translate(_ entity: Input) -> Output {
        var foldersModel: [FolderModel] = []
        var filesModel: [[FileModel]] = []
        let fsModel: [FileModel] = []
        for folder in entity.items.enumerated() {
            foldersModel.append(FolderTranslator.translate(folder.element))
            filesModel.append(fsModel)
            for file in folder.element.files.enumerated() {
                filesModel[folder.offset].append(FileTranslator.translate(file.element))
            }
        }
        return MemoModel(
            folders: foldersModel,
            files: filesModel
        )
    }
}
