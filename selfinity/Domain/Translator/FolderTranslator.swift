//
//  FolderTranslator.swift
//  selfinity
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import Firebase

final class FoldersTranslator: Translator {
    typealias Input  = FoldersEntity
    typealias Output = FoldersModel
    
    static func translate(_ entity: Input) -> Output {
        let repositories: [FolderModel] = entity.items.map {
            FolderTranslator.translate($0)
        }
        
        return FoldersModel(repositories: repositories)
    }
}

final class FolderTranslator: Translator {
    typealias Input  = FolderEntity
    typealias Output = FolderModel
    
    static func translate(_ entity: Input) -> Output {
        var filesModel: [FileModel] = []
        for file in entity.files.enumerated() {
            filesModel.append(FileTranslator.translate(file.element))
        }
        return FolderModel(
            uid: entity.uid,
            files: filesModel,
            title: entity.title,
            owner: UserToPrunedTranslator.translate(Firebase.Auth.auth().currentUser?.uid ?? ""),
            private: entity.private,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }
}
