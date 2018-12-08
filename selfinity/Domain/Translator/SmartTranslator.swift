
//
//  SmartTranslator.swift
//  selfinity
//
//  Created by Apple on 2018/10/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import Firebase

final class SmartsTranslator: Translator {
    typealias Input  = SmartsEntity
    typealias Output = SmartsModel
    
    static func translate(_ entity: Input) -> Output {
        let repositories: [SmartModel] = entity.items.map {
            SmartTranslator.translate($0)
        }
        
        return SmartsModel(repositories: repositories)
    }
}

final class SmartTranslator: Translator {
    typealias Input  = SmartEntity
    typealias Output = SmartModel
    
    static func translate(_ entity: Input) -> Output {
        return SmartModel(
            uid: entity.uid,
            specificSubject: entity.specificSubject,
            specificVerb: entity.specificVerb,
            timeBound: entity.timeBound,
            measurable: entity.measurable,
            owner: UserToPrunedTranslator.translate(Firebase.Auth.auth().currentUser?.uid ?? ""),
            private: entity.private,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }
}
