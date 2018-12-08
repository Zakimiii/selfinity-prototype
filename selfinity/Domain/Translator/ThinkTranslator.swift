//
//  ThinkTranslator.swift
//  selfinity
//
//  Created by Apple on 2018/10/08.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation

final class ThinksTranslator: Translator {
    typealias Input  = ThinksEntity
    typealias Output = ThinksModel
    
    static func translate(_ entity: Input) -> Output {
        let repositories: [ThinkModel] = entity.items.map {
            ThinkTranslator.translate($0)
        }
        
        return ThinksModel(repositories: repositories)
    }
}

final class ThinkTranslator: Translator {
    typealias Input  = ThinkEntity
    typealias Output = ThinkModel
    
    static func translate(_ entity: Input) -> Output {
        return ThinkModel(uid: entity.uid,
                          text: entity.text,
                          credit: entity.credit,
                          private: entity.private,
                          createdAt: entity.createdAt,
                          updatedAt: entity.updatedAt
        )
    }
}
