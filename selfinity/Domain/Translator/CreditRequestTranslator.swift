//
//  CreditRequestTranslator.swift
//  selfinity
//
//  Created by Apple on 2018/10/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation

final class CreditRepuestsTranslator: Translator {
    typealias Input  = CreditRepuestsEntity
    typealias Output = CreditRepuestsModel
    
    static func translate(_ entity: Input) -> Output {
        let repositories: [CreditRepuestModel] = entity.items.map {
            CreditRepuestTranslator.translate($0)
        }
        
        return CreditRepuestsModel(repositories: repositories)
    }
}

final class CreditRepuestTranslator: Translator {
    typealias Input  = CreditRepuestEntity
    typealias Output = CreditRepuestModel
    
    static func translate(_ entity: Input) -> Output {
        return CreditRepuestModel(uid: entity.uid,
                                  text: entity.text,
                                   credit: entity.credit,
                                   fromTagUid: entity.fromTagUid,
                                   fromTagKind: entity.fromTagKind,
                                   toTagUid: entity.toTagUid,
                                   toTagKind: entity.toTagKind,
                                   private: entity.private,
                                   createdAt: entity.createdAt,
                                   updatedAt: entity.updatedAt
        )
    }
}
