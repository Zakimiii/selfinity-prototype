//
//  TaskTranslator.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import Firebase

//final class TasksTranslator: Translator {
//    typealias Input  = TasksEntity
//    typealias Output = TasksModel
//
//    static func translate(_ entity: Input) -> Output {
//        let repositories: [TaskModel] = entity.items.map {
//            TaskTranslator.translate($0)
//        }
//
//        return TasksModel(repositories: repositories)
//    }
//}

final class TaskTranslator: Translator {
    typealias Input  = TaskEntity
    typealias Output = TaskModel
    
    static func translate(_ entity: Input) -> Output {
        return TaskModel(
            uid: entity.uid,
            text: entity.text,
            credit: entity.credit,
            smart: SmartTranslator.translate(entity.smart),
            owner: UserToPrunedTranslator.translate(Firebase.Auth.auth().currentUser?.uid ?? ""),
            private: entity.private,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }
    
    static func translateForModel(_ entity: TaskModel) -> Output {
        return TaskModel(
            uid: entity.uid,
            text: entity.text,
            credit: entity.credit,
            smart: entity.smart,
            owner: UserToPrunedTranslator.translate(Firebase.Auth.auth().currentUser?.uid ?? ""),
            private: entity.private,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }
}
