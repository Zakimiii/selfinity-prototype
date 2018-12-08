//
//  ThinkStatsTranslator.swift
//  selfinity
//
//  Created by Apple on 2018/10/08.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation

final class ThinkStatsTranslator: Translator {
    typealias Input  = ThinkStatsEntity
    typealias Output = ThinkStatsModel
    
    static func translate(_ entity: Input) -> Output {
        return ThinkStatsModel(id: entity.id,
                              owner: entity.owner,
                              private: entity.private,
                              createdAt: entity.createdAt,
                              updatedAt: entity.updatedAt
        )
    }
}
