//
//  PrunedUserTranslator.swift
//  selfinity
//
//  Created by Apple on 2018/10/08.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import Firebase
import SDWebImage

final class PrunedUsersTranslator: Translator {
    typealias Input  = PrunedUsersEntity
    typealias Output = PrunedUsersModel
    
    static func translate(_ entity: Input) -> Output {
        let repositories: [PrunedUserModel] = entity.items.map {
            PrunedUserTranslator.translate($0)
        }
        
        return PrunedUsersModel(repositories: repositories)
    }
}

final class PrunedUserTranslator: Translator {
    typealias Input  = PrunedUserEntity
    typealias Output = PrunedUserModel
    
    static func translate(_ entity: Input) -> Output {
        return PrunedUserModel(
            uid: entity.uid,
            credit: entity.credit,
            sumCredit: entity.sumCredit,
            displayName: entity.displayName,
            profileImage: entity.profileImage,
            backgroundImage: entity.backgroundImage,
            registrationConfirmed: entity.registrationConfirmed,
            permissions: entity.permissions,
            private: entity.private,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }
}
