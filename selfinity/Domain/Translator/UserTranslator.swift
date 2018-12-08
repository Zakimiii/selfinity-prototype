
//
//  UserTranslator.swift
//  selfinity
//
//  Created by Apple on 2018/10/08.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation

final class UsersTranslator: Translator {
    typealias Input  = UsersEntity
    typealias Output = UsersModel
    
    static func translate(_ entity: Input) -> Output {
        let repositories: [UserModel] = entity.items.map {
            UserTranslator.translate($0)
        }
        
        return UsersModel(items: repositories)
    }
}

final class UserTranslator: Translator {
    typealias Input  = UserEntity
    typealias Output = UserModel
    
    static func translate(_ entity: Input) -> Output {
        return UserModel(
            providerID: entity.providerID,
            uid: entity.uid,
            email: entity.email,
            displayName: entity.displayName,
            phoneNumber: entity.phoneNumber,
            photoURL: entity.photoURL
        )
    }
}
