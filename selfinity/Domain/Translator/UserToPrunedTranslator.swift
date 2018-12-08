//
//  UserToPrunedTranslator.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import Firebase

final class UserToPrunedTranslator: Translator {
    typealias Input  = String //FireBase User's uid
    typealias Output = PrunedUserModel
    
    static func translate(_ entity: Input) -> Output {
        guard let user = CurrentPrunedUser.getCurrentPrunedUserModelFromUid(entity) else {
            fatalError("This user is not exist")
        }
        return PrunedUserModel(
            uid: user.uid,
            credit: user.credit,
            sumCredit: user.sumCredit,
            displayName: user.displayName,
            profileImage: user.profileImage,
            backgroundImage: user.backgroundImage,
            registrationConfirmed: user.registrationConfirmed,
            permissions: user.permissions,
            private: user.private,
            createdAt: user.createdAt,
            updatedAt: user.updatedAt
        )
    }
}
