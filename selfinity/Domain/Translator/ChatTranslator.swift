//
//  ChatTranslator.swift
//  selfinity
//
//  Created by Apple on 2018/10/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation

final class ChatsTranslator: Translator {
    typealias Input  = ChatsEntity
    typealias Output = ChatsModel
    
    static func translate(_ entity: Input) -> Output {
        let repositories: [ChatModel] = entity.items.map {
            ChatTranslator.translate($0)
        }
        
        return ChatsModel(repositories: repositories)
    }
}

final class ChatTranslator: Translator {
    typealias Input  = ChatEntity
    typealias Output = ChatModel
    
    static func translate(_ entity: Input) -> Output {
        return ChatModel(uid: entity.uid,
                         credit: entity.credit,
                         text: entity.text,
                         userType: entity.userType,
                         ownerUid: entity.ownerUid,
                         private: entity.private,
                         createdAt: entity.createdAt,
                         updatedAt: entity.updatedAt
        )
    }
}
