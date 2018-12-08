//
//  CausalTranslator.swift
//  selfinity
//
//  Created by Apple on 2018/10/08.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation

final class CausalsTranslator: Translator {
    typealias Input  = CausalsEntity
    typealias Output = CausalsModel
    
    static func translate(_ entity: Input) -> Output {
        let repositories: [CausalModel] = entity.items.map {
            CausalTranslator.translate($0)
        }
        
        return CausalsModel(repositories: repositories)
    }
}

final class CausalTranslator: Translator {
    typealias Input  = CausalEntity
    typealias Output = CausalModel
    
    static func translate(_ entity: Input) -> Output {
        return CausalModel(uid: entity.uid,
                           credit: entity.credit,
                           result: ThinkTranslator.translate(entity.result),
                           resultUid: entity.resultUid,
                           reason: ThinkTranslator.translate(entity.reason),
                           reasonUid: entity.reasonUid,
                           relation: entity.relation,
                          private: entity.private,
                          createdAt: entity.createdAt,
                          updatedAt: entity.updatedAt
        )
    }
}
