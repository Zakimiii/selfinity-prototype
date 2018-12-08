//
//  FileTranslator.swift
//  selfinity
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import Firebase

final class FileTranslator: Translator {
    typealias Input  = FileEntity
    typealias Output = FileModel
    
    static func translate(_ entity: Input) -> Output {
        return FileModel(
            uid: entity.uid,
            folderUid: entity.folderUid,
            folderTitle: entity.folderTitle,
            text: entity.text,
            title: entity.title,
            html: entity.html,
            owner: UserToPrunedTranslator.translate(Firebase.Auth.auth().currentUser?.uid ?? ""),
            private: entity.private,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }
}
